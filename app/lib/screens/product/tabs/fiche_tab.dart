import 'package:flutter/material.dart';
import 'package:formation_flutter/model/product.dart';

class FicheTab extends StatelessWidget {
  final Product product;

  const FicheTab({
    super.key,
    required this.product,
  });

  static const Color _blue = Color(0xFF080040);
  static const Color _lightGreyBg = Color(0xFFF6F6F8);
  static const Color _divider = Color(0xFFE9E9ED);
  static const Color _softText = Color(0xFFCACBD4);
  static const Color _valueText = Color(0xFF7E7E88);
  static const Color _badgeBlue = Color(0xFF31C3E3);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildScoresSection(),
        _buildInfosSection(),
      ],
    );
  }

  Widget _buildScoresSection() {
    return Container(
      width: double.infinity,
      color: _lightGreyBg,
      child: Column(
        children: [
          SizedBox(
            height: 102,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(22, 14, 18, 12),
                    child: _buildNutriColumn(),
                  ),
                ),
                Container(
                  width: 1,
                  color: _divider,
                  height: 68,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 14, 22, 12),
                    child: _buildNovaColumn(),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            color: _divider,
          ),
          SizedBox(
            height: 80,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 12, 22, 10),
              child: _buildEcoRow(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfosSection() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 14),
                _buildInfoRow(
                  'Quantité',
                  product.quantity ?? 'Inconnue',
                ),
                const SizedBox(height: 14),
                Container(height: 1, color: _divider),
                const SizedBox(height: 14),
                _buildInfoRow(
                  'Vendu',
                  _storeLabel(),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _buildTagBadge(
                        label: 'Végétalien',
                        checked: product.isVegan == true,
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: _buildTagBadge(
                        label: 'Végétarien',
                        checked: product.isVegetarian == true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutriColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nutri-Score',
          style: TextStyle(
            color: _blue,
            fontSize: 14,
            fontWeight: FontWeight.w800,
            height: 1,
          ),
        ),
        const SizedBox(height: 10),
        _buildNutriStrip(_nutriLetter(product.nutriScore)),
      ],
    );
  }

  Widget _buildNovaColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Groupe NOVA',
          style: TextStyle(
            color: _blue,
            fontSize: 14,
            fontWeight: FontWeight.w800,
            height: 1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _novaDescription(product.novaScore),
          style: const TextStyle(
            color: _softText,
            fontSize: 13,
            fontWeight: FontWeight.w500,
            height: 1.45,
          ),
        ),
      ],
    );
  }

  Widget _buildEcoRow() {
    final eco = _ecoLabel(product.greenScore);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'EcoScore',
          style: TextStyle(
            color: _blue,
            fontSize: 14,
            fontWeight: FontWeight.w800,
            height: 1,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Text(
              eco,
              style: TextStyle(
                color: _ecoColor(product.greenScore),
                fontSize: 26,
                fontWeight: FontWeight.w800,
                height: 0.95,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Impact environnemental élevé',
                style: TextStyle(
                  color: _softText,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNutriStrip(String activeLetter) {
    const colors = <String, Color>{
      'A': Color(0xFF169A43),
      'B': Color(0xFF87C442),
      'C': Color(0xFFF3C614),
      'D': Color(0xFFF08A12),
      'E': Color(0xFFE94A20),
    };

    const letters = ['A', 'B', 'C', 'D', 'E'];

    return SizedBox(
      width: 164,
      height: 32,
      child: Row(
        children: letters.map((letter) {
          final bool active = letter == activeLetter;
          final bool first = letter == 'A';
          final bool last = letter == 'E';

          return Expanded(
            child: Container(
              height: 32,
              decoration: BoxDecoration(
                color: colors[letter],
                borderRadius: BorderRadius.horizontal(
                  left: first ? const Radius.circular(10) : Radius.zero,
                  right: last ? const Radius.circular(10) : Radius.zero,
                ),
              ),
              child: Center(
                child: Text(
                  letter,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: active ? 22 : 17,
                    fontWeight: active ? FontWeight.w800 : FontWeight.w700,
                    height: 1,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return SizedBox(
      height: 30,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: _blue,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                height: 1,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: _valueText,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                height: 1.1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagBadge({
    required String label,
    required bool checked,
  }) {
    return Container(
      height: 30,
      decoration: BoxDecoration(
        color: _badgeBlue,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            checked ? Icons.check : Icons.close,
            color: Colors.white,
            size: 18,
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }

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
    if (score == null) return 'A';
    final value = score.toString().split('.').last.toUpperCase();
    if (value == 'UNKNOWN') return 'A';
    return value;
  }

  String _novaLabel(ProductNovaScore? score) {
    if (score == null) return '?';
    return score.toString().split('.').last.replaceAll('group', '');
  }

  String _novaDescription(ProductNovaScore? score) {
    final label = _novaLabel(score);
    switch (label) {
      case '1':
        return 'Aliments non transformés\nou transformés minimalement';
      case '2':
        return 'Ingrédients culinaires\ntransformés';
      case '3':
        return 'Produits\ntransformés';
      case '4':
        return 'Produits alimentaires et\nboissons ultra-transformés';
      default:
        return 'Produits alimentaires et\nboissons ultra-transformés';
    }
  }

  String _ecoLabel(ProductGreenScore? score) {
    if (score == null) return 'D';
    return score.toString().split('.').last.toUpperCase();
  }

  Color _ecoColor(ProductGreenScore? score) {
    switch (_ecoLabel(score)) {
      case 'A':
        return const Color(0xFF169A43);
      case 'B':
        return const Color(0xFF87C442);
      case 'C':
        return const Color(0xFFF3C614);
      case 'D':
        return const Color(0xFFF08A12);
      case 'E':
        return const Color(0xFFE94A20);
      default:
        return const Color(0xFFF08A12);
    }
  }
}