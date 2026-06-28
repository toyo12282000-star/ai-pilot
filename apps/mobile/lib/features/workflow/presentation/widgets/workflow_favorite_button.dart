import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/icons.dart';
import 'package:ai_pilot/features/favorite/presentation/providers/favorite_providers.dart';
import 'package:ai_pilot/shared/providers/authenticated_user_provider.dart';

/// ワークフロー詳細画面のお気に入りボタン。
class WorkflowFavoriteButton extends ConsumerStatefulWidget {
  const WorkflowFavoriteButton({
    super.key,
    required this.workflowId,
  });

  final String workflowId;

  @override
  ConsumerState<WorkflowFavoriteButton> createState() =>
      _WorkflowFavoriteButtonState();
}

class _WorkflowFavoriteButtonState extends ConsumerState<WorkflowFavoriteButton> {
  bool _isToggling = false;

  Future<void> _toggleFavorite(bool isFavorite, String userId) async {
    if (_isToggling) {
      return;
    }

    setState(() => _isToggling = true);

    try {
      final repository = ref.read(favoriteRepositoryProvider);

      if (isFavorite) {
        await repository.removeFavorite(userId, widget.workflowId);
        if (!mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('お気に入りを解除しました')),
        );
      } else {
        await repository.addFavorite(userId, widget.workflowId);
        if (!mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('お気に入りに追加しました')),
        );
      }

      invalidateFavoriteForWorkflow(ref, widget.workflowId);
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('お気に入りの更新に失敗しました')),
      );
    } finally {
      if (mounted) {
        setState(() => _isToggling = false);
      }
    }
  }

  void _handleGuestTap() {
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final userId = ref.watch(authenticatedUserIdProvider);
    final isFavoriteAsync = ref.watch(isFavoriteProvider(widget.workflowId));

    if (userId == null) {
      return IconButton(
        onPressed: _handleGuestTap,
        tooltip: 'ログインしてお気に入りに追加',
        icon: const Icon(
          AppIcons.favorite,
          color: AppColors.textSecondary,
        ),
      );
    }

    ref.listen(isFavoriteProvider(widget.workflowId), (previous, next) {
      if (next.hasError && previous?.hasError != true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('お気に入り状態の取得に失敗しました')),
        );
      }
    });

    final isLoading = _isToggling || isFavoriteAsync.isLoading;
    final isFavorite = isFavoriteAsync.value ?? false;
    final isDisabled = isLoading || isFavoriteAsync.hasError;

    return IconButton(
      onPressed:
          isDisabled ? null : () => _toggleFavorite(isFavorite, userId),
      tooltip: isFavorite ? 'お気に入り解除' : 'お気に入りに追加',
      icon: Icon(
        isFavorite ? AppIcons.favoriteFilled : AppIcons.favorite,
        color: isFavorite ? AppColors.primary : AppColors.textSecondary,
      ),
    );
  }
}
