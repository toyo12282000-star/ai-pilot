import 'package:flutter/material.dart';

import 'package:ai_pilot/features/profile/presentation/widgets/profile_document_page.dart';

/// プライバシーポリシー画面（MVP Preview 仮文言）。
class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  static const _sections = [
    ProfileDocumentSection(
      heading: 'はじめに',
      paragraphs: [
        'AI Pilot（以下「本サービス」）は、利用者のプライバシーを尊重します。'
        '本ポリシーは MVP Preview 用の仮文言であり、正式な法務文書ではありません。',
      ],
    ),
    ProfileDocumentSection(
      heading: '取得する情報',
      paragraphs: [
        '本サービスでは、ログイン時にメールアドレス等の認証情報、'
        'お気に入りや実行履歴などの利用データ、'
        'およびサービス改善に必要な最小限の利用状況情報を取得する場合があります。',
      ],
    ),
    ProfileDocumentSection(
      heading: '利用目的',
      paragraphs: [
        '取得した情報は、本サービスの提供、お気に入り・履歴の保存、'
        '認証、セキュリティの確保、およびサービス品質の改善のために利用します。',
      ],
    ),
    ProfileDocumentSection(
      heading: '外部サービスの利用',
      paragraphs: [
        '本サービスは、データベースおよび認証基盤として Supabase を利用しています。'
        'Supabase 上に保存されるデータは、本サービスの提供に必要な範囲に限られます。',
      ],
    ),
    ProfileDocumentSection(
      heading: '第三者への提供',
      paragraphs: [
        '法令に基づく場合を除き、利用者の同意なく個人情報を第三者に提供することはありません。',
      ],
    ),
    ProfileDocumentSection(
      heading: 'お問い合わせ',
      paragraphs: [
        '本ポリシーに関するお問い合わせ窓口は、MVP Preview 期間中は未定です。'
        '正式版公開時にあらためて掲載します。',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return const ProfileDocumentPage(
      title: 'プライバシーポリシー',
      sections: _sections,
      showPreviewBadge: true,
    );
  }
}
