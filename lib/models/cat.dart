class Cat {
  final String imageUrl;

  final String breedName;

  final String description;

  final String temperament;

  final String origin;

  const Cat({
    required this.imageUrl,
    required this.breedName,
    required this.description,
    required this.temperament,
    required this.origin,
  });

  factory Cat.fromJson(Map<String, dynamic> json) {
    try {
      final breed =
          (json['breeds'] as List?)?.firstWhere(
                (b) => b != null,
                orElse: () => {},
              )
              as Map<String, dynamic>;

      return Cat(
        imageUrl: json['url'] as String,
        breedName: _getValue(breed, 'name', 'Неизвестно'),
        description: _getValue(breed, 'description', 'Нет описания'),
        temperament: _getValue(breed, 'temperament', 'Не указан'),
        origin: _getValue(breed, 'origin', 'Не указан'),
      );
    } catch (e, stackTrace) {
      throw FormatException('Ошибка парсинга: $e', stackTrace);
    }
  }

  static String _getValue(
    Map<String, dynamic> map,
    String key,
    String fallback,
  ) {
    final value = map[key];
    return (value is String && value.isNotEmpty) ? value : fallback;
  }

  Map<String, dynamic> toJson() => {
    'url': imageUrl,
    'breeds': [
      {
        'name': breedName,
        'description': description,
        'temperament': temperament,
        'origin': origin,
      },
    ],
  };

  @override
  String toString() => 'Порода: $breedName ($origin)';
}
