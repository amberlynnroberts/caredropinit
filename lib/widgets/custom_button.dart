import 'package:flutter/material.dart';

class CaredropButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool filled;

  const CaredropButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.filled = true,
  });

  @override
  Widget build(BuildContext context) {
    return filled
        ? FilledButton(onPressed: onPressed, child: Text(label))
        : OutlinedButton(onPressed: onPressed, child: Text(label));
  }
}

