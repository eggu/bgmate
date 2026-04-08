import 'package:bgmate_flutter/data/remote/bgg_api_remote_data_source.dart';
import 'package:bgmate_flutter/data/remote/bgg_api_service.dart';
import 'package:bgmate_flutter/data/remote/bgg_remote_data_source.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bggApiServiceProvider = Provider<BggApiService>((_) => BggApiService());

final bggRemoteDataSourceProvider = Provider<BggRemoteDataSource>(
  (ref) => BggApiRemoteDataSource(ref.watch(bggApiServiceProvider)),
);
