import 'package:another_iptv_player/models/import_progress_model.dart';
import 'package:another_iptv_player/models/stalker_provider_config.dart';
import 'package:another_iptv_player/services/stalker_api_service.dart';

class StalkerImportService {
  final StalkerApiService api;

  StalkerImportService({StalkerApiService? api})
      : api = api ?? StalkerApiService();

  Stream<ImportProgressModel> importIncremental({
    required StalkerProviderConfig config,
    required String token,
    required String type,
    String? categoryId,
    int maxPages = 1,
  }) async* {
    var imported = 0;
    for (var page = 1; page <= maxPages; page++) {
      final items = await api.fetchPage(
        config: config,
        token: token,
        type: type,
        page: page,
        categoryId: categoryId,
      );
      imported += items.length;
      yield ImportProgressModel(
        currentItem: '$type page $page',
        processedItems: imported,
        totalItems: null,
        startedAt: DateTime.now(),
      );
      if (items.isEmpty) break;
    }
  }
}
