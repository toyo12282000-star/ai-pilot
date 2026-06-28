import 'package:ai_pilot/features/workflow/domain/entities/ai_tool.dart';

/// [AIToolType] の日本語表示ラベル。
extension AIToolTypeLabel on AIToolType {
  String get label {
    switch (this) {
      case AIToolType.chat:
        return 'チャット';
      case AIToolType.image:
        return '画像生成';
      case AIToolType.code:
        return 'コード';
      case AIToolType.audio:
        return '音声';
      case AIToolType.other:
        return 'その他';
    }
  }
}
