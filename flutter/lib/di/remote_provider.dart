import 'package:bgmate_flutter/data/remote/ai/gemini_llm_client.dart';
import 'package:bgmate_flutter/data/remote/ai/llm_client.dart';
import 'package:bgmate_flutter/data/remote/bgg_collection_sync_api_service.dart';
import 'package:bgmate_flutter/data/remote/bgg_plays_api_service.dart';
import 'package:bgmate_flutter/data/remote/bgg_api_remote_data_source.dart';
import 'package:bgmate_flutter/data/remote/bgg_api_service.dart';
import 'package:bgmate_flutter/data/remote/bgg_remote_data_source.dart';
import 'package:bgmate_flutter/data/remote/used_price_api_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bggApiServiceProvider = Provider<BggApiService>((_) => BggApiService());

final bggRemoteDataSourceProvider = Provider<BggRemoteDataSource>(
  (ref) => BggApiRemoteDataSource(ref.watch(bggApiServiceProvider)),
);

final dioProvider = Provider<Dio>((_) => Dio());

final usedPriceApiServiceProvider = Provider<UsedPriceApiService>(
  (ref) => UsedPriceApiService(
    dio: ref.watch(dioProvider),
    baseUrl: const String.fromEnvironment('BGMATE_USED_PRICE_API_BASE_URL'),
  ),
);

final bggCollectionSyncApiServiceProvider =
    Provider<BggCollectionSyncApiService>(
      (ref) => BggCollectionSyncApiService(
        apiService: ref.watch(bggApiServiceProvider),
      ),
    );

final bggPlaysApiServiceProvider = Provider<BggPlaysApiService>(
  (ref) => BggPlaysApiService(apiService: ref.watch(bggApiServiceProvider)),
);

final llmClientProvider = Provider<LlmClient>(
  (ref) => GeminiLlmClient(
    dio: ref.watch(dioProvider),
    apiKey: const String.fromEnvironment('GEMINI_API_KEY'),
  ),
);
