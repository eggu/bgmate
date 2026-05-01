import 'package:bgmate_flutter/domain/model/board_game.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sort_option.freezed.dart';

enum SortField { addedAt, name, yearPublished }

enum SortOrder { asc, desc }

extension SortFieldComparator on SortField {
  int compare(BoardGame a, BoardGame b) => switch (this) {
        SortField.name => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        SortField.yearPublished => a.yearPublished.compareTo(b.yearPublished),
        SortField.addedAt => 0,
      };
}

@freezed
sealed class SortOption with _$SortOption {
  const factory SortOption({
    @Default(SortField.addedAt) SortField field,
    @Default(SortOrder.desc) SortOrder order,
  }) = _SortOption;
}

extension SortOptionX on SortOption {
  SortOption toggleOrder() => copyWith(
        order: order == SortOrder.asc ? SortOrder.desc : SortOrder.asc,
      );
}
