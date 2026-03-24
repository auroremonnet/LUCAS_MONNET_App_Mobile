import 'package:flutter/material.dart';
import 'package:formation_flutter/model/product_recall.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductRecallPage extends StatelessWidget {
  const ProductRecallPage({
    super.key,
    required this.recall,
  });

  final ProductRecall recall;

  static const Color _blue = Color(0xFF080040);
  static const Color _lightSection = Color(0xFFF6F6F8);
  static const Color _softText = Color(0xFF7C7C86);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: _blue,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Rappel produit',
          style: TextStyle(
            color: _blue,
            fontWeight: FontWeight.w800,
            fontSize: 24,
          ),
        ),
        actions: [
          if (recall.hasShareUrl)
            IconButton(
              onPressed: _share,
              icon: const Icon(Icons.reply),
            ),
          if (recall.hasPdfUrl)
            IconButton(
              onPressed: _openPdf,
              icon: const Icon(Icons.picture_as_pdf_outlined),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (recall.hasImage) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 94),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    recall.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
            if (recall.hasDates) ...[
              _sectionTitle('Dates de commercialisation'),
              _sectionBody(_buildDates(), center: true),
            ],
            if (recall.hasDistributors) ...[
              _sectionTitle('Distributeurs'),
              _sectionBody(recall.distributors, center: true),
            ],
            if (recall.hasGeographicArea) ...[
              _sectionTitle('Zone géographique'),
              _sectionBody(recall.geographicArea, center: true),
            ],
            if (recall.hasReason) ...[
              _sectionTitle('Motif du rappel'),
              _sectionBody(recall.reason),
            ],
            if (recall.hasRisks) ...[
              _sectionTitle('Risques encourus'),
              _sectionBody(recall.risks, center: true),
            ],
            if (recall.hasAdditionalInfo) ...[
              _sectionTitle('Informations complémentaires'),
              _sectionBody(recall.additionalInfo),
            ],
            if (recall.hasInstructions) ...[
              _sectionTitle('Conduite à tenir'),
              _sectionBody(recall.instructions),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  String _buildDates() {
    if (recall.startDate.isNotEmpty && recall.endDate.isNotEmpty) {
      return 'Du ${recall.startDate} au ${recall.endDate}';
    }
    if (recall.startDate.isNotEmpty) {
      return 'À partir du ${recall.startDate}';
    }
    return recall.endDate;
  }

  Widget _sectionTitle(String title) {
    return Container(
      width: double.infinity,
      color: _lightSection,
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: _blue,
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _sectionBody(String text, {bool center = false}) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Text(
        text,
        textAlign: center ? TextAlign.center : TextAlign.left,
        style: const TextStyle(
          color: _softText,
          fontSize: 14,
          height: 1.35,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Future<void> _share() async {
    final link = recall.pdfUrl.isNotEmpty ? recall.pdfUrl : recall.sourceUrl;
    await SharePlus.instance.share(
      ShareParams(
        text: link,
        subject: 'Rappel produit ${recall.productName}',
      ),
    );
  }

  Future<void> _openPdf() async {
    final uri = Uri.tryParse(recall.pdfUrl);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}