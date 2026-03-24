import 'package:flutter/material.dart';
import 'package:formation_flutter/l10n/app_localizations.dart';
import 'package:formation_flutter/res/app_icons.dart';
import 'package:formation_flutter/screens/homepage/homepage_empty.dart';
import 'package:formation_flutter/services/history_service.dart';
import 'package:formation_flutter/services/pocketbase_service.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketbase/pocketbase.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<RecordModel>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    _historyFuture = HistoryService.getHistory();
  }

  Future<void> _reload() async {
    setState(() {
      _loadHistory();
    });
    await _historyFuture;
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.my_scans_screen_title),
        centerTitle: false,
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              await context.push('/favorites');
              if (mounted) {
                _reload();
              }
            },
            icon: const Icon(Icons.star),
          ),
          IconButton(
            onPressed: () {
              PocketBaseService.logout();
              context.go('/login');
            },
            icon: const Icon(Icons.logout),
          ),
          IconButton(
            onPressed: () => _onScanButtonPressed(context),
            icon: const Padding(
              padding: EdgeInsetsDirectional.only(end: 8.0),
              child: Icon(AppIcons.barcode),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<RecordModel>>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return _HistoryErrorView(onRetry: _reload);
          }

          final history = snapshot.data ?? [];

          if (history.isEmpty) {
            return HomePageEmpty(
              onScan: () => _onScanButtonPressed(context),
            );
          }

          return RefreshIndicator(
            onRefresh: _reload,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: history.length,
              separatorBuilder: (_, __) => const SizedBox(height: 18),
              itemBuilder: (context, index) {
                final record = history[index];
                return _HistoryCard(record: record);
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _onScanButtonPressed(BuildContext context) async {
    await context.push('/product', extra: '8445290000842');
    if (mounted) {
      _reload();
    }
  }
  /*Future<void> _onScanButtonPressed(BuildContext context) async {
  await context.push('/product', extra: '8445290000842');
  if (mounted) {
    _reload();
  }
  /scanner
  */
}


class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.record});

  final RecordModel record;

  @override
  Widget build(BuildContext context) {
    final barcode = (record.data['barcode'] ?? '').toString();
    final name = (record.data['name'] ?? 'Nom inconnu').toString();
    final brand = (record.data['brand'] ?? 'Marque inconnue').toString();
    final picture = (record.data['picture'] ?? '').toString();
    final nutriscore = (record.data['nutriscore'] ?? '?').toString().toUpperCase();

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: barcode.isEmpty
          ? null
          : () => context.push('/product', extra: barcode),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: picture.isNotEmpty
                  ? Image.network(
                      picture,
                      width: 96,
                      height: 96,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _imagePlaceholder(),
                    )
                  : _imagePlaceholder(),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: SizedBox(
                height: 96,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1D1753),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      brand,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF9B9BA7),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: _nutriColor(nutriscore),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Nutriscore : $nutriscore',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF1D1753),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      width: 96,
      height: 96,
      color: const Color(0xFFEAEAEA),
      child: const Icon(Icons.image_not_supported, color: Colors.grey),
    );
  }

  Color _nutriColor(String score) {
    switch (score) {
      case 'A':
        return const Color(0xFF1AA64A);
      case 'B':
        return const Color(0xFF86C440);
      case 'C':
        return const Color(0xFFF2C300);
      case 'D':
        return const Color(0xFFF28A1A);
      case 'E':
        return const Color(0xFFE74C2C);
      default:
        return Colors.grey;
    }
  }
}

class _HistoryErrorView extends StatelessWidget {
  const _HistoryErrorView({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            const Text(
              "Une erreur est survenue lors du chargement de l'historique.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF1D1753),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }
}