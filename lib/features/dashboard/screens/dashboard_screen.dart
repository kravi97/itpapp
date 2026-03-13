/// Dashboard screen with real-time timer and enhanced UI
library;

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itpapp/core/theme/app_theme.dart';
import 'package:itpapp/shared/models/task.dart';
import 'package:itpapp/shared/widgets/shimmer_skeleton.dart';
import 'package:itpapp/shared/widgets/animated_widgets.dart';
import '../providers/timer_provider.dart';
import '../../task/providers/task_provider.dart';
import '../widgets/timer_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerProvider);
    final tasksAsync = ref.watch(tasksProvider);
    final taskStats = ref.watch(taskStatsProvider);
    final hour = DateTime.now().hour;

    // Motivational greeting based on time of day
    final greeting = _getGreeting(hour);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Enhanced App Bar with gradient
          SliverAppBar(
            expandedHeight: 220,
            floating: false,
            pinned: true,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppTheme.primaryColor, AppTheme.primaryColor.withAlpha(200)],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FadeInLeft(
                              duration: const Duration(milliseconds: 500),
                              child: Text(
                                greeting,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Colors.white.withAlpha(200),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            FadeInLeft(
                              duration: const Duration(milliseconds: 600),
                              delay: const Duration(milliseconds: 100),
                              child: Text(
                                _getMotivationalMessage(hour),
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Main content
          SliverToBoxAdapter(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(tasksProvider);
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Timer Card with fade animation
                      FadeInSlide(child: TimerCard(timerState: timerState)),
                      const SizedBox(height: 24),

                      // Quick Actions Section
                      FadeInSlide(
                        duration: const Duration(milliseconds: 600),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Quick Actions',
                              style: Theme.of(
                                context,
                              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                _buildQuickActionChip(
                                  context,
                                  icon: Icons.add_circle_outline,
                                  label: 'New Task',
                                  onTap: () {},
                                ),
                                _buildQuickActionChip(
                                  context,
                                  icon: Icons.play_arrow,
                                  label: 'Start Timer',
                                  onTap: () {},
                                ),
                                _buildQuickActionChip(
                                  context,
                                  icon: Icons.checklist,
                                  label: 'View All',
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Task Stats Section with animation
                      FadeInSlide(
                        duration: const Duration(milliseconds: 600),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppTheme.dividerColor),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(30),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Task Overview',
                                style: Theme.of(
                                  context,
                                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 18),
                              GridView.count(
                                crossAxisCount: 2,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                mainAxisSpacing: 14,
                                crossAxisSpacing: 14,
                                childAspectRatio: 1.1,
                                children: [
                                  _StatCard(
                                    label: 'New',
                                    count: taskStats['new'] as int,
                                    color: AppTheme.taskStatusNew,
                                    delayMs: 0,
                                  ),
                                  _StatCard(
                                    label: 'In Progress',
                                    count: taskStats['inProgress'] as int,
                                    color: AppTheme.taskStatusInProgress,
                                    delayMs: 100,
                                  ),
                                  _StatCard(
                                    label: 'Overdue',
                                    count: taskStats['overdue'] as int,
                                    color: AppTheme.taskStatusOverdue,
                                    delayMs: 200,
                                  ),
                                  _StatCard(
                                    label: 'Completed',
                                    count: taskStats['completed'] as int,
                                    color: AppTheme.taskStatusCompleted,
                                    delayMs: 300,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Recent Tasks Header
                      FadeInSlide(
                        duration: const Duration(milliseconds: 700),
                        child: Text(
                          'Recent Tasks',
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 14),
                      tasksAsync.when(
                        data: (tasks) {
                          if (tasks.isEmpty) {
                            return FadeIn(
                              duration: const Duration(milliseconds: 500),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: AppTheme.dividerColor),
                                  color: AppTheme.surfaceColor,
                                ),
                                child: Column(
                                  children: [
                                    Icon(Icons.inbox, size: 56, color: AppTheme.textTertiaryColor),
                                    const SizedBox(height: 14),
                                    Text(
                                      'No tasks yet',
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        color: AppTheme.textSecondaryColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Create a task to get started',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppTheme.textTertiaryColor,
                                      ),
                                    ),
                                  ],
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
                              return FadeInUp(
                                delay: Duration(milliseconds: 100 * index),
                                duration: const Duration(milliseconds: 500),
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 14),
                                  child: _TaskListItem(task: task),
                                ),
                              );
                            },
                          );
                        },
                        loading: () => const ListSkeleton(itemCount: 3),
                        error: (e, st) => FadeIn(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppTheme.errorColor.withOpacity(0.1),
                                border: Border.all(color: AppTheme.errorColor.withOpacity(0.5)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.error, color: AppTheme.errorColor),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Error loading tasks: $e',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall?.copyWith(color: AppTheme.errorColor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting(int hour) {
    if (hour < 12) {
      return 'Good Morning! ☀️';
    } else if (hour < 17) {
      return 'Good Afternoon! 🌤️';
    } else {
      return 'Good Evening! 🌙';
    }
  }

  String _getMotivationalMessage(int hour) {
    final messages = [
      'Keep up the great work!',
      'You\'re doing awesome!',
      'Stay focused and productive!',
      'Great progress today!',
      'Let\'s make it count!',
      'Almost there!',
      'Time to wrap up!',
    ];
    return messages[hour % messages.length];
  }

  Widget _buildQuickActionChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return FadeInSlide(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.dividerColor, width: 1.5),
              borderRadius: BorderRadius.circular(20),
              color: AppTheme.surfaceColor,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18, color: AppTheme.primaryColor),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
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
  final int delayMs;

  const _StatCard({
    required this.label,
    required this.count,
    required this.color,
    this.delayMs = 0,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleUpEntrance(
      duration: const Duration(milliseconds: 600),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          border: Border.all(color: color.withOpacity(0.5), width: 2),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: color.withAlpha(50), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TweenAnimationBuilder<int>(
                    tween: IntTween(begin: 0, end: count),
                    duration: const Duration(milliseconds: 1500),
                    builder: (context, value, child) {
                      return Text(
                        value.toString(),
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TaskListItem extends StatefulWidget {
  final Task task;

  const _TaskListItem({required this.task});

  @override
  State<_TaskListItem> createState() => _TaskListItemState();
}

class _TaskListItemState extends State<_TaskListItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(widget.task.status);
    final progressValue = widget.task.estimatedHours > 0
        ? (widget.task.elapsedHours / widget.task.estimatedHours).clamp(0.0, 1.0)
        : 0.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: statusColor.withAlpha(100),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withAlpha(30),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
        ),
        child: Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with title and status
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.task.title,
                            style: Theme.of(
                              context,
                            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.task.projectName ?? 'No Project',
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondaryColor),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: statusColor.withOpacity(0.5)),
                      ),
                      child: Text(
                        widget.task.status.displayName,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Progress bar with animation
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.task.elapsedHours.toStringAsFixed(1)}h / ${widget.task.estimatedHours.toStringAsFixed(1)}h',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Icon(
                          widget.task.isBillable ? Icons.check_circle : Icons.cancel,
                          size: 16,
                          color: widget.task.isBillable
                              ? AppTheme.successColor
                              : AppTheme.textTertiaryColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    AnimatedProgressBar(value: progressValue, color: statusColor, height: 6),
                  ],
                ),
              ],
            ),
          ),
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
