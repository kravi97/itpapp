/// Timer card widget
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itpapp/core/theme/app_theme.dart';
import '../providers/timer_provider.dart';

class TimerCard extends ConsumerWidget {
  final TimerState? timerState;

  const TimerCard({required this.timerState, super.key});

  String _formatSeconds(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (timerState == null || timerState!.activeTaskId.isEmpty) {
      return Card(
        color: AppTheme.backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Icon(Icons.timer_off, size: 48, color: AppTheme.textTertiaryColor),
              const SizedBox(height: 16),
              Text(
                'No Active Task',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: AppTheme.textSecondaryColor),
              ),
              const SizedBox(height: 8),
              Text(
                'Start a task to begin tracking time',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppTheme.textTertiaryColor),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      color: AppTheme.primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'Active Task Timer',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            StreamBuilder<int>(
              stream: Stream.periodic(
                const Duration(seconds: 1),
                (_) => timerState!.currentElapsedSeconds,
              ),
              builder: (context, snapshot) {
                final elapsed = timerState!.currentElapsedSeconds;
                return Text(
                  _formatSeconds(elapsed),
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            if (timerState!.isRunning)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      ref.read(timerProvider.notifier).pauseTask();
                    },
                    icon: const Icon(Icons.pause),
                    label: const Text('Pause'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white24,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      ref.read(timerProvider.notifier).completeTask();
                    },
                    icon: const Icon(Icons.check),
                    label: const Text('Complete'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.successColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              )
            else
              ElevatedButton.icon(
                onPressed: () {
                  ref.read(timerProvider.notifier).resumeTask();
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('Resume'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white24,
                  foregroundColor: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
