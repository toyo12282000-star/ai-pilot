/// ワークフローを分類するカテゴリ。
///
/// ## 責務
/// - ワークフローを用途・テーマごとにグルーピングする
/// - 一覧画面でのフィルタリング・表示順序を管理する
///
/// ## 保持する値
/// - [id]: 一意識別子
/// - [name]: カテゴリ名（例: ライティング, リサーチ）
/// - [description]: カテゴリの説明
/// - [sortOrder]: 表示順（昇順）
/// - [iconName]: アイコン識別子（UI 表示用）
/// - [createdAt]: 作成日時
/// - [updatedAt]: 更新日時
///
/// ## 他 Entity との関係
/// - 1 つの Category に複数の [Workflow] が属する（1:N）
class Category {
  /// [id] をキーに [Category] を生成する。
  Category({
    required this.id,
    required this.name,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.iconName,
  });

  /// 一意識別子。
  final String id;

  /// カテゴリ名。
  final String name;

  /// カテゴリの説明。
  final String? description;

  /// 表示順（昇順）。
  final int sortOrder;

  /// アイコン識別子（UI 表示用）。
  final String? iconName;

  /// 作成日時。
  final DateTime createdAt;

  /// 更新日時。
  final DateTime updatedAt;

  /// 指定フィールドのみ差し替えた新しいインスタンスを返す。
  Category copyWith({
    String? id,
    String? name,
    String? description,
    int? sortOrder,
    String? iconName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      sortOrder: sortOrder ?? this.sortOrder,
      iconName: iconName ?? this.iconName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
