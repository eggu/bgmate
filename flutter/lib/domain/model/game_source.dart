enum GameSource {
  manualSearch,
  bggSync;

  String toJson() => name;

  static GameSource fromJson(String value) =>
      GameSource.values.firstWhere((e) => e.name == value, orElse: () => GameSource.manualSearch);
}
