enum CollectionStatus {
  owned,
  wishlist,
  wantToPlay,
  prevOwned,
  forTrade;

  String toJson() => name;

  static CollectionStatus? fromJson(String value) =>
      CollectionStatus.values.where((e) => e.name == value).firstOrNull;
}

extension CollectionStatusSetSerializer on Set<CollectionStatus> {
  String serialize() => map((e) => e.name).join(',');
}

extension CollectionStatusSetDeserializer on String {
  Set<CollectionStatus> toCollectionStatusSet() {
    if (isEmpty) return {};
    return split(',')
        .map(CollectionStatus.fromJson)
        .whereType<CollectionStatus>()
        .toSet();
  }
}
