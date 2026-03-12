import 'package:flutter/material.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/res/app_colors.dart';

class CaracteristiquesTab extends StatelessWidget {
  const CaracteristiquesTab({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final ingredientRows = _buildIngredientRows(product.ingredients);
    final allergenRows = _buildSimpleRows(product.allergens, emptyText: 'Aucune');
    final additiveRows = _buildAdditiveRows(product.additives);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionTitle("Ingrédients"),
          _buildWhiteCard(
            child: ingredientRows.isEmpty
                ? _buildSingleValue("Non renseignés")
                : Column(children: ingredientRows),
          ),

          const SizedBox(height: 14),

          _buildSectionTitle("Substances allergènes"),
          _buildWhiteCard(
            child: allergenRows.isEmpty
                ? _buildSingleValue("Aucune")
                : Column(children: allergenRows),
          ),

          const SizedBox(height: 14),

          _buildSectionTitle("Additifs"),
          _buildWhiteCard(
            child: additiveRows.isEmpty
                ? _buildSingleValue("Aucun")
                : Column(children: additiveRows),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // Sections
  // =========================================================

  Widget _buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF3F3F6),
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w900,
          color: AppColors.blue,
        ),
      ),
    );
  }

  Widget _buildWhiteCard({required Widget child}) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: child,
    );
  }

  Widget _buildSingleValue(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.blue,
          ),
        ),
      ),
    );
  }

  // =========================================================
  // Ingredients
  // =========================================================

  List<Widget> _buildIngredientRows(List<dynamic>? ingredients) {
    if (ingredients == null || ingredients.isEmpty) return [];

    final rows = <Widget>[];

    for (int i = 0; i < ingredients.length; i++) {
      final item = ingredients[i]?.toString().trim() ?? '';
      if (item.isEmpty) continue;

      final parsed = _splitIngredient(item);

      rows.add(
        _buildTwoColumnsRow(
          left: parsed.left,
          right: parsed.right,
        ),
      );

      if (i != ingredients.length - 1) {
        rows.add(_divider());
      }
    }

    return rows;
  }

  _IngredientLine _splitIngredient(String raw) {
    final text = raw.trim();

    final match = RegExp(r'^(.*?)\s*\((.*?)\)\s*$').firstMatch(text);
    if (match != null) {
      return _IngredientLine(
        left: match.group(1)?.trim() ?? '',
        right: match.group(2)?.trim() ?? '',
      );
    }

    return _IngredientLine(left: text, right: '');
  }

  // =========================================================
  // Allergènes / additifs
  // =========================================================

  List<Widget> _buildSimpleRows(List<dynamic>? values, {required String emptyText}) {
    if (values == null || values.isEmpty) return [];

    final cleaned = values
        .map((e) => e?.toString().trim() ?? '')
        .where((e) => e.isNotEmpty)
        .toList();

    if (cleaned.isEmpty) return [];

    final rows = <Widget>[];

    for (int i = 0; i < cleaned.length; i++) {
      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              cleaned[i],
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.blue,
              ),
            ),
          ),
        ),
      );

      if (i != cleaned.length - 1) {
        rows.add(_divider());
      }
    }

    return rows;
  }

  List<Widget> _buildAdditiveRows(dynamic additives) {
    if (additives == null) return [];

    final rows = <Widget>[];

    if (additives is Map) {
      final entries = additives.entries
          .where((e) => e.value != null && e.value.toString().trim().isNotEmpty)
          .toList();

      for (int i = 0; i < entries.length; i++) {
        rows.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                entries[i].value.toString(),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blue,
                ),
              ),
            ),
          ),
        );

        if (i != entries.length - 1) {
          rows.add(_divider());
        }
      }

      return rows;
    }

    if (additives is List) {
      final cleaned = additives
          .map((e) => e?.toString().trim() ?? '')
          .where((e) => e.isNotEmpty)
          .toList();

      for (int i = 0; i < cleaned.length; i++) {
        rows.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                cleaned[i],
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blue,
                ),
              ),
            ),
          ),
        );

        if (i != cleaned.length - 1) {
          rows.add(_divider());
        }
      }

      return rows;
    }

    final text = additives.toString().trim();
    if (text.isEmpty) return [];

    rows.add(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.blue,
            ),
          ),
        ),
      ),
    );

    return rows;
  }

  // =========================================================
  // Row UI
  // =========================================================

  Widget _buildTwoColumnsRow({
    required String left,
    required String right,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              left,
              style: const TextStyle(
                fontSize: 15,
                height: 1.2,
                fontWeight: FontWeight.w700,
                color: AppColors.blue,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 6,
            child: Text(
              right,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 15,
                height: 1.25,
                fontWeight: FontWeight.w500,
                color: Color(0xFF7D7D8D),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Divider(
        height: 1,
        thickness: 1,
        color: Color(0xFFF0F0F2),
      ),
    );
  }
}

class _IngredientLine {
  final String left;
  final String right;

  _IngredientLine({
    required this.left,
    required this.right,
  });
}