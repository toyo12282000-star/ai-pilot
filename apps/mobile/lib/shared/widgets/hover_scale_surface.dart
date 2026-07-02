import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/animations.dart';
import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/responsive.dart';
import 'package:ai_pilot/design_system/shadows.dart';

/// Border 主体のカード面 + 控えめな hover scale（デスクトップのみ）。
class HoverScaleSurface extends StatefulWidget {
  const HoverScaleSurface({
    super.key,
    required this.child,
    this.onTap,
    this.borderRadius = AppRadius.card,
    this.backgroundColor = AppColors.surface,
    this.borderColor = AppColors.border,
    this.padding,
  });

  final Widget child;
  final VoidCallback? onTap;
  final BorderRadius borderRadius;
  final Color backgroundColor;
  final Color borderColor;
  final EdgeInsetsGeometry? padding;

  @override
  State<HoverScaleSurface> createState() => _HoverScaleSurfaceState();
}

class _HoverScaleSurfaceState extends State<HoverScaleSurface> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final enableHoverScale = !context.isMobile;

    final surface = enableHoverScale
        ? AnimatedScale(
            scale: _hovered ? AppAnimations.hoverScale : 1,
            duration: AppAnimations.fast,
            curve: AppAnimations.easeOut,
            child: _surfaceBox(),
          )
        : _surfaceBox();

    final child = enableHoverScale
        ? MouseRegion(
            onEnter: (_) => setState(() => _hovered = true),
            onExit: (_) => setState(() => _hovered = false),
            child: surface,
          )
        : surface;

    if (widget.onTap == null) {
      return child;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: widget.borderRadius,
        splashColor: AppColors.primary.withValues(alpha: 0.05),
        highlightColor: AppColors.primarySoft.withValues(alpha: 0.45),
        child: child,
      ),
    );
  }

  Widget _surfaceBox() {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: widget.borderRadius,
        border: Border.all(color: widget.borderColor),
        boxShadow: AppShadows.none,
      ),
      child: widget.padding != null
          ? Padding(padding: widget.padding!, child: widget.child)
          : widget.child,
    );
  }
}
