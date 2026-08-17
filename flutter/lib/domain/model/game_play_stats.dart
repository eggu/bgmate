class GamePlayStats {
  final int bggId;
  final int playCount;
  final DateTime? lastPlayedAt;
  final double? rating;
  final bool isExpansion;

  const GamePlayStats({
    required this.bggId,
    required this.playCount,
    required this.lastPlayedAt,
    required this.rating,
    this.isExpansion = false,
  });
}
