import 'package:flutter/foundation.dart';

/// BGG 도메인 목록 — 웹에서 CORS 우회가 필요한 CDN 호스트
const _bggHosts = {
  'cf.geekdo-images.com',
  'cf.geekdo-static.com',
  'boardgamegeek.com',
  'www.boardgamegeek.com',
};

/// 이미지 프록시 base URL.
///
/// `--dart-define-from-file=dart_define.json`으로 주입된
/// `IMAGE_PROXY_BASE_URL` 값이 우선 사용됩니다.
/// 비어 있으면 공개 weserv.nl 프록시로 폴백합니다.
const _proxyBase = String.fromEnvironment('IMAGE_PROXY_BASE_URL');

/// 플랫폼에 맞는 이미지 URL을 반환합니다.
///
/// - 비웹 환경(Android, iOS, macOS, Windows, Linux): [rawUrl] 그대로 반환.
/// - 웹 환경 + BGG 도메인: CORS 허용 프록시를 거치도록 URL 변환.
/// - 웹 환경 + 비BGG 도메인: [rawUrl] 그대로 반환.
/// - 빈 문자열: 빈 문자열 반환.
///
/// 테스트에서 [isWebOverride]로 `kIsWeb` 값을 주입할 수 있습니다.
String resolveImageUrl(String rawUrl, {bool? isWebOverride}) {
  if (rawUrl.isEmpty) return rawUrl;

  final isWeb = isWebOverride ?? kIsWeb;
  if (!isWeb) return rawUrl;

  final uri = Uri.tryParse(rawUrl);
  if (uri == null || !_bggHosts.contains(uri.host)) return rawUrl;

  // 이미 프록시를 통하고 있으면 이중 wrap 방지
  if (_proxyBase.isNotEmpty && rawUrl.startsWith(_proxyBase)) return rawUrl;
  if (rawUrl.contains('images.weserv.nl')) return rawUrl;

  if (_proxyBase.isNotEmpty) {
    final encoded = Uri.encodeComponent(rawUrl);
    return '$_proxyBase?url=$encoded';
  }

  // 폴백: images.weserv.nl (공개 CORS 프록시)
  final encoded = Uri.encodeComponent(rawUrl);
  return 'https://images.weserv.nl/?url=$encoded';
}
