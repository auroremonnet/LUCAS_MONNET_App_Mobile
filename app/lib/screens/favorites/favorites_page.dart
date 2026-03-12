import 'package:flutter/material.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/services/favorites_service.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketbase/pocketbase.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late Future<List<RecordModel>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _favoritesFuture = FavoritesService.getFavorites();
  }

  Future<void> _reload() async {
    setState(() {
      _favoritesFuture = FavoritesService.getFavorites();
    });
    await _favoritesFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.blue,
        title: const Text(
          'Mes favoris',
          style: TextStyle(
            color: AppColors.blue,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: FutureBuilder<List<RecordModel>>(
        future: _favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const _FavoritesLoadingView();
          }

          if (snapshot.hasError) {
            return _FavoritesErrorView(
              onRetry: _reload,
            );
          }

          final favorites = snapshot.data ?? [];

          if (favorites.isEmpty) {
            return const _FavoritesEmptyView();
          }

          return RefreshIndicator(
            onRefresh: _reload,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              separatorBuilder: (_, __) => const SizedBox(height: 18),
              itemBuilder: (context, index) {
                final record = favorites[index];
                return _FavoriteCard(record: record);
              },
            ),
          );
        },
      ),
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  const _FavoriteCard({required this.record});

  final RecordModel record;

  @override
  Widget build(BuildContext context) {
    final barcode = (record.data['barcode'] ?? '').toString();
    final name = (record.data['name'] ?? 'Nom inconnu').toString();
    final brand = (record.data['brand'] ?? 'Marque inconnue').toString();
    final picture = (record.data['picture'] ?? '').toString();
    final nutriscore = (record.data['nutriscore'] ?? '?').toString().toUpperCase();

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: barcode.isEmpty
          ? null
          : () => context.push('/product', extra: barcode),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: picture.isNotEmpty
                  ? Image.network(
                      picture,
                      width: 96,
                      height: 96,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _imagePlaceholder(),
                    )
                  : _imagePlaceholder(),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: SizedBox(
                height: 96,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: AppColors.blue,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      brand,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.grey2,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: _nutriColor(nutriscore),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Nutriscore : $nutriscore',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      width: 96,
      height: 96,
      color: const Color(0xFFEAEAEA),
      child: const Icon(Icons.image_not_supported, color: Colors.grey),
    );
  }

  Color _nutriColor(String score) {
    switch (score) {
      case 'A':
        return const Color(0xFF1AA64A);
      case 'B':
        return const Color(0xFF86C440);
      case 'C':
        return const Color(0xFFF2C300);
      case 'D':
        return const Color(0xFFF28A1A);
      case 'E':
        return const Color(0xFFE74C2C);
      default:
        return Colors.grey;
    }
  }
}

class _FavoritesLoadingView extends StatelessWidget {
  const _FavoritesLoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.yellow),
    );
  }
}

class _FavoritesErrorView extends StatelessWidget {
  const _FavoritesErrorView({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            const Text(
              'Une erreur est survenue lors du chargement des favoris.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.blue,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.yellow,
                foregroundColor: AppColors.blue,
              ),
              child: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoritesEmptyView extends StatelessWidget {
  const _FavoritesEmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'Aucun favori pour le moment.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.grey2,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}