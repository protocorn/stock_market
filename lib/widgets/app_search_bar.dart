import 'package:flutter/material.dart';
import 'package:stock_market/stock_search.dart';
import 'package:stock_market/theme/app_theme.dart';

/// Shared search field used on every main tab.
/// Tapping it opens the mock-stock search screen.
class AppSearchBar extends StatelessWidget {
  const AppSearchBar({
    super.key,
    this.hintText = 'Search stocks & mutual funds...',
    this.showMic = true,
  });

  final String hintText;
  final bool showMic;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            readOnly: true,
            showCursor: false,
            onTap: () => openStockSearch(context),
            decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: const Icon(Icons.search, color: AppColors.primary),
            ),
          ),
        ),
        if (showMic) ...[
          const SizedBox(width: 10),
          Material(
            color: AppColors.primary,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => openStockSearch(context),
              child: const SizedBox(
                width: 48,
                height: 48,
                child: Icon(Icons.mic, color: Colors.white),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
