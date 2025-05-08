import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../domain/cat_controller.dart';
import '../../domain/liked_cat.dart';
import '../widgets/loading_indicator.dart';
import '../../data/cat_cache_manager.dart';

class LikedCatsScreen extends StatefulWidget {
  const LikedCatsScreen({super.key});

  @override
  State<LikedCatsScreen> createState() => _LikedCatsScreenState();
}

class _LikedCatsScreenState extends State<LikedCatsScreen> {
  String? _selectedBreed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Liked Cats')),

      body: Consumer<CatController>(
        builder: (_, c, __) {
          final breeds =
              {for (final l in c.likedCats) l.cat.breedName}.toList()..sort();

          if (_selectedBreed != null && !breeds.contains(_selectedBreed)) {
            _selectedBreed = null;
          }

          final items =
              c.likedCats
                  .where(
                    (l) =>
                        _selectedBreed == null ||
                        l.cat.breedName == _selectedBreed,
                  )
                  .toList()
                  .reversed
                  .toList();

          return Column(
            children: [
              if (breeds.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: DropdownButton<String?>(
                    value: _selectedBreed,
                    hint: const Text('Все породы'),
                    isExpanded: true,
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('Все породы'),
                      ),
                      ...breeds.map(
                        (b) => DropdownMenuItem(value: b, child: Text(b)),
                      ),
                    ],
                    onChanged: (v) => setState(() => _selectedBreed = v),
                  ),
                ),
              Expanded(
                child:
                    items.isEmpty
                        ? const Center(child: Text('Нет лайкнутых котиков'))
                        : ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (_, i) => _LikedTile(liked: items[i]),
                        ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _LikedTile extends StatelessWidget {
  final LikedCat liked;
  const _LikedTile({required this.liked});

  @override
  Widget build(BuildContext context) {
    final c = context.read<CatController>();

    return Dismissible(
      key: ValueKey('${liked.cat.imageUrl}_${liked.likedAt}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.error.withAlpha(102),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, size: 28),
      ),
      onDismissed: (_) => c.removeLikedCat(liked),

      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              cacheManager: CatCacheManager.instance,
              imageUrl: liked.cat.imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              placeholder: (_, __) => const LoadingIndicator(),
              errorWidget: (_, __, ___) => const Icon(Icons.error),
            ),
          ),
          title: Text(
            liked.cat.breedName,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: Text(
            '${liked.likedAt.day.toString().padLeft(2, "0")}.'
            '${liked.likedAt.month.toString().padLeft(2, "0")}.'
            '${liked.likedAt.year} '
            '${liked.likedAt.hour.toString().padLeft(2, "0")}:'
            '${liked.likedAt.minute.toString().padLeft(2, "0")}',
            style: Theme.of(context).textTheme.bodySmall,
          ),

          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => c.removeLikedCat(liked),
          ),
        ),
      ),
    );
  }
}
