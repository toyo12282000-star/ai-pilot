import 'package:ai_pilot/features/workflow/domain/entities/workflow_step.dart';

/// AI 活用の手順（ワークフロー）本体。
///
/// アプリの中心 Entity。複数の [WorkflowStep] を順序付きで保持し、
/// カテゴリ分類・お気に入り・検索の対象となる。
///
/// ## 責務
/// - AI を使った作業手順全体を 1 つの単位として表現する
/// - 複数の [WorkflowStep] を直接保持し、業務上の構成関係を表現する
/// - カテゴリ・タグによる分類情報を保持する
///
/// ## 保持する値
/// - [id]: 一意識別子
/// - [title]: ワークフロー名
/// - [description]: ワークフローの概要説明
/// - [categoryId]: 所属 [Category] の ID
/// - [steps]: 構成ステップ一覧（[WorkflowStep.order] で実行順を表現）
/// - [tags]: 検索・分類用タグ
/// - [estimatedMinutes]: 想定所要時間（分）
/// - [createdAt]: 作成日時
/// - [updatedAt]: 更新日時
///
/// ## 他 Entity との関係
/// - 1 つの [Category] に属する（N:1）
/// - 複数の [WorkflowStep] を [steps] として直接保持する（1:N）
/// - [Favorite] から参照される
///
/// ID 参照による永続化（Supabase 等）は Data 層の DTO で扱う。
class Workflow {
  /// [id] をキーに [Workflow] を生成する。
  Workflow({
    required this.id,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.createdAt,
    required this.updatedAt,
    List<WorkflowStep> steps = const [],
    List<String> tags = const [],
    this.estimatedMinutes,
  })  : steps = List.unmodifiable(steps),
        tags = List.unmodifiable(tags);

  /// 一意識別子。
  final String id;

  /// ワークフロー名。
  final String title;

  /// ワークフローの概要説明。
  final String description;

  /// 所属 [Category] の ID。
  final String categoryId;

  /// 構成ステップ一覧（[WorkflowStep.order] で実行順を表現）。
  final List<WorkflowStep> steps;

  /// 検索・分類用タグ。
  final List<String> tags;

  /// 想定所要時間（分）。
  final int? estimatedMinutes;

  /// 作成日時。
  final DateTime createdAt;

  /// 更新日時。
  final DateTime updatedAt;

  /// 指定フィールドのみ差し替えた新しいインスタンスを返す。
  Workflow copyWith({
    String? id,
    String? title,
    String? description,
    String? categoryId,
    List<WorkflowStep>? steps,
    List<String>? tags,
    int? estimatedMinutes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Workflow(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      steps: steps ?? this.steps,
      tags: tags ?? this.tags,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
