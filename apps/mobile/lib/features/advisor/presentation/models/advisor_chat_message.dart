/// Advisor チャット UI 用メッセージ。
class AdvisorChatMessage {
  AdvisorChatMessage({
    required this.id,
    required this.role,
    required this.text,
    this.quickReplies = const [],
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory AdvisorChatMessage.assistant({
    required String id,
    required String text,
    List<String> quickReplies = const [],
  }) {
    return AdvisorChatMessage(
      id: id,
      role: AdvisorChatMessageRole.assistant,
      text: text,
      quickReplies: quickReplies,
    );
  }

  factory AdvisorChatMessage.user({
    required String id,
    required String text,
  }) {
    return AdvisorChatMessage(
      id: id,
      role: AdvisorChatMessageRole.user,
      text: text,
    );
  }

  final String id;
  final AdvisorChatMessageRole role;
  final String text;
  final List<String> quickReplies;
  final DateTime createdAt;

  AdvisorChatMessage copyWith({
    List<String>? quickReplies,
  }) {
    return AdvisorChatMessage(
      id: id,
      role: role,
      text: text,
      quickReplies: quickReplies ?? this.quickReplies,
      createdAt: createdAt,
    );
  }
}

enum AdvisorChatMessageRole {
  assistant,
  user,
}
