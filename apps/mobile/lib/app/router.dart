import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_pilot/app/main_shell.dart';
import 'package:ai_pilot/features/auth/presentation/pages/email_auth_page.dart';
import 'package:ai_pilot/features/auth/presentation/pages/login_page.dart';
import 'package:ai_pilot/features/auth/presentation/providers/auth_providers.dart';
import 'package:ai_pilot/features/favorite/presentation/pages/favorites_page.dart';
import 'package:ai_pilot/features/home/presentation/pages/home_page.dart';
import 'package:ai_pilot/features/workflow/presentation/pages/ai_tool_detail_page.dart';
import 'package:ai_pilot/features/workflow/presentation/pages/workflow_detail_page.dart';
import 'package:ai_pilot/features/workflow/presentation/pages/workflow_run_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final canAccess = ref.watch(canAccessAppProvider);
  final authLoading = ref.watch(authLoadingProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isLoginRoute = state.matchedLocation.startsWith('/login');

      if (authLoading && !canAccess) {
        return isLoginRoute ? null : '/login';
      }

      if (!canAccess && !isLoginRoute) {
        return '/login';
      }

      if (canAccess && isLoginRoute) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
        routes: [
          GoRoute(
            path: 'email',
            builder: (context, state) => const EmailAuthPage(),
          ),
        ],
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: HomePage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/favorites',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: FavoritesPage(),
                ),
              ),
            ],
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
