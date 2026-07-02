import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';

/// AI が入力中の Typing インジケーター。
class AdvisorTypingIndicator extends StatefulWidget {
  const AdvisorTypingIndicator({super.key});

  @override
  State<AdvisorTypingIndicator> createState() => _AdvisorTypingIndicatorState();
}

class _AdvisorTypingIndicatorState extends State<AdvisorTypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: AppSpacing.s32),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s12,
            vertical: AppSpacing.s12,
          ),
          decoration: BoxDecoration(
            color: AppColors.surfaceMuted,
            borderRadius: AppRadius.large,
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (index) {
              return AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final phase = (_controller.value + index * 0.2) % 1.0;
                  final opacity = 0.35 + (phase < 0.5 ? phase : 1 - phase) * 1.3;
                  return Padding(
                    padding: EdgeInsets.only(
                      right: index < 2 ? AppSpacing.s4 : 0,
                    ),
                    child: Opacity(
                      opacity: opacity.clamp(0.35, 1.0),
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ),
      ),
    );
  }
}
