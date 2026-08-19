import 'package:flutter/material.dart';

class LoadingSkeleton extends StatelessWidget {
  final double? width;
  final double height;
  final double borderRadius;

  const LoadingSkeleton({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF334155)
            : const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
