import 'package:ai_pilot/features/recommendation/domain/entities/recommendation.dart';

/// Mock おすすめ目的データ。
final List<Recommendation> mockRecommendations = [
  Recommendation(
    id: 'rec_youtube',
    title: 'YouTubeを始めたい',
    description: '動画制作の第一歩からショート投稿まで',
    recommendedWorkflowIds: ['wf_youtube_short'],
    icon: 'video',
    color: '#EF4444',
    priority: 1,
  ),
  Recommendation(
    id: 'rec_side_business',
    title: '副業を始めたい',
    description: 'SNSやブログで収益化の土台を作る',
    recommendedWorkflowIds: ['wf_sns', 'wf_blog'],
    icon: 'work',
    color: '#F59E0B',
    priority: 2,
  ),
  Recommendation(
    id: 'rec_learn_ai',
    title: 'AIを学びたい',
    description: 'AIツールを使った調査と開発に触れる',
    recommendedWorkflowIds: ['wf_research', 'wf_flutter_app'],
    icon: 'auto_awesome',
    color: '#5B5CEB',
    priority: 3,
  ),
  Recommendation(
    id: 'rec_blog',
    title: 'ブログを書きたい',
    description: '構成から執筆までの記事作成フロー',
    recommendedWorkflowIds: ['wf_blog'],
    icon: 'edit',
    color: '#22C55E',
    priority: 4,
  ),
  Recommendation(
    id: 'rec_sns',
    title: 'SNSを伸ばしたい',
    description: '投稿文とビジュアルをセットで作成',
    recommendedWorkflowIds: ['wf_sns'],
    icon: 'share',
    color: '#6DD5FA',
    priority: 5,
  ),
  Recommendation(
    id: 'rec_document',
    title: '資料を作りたい',
    description: '調査からレポート・資料化まで',
    recommendedWorkflowIds: ['wf_research'],
    icon: 'description',
    color: '#8B5CF6',
    priority: 6,
  ),
];
