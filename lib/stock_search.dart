import 'package:flutter/material.dart';
import 'package:stock_market/data/stock_repository.dart';
import 'package:stock_market/models/stock.dart';
import 'package:stock_market/stock_detail.dart';
import 'package:stock_market/theme/app_theme.dart';
import 'package:stock_market/utils/formatters.dart';

/// Full-screen search over mock Indian stocks.
class StockSearchScreen extends StatefulWidget {
  const StockSearchScreen({super.key});

  @override
  State<StockSearchScreen> createState() => _StockSearchScreenState();
}

class _StockSearchScreenState extends State<StockSearchScreen> {
  late Future<MockMarketData> _future;
  final _controller = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _future = StockRepository.instance.load();
    _controller.addListener(() {
      setState(() => _query = _controller.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Stock> _filtered(List<Stock> stocks) {
    if (_query.isEmpty) return stocks;
    return stocks.where((s) {
      return s.ticker.toLowerCase().contains(_query) ||
          s.name.toLowerCase().contains(_query) ||
          s.id.toLowerCase().contains(_query);
    }).toList();
  }

  void _openDetail(Stock stock) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StockDetailScreen(stockId: stock.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= AppLayout.wideBreakpoint;
    final padding =
        isWide ? AppLayout.pagePaddingWide : AppLayout.pagePaddingNarrow;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppLayout.contentMaxWidth),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(padding, 8, padding, 12),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                        color: AppColors.primary,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          autofocus: true,
                          decoration: const InputDecoration(
                            hintText: 'Search stocks & mutual funds...',
                            prefixIcon: Icon(
                              Icons.search,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: FutureBuilder<MockMarketData>(
                    future: _future,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError || !snapshot.hasData) {
                        return const Center(
                          child: Text('Could not load mock stock data.'),
                        );
                      }

                      final results = _filtered(snapshot.data!.stocks);
                      if (results.isEmpty) {
                        return const Center(
                          child: Text(
                            'No stocks match your search.',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        );
                      }

                      return ListView.separated(
                        padding: EdgeInsets.fromLTRB(padding, 0, padding, padding),
                        itemCount: results.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final stock = results[index];
                          return _SearchResultTile(
                            stock: stock,
                            onTap: () => _openDetail(stock),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  const _SearchResultTile({
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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      stock.ticker,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    Formatters.inr(stock.price),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    Formatters.percent(stock.changePercent),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: changeColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.scoreColor(stock.score).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${stock.score}',
                  style: TextStyle(
                    fontSize: 12,
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

/// Opens [StockSearchScreen] from anywhere in the app.
void openStockSearch(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const StockSearchScreen()),
  );
}
