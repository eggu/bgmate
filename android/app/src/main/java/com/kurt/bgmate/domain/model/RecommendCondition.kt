package com.kurt.bgmate.domain.model

data class RecommendCondition(
    val playerCount: Int,
    val playTimeMinutes: PlayTime,
    val moods: Set<Mood>
)

enum class PlayTime(val label: String) {
    SHORT(label = "30분 이하"),
    MEDIUM(label = "30~60분"),
    LONG(label = "60분 이상")
}

enum class Mood(
    val label: String,
    val description: String,
) {
    STRATEGY(
        label = "전략",
        description = "깊이 생각하고 치밀하게 계획을 세워서 승부하는 게임"
    ),
    COOPERATIVE(
        label = "협동",
        description = "모두가 힘을 합쳐 함께 목표를 달성하는 게임"
    ),
    DEDUCTION(
        label = "추리",
        description = "상대의 정체를 간파하거나 숨겨진 정보를 밝혀내는 게임"
    ),
    COMPETITIVE(
        label = "경쟁",
        description = "서로 치열하게 겨루며 1위를 다투는 게임"
    ),
    ROLE_PLAYING(
        label = "롤플레이",
        description = "캐릭터에 몰입해 함께 이야기를 만들어가는 게임"
    ),
    PARTY(
        label = "파티",
        description = "다같이 시끌벅적하게 떠들고 크게 웃는 게임"
    ),
    CREATIVE(
        label = "창의",
        description = "그림, 단어, 몸짓으로 자유롭게 표현하고 소통하는 게임"
    ),
    DEXTERITY(
        label = "순발력",
        description = "빠른 판단력과 반응속도로 승부를 가리는 게임"
    ),
    RELAXED(
        label = "힐링",
        description = "여유롭고 편안한 분위기 속에서 천천히 즐기는 게임"
    ),
    CASUAL(
        label = "캐주얼",
        description = "규칙이 간단해서 남녀노소 누구나 부담 없이 즐길 수 있는 게임"
    ),
}
