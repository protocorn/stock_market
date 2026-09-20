import 'package:flutter/material.dart';
import 'package:stock_market/home.dart';
import 'package:stock_market/theme/app_theme.dart';
import 'package:stock_market/widgets/big_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int _step = 0; // 0..3 → STEP 1..4

  // Step 4 dials
  double _monthly = 12000;
  double _durationYears = 10;
  double _riskIndex = 2; // 0 panic, 1 wait, 2 buy more

  void _next() {
    if (_step < 3) {
      setState(() => _step++);
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  void _back() {
    if (_step == 0) {
      Navigator.pop(context);
      return;
    }
    setState(() => _step--);
  }

  _ProfileResult get _liveResult {
    final riskPoints = _riskIndex.round();
    final durationPoints =
        _durationYears >= 8 ? 2 : (_durationYears >= 4 ? 1 : 0);
    final monthlyPoints = _monthly >= 25000 ? 1 : 0;
    final total = riskPoints * 2 + durationPoints + monthlyPoints;

    if (total <= 2) {
      return const _ProfileResult(
        title: 'Careful Saver',
        emoji: '🛡️',
        equityPercent: 30,
      );
    }
    if (total <= 4) {
      return const _ProfileResult(
        title: 'Balanced Grower',
        emoji: '⚖️',
        equityPercent: 60,
      );
    }
    return const _ProfileResult(
      title: 'Growth Seeker',
      emoji: '🚀',
      equityPercent: 80,
    );
  }

  String get _durationLabel {
    final years = _durationYears.round();
    if (years >= 10) return '10+ yrs';
    return '$years yr${years == 1 ? '' : 's'}';
  }

  String get _riskLabel {
    switch (_riskIndex.round()) {
      case 0:
        return "😱 I'd panic";
      case 1:
        return "😳 I'd wait";
      default:
        return '😎 buy more!';
    }
  }

  String _formatRupees(int amount) {
    final s = amount.toString();
    final buf = StringBuffer('₹');
    final len = s.length;
    for (var i = 0; i < len; i++) {
      final fromEnd = len - i;
      if (i > 0 && fromEnd % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: _back,
                    icon: const Icon(Icons.arrow_back),
                    color: AppColors.primary,
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    child: _step == 3 ? _buildStep4() : _buildEmptyStep(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: BigButton(
                    onPressed: _next,
                    text: _step == 3 ? 'Lock it in →' : 'Continue →',
                    primary: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyStep() {
    final stepNumber = _step + 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'STEP $stepNumber OF 4',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Step $stepNumber',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Content for this step comes later.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 40),
        Container(
          width: double.infinity,
          height: 160,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppLayout.radiusCard),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(
            'Placeholder for step $stepNumber',
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }

  Widget _buildStep4() {
    final result = _liveResult;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'STEP 4 OF 4',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Set your comfort zone',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Drag the dials — your profile updates live below.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 20),
        _DialCard(
          title: '💰  Monthly investment',
          valueLabel: _formatRupees(_monthly.round()),
          value: _monthly,
          min: 500,
          max: 50000,
          divisions: 99,
          minLabel: '₹500',
          maxLabel: '₹50,000',
          onChanged: (v) => setState(() => _monthly = v),
        ),
        const SizedBox(height: 12),
        _DialCard(
          title: '⌛  How long can money stay?',
          valueLabel: _durationLabel,
          value: _durationYears,
          min: 1,
          max: 10,
          divisions: 9,
          minLabel: '1 yr',
          maxLabel: '10+ yrs',
          onChanged: (v) => setState(() => _durationYears = v),
        ),
        const SizedBox(height: 12),
        _DialCard(
          title: '📉  If it drops 20%...',
          valueLabel: _riskLabel,
          value: _riskIndex,
          min: 0,
          max: 2,
          divisions: 2,
          minLabel: "😱 I'd panic",
          midLabel: "😳 I'd wait",
          maxLabel: '😎 buy more!',
          onChanged: (v) => setState(() => _riskIndex = v),
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.softGreen,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              const Text(
                'LIVE RESULT',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${result.title} ${result.emoji}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 10,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  _ResultChip(label: '${result.equityPercent}% equity'),
                  _ResultChip(
                    label: '${100 - result.equityPercent}% safer stuff',
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileResult {
  const _ProfileResult({
    required this.title,
    required this.emoji,
    required this.equityPercent,
  });

  final String title;
  final String emoji;
  final int equityPercent;
}

class _DialCard extends StatelessWidget {
  const _DialCard({
    required this.title,
    required this.valueLabel,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.minLabel,
    required this.maxLabel,
    required this.onChanged,
    this.midLabel,
  });

  final String title;
  final String valueLabel;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String minLabel;
  final String maxLabel;
  final String? midLabel;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppLayout.radiusCard),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Flexible(
                child: Text(
                  valueLabel,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: AppColors.border,
              thumbColor: AppColors.primary,
              overlayColor: AppColors.primary.withValues(alpha: 0.15),
              trackHeight: 4,
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
          if (midLabel == null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  minLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  maxLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    minLabel,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    midLabel!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    maxLabel,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _ResultChip extends StatelessWidget {
  const _ResultChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
