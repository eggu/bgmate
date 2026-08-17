import 'package:bgmate_flutter/domain/model/board_game.dart';
import 'package:bgmate_flutter/domain/model/used_price.dart';
import 'package:dio/dio.dart';

class UsedPriceApiService {
  final Dio _dio;
  final String baseUrl;

  const UsedPriceApiService({required Dio dio, required this.baseUrl})
    : _dio = dio;

  bool get isConfigured => baseUrl.trim().isNotEmpty;

  Future<UsedPrice?> fetchUsedPrice(
    BoardGame game, {
    String? originalName,
  }) async {
    if (!isConfigured) {
      throw StateError('BGMATE_USED_PRICE_API_BASE_URL is missing.');
    }

    final response = await _dio.getUri<Map<String, dynamic>>(
      usedPriceUri(
        baseUrl: baseUrl,
        name: game.name,
        bggId: game.bggId,
        originalName: originalName,
      ),
    );
    final data = response.data;
    if (data == null) return null;
    return UsedPrice.fromApiJson(data);
  }

  static Uri usedPriceUri({
    required String baseUrl,
    required String name,
    required int bggId,
    String? originalName,
  }) {
    final root = Uri.parse(baseUrl.trim().replaceFirst(RegExp(r'/+$'), ''));
    final rootPath = root.path.replaceFirst(RegExp(r'/+$'), '');
    final params = {'name': name, 'bggId': '$bggId'};
    final original = originalName?.trim();
    if (original != null && original.isNotEmpty && original != name.trim()) {
      params['originalName'] = original;
    }
    return root.replace(
      path: '$rootPath/api/bgmate/used-price',
      queryParameters: params,
    );
  }
}
