import 'package:flutter/material.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/screens/product/tabs/fiche_tab.dart'; 

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _currentIndex = 0;
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    // Liste des onglets : l'erreur disparait car FicheTab est importé au-dessus
    final List<Widget> _tabs = [
      FicheTab(product: widget.product), 
      const Center(child: Text("Caractéristiques")),
      const Center(child: Text("Nutrition")),
      const Center(child: Text("Tableau")),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(color: AppColors.blue),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.star : Icons.star_border,
              color: _isFavorite ? Colors.amber : AppColors.blue,
            ),
            onPressed: () => setState(() => _isFavorite = !_isFavorite),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildHeader(), // L'en-tête (image + nom)
          Expanded(child: _tabs[_currentIndex]), // Le contenu de l'onglet
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.blue,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.info_outline), label: 'Fiche'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Caract.'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: 'Nutrition'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_on), label: 'Tableau'),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              widget.product.barcode ?? '',
              width: 100, height: 100, fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported, size: 100),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.product.name ?? "Inconnu",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.blue)),
                Text(widget.product.brands?.join(', ') ?? "Marque inconnue",
                    style: const TextStyle(color: AppColors.grey2)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}