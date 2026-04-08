import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  final StatefulNavigationShell shell;

  const AppShell({super.key, required this.shell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: (index) {
          shell.goBranch(index, initialLocation: index == shell.currentIndex);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.library_books_outlined),
            selectedIcon: Icon(Icons.library_books),
            label: '컬렉션',
          ),
          NavigationDestination(
            icon: Icon(Icons.gavel_outlined),
            selectedIcon: Icon(Icons.gavel),
            label: '규칙 판정관',
          ),
          NavigationDestination(
            icon: Icon(Icons.recommend_outlined),
            selectedIcon: Icon(Icons.recommend),
            label: '게임 추천',
          ),
          NavigationDestination(
            icon: Icon(Icons.scoreboard_outlined),
            selectedIcon: Icon(Icons.scoreboard),
            label: '전적 관리',
          ),
        ],
      ),
    );
  }
}
