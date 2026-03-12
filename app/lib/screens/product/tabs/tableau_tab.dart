import 'package:flutter/material.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/res/app_colors.dart';

class TableauTab extends StatelessWidget {
  const TableauTab({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final rows = _buildRows(product);

    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(1.9),
                1: FlexColumnWidth(1.15),
                2: FlexColumnWidth(0.85),
              },
              border: const TableBorder(
                horizontalInside: BorderSide(
                  color: Color(0xFFF0F0F2),
                  width: 1,
                ),
                verticalInside: BorderSide(
                  color: Color(0xFFF0F0F2),
                  width: 1,
                ),
              ),
              children: [
                _buildHeaderRow(),
                ...rows.map(_buildDataRow),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildHeaderRow() {
    return const TableRow(
      children: [
        _HeaderCell(''),
        _HeaderCell('Pour 100g'),
        _HeaderCell('Par part'),
      ],
    );
  }

  TableRow _buildDataRow(_NutritionTableRow row) {
    return TableRow(
      children: [
        _LeftCell(row.label, isIndented: row.isSubRow),
        _ValueCell(row.per100g),
        _ValueCell(row.perServing),
      ],
    );
  }

  List<_NutritionTableRow> _buildRows(Product product) {
    final nf = product.nutritionFacts;
    final carbs = _readField(nf, ['carbohydrates', 'carbs', 'glucides']);

    return [
      _NutritionTableRow(
        label: 'Énergie',
        per100g: _formatEnergy(_readValue(carbsOrEnergy: _readField(nf, ['energy']), per100g: true), _readUnit(_readField(nf, ['energy']), 'kJ')),
        perServing: _formatEnergy(_readValue(carbsOrEnergy: _readField(nf, ['energy']), per100g: false), _readUnit(_readField(nf, ['energy']), 'kJ')),
      ),
      _NutritionTableRow(
        label: 'Matières grasses',
        per100g: _formatValue(nf?.fat?.per100g, nf?.fat?.unit ?? 'g'),
        perServing: _formatValue(nf?.fat?.perServing, nf?.fat?.unit ?? 'g'),
      ),
      _NutritionTableRow(
        label: 'dont Acides gras saturés',
        isSubRow: true,
        per100g: _formatValue(
          nf?.saturatedFat?.per100g,
          nf?.saturatedFat?.unit ?? 'g',
        ),
        perServing: _formatValue(
          nf?.saturatedFat?.perServing,
          nf?.saturatedFat?.unit ?? 'g',
        ),
      ),
      _NutritionTableRow(
        label: 'Glucides',
        per100g: _formatValue(
          _readValue(carbsOrEnergy: carbs, per100g: true),
          _readUnit(carbs, 'g'),
        ),
        perServing: _formatValue(
          _readValue(carbsOrEnergy: carbs, per100g: false),
          _readUnit(carbs, 'g'),
        ),
      ),
      _NutritionTableRow(
        label: 'dont Sucres',
        isSubRow: true,
        per100g: _formatValue(nf?.sugar?.per100g, nf?.sugar?.unit ?? 'g'),
        perServing: _formatValue(nf?.sugar?.perServing, nf?.sugar?.unit ?? 'g'),
      ),
      _NutritionTableRow(
        label: 'Fibres alimentaires',
        per100g: _formatValue(
          _readValue(carbsOrEnergy: _readField(nf, ['fiber', 'fibers', 'fibre']), per100g: true),
          _readUnit(_readField(nf, ['fiber', 'fibers', 'fibre']), 'g'),
        ),
        perServing: _formatValue(
          _readValue(carbsOrEnergy: _readField(nf, ['fiber', 'fibers', 'fibre']), per100g: false),
          _readUnit(_readField(nf, ['fiber', 'fibers', 'fibre']), 'g'),
        ),
      ),
      _NutritionTableRow(
        label: 'Protéines',
        per100g: _formatValue(
          _readValue(carbsOrEnergy: _readField(nf, ['proteins', 'protein']), per100g: true),
          _readUnit(_readField(nf, ['proteins', 'protein']), 'g'),
        ),
        perServing: _formatValue(
          _readValue(carbsOrEnergy: _readField(nf, ['proteins', 'protein']), per100g: false),
          _readUnit(_readField(nf, ['proteins', 'protein']), 'g'),
        ),
      ),
      _NutritionTableRow(
        label: 'Sel',
        per100g: _formatValue(nf?.salt?.per100g, nf?.salt?.unit ?? 'g'),
        perServing: _formatValue(nf?.salt?.perServing, nf?.salt?.unit ?? 'g'),
      ),
      _NutritionTableRow(
        label: 'Sodium',
        per100g: _formatValue(
          _readValue(carbsOrEnergy: _readField(nf, ['sodium']), per100g: true),
          _readUnit(_readField(nf, ['sodium']), 'g'),
        ),
        perServing: _formatValue(
          _readValue(carbsOrEnergy: _readField(nf, ['sodium']), per100g: false),
          _readUnit(_readField(nf, ['sodium']), 'g'),
        ),
      ),
    ];
  }

  dynamic _readField(dynamic obj, List<String> names) {
    if (obj == null) return null;

    for (final name in names) {
      try {
        final value = (obj as dynamic)
            .toJson()[name];
        if (value != null) return value;
      } catch (_) {}

      try {
        final value = switch (name) {
          'carbohydrates' => (obj as dynamic).carbohydrates,
          'carbs' => (obj as dynamic).carbs,
          'glucides' => (obj as dynamic).glucides,
          'fiber' => (obj as dynamic).fiber,
          'fibers' => (obj as dynamic).fibers,
          'fibre' => (obj as dynamic).fibre,
          'proteins' => (obj as dynamic).proteins,
          'protein' => (obj as dynamic).protein,
          'sodium' => (obj as dynamic).sodium,
          'energy' => (obj as dynamic).energy,
          _ => null,
        };
        if (value != null) return value;
      } catch (_) {}
    }

    return null;
  }

  dynamic _readValue({required dynamic carbsOrEnergy, required bool per100g}) {
    if (carbsOrEnergy == null) return null;

    try {
      return per100g
          ? (carbsOrEnergy as dynamic).per100g
          : (carbsOrEnergy as dynamic).perServing;
    } catch (_) {
      return null;
    }
  }

  String _readUnit(dynamic field, String fallback) {
    if (field == null) return fallback;
    try {
      return (field as dynamic).unit ?? fallback;
    } catch (_) {
      return fallback;
    }
  }

  String _formatEnergy(dynamic value, String unit) {
    if (value == null) return '?';

    final num? numeric = _toNum(value);
    if (numeric == null) return '?';

    return '${_formatNumber(numeric)} ${unit.toLowerCase()}';
  }

  String _formatValue(dynamic value, String unit) {
    if (value == null) return '?';

    final num? numeric = _toNum(value);
    if (numeric == null) return '?';

    return '${_formatNumber(numeric)} $unit';
  }

  num? _toNum(dynamic value) {
    if (value is num) return value;
    return num.tryParse(value.toString());
  }

  String _formatNumber(num value) {
    String text;

    if (value == value.roundToDouble()) {
      text = value.toInt().toString();
    } else if (value < 1) {
      text = value.toStringAsFixed(3);
    } else {
      text = value.toStringAsFixed(1);
    }

    text = text.replaceAll('.', ',');

    while (text.contains(',') && text.endsWith('0')) {
      text = text.substring(0, text.length - 1);
    }

    if (text.endsWith(',')) {
      text = text.substring(0, text.length - 1);
    }

    return text;
  }
}

class _NutritionTableRow {
  final String label;
  final String per100g;
  final String perServing;
  final bool isSubRow;

  _NutritionTableRow({
    required this.label,
    required this.per100g,
    required this.perServing,
    this.isSubRow = false,
  });
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w800,
          color: AppColors.blue,
        ),
      ),
    );
  }
}

class _LeftCell extends StatelessWidget {
  const _LeftCell(this.text, {this.isIndented = false});

  final String text;
  final bool isIndented;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(
        left: isIndented ? 2 : 4,
        right: 8,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: isIndented ? 14 : 15,
          fontWeight: FontWeight.w700,
          color: AppColors.blue,
        ),
      ),
    );
  }
}

class _ValueCell extends StatelessWidget {
  const _ValueCell(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.blue,
        ),
      ),
    );
  }
}