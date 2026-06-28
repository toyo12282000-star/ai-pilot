import 'package:flutter/material.dart';

import 'package:ai_pilot/features/profile/presentation/widgets/profile_document_page.dart';

/// AI Pilot について画面。
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const _sections = [
    ProfileDocumentSection(
      heading: 'AI Pilotとは',
      paragraphs: [
        'AI Pilotは、やりたいことを選ぶだけで最適なAIワークフローへ案内するアプリです。',
        'AIツールの使い分けに迷わず、目的達成までの手順をわかりやすくナビゲートします。',
      ],
    ),
    ProfileDocumentSection(
      heading: 'できること',
      paragraphs: [
        '目的に合ったワークフローの提案、ステップごとの手順案内、'
        'お気に入りへの保存、実行履歴の管理（ログイン時）などを提供します。',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return const ProfileDocumentPage(
      title: 'AI Pilotについて',
      sections: _sections,
    );
  }
}
