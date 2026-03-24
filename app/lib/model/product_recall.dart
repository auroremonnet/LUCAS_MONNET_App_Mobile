class ProductRecall {
  final String id;
  final String barcode;
  final String productName;
  final String brand;
  final String imageUrl;
  final String startDate;
  final String endDate;
  final String distributors;
  final String geographicArea;
  final String reason;
  final String risks;
  final String additionalInfo;
  final String instructions;
  final String pdfUrl;
  final String sourceUrl;
  final String title;

  const ProductRecall({
    required this.id,
    required this.barcode,
    required this.productName,
    required this.brand,
    required this.imageUrl,
    required this.startDate,
    required this.endDate,
    required this.distributors,
    required this.geographicArea,
    required this.reason,
    required this.risks,
    required this.additionalInfo,
    required this.instructions,
    required this.pdfUrl,
    required this.sourceUrl,
    required this.title,
  });

  factory ProductRecall.fromRecord(dynamic record) {
    String read(String key) => (record.data[key] ?? '').toString();

    return ProductRecall(
      id: record.id.toString(),
      barcode: read('barcode'),
      productName: read('product_name'),
      brand: read('brand'),
      imageUrl: read('image_url'),
      startDate: read('start_date'),
      endDate: read('end_date'),
      distributors: read('distributors'),
      geographicArea: read('geographic_area'),
      reason: read('reason'),
      risks: read('risks'),
      additionalInfo: read('additional_info'),
      instructions: read('instructions'),
      pdfUrl: read('pdf_url'),
      sourceUrl: read('source_url'),
      title: read('title'),
    );
  }

  bool get hasDates => startDate.isNotEmpty || endDate.isNotEmpty;
  bool get hasDistributors => distributors.isNotEmpty;
  bool get hasGeographicArea => geographicArea.isNotEmpty;
  bool get hasReason => reason.isNotEmpty;
  bool get hasRisks => risks.isNotEmpty;
  bool get hasAdditionalInfo => additionalInfo.isNotEmpty;
  bool get hasInstructions => instructions.isNotEmpty;
  bool get hasImage => imageUrl.isNotEmpty;
  bool get hasPdfUrl => pdfUrl.isNotEmpty;
  bool get hasShareUrl => pdfUrl.isNotEmpty || sourceUrl.isNotEmpty;
}