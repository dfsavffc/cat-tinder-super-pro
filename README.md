# Cat Tinder 😻

Приложение‑тренажёр для свайпов: знакомьтесь с пушистыми, лайкайте, ведите список избранных.  
Работает на Flutter 3.7+, поддерживает светлую и тёмную темы.

## Скриншоты

| Главный экран | Детали породы | Лайкнутые |
|:--:|:--:|:--:|
| <img src="screenshots/main.png" width="250"/> | <img src="screenshots/detail.png" width="250"/> | <img src="screenshots/liked.png" width="250"/> |

| Без сети | Восстановлено |  |
|:--:|:--:|:--:|
| <img src="screenshots/main_screen_without_connection.png" width="250"/> | <img src="screenshots/main_screen_with_connection.png" width="250"/> |  |


## Функциональность
- **Свайпы** ←/→ или кнопки 👍 / 👎
- **Список лайкнутых** с фильтром по породе и удалением свайпом ↔ / иконкой 🗑
- **Счётчик лайков** в AppBar (динамически, совпадает с количеством в избранном)
- **Детальная карточка** с описанием, характером, происхождением
- **Автоподгрузка** карточек, CircularProgressIndicator и заглушка-картинка при ожидании
- **Переключение темы** 🌚 / 🌝
- **Обработка ошибок сети** (AlertDialog + кнопка «Повторить»)
- **Оффлайн-режим**: отображение ранее загруженных котиков без сети
- **Персистентные лайки/дизлайки**: сохраняются между запусками приложения
- **Кэширование изображений**: через `cached_network_image`, доступно оффлайн
- **Индикатор сетевого статуса**: индикитор отсутствия соединения с сетью
- **Unit-тесты**: проверки операций лайков и дизлайков в `CatController` с использованием `mocktail`

## Технологии
| Категория | Используется |
|-----------|--------------|
| UI | **Flutter 3.7+, Material 3** |
| State‑management | **Provider + ChangeNotifier** |
| DI | **get_it** |
| HTTP | **http** |
| Кэш изображений | **cached_network_image** |
| Конфиги | **flutter_dotenv** |
| API | [TheCatAPI](https://thecatapi.com/) |

## Используемые пакеты
- [`provider`](https://pub.dev/packages/provider) — управление состоянием  
- [`get_it`](https://pub.dev/packages/get_it) — внедрение зависимостей  
- [`http`](https://pub.dev/packages/http) — HTTP‑запросы  
- [`cached_network_image`](https://pub.dev/packages/cached_network_image) — кеширование картинок  
- [`flutter_dotenv`](https://pub.dev/packages/flutter_dotenv) — переменные окружения  
- [`cupertino_icons`](https://pub.dev/packages/cupertino_icons) — иконки iOS‑стиля  


## Как запустить
```bash
flutter pub get
flutter run --dart-define=CAT_API_KEY=<YOUR_KEY>
```

## Ссылка на скачивание APK
[Скачать APK](https://drive.google.com/file/d/1ozN_hWA0UjyYeMzCrQ6YULxlwlpxO5zL/view?usp=sharing)