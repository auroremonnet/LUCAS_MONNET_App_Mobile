import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/services/pocketbase_service.dart';
import 'package:pocketbase/pocketbase.dart';

class FavoritesService {
  FavoritesService._();

  static PocketBase get _pb => PocketBaseService.pb;

  static String? get _userId => _pb.authStore.model?.id;

  static Future<bool> isFavorite(String barcode) async {
    final userId = _userId;
    if (userId == null || barcode.isEmpty) return false;

    try {
      final record = await _pb.collection('favorites').getFirstListItem(
        'user = "$userId" && barcode = "$barcode"',
      );
      return record.id.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  static Future<void> addFavorite(Product product) async {
    final userId = _userId;
    if (userId == null) {
      throw Exception('Utilisateur non connecté');
    }

    final barcode = product.barcode;
    if (barcode == null || barcode.isEmpty) {
      throw Exception('Code-barres introuvable');
    }

    final existing = await _findFavoriteRecord(barcode);
    if (existing != null) return;

    await _pb.collection('favorites').create(
      body: {
        'user': userId,
        'barcode': barcode,
        'name': product.name ?? 'Nom inconnu',
        'brand': product.brands?.join(', ') ?? 'Marque inconnue',
        'picture': product.picture ?? '',
        'nutriscore': product.nutriScore?.toString().split('.').last.toUpperCase() ?? '?',
        'key': '${userId}_$barcode',
      },
    );
  }

  static Future<void> removeFavorite(String barcode) async {
    final record = await _findFavoriteRecord(barcode);
    if (record == null) return;

    await _pb.collection('favorites').delete(record.id);
  }

  static Future<List<RecordModel>> getFavorites() async {
    final userId = _userId;
    if (userId == null) {
      throw Exception('Utilisateur non connecté');
    }

    final result = await _pb.collection('favorites').getFullList(
      filter: 'user = "$userId"',
      sort: '-created',
    );

    final unique = <String, RecordModel>{};
    for (final record in result) {
      final barcode = (record.data['barcode'] ?? '').toString();
      if (barcode.isNotEmpty && !unique.containsKey(barcode)) {
        unique[barcode] = record;
      }
    }

    return unique.values.toList();
  }

  static Future<RecordModel?> _findFavoriteRecord(String barcode) async {
    final userId = _userId;
    if (userId == null || barcode.isEmpty) return null;

    try {
      return await _pb.collection('favorites').getFirstListItem(
        'user = "$userId" && barcode = "$barcode"',
      );
    } catch (_) {
      return null;
    }
  }
}