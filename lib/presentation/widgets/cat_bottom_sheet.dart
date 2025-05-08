import 'package:flutter/material.dart';
import '../../models/cat.dart';

class CatBottomSheet extends StatelessWidget {
  final Cat cat;
  const CatBottomSheet({super.key, required this.cat});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _Section(
                title: 'Описание',
                content: cat.description,
                icon: Icons.pets,
              ),
              _Section(
                title: 'Характер',
                content: cat.temperament,
                icon: Icons.face,
              ),
              _Section(
                title: 'Происхождение',
                content: cat.origin,
                icon: Icons.location_on,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;
  const _Section({
    required this.title,
    required this.content,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Theme.of(context).textTheme.bodyMedium?.color),
              const SizedBox(width: 8),
              Text(
                title,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(content, style: textTheme.bodyMedium),
        ],
      ),
    );
  }
}
