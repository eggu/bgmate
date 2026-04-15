import 'package:bgmate_flutter/core/image/image_url_resolver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('resolveImageUrl', () {
    const bggUrl = 'https://cf.geekdo-images.com/thumb/img/abc123.jpg';
    const staticUrl = 'https://cf.geekdo-static.com/assets/logo.png';
    const bggRootUrl = 'https://boardgamegeek.com/image/1234';
    const nonBggUrl = 'https://example.com/image.jpg';

    group('비웹 환경', () {
      test('BGG URL을 그대로 반환한다', () {
        expect(resolveImageUrl(bggUrl, isWebOverride: false), bggUrl);
      });

      test('빈 문자열을 그대로 반환한다', () {
        expect(resolveImageUrl('', isWebOverride: false), '');
      });

      test('비BGG URL을 그대로 반환한다', () {
        expect(resolveImageUrl(nonBggUrl, isWebOverride: false), nonBggUrl);
      });
    });

    group('웹 환경 — weserv.nl 폴백 (IMAGE_PROXY_BASE_URL 미설정)', () {
      test('BGG CDN URL을 weserv 프록시로 변환한다', () {
        final result = resolveImageUrl(bggUrl, isWebOverride: true);
        expect(result, startsWith('https://images.weserv.nl/?url='));
        expect(result, contains(Uri.encodeComponent(bggUrl)));
      });

      test('cf.geekdo-static.com URL을 weserv 프록시로 변환한다', () {
        final result = resolveImageUrl(staticUrl, isWebOverride: true);
        expect(result, startsWith('https://images.weserv.nl/?url='));
        expect(result, contains(Uri.encodeComponent(staticUrl)));
      });

      test('boardgamegeek.com URL을 weserv 프록시로 변환한다', () {
        final result = resolveImageUrl(bggRootUrl, isWebOverride: true);
        expect(result, startsWith('https://images.weserv.nl/?url='));
      });

      test('비BGG URL은 그대로 반환한다', () {
        expect(resolveImageUrl(nonBggUrl, isWebOverride: true), nonBggUrl);
      });

      test('빈 문자열은 그대로 반환한다', () {
        expect(resolveImageUrl('', isWebOverride: true), '');
      });

      test('이미 weserv URL이면 이중 wrap 하지 않는다', () {
        final alreadyProxied =
            'https://images.weserv.nl/?url=${Uri.encodeComponent(bggUrl)}';
        expect(
          resolveImageUrl(alreadyProxied, isWebOverride: true),
          alreadyProxied,
        );
      });

      test('잘못된 URL은 그대로 반환한다', () {
        const invalid = 'not a url';
        expect(resolveImageUrl(invalid, isWebOverride: true), invalid);
      });
    });
  });
}
