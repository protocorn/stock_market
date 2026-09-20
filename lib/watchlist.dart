import 'package:flutter/material.dart';
import 'package:stock_market/data/stock_repository.dart';
import 'package:stock_market/models/stock.dart';
import 'package:stock_market/stock_detail.dart';
import 'package:stock_market/stock_search.dart';
import 'package:stock_market/theme/app_theme.dart';
import 'package:stock_market/utils/formatters.dart';
import 'package:stock_market/widgets/app_page.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  late Future<MockMarketData> _future;
  List<String>? _watchlistIds;
  int _addCursor = 0;

  @override
  void initState() {
    super.initState();
    _future = StockRepository.instance.load().then((data) {
      _watchlistIds ??= List.of(data.defaultWatchlistIds);
      return data;
    });
  }

  void _openDetail(String stockId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StockDetailScreen(stockId: stockId),
      ),
    );
  }

  void _addItem(MockMarketData data) {
    final ids = _watchlistIds ?? [];
    final candidates =
        data.stocks.where((s) => !ids.contains(s.id)).toList();
    if (candidates.isEmpty) {
      final next = data.stocks[_addCursor % data.stocks.length];
      _addCursor++;
      setState(() => _watchlistIds = [...ids, next.id]);
      return;
    }
    setState(() => _watchlistIds = [...ids, candidates.first.id]);
  }

  void _removeItem() {
    final ids = _watchlistIds ?? [];
    if (ids.isEmpty) return;
    setState(() => _watchlistIds = ids.sublist(0, ids.length - 1));
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      child: FutureBuilder<MockMarketData>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Padding(
              padding: EdgeInsets.all(40),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Text('Could not load mock stock data.');
          }

          final data = snapshot.data!;
          final watchlistIds = _watchlistIds ?? data.defaultWatchlistIds;

          final recommendation = data.byId(data.recommendationId);
          final watchlistStocks = watchlistIds
              .map(data.byId)
              .whereType<Stock>()
              .toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Watchlist',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  IconButton.filled(
                    onPressed: watchlistIds.isEmpty ? null : _removeItem,
                    icon: const Icon(Icons.remove),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: () => _addItem(data),
                    icon: const Icon(Icons.add),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppLayout.sectionGap),
              if (recommendation != null)
                _RecommendationCard(
                  stock: recommendation,
                  onOpen: () => _openDetail(recommendation.id),
                ),
              const SizedBox(height: 12),
              ...watchlistStocks.map((stock) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _WatchlistRow(
                    stock: stock,
                    onTap: () => _openDetail(stock.id),
                  ),
                );
              }),
              if (watchlistStocks.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    'No stocks yet. Tap + to add from mock data.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () => openStockSearch(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(color: AppColors.border),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('+ Search any stock or fund'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({
    required this.stock,
    required this.onOpen,
  });

  final Stock stock;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppLayout.radiusCard),
      child: InkWell(
        onTap: onOpen,
        borderRadius: BorderRadius.circular(AppLayout.radiusCard),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppLayout.radiusCard),
            border: Border.all(color: AppColors.primary),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      stock.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Text(
                    'score ${stock.previousScore} → ${stock.score} ↑',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                stock.recommendationInsight,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Text(
                    '${Formatters.priceAndChange(stock.price, stock.changePercent)} today',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: onOpen,
                    child: const Text('Buy'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WatchlistRow extends StatelessWidget {
  const _WatchlistRow({
    required this.stock,
    required this.onTap,
  });

  final Stock stock;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final changeColor =
        stock.isUp ? AppColors.scoreHigh : AppColors.negative;

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppLayout.radiusCard),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppLayout.radiusCard),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppLayout.radiusCard),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.softGreen,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  stock.ticker.length > 4
                      ? stock.ticker.substring(0, 4)
                      : stock.ticker,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stock.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${Formatters.inr(stock.price)}  · ',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          TextSpan(
                            text: Formatters.percent(stock.changePercent),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: changeColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 56,
                height: 28,
                child: Placeholder(),
              ),
              const SizedBox(width: 10),
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.scoreColor(stock.score).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${stock.score}',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.scoreColor(stock.score),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
