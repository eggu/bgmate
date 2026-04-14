import 'package:freezed_annotation/freezed_annotation.dart';

part 'recommend_condition.freezed.dart';

@freezed
sealed class RecommendCondition with _$RecommendCondition {
  const factory RecommendCondition({
    required int playerCount,
    required PlayTime playTimeMinutes,
    required Set<Mood> moods,
  }) = _RecommendCondition;
}

enum PlayTime {
  short('30분 이하'),
  medium('30~60분'),
  long('60분 이상');

  const PlayTime(this.label);

  final String label;
}

enum Mood {
  strategy('전략', '깊이 생각하고 치밀하게 계획을 세워서 승부하는 게임'),
  cooperative('협동', '모두가 힘을 합쳐 함께 목표를 달성하는 게임'),
  deduction('추리', '상대의 정체를 간파하거나 숨겨진 정보를 밝혀내는 게임'),
  competitive('경쟁', '서로 치열하게 겨루며 1위를 다투는 게임'),
  rolePlaying('롤플레이', '캐릭터에 몰입해 함께 이야기를 만들어가는 게임'),
  party('파티', '다같이 시끌벅적하게 떠들고 크게 웃는 게임'),
  creative('창의', '그림, 단어, 몸짓으로 자유롭게 표현하고 소통하는 게임'),
  dexterity('순발력', '빠른 판단력과 반응속도로 승부를 가리는 게임'),
  relaxed('힐링', '여유롭고 편안한 분위기 속에서 천천히 즐기는 게임'),
  casual('캐주얼', '규칙이 간단해서 남녀노소 누구나 부담 없이 즐길 수 있는 게임');

  final String label;
  final String description;

  const Mood(this.label, this.description);
}
