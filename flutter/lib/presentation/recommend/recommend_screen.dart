import 'package:bgmate_flutter/data/repository/recommend_repository_impl.dart';
import 'package:bgmate_flutter/domain/model/recommend_condition.dart';
import 'package:bgmate_flutter/domain/model/recommend_result.dart';
import 'package:bgmate_flutter/presentation/recommend/recommend_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecommendScreen extends ConsumerStatefulWidget {
  const RecommendScreen({super.key});

  @override
  ConsumerState<RecommendScreen> createState() => _RecommendScreenState();
}

class _RecommendScreenState extends ConsumerState<RecommendScreen> {
  int? _selectedPlayerCount;
  PlayTime? _selectedPlayTime;
  final Set<Mood> _selectedMoods = {};
  bool _includeNew = true;
  bool _hasRequested = false;

  final _resultKey = GlobalKey();
  final _scrollController = ScrollController();

  bool get _recommendEnabled =>
      _selectedPlayerCount != null &&
      _selectedPlayTime != null &&
      _selectedMoods.isNotEmpty;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRecommendClick() async {
    setState(() => _hasRequested = true);
    await ref.read(recommendProvider.notifier).recommend(
          _selectedPlayerCount!,
          _selectedPlayTime!,
          Set.unmodifiable(_selectedMoods),
          _includeNew,
        );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _resultKey.currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(ctx, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(recommendProvider);
    final isLoading = asyncState.isLoading;
    final results = asyncState.value ?? [];
    final errorMessage = _buildErrorMessage(asyncState.error);

    return Scaffold(
      appBar: AppBar(title: const Text('추천')),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _HeaderSection(),
            const SizedBox(height: 24),
            _ConditionSection(
              title: '인원수 선택',
              description: '함께 플레이할 인원을 선택해 주세요.',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(8, (i) {
                  final count = i + 1;
                  return FilterChip(
                    label: Text('$count명'),
                    selected: _selectedPlayerCount == count,
                    onSelected: (_) => setState(() => _selectedPlayerCount = count),
                  );
                }),
              ),
            ),
            const SizedBox(height: 24),
            _ConditionSection(
              title: '플레이 시간 선택',
              description: '대략 어느 정도 길이의 게임을 원하는지 골라 주세요.',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: PlayTime.values.map((pt) {
                  return FilterChip(
                    label: Text(pt.label),
                    selected: _selectedPlayTime == pt,
                    onSelected: (_) => setState(() => _selectedPlayTime = pt),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            _ConditionSection(
              title: '분위기 선택',
              description: '원하는 분위기를 모두 선택해 주세요. 여러 개를 고를 수 있어요.',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _recommendMoods.map((mood) {
                  return FilterChip(
                    label: Text(mood.label),
                    selected: _selectedMoods.contains(mood),
                    onSelected: (_) => setState(() {
                      if (_selectedMoods.contains(mood)) {
                        _selectedMoods.remove(mood);
                      } else {
                        _selectedMoods.add(mood);
                      }
                    }),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            _IncludeNewRow(
              includeNew: _includeNew,
              onChanged: (v) => setState(() => _includeNew = v),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: (_recommendEnabled && !isLoading) ? _onRecommendClick : null,
                child: isLoading
                    ? const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          ),
                          SizedBox(width: 8),
                          Text('추천 중...'),
                        ],
                      )
                    : const Text('추천 받기'),
              ),
            ),
            if (_hasRequested || isLoading) ...[
              const SizedBox(height: 24),
              _RecommendResultSection(
                key: _resultKey,
                results: results,
                hasRequested: _hasRequested,
                isLoading: isLoading,
                errorMessage: errorMessage,
              ),
            ],
          ],
        ),
      ),
    );
  }

  String? _buildErrorMessage(Object? error) {
    if (error is RecommendTemporaryUnavailableException) {
      return '요청이 많아 추천 서버가 잠시 불안정해요. 잠시 후 다시 시도해 주세요.';
    }
    if (error == null) return null;
    return '추천을 불러오는 중 문제가 발생했어요. 잠시 후 다시 시도해 주세요.';
  }
}

// ---------------------------------------------------------------------------
// Header
// ---------------------------------------------------------------------------

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: cs.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.auto_awesome, size: 22, color: cs.onPrimaryContainer),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '인원, 시간, 분위기를 고르면 오늘 맞는 게임을 골라드릴게요.',
                style: tt.bodyMedium?.copyWith(color: cs.onPrimaryContainer),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Condition section wrapper
// ---------------------------------------------------------------------------

class _ConditionSection extends StatelessWidget {
  const _ConditionSection({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: tt.titleMedium),
        const SizedBox(height: 4),
        Text(description, style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Include-new switch row
// ---------------------------------------------------------------------------

class _IncludeNewRow extends StatelessWidget {
  const _IncludeNewRow({required this.includeNew, required this.onChanged});

  final bool includeNew;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('새 게임도 추천받기', style: tt.bodyMedium),
              Text(
                includeNew ? '보유 게임 우선, 더 잘 맞는 게임도 추천' : '내 컬렉션 안에서만 추천',
                style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
              ),
            ],
          ),
        ),
        Switch(value: includeNew, onChanged: onChanged),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Result section
// ---------------------------------------------------------------------------

class _RecommendResultSection extends StatelessWidget {
  const _RecommendResultSection({
    super.key,
    required this.results,
    required this.hasRequested,
    required this.isLoading,
    required this.errorMessage,
  });

  final List<RecommendResult> results;
  final bool hasRequested;
  final bool isLoading;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    final description = switch (true) {
      _ when isLoading => '조건에 맞는 게임을 정리하고 있어요.',
      _ when errorMessage != null => errorMessage!,
      _ when results.isEmpty => '조건에 딱 맞는 추천을 찾지 못했어요. 분위기나 플레이 시간을 조금 넓혀보세요.',
      _ => '선택한 조건을 바탕으로 잘 맞는 게임을 골라봤어요.',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('추천 결과', style: tt.titleMedium),
        const SizedBox(height: 4),
        Text(description, style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
        const SizedBox(height: 12),
        if (isLoading)
          const _LoadingResultCard()
        else if (errorMessage != null)
          _ErrorResultCard(message: errorMessage!)
        else if (results.isEmpty)
          const _EmptyResultCard()
        else
          Column(
            children: results
                .asMap()
                .entries
                .map((e) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _RecommendResultCard(rank: e.key + 1, result: e.value),
                    ))
                .toList(),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Result card
// ---------------------------------------------------------------------------

class _RecommendResultCard extends StatelessWidget {
  const _RecommendResultCard({required this.rank, required this.result});

  final int rank;
  final RecommendResult result;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    final score = result.bggScore;
    final scoreText = (score != null && score > 0) ? score.toStringAsFixed(1) : null;
    final difficultyText = (result.difficulty?.isNotEmpty ?? false) ? result.difficulty : null;

    return Card(
      color: cs.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: cs.primary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '$rank',
                    style: tt.labelLarge?.copyWith(
                      color: cs.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(result.name, style: tt.titleMedium),
                      const SizedBox(height: 6),
                      _OwnershipBadge(isOwned: result.isOwned),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(result.reason, style: tt.bodyMedium),
            if (scoreText != null || difficultyText != null) ...[
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  if (scoreText != null) ...[
                    _MetaItem(icon: Icons.star_outline, label: 'BGG 평점', value: scoreText),
                    const SizedBox(width: 16),
                  ],
                  if (difficultyText != null)
                    _MetaItem(icon: Icons.check_circle_outline, label: '난이도', value: difficultyText),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Ownership badge
// ---------------------------------------------------------------------------

class _OwnershipBadge extends StatelessWidget {
  const _OwnershipBadge({required this.isOwned});

  final bool isOwned;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final bgColor = isOwned ? cs.primaryContainer : cs.secondaryContainer;
    final fgColor = isOwned ? cs.onPrimaryContainer : cs.onSecondaryContainer;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isOwned ? Icons.check_circle_outline : Icons.shopping_bag_outlined,
            size: 14,
            color: fgColor,
          ),
          const SizedBox(width: 4),
          Text(
            isOwned ? '보유 중' : '새 게임',
            style: tt.labelMedium?.copyWith(color: fgColor),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Meta item (score / difficulty)
// ---------------------------------------------------------------------------

class _MetaItem extends StatelessWidget {
  const _MetaItem({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: cs.onSurfaceVariant),
        const SizedBox(width: 6),
        Text(
          '$label $value',
          style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Loading / empty cards
// ---------------------------------------------------------------------------

class _LoadingResultCard extends StatelessWidget {
  const _LoadingResultCard();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Card(
      color: cs.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 12),
            Text('추천 결과를 불러오고 있습니다.', style: tt.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _EmptyResultCard extends StatelessWidget {
  const _EmptyResultCard();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Card(
      color: cs.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          '추천 결과가 없어요. 선택한 분위기 수를 줄이거나 플레이 시간 조건을 바꿔서 다시 시도해 보세요.',
          style: tt.bodyMedium,
        ),
      ),
    );
  }
}

class _ErrorResultCard extends StatelessWidget {
  const _ErrorResultCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Card(
      color: cs.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          message,
          style: tt.bodyMedium?.copyWith(color: cs.onErrorContainer),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Constants
// ---------------------------------------------------------------------------

const _recommendMoods = [
  Mood.strategy,
  Mood.cooperative,
  Mood.deduction,
  Mood.competitive,
  Mood.rolePlaying,
  Mood.party,
  Mood.creative,
  Mood.dexterity,
  Mood.relaxed,
  Mood.casual,
];
