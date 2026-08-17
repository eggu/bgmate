import 'package:bgmate_flutter/di/remote_provider.dart';
import 'package:bgmate_flutter/domain/model/used_price.dart';
import 'package:bgmate_flutter/presentation/collection/game_list_notifier.dart';
import 'package:bgmate_flutter/presentation/collection/game_used_price_provider.dart';
import 'package:bgmate_flutter/presentation/sale/sale_candidate_selector.dart';
import 'package:bgmate_flutter/presentation/sale/sale_recommend_provider.dart';
import 'package:bgmate_flutter/presentation/widgets/external_uri_launcher.dart';
import 'package:bgmate_flutter/presentation/widgets/game_thumbnail.dart';
import 'package:bgmate_flutter/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SaleRecommendScreen extends ConsumerWidget {
  const SaleRecommendScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final candidates = ref.watch(saleCandidatesProvider);
    final filters = ref.watch(saleFiltersProvider);
    final collection = ref.watch(gameListProvider);
    final isCollectionEmpty = collection.maybeWhen(
      data: (games) => games.isEmpty,
      orElse: () => false,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('판매 추천')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _FilterSection(
            filters: filters,
            onChanged: (next) =>
                ref.read(saleFiltersProvider.notifier).set(next),
          ),
          const SizedBox(height: 16),
          candidates.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (_, _) => const _MessageCard('판매 후보를 불러오지 못했습니다.'),
            data: (items) {
              if (items.isEmpty) {
                if (isCollectionEmpty) return const _EmptySaleCollectionState();
                return const _MessageCard('현재 필터에 맞는 판매 추천 후보가 없습니다.');
              }

              return Column(
                children: [
                  for (final item in items) _CandidateCard(candidate: item),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FilterSection extends StatelessWidget {
  final SaleFilters filters;
  final ValueChanged<SaleFilters> onChanged;

  const _FilterSection({required this.filters, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('필터', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            SegmentedButton<SaleGameTypeFilter>(
              segments: const [
                ButtonSegment(
                  value: SaleGameTypeFilter.base,
                  label: Text('본판만'),
                ),
                ButtonSegment(
                  value: SaleGameTypeFilter.expansion,
                  label: Text('확장만'),
                ),
                ButtonSegment(value: SaleGameTypeFilter.all, label: Text('전체')),
              ],
              selected: {filters.gameType},
              onSelectionChanged: (values) =>
                  onChanged(filters.copyWith(gameType: values.single)),
            ),
            const SizedBox(height: 16),
            _CounterRow(
              label: '최소 플레이 횟수',
              value: filters.minPlays,
              suffix: '회 이상',
              onChanged: (value) => onChanged(
                filters.copyWith(minPlays: _clampInt(value, 0, 9999)),
              ),
            ),
            const SizedBox(height: 16),
            Text('미플레이 기준: ${_formatMonths(filters.monthsUnplayed)} 이상'),
            Slider(
              min: 1,
              max: 60,
              divisions: 59,
              value: filters.monthsUnplayed.toDouble(),
              label: _formatMonths(filters.monthsUnplayed),
              onChanged: (value) =>
                  onChanged(filters.copyWith(monthsUnplayed: value.round())),
            ),
            const SizedBox(height: 8),
            Text('최대 후보 수: ${filters.maxCandidates}개'),
            Slider(
              min: 5,
              max: 50,
              divisions: 9,
              value: filters.maxCandidates.toDouble(),
              label: '${filters.maxCandidates}개',
              onChanged: (value) =>
                  onChanged(filters.copyWith(maxCandidates: value.round())),
            ),
          ],
        ),
      ),
    );
  }
}

class _CounterRow extends StatelessWidget {
  final String label;
  final int value;
  final String suffix;
  final ValueChanged<int> onChanged;

  const _CounterRow({
    required this.label,
    required this.value,
    required this.suffix,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label)),
        IconButton(
          onPressed: value > 0 ? () => onChanged(value - 1) : null,
          icon: const Icon(Icons.remove),
        ),
        Text('$value $suffix'),
        IconButton(
          onPressed: () => onChanged(value + 1),
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}

class _CandidateCard extends ConsumerWidget {
  final SaleCandidate candidate;

  const _CandidateCard({required this.candidate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final priceApiConfigured = ref
        .watch(usedPriceApiServiceProvider)
        .isConfigured;
    final price = priceApiConfigured
        ? ref.watch(gameUsedPriceProvider(candidate.game))
        : null;
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '판매 후보',
              style: tt.labelMedium?.copyWith(
                color: cs.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 58,
                  height: 58,
                  child: GameThumbnail(url: candidate.game.thumbnail),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(candidate.game.name, style: tt.titleMedium),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          _SaleBadge(
                            icon: Icons.history_outlined,
                            label: _formatUnplayed(candidate.yearsUnplayed),
                          ),
                          _SaleBadge(
                            icon: Icons.sports_esports_outlined,
                            label: '${candidate.playCount}회 플레이',
                          ),
                          _SaleBadge(
                            icon: Icons.event_available_outlined,
                            label: _formatLastPlayed(candidate.lastPlayedAt),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _saleReason(candidate),
              style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 10),
            if (!priceApiConfigured)
              Text(
                '중고가 API 미설정',
                style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
              )
            else
              price!.when(
                loading: () => const Text('중고가 조회 중'),
                error: (_, _) =>
                    Text('중고가 조회 실패', style: TextStyle(color: cs.error)),
                data: (value) => _PriceLine(price: value),
              ),
          ],
        ),
      ),
    );
  }
}

class _SaleBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SaleBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: cs.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: cs.onSecondaryContainer),
            const SizedBox(width: 4),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(color: cs.onSecondaryContainer),
            ),
          ],
        ),
      ),
    );
  }
}

String _saleReason(SaleCandidate candidate) {
  final unplayed = _formatUnplayed(candidate.yearsUnplayed);
  return '$unplayed · ${candidate.playCount}회 플레이 기준으로 정리 후보에 올랐습니다.';
}

String _formatUnplayed(double? years) {
  if (years == null) return '플레이 기록 없음';
  if (years < 1) return '1년 미만 미플레이';
  return '${years.round()}년 미플레이';
}

String _formatLastPlayed(DateTime? date) {
  if (date == null) return '플레이 기록 없음';
  return '최근 플레이 '
      '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
}

class _PriceLine extends StatelessWidget {
  final UsedPrice? price;

  const _PriceLine({required this.price});

  @override
  Widget build(BuildContext context) {
    if (price == null) return const Text('보드라이프 미매칭');
    if (price!.listingCount == 0) {
      return TextButton.icon(
        onPressed: () => openExternalUri(context, price!.shopUri),
        icon: const Icon(Icons.open_in_new),
        label: const Text('매물 없음'),
      );
    }
    return Wrap(
      spacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          '최저가 ${_formatWon(price!.minPrice)} · '
          '최고가 ${_formatWon(price!.maxPrice)} · '
          '평균가 ${_formatWon(price!.avgPrice)} · '
          '매물 ${price!.listingCount}개',
        ),
        TextButton.icon(
          onPressed: () => openExternalUri(context, price!.shopUri),
          icon: const Icon(Icons.open_in_new),
          label: const Text('보드라이프'),
        ),
      ],
    );
  }
}

class _EmptySaleCollectionState extends StatelessWidget {
  const _EmptySaleCollectionState();

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(Icons.sell_outlined, size: 36, color: cs.primary),
            const SizedBox(height: 12),
            Text('컬렉션이 비어 있어요', style: tt.titleMedium),
            const SizedBox(height: 8),
            Text(
              'BGG 컬렉션을 동기화하거나 게임을 먼저 추가하면 판매 후보를 계산할 수 있어요.',
              textAlign: TextAlign.center,
              style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                FilledButton.icon(
                  onPressed: () => context.go(AppRoutes.settings),
                  icon: const Icon(Icons.sync),
                  label: const Text('BGG 동기화'),
                ),
                OutlinedButton.icon(
                  onPressed: () => context.go(AppRoutes.gameSearch),
                  icon: const Icon(Icons.search),
                  label: const Text('게임 검색'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageCard extends StatelessWidget {
  final String message;

  const _MessageCard(this.message);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(child: Text(message)),
      ),
    );
  }
}

String _formatMonths(int months) {
  if (months < 12) return '$months개월';
  final years = months ~/ 12;
  final rest = months % 12;
  if (rest == 0) return '$years년';
  return '$years년 $rest개월';
}

int _clampInt(int value, int min, int max) {
  if (value < min) return min;
  if (value > max) return max;
  return value;
}

String _formatWon(int? value) {
  if (value == null) return '-';
  final text = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < text.length; i++) {
    if (i > 0 && (text.length - i) % 3 == 0) buffer.write(',');
    buffer.write(text[i]);
  }
  return '$buffer원';
}
