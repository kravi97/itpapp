/// Tasks screen
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itpapp/shared/models/task.dart';
import '../providers/task_provider.dart';
import '../../projects/providers/project_provider.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      body: tasksAsync.when(
        data: (tasks) {
          if (tasks.isEmpty) {
            return const Center(child: Text('No tasks yet. Create one to get started!'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return _TaskCard(
                key: ValueKey(task.id),
                task: task,
                onStart: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Started: ${task.title}')));
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text('Error loading tasks: $error'),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(context: context, builder: (context) => const _CreateTaskDialog());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onStart;

  const _TaskCard({required this.task, required this.onStart, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progressValue = task.estimatedHours > 0
        ? (task.elapsedHours / task.estimatedHours).clamp(0.0, 1.0)
        : 0.0;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title and Status
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(task.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    task.status.displayName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Project Name
            Text(
              task.projectName ?? 'No Project',
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 12),
            // Progress Bar (only if estimated hours > 0)
            if (task.estimatedHours > 0) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progressValue,
                  minHeight: 8,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
                ),
              ),
              const SizedBox(height: 12),
            ],
            // Hours and Action Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${task.elapsedHours.toStringAsFixed(1)}h / ${task.estimatedHours.toStringAsFixed(1)}h',
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: task.isActive ? null : onStart,
                  icon: Icon(task.isActive ? Icons.play_circle : Icons.play_arrow, size: 18),
                  label: Text(task.isActive ? 'Active' : 'Start'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    textStyle: const TextStyle(fontSize: 13),
                  ),
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
        return Colors.blue;
      case TaskStatus.inProgress:
        return Colors.orange;
      case TaskStatus.overdue:
        return Colors.red;
      case TaskStatus.completed:
        return Colors.green;
    }
  }
}

class _CreateTaskDialog extends ConsumerStatefulWidget {
  const _CreateTaskDialog();

  @override
  ConsumerState<_CreateTaskDialog> createState() => _CreateTaskDialogState();
}

class _CreateTaskDialogState extends ConsumerState<_CreateTaskDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _estimatedHoursController;
  late TextEditingController _categoryController;
  Priority _selectedPriority = Priority.medium;
  String? _selectedProjectId;
  String? _selectedProjectName;
  bool _isBillable = true;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _estimatedHoursController = TextEditingController();
    _categoryController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _estimatedHoursController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _createTask() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter task title')));
      return;
    }
    if (_selectedProjectId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a project')));
      return;
    }
    if (_estimatedHoursController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter estimated hours')));
      return;
    }

    final newTask = Task(
      id: 'task_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text,
      description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
      projectId: _selectedProjectId!,
      projectName: _selectedProjectName ?? 'Unknown Project',
      status: TaskStatus.newTask,
      priority: _selectedPriority,
      category: _categoryController.text.isEmpty ? 'General' : _categoryController.text,
      estimatedHours: double.tryParse(_estimatedHoursController.text) ?? 0.0,
      isBillable: _isBillable,
    );

    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    ref
        .read(taskNotifierProvider.notifier)
        .createTask(newTask)
        .then((_) {
          if (mounted) {
            navigator.pop();
            messenger.showSnackBar(const SnackBar(content: Text('Task created successfully')));
          }
        })
        .catchError((e) {
          if (mounted) {
            messenger.showSnackBar(SnackBar(content: Text('Error creating task: $e')));
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    final projectsAsync = ref.watch(projectsProvider);

    return AlertDialog(
      title: const Text('Create Task'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Task Title',
                hintText: 'Enter task title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter task description (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            projectsAsync.when(
              data: (projects) => DropdownButtonFormField<String>(
                initialValue: _selectedProjectId,
                decoration: const InputDecoration(
                  labelText: 'Project',
                  border: OutlineInputBorder(),
                ),
                items: projects
                    .map(
                      (project) => DropdownMenuItem(value: project.id, child: Text(project.name)),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedProjectId = value;
                    // Also store the project name
                    if (value != null) {
                      final selectedProject = projects.firstWhere((p) => p.id == value);
                      _selectedProjectName = selectedProject.name;
                    }
                  });
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => DropdownButtonFormField<String>(
                initialValue: null,
                decoration: const InputDecoration(
                  labelText: 'Project',
                  border: OutlineInputBorder(),
                ),
                items: const [],
                onChanged: (_) {},
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _estimatedHoursController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Estimated Hours',
                hintText: 'Enter estimated hours',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(
                labelText: 'Category',
                hintText: 'e.g., Development, Design',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Priority>(
              initialValue: _selectedPriority,
              decoration: const InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(),
              ),
              items: Priority.values
                  .map(
                    (priority) =>
                        DropdownMenuItem(value: priority, child: Text(priority.displayName)),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _selectedPriority = value ?? Priority.medium),
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              value: _isBillable,
              onChanged: (value) => setState(() => _isBillable = value ?? true),
              title: const Text('Billable'),
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        ElevatedButton(onPressed: _createTask, child: const Text('Create')),
      ],
    );
  }
}
