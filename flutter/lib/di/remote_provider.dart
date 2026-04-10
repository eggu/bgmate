import 'package:bgmate_flutter/data/remote/ai/gemini_llm_client.dart';
import 'package:bgmate_flutter/data/remote/ai/llm_client.dart';
import 'package:bgmate_flutter/data/remote/bgg_api_remote_data_source.dart';
import 'package:bgmate_flutter/data/remote/bgg_api_service.dart';
import 'package:bgmate_flutter/data/remote/bgg_remote_data_source.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bggApiServiceProvider = Provider<BggApiService>((_) => BggApiService());

final bggRemoteDataSourceProvider = Provider<BggRemoteDataSource>(
  (ref) => BggApiRemoteDataSource(ref.watch(bggApiServiceProvider)),
);

final dioProvider = Provider<Dio>((_) => Dio());

final llmClientProvider = Provider<LlmClient>(
  (ref) => GeminiLlmClient(
    dio: ref.watch(dioProvider),
    apiKey: const String.fromEnvironment('GEMINI_API_KEY'),
  ),
);
