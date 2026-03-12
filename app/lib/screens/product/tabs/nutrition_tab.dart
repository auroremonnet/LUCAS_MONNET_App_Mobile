import 'package:flutter/material.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/res/app_colors.dart';

class NutritionTab extends StatelessWidget {
  const NutritionTab({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final bool isDrink = _isDrink(product);

    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              child: Text(
                'Repères nutritionnels pour 100g',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey2,
                ),
              ),
            ),

            _buildNutrientRow(
              title: 'Matières grasses / lipides',
              value: product.nutritionFacts?.fat?.per100g,
              unit: product.nutritionFacts?.fat?.unit ?? 'g',
              level: _fatLevel(product.nutritionFacts?.fat?.per100g, isDrink),
            ),

            _divider(),

            _buildNutrientRow(
              title: 'Acides gras saturés',
              value: product.nutritionFacts?.saturatedFat?.per100g,
              unit: product.nutritionFacts?.saturatedFat?.unit ?? 'g',
              level: _saturatedFatLevel(
                product.nutritionFacts?.saturatedFat?.per100g,
                isDrink,
              ),
            ),

            _divider(),

            _buildNutrientRow(
              title: 'Sucres',
              value: product.nutritionFacts?.sugar?.per100g,
              unit: product.nutritionFacts?.sugar?.unit ?? 'g',
              level: _sugarsLevel(product.nutritionFacts?.sugar?.per100g, isDrink),
            ),

            _divider(),

            _buildNutrientRow(
              title: 'Sel',
              value: product.nutritionFacts?.salt?.per100g,
              unit: product.nutritionFacts?.salt?.unit ?? 'g',
              level: _saltLevel(product.nutritionFacts?.salt?.per100g, isDrink),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientRow({
    required String title,
    required dynamic value,
    required String unit,
    required _NutritionLevel level,
  }) {
    final String formattedValue = _formatValue(value, unit);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.2,
                  fontWeight: FontWeight.w700,
                  color: AppColors.blue,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formattedValue,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.1,
                  fontWeight: FontWeight.w700,
                  color: _levelColor(level),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _levelText(level),
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.1,
                  fontWeight: FontWeight.w700,
                  color: _levelColor(level),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Divider(
        height: 1,
        thickness: 1,
        color: Color(0xFFF0F0F2),
      ),
    );
  }

  // =========================
  // LOGIQUE DES SEUILS
  // =========================

  _NutritionLevel _fatLevel(dynamic rawValue, bool isDrink) {
    final value = _toNum(rawValue);
    if (value == null) return _NutritionLevel.unknown;

    final multiplier = isDrink ? 0.5 : 1.0;
    final lowMax = 3.0 * multiplier;
    final moderateMax = 20.0 * multiplier;

    if (value <= lowMax) return _NutritionLevel.low;
    if (value <= moderateMax) return _NutritionLevel.moderate;
    return _NutritionLevel.high;
  }

  _NutritionLevel _saturatedFatLevel(dynamic rawValue, bool isDrink) {
    final value = _toNum(rawValue);
    if (value == null) return _NutritionLevel.unknown;

    final multiplier = isDrink ? 0.5 : 1.0;
    final lowMax = 1.5 * multiplier;
    final moderateMax = 5.0 * multiplier;

    if (value <= lowMax) return _NutritionLevel.low;
    if (value <= moderateMax) return _NutritionLevel.moderate;
    return _NutritionLevel.high;
  }

  _NutritionLevel _sugarsLevel(dynamic rawValue, bool isDrink) {
    final value = _toNum(rawValue);
    if (value == null) return _NutritionLevel.unknown;

    final multiplier = isDrink ? 0.5 : 1.0;
    final lowMax = 5.0 * multiplier;
    final moderateMax = 12.5 * multiplier;

    if (value <= lowMax) return _NutritionLevel.low;
    if (value <= moderateMax) return _NutritionLevel.moderate;
    return _NutritionLevel.high;
  }

  _NutritionLevel _saltLevel(dynamic rawValue, bool isDrink) {
    final value = _toNum(rawValue);
    if (value == null) return _NutritionLevel.unknown;

    final multiplier = isDrink ? 0.5 : 1.0;
    final lowMax = 0.3 * multiplier;
    final moderateMax = 1.5 * multiplier;

    if (value <= lowMax) return _NutritionLevel.low;
    if (value <= moderateMax) return _NutritionLevel.moderate;
    return _NutritionLevel.high;
  }

  // =========================
  // HELPERS
  // =========================

  num? _toNum(dynamic value) {
    if (value == null) return null;
    if (value is num) return value;

    final text = value.toString().trim().replaceAll(',', '.');
    return num.tryParse(text);
  }

  Color _levelColor(_NutritionLevel level) {
    switch (level) {
      case _NutritionLevel.low:
        return const Color(0xFF7FAE63);
      case _NutritionLevel.moderate:
        return const Color(0xFFBE9A57);
      case _NutritionLevel.high:
        return const Color(0xFFC97878);
      case _NutritionLevel.unknown:
        return AppColors.grey2;
    }
  }

  String _levelText(_NutritionLevel level) {
    switch (level) {
      case _NutritionLevel.low:
        return 'Faible quantité';
      case _NutritionLevel.moderate:
        return 'Quantité modérée';
      case _NutritionLevel.high:
        return 'Quantité élevée';
      case _NutritionLevel.unknown:
        return 'Quantité inconnue';
    }
  }

  String _formatValue(dynamic value, String unit) {
    final numeric = _toNum(value);
    if (numeric == null) return '--';

    String text;
    if (numeric == numeric.roundToDouble()) {
      text = numeric.toInt().toString();
    } else if (numeric < 1) {
      text = numeric.toStringAsFixed(2);
    } else {
      text = numeric.toStringAsFixed(1);
    }

    text = text.replaceAll('.', ',');

    while (text.contains(',') && text.endsWith('0')) {
      text = text.substring(0, text.length - 1);
    }

    if (text.endsWith(',')) {
      text = text.substring(0, text.length - 1);
    }

    return '$text$unit';
  }

  bool _isDrink(Product product) {
    try {
      final dynamic dynamicProduct = product;

      final dynamic explicitFlag = dynamicProduct.isBeverage;
      if (explicitFlag is bool) return explicitFlag;

      final dynamic categories = dynamicProduct.categories;
      if (categories is List) {
        final lower = categories.map((e) => e.toString().toLowerCase()).join(' ');
        if (lower.contains('boisson') ||
            lower.contains('boissons') ||
            lower.contains('beverage') ||
            lower.contains('beverages') ||
            lower.contains('drink') ||
            lower.contains('drinks')) {
          return true;
        }
      }
    } catch (_) {}

    return false;
  }
}

enum _NutritionLevel {
  low,
  moderate,
  high,
  unknown,
}