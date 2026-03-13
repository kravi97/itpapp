import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:itpapp/core/theme/app_theme.dart';
import 'package:itpapp/shared/models/timesheet.dart';
import 'package:itpapp/features/timesheet/providers/timesheet_provider.dart';

class TimesheetScreen extends ConsumerWidget {
  const TimesheetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTimesheetAsync = ref.watch(currentTimesheetProvider);
    final timesheetAsync = ref.watch(timesheetsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Timesheet'), elevation: 0),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Current Week Summary
            currentTimesheetAsync.when(
              data: (timesheet) {
                if (timesheet == null) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('No timesheet for this week'),
                    ),
                  );
                }
                return _WeekSummary(timesheet: timesheet);
              },
              loading: () => const Card(
                child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()),
              ),
              error: (e, st) => Card(
                child: Padding(padding: const EdgeInsets.all(16), child: Text('Error: $e')),
              ),
            ),
            const SizedBox(height: 24),

            // Timesheet History
            Text('Recent Timesheets', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            timesheetAsync.when(
              data: (timesheets) {
                if (timesheets.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No timesheets yet'),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: timesheets.length,
                  itemBuilder: (context, index) {
                    final timesheet = timesheets[index];
                    return _TimesheetCard(timesheet: timesheet);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Text('Error: $e'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddEntryDialog(context, ref);
        },
        tooltip: 'Add Time Entry',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddEntryDialog(BuildContext context, WidgetRef ref) {
    showDialog(context: context, builder: (context) => const _AddTimesheetEntryDialog());
  }
}

class _WeekSummary extends ConsumerWidget {
  final Timesheet timesheet;

  const _WeekSummary({required this.timesheet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Week of ${DateFormat('MMM dd').format(timesheet.weekStartDate)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(timesheet.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    timesheet.status.displayName,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StatItem(
                  label: 'Total Hours',
                  value: '${timesheet.totalHours.toStringAsFixed(1)}h',
                ),
                _StatItem(label: 'Entries', value: '${timesheet.entries.length}'),
                _StatItem(label: 'Target', value: '40h'),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: timesheet.totalHours / 40,
                minHeight: 8,
                backgroundColor: AppTheme.surfaceVariant,
                valueColor: AlwaysStoppedAnimation(
                  timesheet.totalHours >= 40
                      ? AppTheme.taskStatusCompleted
                      : AppTheme.taskStatusInProgress,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(TimesheetStatus status) {
    switch (status) {
      case TimesheetStatus.draft:
        return Colors.grey;
      case TimesheetStatus.submitted:
        return Colors.blue;
      case TimesheetStatus.approved:
        return AppTheme.taskStatusCompleted;
      case TimesheetStatus.rejected:
        return Colors.red;
    }
  }
}

class _TimesheetCard extends StatelessWidget {
  final Timesheet timesheet;

  const _TimesheetCard({required this.timesheet});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('MMM dd - ').format(timesheet.weekStartDate) +
                      DateFormat(
                        'MMM dd, yyyy',
                      ).format(timesheet.weekStartDate.add(const Duration(days: 6))),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  '${timesheet.totalHours}h',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${timesheet.entries.length} entries • ${timesheet.status.displayName}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}

class _AddTimesheetEntryDialog extends ConsumerStatefulWidget {
  const _AddTimesheetEntryDialog();

  @override
  ConsumerState<_AddTimesheetEntryDialog> createState() => _AddTimesheetEntryDialogState();
}

class _AddTimesheetEntryDialogState extends ConsumerState<_AddTimesheetEntryDialog> {
  late TextEditingController _hoursController;
  late TextEditingController _notesController;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _hoursController = TextEditingController();
    _notesController = TextEditingController();
    _selectedDate = DateTime.now();
  }

  @override
  void dispose() {
    _hoursController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add Time Entry', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 24),
              // Date Picker
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Date: ${DateFormat('MMM dd, yyyy').format(_selectedDate!)}'),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate!,
                      firstDate: DateTime.now().subtract(const Duration(days: 90)),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      setState(() => _selectedDate = date);
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),
              // Hours input
              TextField(
                controller: _hoursController,
                decoration: InputDecoration(
                  labelText: 'Hours Worked',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  suffixText: 'hours',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 16),
              // Notes input
              TextField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: 'Notes (Optional)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  hintText: 'What did you work on?',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: () {
                      // TODO: Implement save logic
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Time entry added successfully')),
                      );
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
