import 'package:flutter/material.dart';
import 'package:stock_market/portfolio.dart';
import 'package:stock_market/watchlist.dart';
import 'package:stock_market/research.dart';
import 'package:stock_market/agent.dart';
import 'package:stock_market/theme/app_theme.dart';

class WebNavDestination {
  final String label;
  final IconData icon;

  WebNavDestination({required this.label, required this.icon});
}

List<WebNavDestination> appDestinations = [
  WebNavDestination(label: 'Portfolio', icon: Icons.home),
  WebNavDestination(label: 'Watchlist', icon: Icons.bookmark_border),
  WebNavDestination(label: 'Research', icon: Icons.explore),
  WebNavDestination(label: 'Agent', icon: Icons.settings),
];

class StandardAdaptiveShell extends StatefulWidget {
  const StandardAdaptiveShell({super.key});
  @override
  State<StandardAdaptiveShell> createState() => _StandardAdaptiveShellState();
}

class _StandardAdaptiveShellState extends State<StandardAdaptiveShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const PortfolioScreen(),
    const WatchlistScreen(),
    const ResearchScreen(),
    const AgentScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > AppLayout.wideBreakpoint) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              title: const Text('Stock Market'),
              actions: List.generate(appDestinations.length, (index) {
                final destination = appDestinations[index];
                final isSelected = index == _currentIndex;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextButton.icon(
                    onPressed: () => setState(() => _currentIndex = index),
                    icon: Icon(
                      destination.icon,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
                    label: Text(
                      destination.label,
                      style: TextStyle(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: isSelected ? 18 : 16,
                      ),
                    ),
                  ),
                );
              }),
            ),
            body: _pages[_currentIndex],
          );
        }
        return Scaffold(
          backgroundColor: AppColors.background,
          bottomNavigationBar: BottomNavigationBar(
            items: appDestinations.map((dest) {
              return BottomNavigationBarItem(
                icon: Icon(dest.icon),
                label: dest.label,
              );
            }).toList(),
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
          ),
          body: _pages[_currentIndex],
        );
      },
    );
  }
}
