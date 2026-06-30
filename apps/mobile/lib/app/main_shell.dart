import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_pilot/app/app_sidebar.dart';
import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/icons.dart';

/// ホーム / お気に入り / 設定タブ用の Shell Scaffold。
class MainShell extends StatelessWidget {
  const MainShell({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  static const double _sidebarBreakpoint = 900;

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
    NavigationDestination(
      icon: Icon(AppIcons.settings),
      selectedIcon: Icon(AppIcons.settingsFilled),
      label: '設定',
    ),
  ];

  void _onDestinationSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final useSidebar =
        MediaQuery.sizeOf(context).width >= _sidebarBreakpoint;

    if (useSidebar) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Row(
          children: [
            SizedBox(
              width: AppSidebar.width,
              child: AppSidebar(
                selectedIndex: navigationShell.currentIndex,
                onDestinationSelected: _onDestinationSelected,
              ),
            ),
            Expanded(child: navigationShell),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: navigationShell,
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.outline),
          ),
        ),
        child: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _onDestinationSelected,
          destinations: _destinations,
        ),
      ),
    );
  }
}
