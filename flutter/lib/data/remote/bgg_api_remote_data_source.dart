import 'package:bgmate_flutter/data/remote/bgg_api_service.dart';
import 'package:bgmate_flutter/data/remote/bgg_remote_data_source.dart';
import 'package:bgmate_flutter/domain/model/board_game.dart';

import 'bgg_xml_parser.dart';

class BggApiRemoteDataSource implements BggRemoteDataSource {
  final BggApiService _apiService;

  BggApiRemoteDataSource(this._apiService);

  @override
  Future<List<BoardGame>> searchGames(String query) async {
    final xml = await _apiService.searchGames(query);
    return BggXmlParser.parseSearchResults(xml);
  }
}
