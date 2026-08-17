import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  final StatefulNavigationShell shell;

  const AppShell({super.key, required this.shell});

  static const _destinations = [
    (icon: Icons.casino_outlined, selectedIcon: Icons.casino, label: '오늘 플레이'),
    (
      icon: Icons.library_books_outlined,
      selectedIcon: Icons.library_books,
      label: '컬렉션',
    ),
    (icon: Icons.sell_outlined, selectedIcon: Icons.sell, label: '판매 추천'),
    (icon: Icons.gavel_outlined, selectedIcon: Icons.gavel, label: '판정'),
    (
      icon: Icons.recommend_outlined,
      selectedIcon: Icons.recommend,
      label: '추천',
    ),
    (
      icon: Icons.scoreboard_outlined,
      selectedIcon: Icons.scoreboard,
      label: '전적',
    ),
    (icon: Icons.settings_outlined, selectedIcon: Icons.settings, label: '설정'),
  ];

  void _onTap(int index) =>
      shell.goBranch(index, initialLocation: index == shell.currentIndex);

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 600;

    if (isWide) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: shell.currentIndex,
              onDestinationSelected: _onTap,
              labelType: NavigationRailLabelType.all,
              destinations: [
                for (final d in _destinations)
                  NavigationRailDestination(
                    icon: Icon(d.icon),
                    selectedIcon: Icon(d.selectedIcon),
                    label: Text(d.label),
                  ),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: shell),
          ],
        ),
      );
    }

    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: _onTap,
        destinations: [
          for (final d in _destinations)
            NavigationDestination(
              icon: Icon(d.icon),
              selectedIcon: Icon(d.selectedIcon),
              label: d.label,
            ),
        ],
      ),
    );
  }
}
