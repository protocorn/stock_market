import 'package:flutter/material.dart';
import 'package:stock_market/theme/app_theme.dart';

class BigButton extends StatelessWidget {
  const BigButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.primary = false,
  });

  final VoidCallback onPressed;
  final String text;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 56),
        elevation: 0,
        backgroundColor: primary ? AppColors.primary : AppColors.surface,
        foregroundColor: primary ? Colors.white : AppColors.textPrimary,
        shape: const StadiumBorder(),
        side: primary
            ? BorderSide.none
            : const BorderSide(color: AppColors.border),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
