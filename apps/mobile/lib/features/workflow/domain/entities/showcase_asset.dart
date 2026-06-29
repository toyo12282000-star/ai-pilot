/// 完成作品サンプルに紐づく成果物の種別。
enum ShowcaseAssetType {
  image,
  video,
  article,
  slide,
  prompt,
}

/// 完成作品サンプルの関連アセット。
class ShowcaseAsset {
  ShowcaseAsset({
    required this.id,
    required this.showcaseId,
    required this.assetType,
    this.url,
    this.title,
    this.sortOrder = 0,
  });

  final String id;
  final String showcaseId;
  final ShowcaseAssetType assetType;
  final String? url;
  final String? title;
  final int sortOrder;
}
