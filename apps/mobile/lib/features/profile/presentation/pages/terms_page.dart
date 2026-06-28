import 'package:flutter/material.dart';

import 'package:ai_pilot/features/profile/presentation/widgets/profile_document_page.dart';

/// 利用規約画面（MVP Preview 仮文言）。
class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  static const _sections = [
    ProfileDocumentSection(
      heading: 'はじめに',
      paragraphs: [
        '本利用規約は、AI Pilot（以下「本サービス」）の利用条件を定めるものです。'
        '本サービスは MVP Preview として提供されており、正式な法務文書ではありません。',
        '本サービスを利用することで、本規約に同意したものとみなします。',
      ],
    ),
    ProfileDocumentSection(
      heading: '禁止事項',
      paragraphs: [
        '法令または公序良俗に反する行為、本サービスの運営を妨害する行為、'
        '他の利用者または第三者の権利を侵害する行為、'
        '不正アクセスや過度な負荷を与える行為を禁止します。',
      ],
    ),
    ProfileDocumentSection(
      heading: '免責事項',
      paragraphs: [
        '本サービスは現状有姿で提供されます。'
        '本サービスの利用により生じた損害について、運営者は故意または重過失がある場合を除き、'
        '責任を負いません。',
      ],
    ),
    ProfileDocumentSection(
      heading: 'AI出力の確認責任',
      paragraphs: [
        '本サービスが案内するAIツールやプロンプトの出力内容は、'
        '利用者自身の責任において確認・利用してください。'
        '出力内容の正確性、適法性、有用性について、運営者は保証しません。',
      ],
    ),
    ProfileDocumentSection(
      heading: 'サービスの変更',
      paragraphs: [
        '運営者は、事前の通知なく本サービスの内容、機能、提供条件を変更、'
        '中断、または終了することがあります。',
        'MVP Preview 期間中は、仕様やデータが予告なく変更される場合があります。',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return const ProfileDocumentPage(
      title: '利用規約',
      sections: _sections,
      showPreviewBadge: true,
    );
  }
}
