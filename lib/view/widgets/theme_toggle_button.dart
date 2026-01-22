import 'package:flutter/material.dart';

class ThemeToggleButton extends StatelessWidget {
  final ColorScheme colorScheme;
  final VoidCallback onPressed;

  const ThemeToggleButton({
    super.key,
    required this.colorScheme,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.brightness_4, color: colorScheme.surface),
      onPressed: onPressed,
    );
  }
}
