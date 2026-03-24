import 'package:flutter/material.dart';
import 'package:formation_flutter/model/product_recall.dart';
import 'package:formation_flutter/services/pocketbase_service.dart';

class RecallFetcher extends ChangeNotifier {
  RecallFetcher({required String barcode})
      : _barcode = barcode,
        _state = RecallFetcherLoading() {
    loadRecall();
  }

  final String _barcode;
  RecallFetcherState _state;

  RecallFetcherState get state => _state;

  Future<void> loadRecall() async {
    _state = RecallFetcherLoading();
    notifyListeners();

    try {
      final pb = PocketBaseService.pb;

      final record = await pb.collection('product_recalls').getFirstListItem(
        'barcode = "$_barcode"',
      );

      _state = RecallFetcherFound(ProductRecall.fromRecord(record));
    } catch (_) {
      _state = RecallFetcherNotFound();
    } finally {
      notifyListeners();
    }
  }
}

sealed class RecallFetcherState {}

class RecallFetcherLoading extends RecallFetcherState {}

class RecallFetcherNotFound extends RecallFetcherState {}

class RecallFetcherFound extends RecallFetcherState {
  RecallFetcherFound(this.recall);
  final ProductRecall recall;
}