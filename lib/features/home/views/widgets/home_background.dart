import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

class HomeBackground extends StatelessWidget {
  const HomeBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: AppPalette.homeBackgroundGradient,
      ),
      child: Stack(
        children: [
          Positioned(
            top: -120,
            left: -70,
            child: _BlurCircle(
              size: 220,
              color: AppPalette.primary.withValues(alpha: 0.14),
            ),
          ),
          Positioned(
            top: 140,
            right: -80,
            child: _BlurCircle(
              size: 220,
              color: AppPalette.secondary.withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    );
  }
}

class _BlurCircle extends StatelessWidget {
  const _BlurCircle({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
