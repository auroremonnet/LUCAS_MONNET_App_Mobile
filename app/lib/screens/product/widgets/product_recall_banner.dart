import 'package:flutter/material.dart';

class ProductRecallBanner extends StatelessWidget {
  const ProductRecallBanner({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0x5CFF0000),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.warning_rounded,
                color: Color(0xFFA60000),
                size: 24,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Un rappel produit est en cours pour cet article',
                  style: TextStyle(
                    color: Color(0xFFA60000),
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                color: Color(0xFFA60000),
              ),
            ],
          ),
        ),
      ),
    );
  }
}