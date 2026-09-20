import 'package:flutter/material.dart';
import 'package:stock_market/theme/app_theme.dart';
import 'package:stock_market/widgets/app_search_bar.dart';

/// Shared page chrome: pinned search, then scrollable body.
class AppPage extends StatelessWidget {
  const AppPage({
    super.key,
    required this.child,
                        this.searchHint = 'Search stocks & mutual funds...',
    this.showSearch = true,
  });

  final Widget child;
  final String searchHint;
  final bool showSearch;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ColoredBox(
        color: AppColors.background,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= AppLayout.wideBreakpoint;
            final padding = isWide
                ? AppLayout.pagePaddingWide
                : AppLayout.pagePaddingNarrow;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppLayout.contentMaxWidth,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (showSearch)
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          padding,
                          AppLayout.searchTopPadding,
                          padding,
                          AppLayout.sectionGap,
                        ),
                        child: AppSearchBar(hintText: searchHint),
                      ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(
                          padding,
                          showSearch ? 0 : AppLayout.searchTopPadding,
                          padding,
                          padding,
                        ),
                        child: child,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
