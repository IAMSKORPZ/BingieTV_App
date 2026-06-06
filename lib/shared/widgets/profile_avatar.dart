import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String label;
  final String? imageUrl;

  const ProfileAvatar({super.key, required this.label, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: imageUrl == null ? null : NetworkImage(imageUrl!),
      child: imageUrl == null ? Text(label.characters.first.toUpperCase()) : null,
    );
  }
}
