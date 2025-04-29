import 'package:flutter/material.dart';

class EdgeState extends StatelessWidget {
  final IconData? icon;
  final double iconSize;
  final Color? iconColor;
  final String message;
  final bool showLoader;
  final Function()? onPressed;

  const EdgeState({
    super.key,
    this.icon,
    this.iconSize = 64,
    this.iconColor,
    required this.message,
    this.showLoader = false,
    this.onPressed,
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
          if (onPressed != null) ...[
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
              icon: const Icon(Icons.refresh),
              label: const Text("Try Again", style: TextStyle(fontSize: 16)),
            ),
          ],
        ],
      ),
    );
  }
}
