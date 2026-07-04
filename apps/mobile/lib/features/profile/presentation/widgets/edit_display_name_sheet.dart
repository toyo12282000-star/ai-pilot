import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/profile/domain/services/user_display_name_resolver.dart';
import 'package:ai_pilot/features/profile/presentation/providers/profile_providers.dart';

/// 表示名編集ボトムシートを表示する。
Future<void> showEditDisplayNameSheet({
  required BuildContext context,
  required WidgetRef ref,
  required String initialValue,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) {
      return Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.s16,
          right: AppSpacing.s16,
          top: AppSpacing.s16,
          bottom: MediaQuery.viewInsetsOf(sheetContext).bottom + AppSpacing.s24,
        ),
        child: _EditDisplayNameSheetBody(
          initialValue: initialValue,
          onSave: (value) async {
            await updateCurrentUserDisplayName(ref, value);
            if (!context.mounted) {
              return;
            }
            Navigator.of(sheetContext).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('表示名を保存しました')),
            );
          },
        ),
      );
    },
  );
}

class _EditDisplayNameSheetBody extends StatefulWidget {
  const _EditDisplayNameSheetBody({
    required this.initialValue,
    required this.onSave,
  });

  final String initialValue;
  final Future<void> Function(String value) onSave;

  @override
  State<_EditDisplayNameSheetBody> createState() =>
      _EditDisplayNameSheetBodyState();
}

class _EditDisplayNameSheetBodyState extends State<_EditDisplayNameSheetBody> {
  late final TextEditingController _controller;
  String? _errorText;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final validationError =
        UserDisplayNameResolver.validateForSave(_controller.text);
    if (validationError != null) {
      setState(() => _errorText = validationError);
      return;
    }

    setState(() {
      _errorText = null;
      _isSaving = true;
    });

    try {
      await widget.onSave(_controller.text.trim());
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isSaving = false;
        _errorText = '保存に失敗しました。もう一度お試しください';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '表示名を編集',
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.s8),
          Text(
            '作品の作成履歴や共有名として表示されます',
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.s16),
          TextField(
            controller: _controller,
            autofocus: true,
            maxLength: UserDisplayNameResolver.maxLength,
            inputFormatters: [
              LengthLimitingTextInputFormatter(UserDisplayNameResolver.maxLength),
            ],
            decoration: InputDecoration(
              labelText: '表示名',
              hintText: '例: 山田太郎',
              errorText: _errorText,
              counterText: '',
              border: OutlineInputBorder(
                borderRadius: AppRadius.medium,
              ),
            ),
            onChanged: (_) {
              if (_errorText != null) {
                setState(() => _errorText = null);
              }
            },
            onSubmitted: (_) => _save(),
          ),
          const SizedBox(height: AppSpacing.s16),
          FilledButton(
            onPressed: _isSaving ? null : _save,
            child: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('保存'),
          ),
        ],
      ),
    );
  }
}
