import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PocketBaseService {
  static late final PocketBase pb;

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    
    final store = AsyncAuthStore(
      save: (String data) async => prefs.setString('pb_auth', data),
      initial: prefs.getString('pb_auth'),
    );
    
    // Remplacement de 10.0.2.2 par 127.0.0.1 pour Windows/Web
    pb = PocketBase('http://127.0.0.1:8090', authStore: store);
  }

  static bool get isAuthenticated => pb.authStore.isValid;
  
  static void logout() {
    pb.authStore.clear();
  }
}