import 'package:bgmate_flutter/core/image/image_url_resolver.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// 보드게임 썸네일 위젯.
///
/// - [url]이 있으면 이미지 로드 (로딩 중 스피너, 에러 시 기본 placeholder)
/// - [url]이 비어 있으면 [isEnriching] 여부에 따라 placeholder 표시
///   - [isEnriching] == true (디버그 전용): 스피너 placeholder
///   - [isEnriching] == false (디버그 전용): "없음" placeholder
///   - 릴리즈: 항상 기본 placeholder
class GameThumbnail extends StatelessWidget {
  final String url;

  /// 아직 /thing API 보강이 완료되지 않은 항목인지 여부 (디버그 전용 표시에 사용)
  final bool isEnriching;

  const GameThumbnail({
    super.key,
    required this.url,
    this.isEnriching = false,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: url.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: resolveImageUrl(url),
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  const GameThumbnailLoadingPlaceholder(),
              errorWidget: (context, url, error) =>
                  const GameThumbnailPlaceholder(),
            )
          : _emptyPlaceholder(),
    );
  }

  Widget _emptyPlaceholder() {
    if (kDebugMode) {
      return isEnriching
          ? const GameThumbnailLoadingPlaceholder()
          : const GameThumbnailEmptyPlaceholder();
    }
    return const GameThumbnailPlaceholder();
  }
}

/// 기본 placeholder — 썸네일 없음 (릴리즈 공통)
class GameThumbnailPlaceholder extends StatelessWidget {
  const GameThumbnailPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: const Icon(Icons.casino_outlined, color: Colors.grey),
    );
  }
}

/// 디버그 전용 — BGG에 썸네일이 없는 게임
class GameThumbnailEmptyPlaceholder extends StatelessWidget {
  const GameThumbnailEmptyPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.hide_image_outlined, color: Colors.grey, size: 20),
          Text('없음', style: TextStyle(color: Colors.grey, fontSize: 10)),
        ],
      ),
    );
  }
}

/// 이미지 다운로드 중 또는 /thing API 보강 대기 중
class GameThumbnailLoadingPlaceholder extends StatelessWidget {
  const GameThumbnailLoadingPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey[50],
      child: const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}
