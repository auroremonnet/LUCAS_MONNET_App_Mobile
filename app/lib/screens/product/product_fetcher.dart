import 'package:flutter/material.dart';
import 'package:formation_flutter/api/open_food_facts_api.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/services/pocketbase_service.dart';

class ProductFetcher extends ChangeNotifier {
  ProductFetcher({required String barcode})
      : _barcode = barcode,
        _state = ProductFetcherLoading() {
    loadProduct();
  }

  final String _barcode;
  ProductFetcherState _state;

  Future<void> loadProduct() async {
    _state = ProductFetcherLoading();
    notifyListeners();

    try {
      final Product product = await OpenFoodFactsAPI().getProduct(_barcode);

      _saveToPocketBase(product);

      _state = ProductFetcherSuccess(product);
    } catch (error) {
      _state = ProductFetcherError(error);
    } finally {
      notifyListeners();
    }
  }

  Future<void> _saveToPocketBase(Product product) async {
    try {
      final pb = PocketBaseService.pb;
      final userId = pb.authStore.model?.id;

      if (userId == null) return;
      if ((product.barcode ?? '').isEmpty) return;

      await pb.collection('history').create(
        body: {
          'user': userId,
          'barcode': product.barcode,
          'name': product.name ?? 'Nom inconnu',
          'brand': product.brands?.join(', ') ?? 'Marque inconnue',
          'picture': product.picture ?? '',
          'nutriscore':
              product.nutriScore?.toString().split('.').last.toUpperCase() ?? '?',
        },
      );

      print("Sauvegardé dans l'historique !");
    } catch (e) {
      print("Erreur de sauvegarde historique : $e");
    }
  }

  ProductFetcherState get state => _state;
}

sealed class ProductFetcherState {}

class ProductFetcherLoading extends ProductFetcherState {}

class ProductFetcherSuccess extends ProductFetcherState {
  ProductFetcherSuccess(this.product);
  final Product product;
}

class ProductFetcherError extends ProductFetcherState {
  ProductFetcherError(this.error);
  final dynamic error;
}