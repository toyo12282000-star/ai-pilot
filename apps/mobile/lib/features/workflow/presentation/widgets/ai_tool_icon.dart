import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/icons.dart';
import 'package:ai_pilot/features/workflow/domain/entities/ai_tool.dart';

/// [AITool.iconName] を Material アイコンに変換する。
IconData aiToolIconFromName(String? iconName, {AIToolType? type}) {
  switch (iconName) {
    case 'chatgpt':
    case 'claude':
    case 'gemini':
    case 'perplexity':
      return Icons.chat_bubble_outline;
    case 'canva':
    case 'image':
      return Icons.image_outlined;
    case 'elevenlabs':
      return Icons.mic_outlined;
    case 'capcut':
    case 'video':
      return Icons.videocam_outlined;
    case 'cursor':
    case 'code':
      return Icons.code;
    case 'edit':
      return Icons.edit_outlined;
    case 'search':
      return Icons.search;
    default:
      return switch (type) {
        AIToolType.chat => Icons.chat_bubble_outline,
        AIToolType.image => Icons.image_outlined,
        AIToolType.code => Icons.code,
        AIToolType.audio => Icons.mic_outlined,
        AIToolType.other => Icons.auto_awesome,
        null => Icons.auto_awesome,
      };
  }
}

/// AI ツール Hero 用のアイコン表示。
class AIToolIconAvatar extends StatelessWidget {
  const AIToolIconAvatar({
    super.key,
    required this.iconName,
    this.type,
    this.size = 56,
  });

  final String? iconName;
  final AIToolType? type;
  final double size;

  @override
  Widget build(BuildContext context) {
    final icon = aiToolIconFromName(iconName, type: type);

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary.withValues(alpha: 0.1),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.25),
        ),
      ),
      child: Icon(
        icon,
        size: AppIcons.sizeXl,
        color: AppColors.primary,
      ),
    );
  }
}
