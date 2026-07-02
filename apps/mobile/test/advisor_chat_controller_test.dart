import 'package:flutter_test/flutter_test.dart';

import 'package:ai_pilot/features/advisor/presentation/models/advisor_chat_message.dart';
import 'package:ai_pilot/features/advisor/presentation/controllers/advisor_chat_controller.dart';
import 'package:ai_pilot/features/advisor/presentation/models/advisor_conversation_flow.dart';

void main() {
  test('initial greeting includes quick replies', () {
    final chat = AdvisorChatController()..initialize();

    expect(chat.messages, hasLength(1));
    expect(chat.messages.first.text, AdvisorConversationFlow.initialGreeting);
    expect(
      chat.messages.first.quickReplies,
      AdvisorConversationFlow.initialQuickReplies,
    );
  });

  test('youtube path asks two follow-ups then completes', () {
    final chat = AdvisorChatController()..initialize();

    chat.selectQuickReply('YouTube動画を作りたい');
    expect(chat.messages.last.text, 'どんなジャンルですか？');
    expect(chat.isCompleted, isFalse);

    chat.selectQuickReply('美容');
    expect(chat.messages.last.text, 'どのくらいの時間で作りたいですか？');

    chat.selectQuickReply('30分');
    expect(chat.isCompleted, isTrue);
    expect(
      chat.buildQuery(),
      'YouTube動画を作りたい 美容 30分',
    );
  });

  test('undecided path asks one follow-up', () {
    final chat = AdvisorChatController()..initialize();

    chat.selectQuickReply('まだ決まっていない');
    expect(chat.messages.last.text, '今の目的に近いものはどれですか？');

    chat.selectQuickReply('AIを学びたい');
    expect(chat.isCompleted, isTrue);
    expect(chat.buildQuery(), contains('AIを学びたい'));
  });

  test('history query skips conversation', () {
    final chat = AdvisorChatController();
    final query = chat.startFromHistoryQuery('YouTubeを始めたい');

    expect(query, 'YouTubeを始めたい');
    expect(chat.isCompleted, isTrue);
    expect(
      chat.messages.where((m) => m.role == AdvisorChatMessageRole.user),
      hasLength(1),
    );
  });
}
