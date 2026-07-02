import 'package:ai_pilot/features/advisor/domain/entities/advisor_suggestion.dart';
import 'package:ai_pilot/features/advisor/presentation/models/advisor_chat_message.dart';
import 'package:ai_pilot/features/advisor/presentation/models/advisor_conversation_flow.dart';

/// Advisor 画面のチャット UI 状態（Presentation のみ）。
class AdvisorChatController {
  final List<AdvisorChatMessage> messages = [];
  AdvisorIntentPath? path;
  int followUpIndex = 0;
  final List<String> selectedAnswers = [];
  bool isTyping = false;
  bool isSubmitting = false;
  bool isCompleted = false;
  bool conversationActive = false;
  List<AdvisorSuggestion>? suggestions;
  String? errorMessage;
  int _messageCounter = 0;

  void initialize() {
    if (messages.isNotEmpty) {
      return;
    }
    messages.add(
      AdvisorChatMessage.assistant(
        id: _nextId(),
        text: AdvisorConversationFlow.initialGreeting,
        quickReplies: AdvisorConversationFlow.initialQuickReplies,
      ),
    );
  }

  void resetConversation() {
    messages.clear();
    path = null;
    followUpIndex = 0;
    selectedAnswers.clear();
    isTyping = false;
    isSubmitting = false;
    isCompleted = false;
    conversationActive = false;
    suggestions = null;
    errorMessage = null;
    initialize();
  }

  String _nextId() {
    _messageCounter += 1;
    return 'msg_$_messageCounter';
  }

  /// Quick Reply 選択。
  void selectQuickReply(String reply) {
    if (isSubmitting || isCompleted) {
      return;
    }

    _clearQuickRepliesOnLastAssistant();
    messages.add(AdvisorChatMessage.user(id: _nextId(), text: reply));
    selectedAnswers.add(reply);
    conversationActive = true;

    path ??= AdvisorConversationFlow.pathForInitialReply(reply);

    final followUps = path != null
        ? AdvisorConversationFlow.followUpsFor(path!)
        : const <AdvisorFollowUpQuestion>[];

    if (followUpIndex < followUps.length) {
      final question = followUps[followUpIndex];
      followUpIndex += 1;
      messages.add(
        AdvisorChatMessage.assistant(
          id: _nextId(),
          text: question.text,
          quickReplies: question.quickReplies,
        ),
      );
      return;
    }

    _markReadyForSuggestion();
  }

  /// テキスト送信（会話中は回答、それ以外は直接 query）。
  String? submitText(String rawText) {
    final text = rawText.trim();
    if (text.isEmpty || isSubmitting) {
      return null;
    }

    if (isCompleted) {
      resetConversation();
    }

    _clearQuickRepliesOnLastAssistant();
    messages.add(AdvisorChatMessage.user(id: _nextId(), text: text));

    if (conversationActive && path != null) {
      final followUps = AdvisorConversationFlow.followUpsFor(path!);
      if (followUpIndex <= followUps.length) {
        selectedAnswers.add(text);
        if (followUpIndex < followUps.length) {
          final question = followUps[followUpIndex];
          followUpIndex += 1;
          messages.add(
            AdvisorChatMessage.assistant(
              id: _nextId(),
              text: question.text,
              quickReplies: question.quickReplies,
            ),
          );
          return null;
        }
        _markReadyForSuggestion();
        return buildQuery();
      }
    }

    selectedAnswers.clear();
    selectedAnswers.add(text);
    conversationActive = true;
    _markReadyForSuggestion();
    return buildQuery();
  }

  /// 履歴タップなど、会話をスキップして query のみで推薦。
  String startFromHistoryQuery(String query) {
    resetConversation();
    final trimmed = query.trim();
    messages.add(AdvisorChatMessage.user(id: _nextId(), text: trimmed));
    selectedAnswers.add(trimmed);
    conversationActive = true;
    _markReadyForSuggestion();
    return trimmed;
  }

  void _markReadyForSuggestion() {
    _clearQuickRepliesOnLastAssistant();
    messages.add(
      AdvisorChatMessage.assistant(
        id: _nextId(),
        text: AdvisorConversationFlow.completionMessage,
      ),
    );
    isCompleted = true;
  }

  void _clearQuickRepliesOnLastAssistant() {
    for (var i = messages.length - 1; i >= 0; i--) {
      final message = messages[i];
      if (message.role == AdvisorChatMessageRole.assistant &&
          message.quickReplies.isNotEmpty) {
        messages[i] = message.copyWith(quickReplies: []);
        break;
      }
    }
  }

  String buildQuery() {
    return AdvisorConversationFlow.buildQuery(selectedAnswers);
  }

  void setSubmitting(bool value) {
    isSubmitting = value;
    if (value) {
      isTyping = true;
      errorMessage = null;
    } else {
      isTyping = false;
    }
  }

  void setSuggestions(List<AdvisorSuggestion> value) {
    suggestions = value;
    isTyping = false;
    isSubmitting = false;
    errorMessage = null;
  }

  void setError(String message) {
    errorMessage = message;
    isTyping = false;
    isSubmitting = false;
    suggestions = null;
  }

  void showEmptyResultRetry() {
    messages.add(
      AdvisorChatMessage.assistant(
        id: _nextId(),
        text: '近いWorkflowが見つかりませんでした。別の言葉で試してみましょう。',
        quickReplies: AdvisorConversationFlow.initialQuickReplies,
      ),
    );
    isCompleted = false;
    path = null;
    followUpIndex = 0;
    selectedAnswers.clear();
    conversationActive = false;
    suggestions = const [];
  }
}
