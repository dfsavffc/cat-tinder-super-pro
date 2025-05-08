import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/cat.dart';
import '../widgets/detail_section.dart';
import '../../data/cat_cache_manager.dart';

class DetailScreen extends StatelessWidget {
  final Cat cat;
  const DetailScreen({super.key, required this.cat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(cat.breedName), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: CachedNetworkImage(
                cacheManager: CatCacheManager.instance,
                imageUrl: cat.imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder:
                    (_, __) => const Center(child: CircularProgressIndicator()),
                errorWidget: (_, __, ___) => const Icon(Icons.error, size: 40),
              ),
            ),
            const SizedBox(height: 24),
            DetailSection(
              icon: Icons.description,
              title: 'Описание',
              content: cat.description,
            ),
            DetailSection(
              icon: Icons.psychology,
              title: 'Характер',
              content: cat.temperament,
            ),
            DetailSection(
              icon: Icons.place,
              title: 'Происхождение',
              content: cat.origin,
            ),
          ],
        ),
      ),
    );
  }
}
