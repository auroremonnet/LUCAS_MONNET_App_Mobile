import 'package:flutter/material.dart';
import 'package:formation_flutter/l10n/app_localizations.dart';
import 'package:formation_flutter/model/product_recall.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/res/app_theme_extension.dart';
import 'package:formation_flutter/screens/favorites/favorites_page.dart';
import 'package:formation_flutter/screens/homepage/homepage_screen.dart';
import 'package:formation_flutter/screens/login/login_screen.dart';
import 'package:formation_flutter/screens/login/register_screen.dart';
import 'package:formation_flutter/screens/product/product_page.dart';
import 'package:formation_flutter/screens/recalls/product_recall_page.dart';
import 'package:formation_flutter/screens/scanner/scanner_screen.dart';
import 'package:formation_flutter/services/pocketbase_service.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PocketBaseService.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GoRouter _router = GoRouter(
    initialLocation: PocketBaseService.isAuthenticated ? '/' : '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (_, _) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (_, _) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (_, _) => const HomePage(),
      ),
      GoRoute(
        path: '/scanner',
        builder: (_, _) => const ScannerScreen(),
      ),
      GoRoute(
        path: '/favorites',
        builder: (_, _) => const FavoritesPage(),
      ),
      GoRoute(
        path: '/product',
        builder: (_, GoRouterState state) =>
            ProductPage(barcode: state.extra as String),
      ),
      GoRoute(
        path: '/product-recall',
        builder: (_, GoRouterState state) =>
            ProductRecallPage(recall: state.extra as ProductRecall),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Yuka Clone',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        extensions: [OffThemeExtension.defaultValues()],
        fontFamily: 'Avenir',
        dividerTheme: const DividerThemeData(
          color: AppColors.grey2,
          space: 1.0,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.blue),
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}