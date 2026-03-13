/// Animated loader components
library;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Custom animated circular loader
class AnimatedCircularLoader extends StatelessWidget {
  final double size;
  final Color? color;
  final Color? backgroundColor;
  final double strokeWidth;

  const AnimatedCircularLoader({
    super.key,
    this.size = 50,
    this.color,
    this.backgroundColor,
    this.strokeWidth = 4,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loaderColor = color ?? theme.primaryColor;
    final bgColor = backgroundColor ?? (loaderColor.withAlpha(50));

    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: Animate(
          effects: [RotateEffect(duration: const Duration(milliseconds: 1500))],
          onComplete: (controller) => controller.repeat(),
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(loaderColor),
            backgroundColor: bgColor,
            strokeWidth: strokeWidth,
          ),
        ),
      ),
    );
  }
}

/// Pulsing loader for subtle loading states
class PulsingLoader extends StatelessWidget {
  final double size;
  final Color? color;

  const PulsingLoader({
    super.key,
    this.size = 12,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loaderColor = color ?? theme.primaryColor;

    return Center(
      child: SizedBox.square(
        dimension: size,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: loaderColor,
          ),
        ).animate(onPlay: (controller) => controller.repeat()).scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1.2, 1.2),
          duration: const Duration(milliseconds: 1000),
        ),
      ),
    );
  }
}

/// Multi-dot bouncing loader
class BouncingDotsLoader extends StatelessWidget {
  final Color? color;

  const BouncingDotsLoader({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loaderColor = color ?? theme.primaryColor;

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          3,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: SizedBox.square(
              dimension: 8,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: loaderColor,
                ),
              ),
            ).animate(onPlay: (controller) => controller.repeat()).scaleY(
              begin: 1,
              end: 0.5,
              duration: const Duration(milliseconds: 600),
              delay: Duration(milliseconds: index * 150),
            ),
          ),
        ),
      ),
    );
  }
}

/// Wave loader animation
class WaveLoader extends StatelessWidget {
  final Color? color;

  const WaveLoader({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final waveColor = color ?? theme.primaryColor;

    return Center(
      child: SizedBox(
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            4,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: _buildWaveBar(waveColor)
                  .animate(onPlay: (controller) => controller.repeat())
                  .scaleY(
                    begin: 0.3,
                    end: 1,
                    duration: const Duration(milliseconds: 600),
                    delay: Duration(milliseconds: index * 100),
                  ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWaveBar(Color color) {
    return Container(
      width: 4,
      color: color,
    );
  }
}

/// Loading overlay widget
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? message;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black.withAlpha(100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AnimatedCircularLoader(),
                if (message != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    message!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ],
              ],
            ),
          ).animate().fadeIn(duration: const Duration(milliseconds: 300)),
      ],
    );
  }
}

/// Mini inline loader
class CompactLoader extends StatelessWidget {
  final double size;
  final Color? color;

  const CompactLoader({
    super.key,
    this.size = 24,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loaderColor = color ?? theme.primaryColor;

    return SizedBox.square(
      dimension: size,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(loaderColor),
        strokeWidth: 2,
      ),
    );
  }
}
