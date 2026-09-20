import 'package:flutter/material.dart';
import 'package:stock_market/theme/app_theme.dart';
import 'package:stock_market/widgets/app_page.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PortfolioHeader(),
          SizedBox(height: AppLayout.sectionGap),
          _GraphPlaceholder(),
          SizedBox(height: AppLayout.sectionGap),
          _TodayActionCard(),
        ],
      ),
    );
  }
}

class _PortfolioHeader extends StatelessWidget {
  const _PortfolioHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Hello Sahil!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 12),
        CircleAvatar(
          backgroundImage: const AssetImage('assets/images/avatar.png'),
          radius: 24,
          onBackgroundImageError: (_, _) {},
          child: const Text(
            'S',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
class _TodayActionCard extends StatelessWidget {
  const _TodayActionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppLayout.radiusCard),
        border: Border.all(color: AppColors.border),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What should I do today?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _ActionTile(
                  emoji: '💰',
                  label: 'I have money to invest',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _ActionTile(
                  emoji: '🪙',
                  label: 'I need money',
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'Today: nothing urgent. Your SIP runs in 3 days, all on plan.',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.emoji,
    required this.label,
  });

  final String emoji;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.softGreen,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GraphPlaceholder extends StatelessWidget {
  const _GraphPlaceholder();

  static const double _aspectRatio = 16 / 9;
  static const double _minHeight = 280;
  static const double _maxHeight = 420;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = (width / _aspectRatio).clamp(_minHeight, _maxHeight);

        return SizedBox(
          width: width,
          height: height,
          child: const Placeholder(),
        );
      },
    );
  }
}
