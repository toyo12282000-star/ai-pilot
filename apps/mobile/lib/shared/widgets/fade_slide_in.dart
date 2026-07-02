import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/animations.dart';
import 'package:ai_pilot/design_system/responsive.dart';

/// 画面表示時の軽い Fade + Slide アニメーション（モバイルでは無効）。
class FadeSlideIn extends StatefulWidget {
  const FadeSlideIn({
    super.key,
    required this.child,
    this.index = 0,
    this.delayPerIndex = 50,
  });

  final Widget child;
  final int index;
  final int delayPerIndex;

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _opacity;
  Animation<Offset>? _slide;
  var _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (context.isMobile || _started) {
      return;
    }
    _started = true;

    _controller = AnimationController(
      vsync: this,
      duration: AppAnimations.fast,
    );
    final curve = CurvedAnimation(
      parent: _controller!,
      curve: AppAnimations.easeOut,
    );
    _opacity = curve;
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.03),
      end: Offset.zero,
    ).animate(curve);

    Future<void>.delayed(
      Duration(milliseconds: widget.delayPerIndex * widget.index),
      () {
        if (mounted) {
          _controller?.forward();
        }
      },
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (context.isMobile) {
      return widget.child;
    }

    return FadeTransition(
      opacity: _opacity ?? const AlwaysStoppedAnimation(1),
      child: SlideTransition(
        position: _slide ?? const AlwaysStoppedAnimation(Offset.zero),
        child: widget.child,
      ),
    );
  }
}
