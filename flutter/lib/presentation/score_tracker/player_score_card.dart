import 'package:bgmate_flutter/domain/model/player_score.dart';
import 'package:flutter/material.dart';

class PlayerScoreCard extends StatefulWidget {
  final PlayerScore player;
  final ValueChanged<int> onScoreChanged;

  const PlayerScoreCard({
    required this.player,
    required this.onScoreChanged,
    super.key,
  });

  @override
  State<PlayerScoreCard> createState() => _PlayerScoreCardState();
}

class _PlayerScoreCardState extends State<PlayerScoreCard> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.player.score == 0 ? '' : '${widget.player.score}',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // 순위 배지 — AnimatedSwitcher로 숫자 전환 애니메이션
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: Text(
                '${widget.player.rank == 0 ? '-' : widget.player.rank}위',
                key: ValueKey(widget.player.rank),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: widget.player.rank == 1
                      ? Colors.amber
                      : null,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // 플레이어 이름
            Expanded(
              child: Text(
                widget.player.name,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            // 점수 입력
            SizedBox(
              width: 90,
              child: TextField(
                controller: _controller,
                textAlign: TextAlign.end,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                ),
                onChanged: (value) {
                  final score = int.tryParse(value);
                  if (score != null) widget.onScoreChanged(score);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}