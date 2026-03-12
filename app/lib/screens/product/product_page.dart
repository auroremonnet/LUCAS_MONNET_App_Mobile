import 'package:flutter/material.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/screens/product/product_fetcher.dart';
import 'package:formation_flutter/screens/product/states/empty/product_page_empty.dart';
import 'package:formation_flutter/screens/product/states/error/product_page_error.dart';
import 'package:formation_flutter/screens/product/tabs/caracteristiques_tab.dart';
import 'package:formation_flutter/screens/product/tabs/fiche_tab.dart';
import 'package:formation_flutter/screens/product/tabs/nutrition_tab.dart';
import 'package:formation_flutter/screens/product/tabs/tableau_tab.dart';
import 'package:formation_flutter/services/favorites_service.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key, required this.barcode})
      : assert(barcode.length > 0);

  final String barcode;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int _currentIndex = 0;
  bool _isFavorite = false;
  bool _favoriteLoading = true;
  bool _favoriteActionLoading = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteState();
  }

  Future<void> _loadFavoriteState() async {
    try {
      final favorite = await FavoritesService.isFavorite(widget.barcode);
      if (!mounted) return;
      setState(() {
        _isFavorite = favorite;
        _favoriteLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isFavorite = false;
        _favoriteLoading = false;
      });
    }
  }

  Future<void> _toggleFavorite(Product product) async {
    if (_favoriteActionLoading) return;

    final wasFavorite = _isFavorite;

    setState(() {
      _favoriteActionLoading = true;
    });

    try {
      if (wasFavorite) {
        await FavoritesService.removeFavorite(product.barcode ?? '');
      } else {
        await FavoritesService.addFavorite(product);
      }

      if (!mounted) return;
      setState(() {
        _isFavorite = !wasFavorite;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            wasFavorite
                ? 'Produit retiré des favoris'
                : 'Produit ajouté aux favoris',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur favoris : $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _favoriteActionLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProductFetcher>(
      create: (_) => ProductFetcher(barcode: widget.barcode),
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.blue,
          unselectedItemColor: AppColors.grey2,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.info_outline),
              label: 'Fiche',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: 'Caractéristiques',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.eco_outlined),
              label: 'Nutrition',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.view_list_outlined),
              label: 'Tableau',
            ),
          ],
        ),
        body: Consumer<ProductFetcher>(
          builder: (BuildContext context, ProductFetcher notifier, _) {
            return switch (notifier.state) {
              ProductFetcherLoading() => const ProductPageEmpty(),
              ProductFetcherError(error: var err) => ProductPageError(error: err),
              ProductFetcherSuccess(product: var prod) => _buildProductView(prod, context),
            };
          },
        ),
      ),
    );
  }

  Widget _buildProductView(Product product, BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final topPadding = MediaQuery.of(context).padding.top;

    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: screenHeight * 0.40,
          child: Image.network(
            product.picture ?? '',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: AppColors.grey2),
          ),
        ),
        Positioned.fill(
          top: screenHeight * 0.35,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.0),
                topRight: Radius.circular(24.0),
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name ?? 'Nom inconnu',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: AppColors.blue,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.brands?.join(', ') ?? 'Marque inconnue',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.grey2,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTabContent(product),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: topPadding + 8,
          left: 8,
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        Positioned(
          top: topPadding + 8,
          right: 8,
          child: _favoriteLoading
              ? const Padding(
                  padding: EdgeInsets.all(12),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                )
              : IconButton(
                  icon: Icon(
                    _isFavorite ? Icons.star : Icons.star_border,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: _favoriteActionLoading
                      ? null
                      : () => _toggleFavorite(product),
                ),
        ),
      ],
    );
  }

  Widget _buildTabContent(Product product) {
    return [
      FicheTab(product: product),
      CaracteristiquesTab(product: product),
      NutritionTab(product: product),
      TableauTab(product: product),
    ][_currentIndex];
  }
}