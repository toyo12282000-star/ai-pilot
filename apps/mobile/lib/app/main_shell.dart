import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/icons.dart';

/// ホーム / お気に入りタブ用の Shell Scaffold。
class MainShell extends StatelessWidget {
  const MainShell({
    super.key,
    required this.child,
  });

  final Widget child;

  static const _destinations = [
    NavigationDestination(
      icon: Icon(AppIcons.home),
      selectedIcon: Icon(AppIcons.homeFilled),
      label: 'ホーム',
    ),
    NavigationDestination(
      icon: Icon(AppIcons.favorite),
      selectedIcon: Icon(AppIcons.favoriteFilled),
      label: 'お気に入り',
    ),
  ];

  int _selectedIndex(String location) {
    if (location.startsWith('/favorites')) {
      return 1;
    }
    return 0;
  }

  void _onDestinationSelected(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
      case 1:
        context.go('/favorites');
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final selectedIndex = _selectedIndex(location);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: child,
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.outline),
          ),
        ),
        child: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) =>
              _onDestinationSelected(context, index),
          destinations: _destinations,
        ),
      ),
    );
  }
}
