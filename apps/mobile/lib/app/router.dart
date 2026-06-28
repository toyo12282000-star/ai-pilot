import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_pilot/app/main_shell.dart';
import 'package:ai_pilot/features/favorite/presentation/pages/favorites_page.dart';
import 'package:ai_pilot/features/home/presentation/pages/home_page.dart';
import 'package:ai_pilot/features/workflow/presentation/pages/ai_tool_detail_page.dart';
import 'package:ai_pilot/features/workflow/presentation/pages/workflow_detail_page.dart';
import 'package:ai_pilot/features/workflow/presentation/pages/workflow_run_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomePage(),
            ),
          ),
          GoRoute(
            path: '/favorites',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: FavoritesPage(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/workflows/:id/run',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return WorkflowRunPage(workflowId: id);
        },
      ),
      GoRoute(
        path: '/workflows/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return WorkflowDetailPage(workflowId: id);
        },
      ),
      GoRoute(
        path: '/ai-tools/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return AIToolDetailPage(aiToolId: id);
        },
      ),
    ],
  );
});
