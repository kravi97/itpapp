/// Dashboard screen with real-time timer
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itpapp/core/theme/app_theme.dart';
import 'package:itpapp/shared/models/task.dart';
import '../providers/timer_provider.dart';
import '../../task/providers/task_provider.dart';
import '../widgets/timer_card.dart';
import '../widgets/active_task_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerProvider);
    final tasksAsync = ref.watch(tasksProvider);
    final taskStats = ref.watch(taskStatsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard'), elevation: 0),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.refresh(tasksProvider);
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Timer Card
              TimerCard(timerState: timerState),
              const SizedBox(height: 24),

              // Task Stats
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.dividerColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Task Overview', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 16),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      children: [
                        _StatCard(
                          label: 'New',
                          count: taskStats['new'] as int,
                          color: AppTheme.taskStatusNew,
                        ),
                        _StatCard(
                          label: 'In Progress',
                          count: taskStats['inProgress'] as int,
                          color: AppTheme.taskStatusInProgress,
                        ),
                        _StatCard(
                          label: 'Overdue',
                          count: taskStats['overdue'] as int,
                          color: AppTheme.taskStatusOverdue,
                        ),
                        _StatCard(
                          label: 'Completed',
                          count: taskStats['completed'] as int,
                          color: AppTheme.taskStatusCompleted,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Recent Tasks
              Text('Recent Tasks', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              tasksAsync.when(
                data: (tasks) {
                  if (tasks.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text(
                          'No tasks yet',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondaryColor),
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: tasks.take(3).length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _TaskListItem(task: task),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => Text('Error: $e'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _StatCard({required this.label, required this.count, required this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            count.toString(),
            style: Theme.of(
              context,
            ).textTheme.displaySmall?.copyWith(color: color, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondaryColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _TaskListItem extends StatelessWidget {
  final Task task;

  const _TaskListItem({required this.task, super.key});

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(task.status);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: Theme.of(context).textTheme.titleSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        task.projectName ?? 'No Project',
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondaryColor),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    task.status.displayName,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '${task.elapsedHours.toStringAsFixed(1)}h / ${task.estimatedHours.toStringAsFixed(1)}h',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const Spacer(),
                Icon(
                  task.isBillable ? Icons.check_circle : Icons.cancel,
                  size: 16,
                  color: task.isBillable ? AppTheme.successColor : AppTheme.textTertiaryColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.newTask:
        return AppTheme.taskStatusNew;
      case TaskStatus.inProgress:
        return AppTheme.taskStatusInProgress;
      case TaskStatus.overdue:
        return AppTheme.taskStatusOverdue;
      case TaskStatus.completed:
        return AppTheme.taskStatusCompleted;
    }
  }
}
