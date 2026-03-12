import 'package:flutter/material.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/res/app_colors.dart';

class FicheTab extends StatelessWidget {
  final Product product;
  const FicheTab({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // --- Bloc Scores ---
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _scoreCard(
                        title: 'Nutri-Score',
                        child: _nutriScoreImage(product.nutriScore),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _scoreCard(
                        title: 'Groupe NOVA',
                        subtitle: 'Produits alimentaires et\nboissons ultra-transformés',
                        value: _novaLabel(product.novaScore),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _scoreCard(
                  fullWidth: true,
                  title: 'EcoScore',
                  subtitle: 'Impact environnemental élevé',
                  value: _ecoLabel(product.greenScore),
                  valueColor: _ecoColor(product.greenScore),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // --- Bloc Infos générales ---
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: Column(
              children: [
                _infoRow(
                  'Quantité',
                  product.quantity ?? 'Inconnue',
                ),
                const SizedBox(height: 18),
                _infoRow(
                  'Vendu',
                  _storeLabel(),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: _tagBadge(
                        label: 'Végétalien',
                        active: product.isVegan == true,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _tagBadge(
                        label: 'Végétarien',
                        active: product.isVegetarian == true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // UI
  // =========================

  Widget _scoreCard({
    required String title,
    Widget? child,
    String? subtitle,
    String? value,
    Color? valueColor,
    bool fullWidth = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFEAEAEA), width: 1),
        borderRadius: BorderRadius.circular(2),
      ),
      child: child ??
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.1,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF27235C),
                ),
              ),
              if (value != null) ...[
                const SizedBox(height: 6),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    height: 1,
                    fontWeight: FontWeight.w800,
                    color: valueColor ?? const Color(0xFF27235C),
                  ),
                ),
              ],
              if (subtitle != null) ...[
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.25,
                    color: Color(0xFFB8B8C6),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ],
          ),
    );
  }

  Widget _nutriScoreImage(ProductNutriScore? score) {
    final letter = _nutriLetter(score);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nutri-Score',
          style: TextStyle(
            fontSize: 14,
            height: 1.1,
            fontWeight: FontWeight.w700,
            color: Color(0xFF27235C),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 38,
          width: 112,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: const Color(0xFFF5F5F7),
          ),
          child: Row(
            children: [
              _nutriBox('A', const Color(0xFF1AA64A), active: letter == 'A'),
              _nutriBox('B', const Color(0xFF86C440), active: letter == 'B'),
              _nutriBox('C', const Color(0xFFF4C31B), active: letter == 'C'),
              _nutriBox('D', const Color(0xFFF28A1A), active: letter == 'D'),
              _nutriBox('E', const Color(0xFFE74C2C), active: letter == 'E'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _nutriBox(String label, Color color, {required bool active}) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(
          left: label == 'A' ? 0 : 1,
        ),
        decoration: BoxDecoration(
          color: active ? color : color.withOpacity(0.9),
          borderRadius: BorderRadius.horizontal(
            left: label == 'A' ? const Radius.circular(8) : Radius.zero,
            right: label == 'E' ? const Radius.circular(8) : Radius.zero,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: active ? 24 : 18,
              fontWeight: active ? FontWeight.w900 : FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF27235C),
            ),
          ),
        ),
        Text(
          value,
          textAlign: TextAlign.right,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF7D7D8D),
          ),
        ),
      ],
    );
  }

  Widget _tagBadge({
    required String label,
    required bool active,
  }) {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: const Color(0xFF31C1DF),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            active ? Icons.check : Icons.close,
            color: Colors.white,
            size: 18,
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // Helpers
  // =========================

  String _storeLabel() {
    final dynamic stores = _readStores(product);
    if (stores is List && stores.isNotEmpty) {
      return stores.join(', ');
    }
    if (stores is String && stores.trim().isNotEmpty) {
      return stores;
    }
    return 'France';
  }

  dynamic _readStores(Product product) {
    try {
      return (product as dynamic).stores;
    } catch (_) {
      try {
        return (product as dynamic).store;
      } catch (_) {
        try {
          return (product as dynamic).countries;
        } catch (_) {
          return null;
        }
      }
    }
  }

  String _nutriLetter(ProductNutriScore? score) {
    if (score == null) return '?';
    final s = score.toString().split('.').last.toUpperCase();
    return s == 'UNKNOWN' ? '?' : s;
  }

  String _novaLabel(ProductNovaScore? s) {
    if (s == null) return '?';
    return s.toString().split('.').last.replaceAll('group', '');
  }

  String _ecoLabel(ProductGreenScore? s) {
    if (s == null) return '?';
    return s.toString().split('.').last.toUpperCase();
  }

  Color _ecoColor(ProductGreenScore? s) {
    final label = _ecoLabel(s);
    switch (label) {
      case 'A':
        return const Color(0xFF1AA64A);
      case 'B':
        return const Color(0xFF86C440);
      case 'C':
        return const Color(0xFFF4C31B);
      case 'D':
        return const Color(0xFFF28A1A);
      case 'E':
        return const Color(0xFFE74C2C);
      default:
        return const Color(0xFF27235C);
    }
  }
}