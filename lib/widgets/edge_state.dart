import 'package:flutter/material.dart';

class EdgeState extends StatelessWidget {
  final IconData? icon;
  final double iconSize;
  final Color? iconColor;
  final String message;
  final bool showLoader;

  const EdgeState({
    super.key,
    this.icon,
    this.iconSize = 64,
    this.iconColor,
    required this.message,
    this.showLoader = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (showLoader)
            const CircularProgressIndicator()
          else if (icon != null)
            Icon(icon, size: iconSize, color: iconColor),
          const SizedBox(height: 12),
          Text(
            message,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
