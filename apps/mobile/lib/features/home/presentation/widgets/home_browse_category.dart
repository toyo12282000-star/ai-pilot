/// ホーム向けの固定カテゴリチップ定義。
class HomeBrowseCategory {
  const HomeBrowseCategory({
    required this.label,
    required this.categoryId,
  });

  final String label;
  final String categoryId;

  static const List<HomeBrowseCategory> items = [
    HomeBrowseCategory(label: 'YouTube', categoryId: 'cat_video'),
    HomeBrowseCategory(label: 'Instagram', categoryId: 'cat_image'),
    HomeBrowseCategory(label: 'ブログ', categoryId: 'cat_writing'),
    HomeBrowseCategory(label: '画像生成', categoryId: 'cat_image'),
    HomeBrowseCategory(label: '資料', categoryId: 'cat_research'),
    HomeBrowseCategory(label: 'アプリ', categoryId: 'cat_dev'),
  ];
}
