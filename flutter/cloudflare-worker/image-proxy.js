/**
 * BGMate Image Proxy — Cloudflare Worker
 *
 * BGG CDN은 Access-Control-Allow-Origin 헤더를 제공하지 않아
 * Flutter Web에서 CORS 오류가 발생합니다. 이 워커는 BGG 이미지를
 * 중계하면서 CORS 헤더를 추가합니다.
 *
 * 사용법: GET https://<worker-domain>?url=<encoded-bgg-image-url>
 *
 * 배포:
 *   npm install -g wrangler
 *   wrangler login
 *   wrangler deploy
 */

// SSRF 방지: 허용할 도메인 목록
const ALLOWED_HOSTS = new Set([
  'cf.geekdo-images.com',
  'cf.geekdo-static.com',
  'boardgamegeek.com',
  'www.boardgamegeek.com',
]);

// 이미지 캐시 TTL (30일)
const CACHE_TTL = 60 * 60 * 24 * 30;

export default {
  async fetch(request, env, ctx) {
    // CORS preflight
    if (request.method === 'OPTIONS') {
      return corsResponse(new Response(null, { status: 204 }));
    }

    if (request.method !== 'GET') {
      return corsResponse(new Response('Method Not Allowed', { status: 405 }));
    }

    const { searchParams } = new URL(request.url);
    const rawUrl = searchParams.get('url');

    if (!rawUrl) {
      return corsResponse(
        new Response('Missing ?url= parameter', { status: 400 })
      );
    }

    let targetUrl;
    try {
      targetUrl = new URL(rawUrl);
    } catch {
      return corsResponse(new Response('Invalid URL', { status: 400 }));
    }

    // SSRF 방지: allowlist 외의 호스트 차단
    if (!ALLOWED_HOSTS.has(targetUrl.hostname)) {
      return corsResponse(
        new Response(`Host not allowed: ${targetUrl.hostname}`, { status: 403 })
      );
    }

    // Cloudflare Cache API 활용
    const cache = caches.default;
    const cacheKey = new Request(rawUrl, { method: 'GET' });
    const cached = await cache.match(cacheKey);
    if (cached) {
      const res = new Response(cached.body, cached);
      res.headers.set('CF-Cache-Status', 'HIT');
      return corsResponse(res);
    }

    let upstream;
    try {
      upstream = await fetch(rawUrl, {
        headers: {
          // BGG CDN에 일반 브라우저처럼 보이도록
          'User-Agent': 'Mozilla/5.0 (compatible; BGMateProxy/1.0)',
          Accept: 'image/webp,image/apng,image/*,*/*;q=0.8',
        },
      });
    } catch (err) {
      return corsResponse(
        new Response(`Failed to fetch upstream: ${err.message}`, {
          status: 502,
        })
      );
    }

    if (!upstream.ok) {
      return corsResponse(
        new Response(`Upstream error: ${upstream.status}`, {
          status: upstream.status,
        })
      );
    }

    const response = new Response(upstream.body, {
      status: upstream.status,
      headers: {
        'Content-Type':
          upstream.headers.get('Content-Type') || 'image/jpeg',
        'Cache-Control': `public, max-age=${CACHE_TTL}`,
        'CF-Cache-Status': 'MISS',
      },
    });

    // 비동기 캐시 저장 (응답 반환을 블로킹하지 않음)
    ctx.waitUntil(cache.put(cacheKey, response.clone()));

    return corsResponse(response);
  },
};

function corsResponse(response) {
  const res = new Response(response.body, response);
  res.headers.set('Access-Control-Allow-Origin', '*');
  res.headers.set('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.headers.set('Access-Control-Max-Age', '86400');
  return res;
}
