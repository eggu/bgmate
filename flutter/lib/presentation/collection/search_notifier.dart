import 'package:bgmate_flutter/di/repository_provider.dart';
import 'package:bgmate_flutter/domain/model/board_game.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchNotifier extends AsyncNotifier<List<BoardGame>> {
  static const _batchSize = 20;

  /// 검색 API에서 받은 전체 결과 (상세 정보 미포함)
  List<BoardGame> _rawResults = [];

  /// 지금까지 /thing API로 보강 완료된 항목 수
  int _enrichedUpTo = 0;

  bool _isLoadingMore = false;

  /// reset/새 검색 시 증가 — 진행 중인 비동기 작업이 완료되면 세대 확인 후 무시
  int _generation = 0;

  @override
  Future<List<BoardGame>> build() async {
    return [];
  }

  Future<void> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      _reset();
      state = const AsyncValue.data([]);
      return;
    }

    _reset();
    state = const AsyncValue.loading();

    final result = await AsyncValue.guard(
      () => ref.read(gameRepositoryProvider).searchBgg(trimmed),
    );

    if (result.hasError) {
      state = result;
      return;
    }

    _rawResults = result.value ?? [];

    // 검색 결과를 먼저 보여주고 (썸네일 없는 상태)
    state = AsyncValue.data(List.of(_rawResults));

    // 첫 배치 즉시 보강
    await _enrichNextBatch();
  }

  /// 스크롤이 끝에 가까워질 때 호출
  Future<void> loadNextBatch() async {
    if (_isLoadingMore) return;
    if (_enrichedUpTo >= _rawResults.length) return;

    await _enrichNextBatch();
  }

  Future<void> _enrichNextBatch() async {
    _isLoadingMore = true;
    final gen = _generation; // 현재 세대 캡처

    final remaining = _rawResults.length - _enrichedUpTo;
    final batchSize = remaining < _batchSize ? remaining : _batchSize;
    final batch = _rawResults.sublist(_enrichedUpTo, _enrichedUpTo + batchSize);

    try {
      final enriched = await ref
          .read(gameRepositoryProvider)
          .enrichWithDetails(batch);

      // await 이후 세대가 바뀌었으면 (reset/새 검색) 결과 버림
      if (gen != _generation) return;

      final enrichedMap = {for (final g in enriched) g.bggId: g};
      final current = List.of(state.value ?? _rawResults);
      for (var i = _enrichedUpTo; i < _enrichedUpTo + batchSize; i++) {
        final enrichedGame = enrichedMap[_rawResults[i].bggId];
        if (enrichedGame != null) current[i] = enrichedGame;
      }

      _enrichedUpTo += batchSize;
      state = AsyncValue.data(current);
    } catch (_) {
      // 보강 실패해도 기존 검색 결과는 유지
    } finally {
      if (gen == _generation) _isLoadingMore = false;
    }
  }

  int get enrichedUpTo => _enrichedUpTo;

  bool get hasMoreToEnrich => _enrichedUpTo < _rawResults.length;

  void clear() {
    _reset();
    state = const AsyncData([]);
  }

  void _reset() {
    _generation++;
    _rawResults = [];
    _enrichedUpTo = 0;
    _isLoadingMore = false;
  }
}

final searchNotifierProvider =
    AsyncNotifierProvider.autoDispose<SearchNotifier, List<BoardGame>>(
      SearchNotifier.new,
    );
