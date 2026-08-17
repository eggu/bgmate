class UsedPrice {
  final int? bggId;
  final String boardlifeId;
  final String boardlifeName;
  final String shopUrl;
  final int? minPrice;
  final int? maxPrice;
  final int? avgPrice;
  final int listingCount;
  final DateTime? cachedAt;

  const UsedPrice({
    required this.bggId,
    required this.boardlifeId,
    required this.boardlifeName,
    required this.shopUrl,
    required this.minPrice,
    required this.maxPrice,
    required this.avgPrice,
    required this.listingCount,
    required this.cachedAt,
  });

  Uri get shopUri =>
      Uri.parse('https://boardlife.co.kr/game/$boardlifeId/shop');

  static UsedPrice? fromApiJson(Map<String, dynamic> json) {
    if (json['ok'] != true) return null;

    return UsedPrice(
      bggId: _intOrNull(json['bggId']),
      boardlifeId: json['boardlifeId'] as String? ?? '',
      boardlifeName: json['boardlifeName'] as String? ?? '',
      shopUrl: json['shopUrl'] as String? ?? '',
      minPrice: _intOrNull(json['minPrice']),
      maxPrice: _intOrNull(json['maxPrice']),
      avgPrice: _intOrNull(json['avgPrice']),
      listingCount: _intOrNull(json['listingCount']) ?? 0,
      cachedAt: DateTime.tryParse(json['cachedAt'] as String? ?? ''),
    );
  }

  static int? _intOrNull(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}
