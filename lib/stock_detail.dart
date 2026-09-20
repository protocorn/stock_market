import 'package:flutter/material.dart';
import 'package:stock_market/data/stock_repository.dart';
import 'package:stock_market/models/stock.dart';
import 'package:stock_market/theme/app_theme.dart';
import 'package:stock_market/utils/formatters.dart';

class StockDetailScreen extends StatefulWidget {
  const StockDetailScreen({super.key, required this.stockId});

  final String stockId;

  @override
  State<StockDetailScreen> createState() => _StockDetailScreenState();
}

class _StockDetailScreenState extends State<StockDetailScreen> {
  late Future<Stock?> _future;
  int _financialTab = 0;

  @override
  void initState() {
    super.initState();
    _future = StockRepository.instance.getById(widget.stockId);
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
            child: FutureBuilder<Stock?>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                final stock = snapshot.data;
                if (stock == null) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Stock not found in mock data.'),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Go back'),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(padding, 8, padding, 0),
                      child: Row(
                        children: [
                          TextButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.chevron_left),
                            label: const Text('back'),
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.primary,
                            ),
                          ),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.favorite_border, size: 18),
                            label: const Text('watchlist'),
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(padding, 8, padding, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _Header(stock: stock),
                            const SizedBox(height: AppLayout.sectionGap),
                            _SummaryCard(stock: stock),
                            const SizedBox(height: AppLayout.sectionGap),
                            Text(
                              'Why score ${stock.score}?',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _ScoreBarCard(
                              icon: Icons.bar_chart,
                              label: 'Fundamentals',
                              score: stock.fundamentals.score,
                              detail: stock.fundamentals.detail,
                            ),
                            const SizedBox(height: 10),
                            _ScoreBarCard(
                              icon: Icons.show_chart,
                              label: 'Technicals',
                              score: stock.technicals.score,
                              detail: stock.technicals.detail,
                            ),
                            const SizedBox(height: 10),
                            _ScoreBarCard(
                              icon: Icons.newspaper,
                              label: 'News & buzz',
                              score: stock.news.score,
                              detail: stock.news.detail,
                            ),
                            const SizedBox(height: AppLayout.sectionGap),
                            const Text(
                              'How it compares with peers',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Peers from the same sector — higher score at a saner P/E is the better pick.',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _PeersCard(peers: stock.peers),
                            const SizedBox(height: AppLayout.sectionGap),
                            const Text(
                              'Financials',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _FinancialTabs(
                              selected: _financialTab,
                              onChanged: (i) =>
                                  setState(() => _financialTab = i),
                            ),
                            const SizedBox(height: 12),
                            _FinancialsCard(financials: stock.financials),
                            const SizedBox(height: 10),
                            _InsightBox(
                              emoji: '💡',
                              text: stock.financialInsight,
                            ),
                            const SizedBox(height: AppLayout.sectionGap),
                            const Text(
                              "What's happening",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _EventsCard(stock: stock),
                            const SizedBox(height: 10),
                            _InsightBox(
                              emoji: '🎯',
                              text: stock.forYouInsight,
                            ),
                          ],
                        ),
                      ),
                    ),
                    _BottomActions(stock: stock),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.stock});

  final Stock stock;

  @override
  Widget build(BuildContext context) {
    final changeColor =
        stock.isUp ? AppColors.scoreHigh : AppColors.negative;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                stock.ticker,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${Formatters.inr(stock.price)}  ',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    TextSpan(
                      text: '${Formatters.percent(stock.changePercent)} today',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: changeColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                stock.inPortfolio
                    ? 'in your portfolio'
                    : 'not in your portfolio yet',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 88,
          height: 88,
          child: CustomPaint(
            painter: _ScoreRingPainter(
              score: stock.score,
              color: AppColors.scoreColor(stock.score),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${stock.score}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                  const Text(
                    '/100',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ScoreRingPainter extends CustomPainter {
  _ScoreRingPainter({required this.score, required this.color});

  final int score;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    final track = Paint()
      ..color = AppColors.border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;
    final progress = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, track);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.5708,
      (score.clamp(0, 100) / 100) * 6.2832,
      false,
      progress,
    );
  }

  @override
  bool shouldRepaint(covariant _ScoreRingPainter oldDelegate) {
    return oldDelegate.score != score || oldDelegate.color != color;
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.stock});

  final Stock stock;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppLayout.radiusCard),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '"${stock.summaryQuote}"',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
              color: AppColors.textPrimary,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 10),
          Text(
            '— Investright score ${stock.score}/100',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              stock.statusTag,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFFE65100),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            stock.summaryDescription,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreBarCard extends StatefulWidget {
  const _ScoreBarCard({
    required this.icon,
    required this.label,
    required this.score,
    required this.detail,
  });

  final IconData icon;
  final String label;
  final int score;
  final String detail;

  @override
  State<_ScoreBarCard> createState() => _ScoreBarCardState();
}

class _ScoreBarCardState extends State<_ScoreBarCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.scoreColor(widget.score);

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppLayout.radiusCard),
      child: InkWell(
        onTap: () => setState(() => _expanded = !_expanded),
        borderRadius: BorderRadius.circular(AppLayout.radiusCard),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppLayout.radiusCard),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(widget.icon, color: AppColors.primary, size: 22),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 100,
                    child: Text(
                      widget.label,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: widget.score / 100,
                        minHeight: 10,
                        backgroundColor: AppColors.border,
                        color: color,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${widget.score}',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: color,
                    ),
                  ),
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
              if (_expanded) ...[
                const SizedBox(height: 12),
                Text(
                  widget.detail,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _PeersCard extends StatelessWidget {
  const _PeersCard({required this.peers});

  final List<PeerSnapshot> peers;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppLayout.radiusCard),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Expanded(flex: 3, child: SizedBox()),
              Expanded(
                child: Text(
                  'Score',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ),
              Expanded(
                child: Text(
                  'P/E',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ),
              Expanded(
                child: Text(
                  'ROE',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...peers.map((peer) => _PeerRow(peer: peer)),
        ],
      ),
    );
  }
}

class _PeerRow extends StatelessWidget {
  const _PeerRow({required this.peer});

  final PeerSnapshot peer;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.scoreColor(peer.score);

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: peer.isSelf ? AppColors.softGreen : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              peer.name,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${peer.score}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              peer.pe.toStringAsFixed(1),
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(
              '${peer.roe.round()}%',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _FinancialTabs extends StatelessWidget {
  const _FinancialTabs({
    required this.selected,
    required this.onChanged,
  });

  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    const labels = ['P&L', 'Balance sheet', 'Ratios'];

    return Row(
      children: List.generate(labels.length, (i) {
        final isSelected = i == selected;
        return Padding(
          padding: EdgeInsets.only(right: i == labels.length - 1 ? 0 : 8),
          child: GestureDetector(
            onTap: () => onChanged(i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.softGreen,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                labels[i],
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _FinancialsCard extends StatelessWidget {
  const _FinancialsCard({required this.financials});

  final FinancialsSnapshot financials;

  @override
  Widget build(BuildContext context) {
    final years = financials.years;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppLayout.radiusCard),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _FinanceRow(
            label: '',
            y1: years[0],
            y2: years[1],
            y3: years[2],
            isHeader: true,
          ),
          const Divider(height: 20, color: AppColors.border),
          _FinanceRow(
            label: 'Revenue',
            y1: financials.revenue[0],
            y2: financials.revenue[1],
            y3: financials.revenue[2],
          ),
          const Divider(height: 20, color: AppColors.border),
          _FinanceRow(
            label: 'Net profit',
            y1: financials.netProfit[0],
            y2: financials.netProfit[1],
            y3: financials.netProfit[2],
          ),
          const Divider(height: 20, color: AppColors.border),
          _FinanceRow(
            label: 'Op. margin',
            y1: financials.opMargin[0],
            y2: financials.opMargin[1],
            y3: financials.opMargin[2],
          ),
        ],
      ),
    );
  }
}

class _FinanceRow extends StatelessWidget {
  const _FinanceRow({
    required this.label,
    required this.y1,
    required this.y2,
    required this.y3,
    this.isHeader = false,
  });

  final String label;
  final String y1;
  final String y2;
  final String y3;
  final bool isHeader;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: 13,
      fontWeight: isHeader ? FontWeight.w700 : FontWeight.w500,
      color: isHeader ? AppColors.textSecondary : AppColors.textPrimary,
    );
    final boldStyle = style.copyWith(fontWeight: FontWeight.w800);

    return Row(
      children: [
        Expanded(flex: 2, child: Text(label, style: style)),
        Expanded(child: Text(y1, textAlign: TextAlign.center, style: style)),
        Expanded(child: Text(y2, textAlign: TextAlign.center, style: style)),
        Expanded(child: Text(y3, textAlign: TextAlign.center, style: boldStyle)),
      ],
    );
  }
}

class _EventsCard extends StatelessWidget {
  const _EventsCard({required this.stock});

  final Stock stock;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppLayout.radiusCard),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  stock.eventTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.softGreen,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  stock.eventTag,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            stock.eventDescription,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightBox extends StatelessWidget {
  const _InsightBox({required this.emoji, required this.text});

  final String emoji;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.softGreen,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomActions extends StatelessWidget {
  const _BottomActions({required this.stock});

  final Stock stock;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(color: AppColors.border),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Text(
                  'Sell',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 5,
              child: FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: Text(
                  'Buy 1 · ${Formatters.inr(stock.price)}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
