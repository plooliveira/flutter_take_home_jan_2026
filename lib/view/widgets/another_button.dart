import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnotherButton extends StatelessWidget {
  final bool isLoading;

  final VoidCallback onPressed;

  const AnotherButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Button to get another image',
      child:
          ElevatedButton(
                onPressed: isLoading ? () {} : onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Another'),
              )
              .animate(target: isLoading ? 0 : 1, delay: 200.ms)
              .fade()
              .moveY(begin: 10, end: 0),
    );
  }
}
