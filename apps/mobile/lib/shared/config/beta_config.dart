/// β版配布向けの定数（フィードバック導線など）。
abstract final class BetaConfig {
  /// フィードバック受付メールアドレス（β配布時に差し替え）。
  static const feedbackEmail = 'toyo12282000@gmail.com';

  static const feedbackSubject = 'AI Pilot β版フィードバック';

  static const workflowRequestSubject = 'AI Pilot Workflowリクエスト';

  static Uri mailtoFeedback({
    required String subject,
    String? bodyPrefix,
  }) {
    final body = bodyPrefix == null
        ? 'AI Pilot β版についてのフィードバック:\n\n'
        : '$bodyPrefix\n\n';
    return Uri(
      scheme: 'mailto',
      path: feedbackEmail,
      query: _encodeQuery({
        'subject': subject,
        'body': body,
      }),
    );
  }

  static Uri get feedbackUri => mailtoFeedback(subject: feedbackSubject);

  static Uri get workflowRequestUri => mailtoFeedback(
        subject: workflowRequestSubject,
        bodyPrefix: '欲しいWorkflow / 作りたい成果物:\n',
      );

  static String _encodeQuery(Map<String, String> params) {
    return params.entries
        .map(
          (entry) =>
              '${Uri.encodeComponent(entry.key)}=${Uri.encodeComponent(entry.value)}',
        )
        .join('&');
  }
}
