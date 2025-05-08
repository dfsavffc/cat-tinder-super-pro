import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cat_tinder_pro/domain/cat_controller.dart';
import 'package:cat_tinder_pro/models/cat.dart';
import 'package:cat_tinder_pro/domain/liked_cat.dart';
import 'package:cat_tinder_pro/di/service_locator.dart';
import 'package:cat_tinder_pro/data/cat_service.dart';
import 'package:cat_tinder_pro/data/cat_local_storage.dart';

class FakeLikedCat extends Fake implements LikedCat {}

class MockCatService extends Mock implements CatService {}

class MockLocalStorage extends Mock implements CatLocalStorage {}

void main() {
  late MockCatService service;
  late MockLocalStorage local;

  final stubCat = Cat(
    imageUrl: 'url1',
    breedName: 'Breed',
    description: 'desc',
    temperament: 'temp',
    origin: 'orig',
  );
  setUpAll(() {
    registerFallbackValue(FakeLikedCat());
  });

  setUp(() {
    service = MockCatService();
    local = MockLocalStorage();
    getIt.reset();
    getIt.registerSingleton<CatService>(service);
    getIt.registerSingleton<CatLocalStorage>(local);

    when(() => local.getLikedCats()).thenAnswer((_) async => []);
    when(() => local.getDislikedUrls()).thenAnswer((_) async => []);
    when(() => service.fetchRandomCat()).thenAnswer((_) async => stubCat);
    when(() => local.getCachedCats()).thenAnswer((_) async => []);
  });

  test('handleSwipe(true) добавляет лайк и сохраняет', () async {
    final c = CatController();
    await c.initialize();

    when(() => local.addLikedCat(any())).thenAnswer((_) async {});

    c.handleSwipe(true);

    expect(c.likedCats.length, 1);
    expect(c.likesCount, 1);
    verify(() => local.addLikedCat(any())).called(1);
  });

  test('handleSwipe(false) сохраняет дизлайк', () async {
    final c = CatController();
    await c.initialize();

    when(() => local.addDislikedUrl(any())).thenAnswer((_) async {});

    c.handleSwipe(false);

    verify(() => local.addDislikedUrl('url1')).called(1);
  });

  test('removeLikedCat() удаляет лайк и кэш', () async {
    final liked = LikedCat(cat: stubCat, likedAt: DateTime.now());
    when(() => local.getLikedCats()).thenAnswer((_) async => [liked]);

    final c = CatController();
    await c.initialize();

    when(() => local.removeLikedCat(any())).thenAnswer((_) async {});

    c.removeLikedCat(liked);

    expect(c.likedCats.isEmpty, true);
    verify(() => local.removeLikedCat(liked)).called(1);
  });
}
