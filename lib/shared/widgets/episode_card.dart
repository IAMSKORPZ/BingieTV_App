import 'package:flutter/material.dart';

class EpisodeCard extends StatelessWidget {
  final String title;
  final String meta;
  final VoidCallback? onPlay;

  const EpisodeCard({
    super.key,
    required this.title,
    required this.meta,
    this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: IconButton(
          icon: const Icon(Icons.play_circle_outline),
          onPressed: onPlay,
        ),
        title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(meta, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}
