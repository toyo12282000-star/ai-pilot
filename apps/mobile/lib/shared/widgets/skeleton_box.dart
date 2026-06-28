import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/radius.dart';

/// 控えめなパルスアニメーション付きのプレースホルダー矩形。
///
/// 派手な shimmer ではなく、opacity のみをゆっくり変化させる。
class SkeletonBox extends StatefulWidget {
  const SkeletonBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius = AppRadius.small,
  });

  final double? width;
  final double? height;
  final BorderRadius borderRadius;

  @override
  State<SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<SkeletonBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _opacity = Tween<double>(begin: 0.32, end: 0.52).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacity,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: AppColors.outline.withValues(alpha: _opacity.value),
            borderRadius: widget.borderRadius,
          ),
        );
      },
    );
  }
}
