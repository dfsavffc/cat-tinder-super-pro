import 'package:get_it/get_it.dart';
import '../data/cat_local_storage.dart';
import '../data/cat_service.dart';
import '../data/connectivity_service.dart';

final getIt = GetIt.instance;

void setupLocator() {
  if (!getIt.isRegistered<CatLocalStorage>()) {
    getIt.registerLazySingleton<CatLocalStorage>(() => CatLocalStorage());
  }

  if (!getIt.isRegistered<CatService>()) {
    getIt.registerLazySingleton<CatService>(() => CatService(local: getIt()));
  }

  if (!getIt.isRegistered<ConnectivityService>()) {
    getIt.registerLazySingleton<ConnectivityService>(
      () => ConnectivityService(),
    );
  }
}
