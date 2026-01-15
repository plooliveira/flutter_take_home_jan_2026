import 'package:flutter/material.dart';

class BackgroundLayer extends StatelessWidget {
  final ColorScheme colorScheme;

  const BackgroundLayer({super.key, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      color: colorScheme.primary,
    );
  }
}
