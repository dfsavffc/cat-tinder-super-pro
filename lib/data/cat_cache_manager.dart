import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CatCacheManager {
  static final CacheManager instance = CacheManager(
    Config(
      'catCache',
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 100,
      repo: JsonCacheInfoRepository(databaseName: 'catCache'),
      fileService: HttpFileService(),
    ),
  );
}
