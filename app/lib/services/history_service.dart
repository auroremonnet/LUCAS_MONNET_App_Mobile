import 'package:formation_flutter/services/pocketbase_service.dart';
import 'package:pocketbase/pocketbase.dart';

class HistoryService {
  HistoryService._();

  static PocketBase get _pb => PocketBaseService.pb;

  static String? get _userId => _pb.authStore.model?.id;

  static Future<List<RecordModel>> getHistory() async {
    final userId = _userId;
    if (userId == null) {
      throw Exception('Utilisateur non connecté');
    }

    final result = await _pb.collection('history').getFullList(
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
}