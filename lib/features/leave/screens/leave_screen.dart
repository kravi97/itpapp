import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:itpapp/core/theme/app_theme.dart';
import 'package:itpapp/shared/models/leave.dart';
import 'package:itpapp/features/leave/providers/leave_provider.dart';

class LeaveScreen extends ConsumerWidget {
  const LeaveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaveApplicationsAsync = ref.watch(leaveApplicationsProvider);
    final leaveBalanceAsync = ref.watch(leaveBalanceProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Leave'), elevation: 0),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Leave Balance (same loader as Timesheet top section)
            leaveBalanceAsync.when(
              data: (balance) => _LeaveBalanceCard(balance: balance),
              loading: () => _ShimmerLoadingCard(),
              error: (e, st) => Card(
                child: Padding(padding: const EdgeInsets.all(16), child: Text('Error: $e')),
              ),
            ),
            const SizedBox(height: 24),

            // Leave Applications
            Text('My Applications', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            leaveApplicationsAsync.when(
              data: (applications) {
                if (applications.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No leave applications yet'),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: applications.length,
                  itemBuilder: (context, index) {
                    final leave = applications[index];
                    return _LeaveApplicationCard(leave: leave);
                  },
                );
              },
              loading: () => _ShimmerLeaveApplicationList(),
              error: (e, st) => Text('Error: $e'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) => const _ApplyLeaveDialog(),
        ),
        tooltip: 'Apply for Leave',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _LeaveBalanceCard extends StatelessWidget {
  final Map<LeaveType, double> balance;

  const _LeaveBalanceCard({required this.balance});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Leave Balance', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: balance.entries.map((entry) {
                return Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.value.toString(),
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          entry.key.displayName,
                          style: Theme.of(context).textTheme.labelSmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _LeaveApplicationCard extends StatelessWidget {
  final LeaveApplication leave;

  const _LeaveApplicationCard({required this.leave});

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
                  leave.leaveType.displayName,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(leave.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    leave.status.displayName,
                    style: TextStyle(
                      color: _getStatusColor(leave.status),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${DateFormat('MMM dd').format(leave.fromDate)} - ${DateFormat('MMM dd, yyyy').format(leave.toDate)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text('${leave.numberOfDays} day(s)', style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(LeaveStatus status) {
    switch (status) {
      case LeaveStatus.pending:
        return Colors.orange;
      case LeaveStatus.approved:
        return AppTheme.taskStatusCompleted;
      case LeaveStatus.rejected:
        return Colors.red;
      case LeaveStatus.cancelled:
        return Colors.grey;
    }
  }
}

class _ApplyLeaveDialog extends ConsumerStatefulWidget {
  const _ApplyLeaveDialog();

  @override
  ConsumerState<_ApplyLeaveDialog> createState() => _ApplyLeaveDialogState();
}

class _ApplyLeaveDialogState extends ConsumerState<_ApplyLeaveDialog> {
  late TextEditingController _reasonController;
  LeaveType _selectedType = LeaveType.annual;
  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  void initState() {
    super.initState();
    _reasonController = TextEditingController();
    _fromDate = DateTime.now();
    _toDate = DateTime.now().add(const Duration(days: 1));
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final days = _toDate != null && _fromDate != null
        ? _toDate!.difference(_fromDate!).inDays + 1
        : 1;

    return AlertDialog(
      title: const Text('Apply for Leave'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Leave Type
            DropdownButtonFormField<LeaveType>(
              initialValue: _selectedType,
              decoration: InputDecoration(
                labelText: 'Leave Type',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              items: LeaveType.values
                  .map((type) => DropdownMenuItem(value: type, child: Text(type.displayName)))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedType = value);
                }
              },
            ),
            const SizedBox(height: 16),
            // From Date
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('From: ${DateFormat('MMM dd, yyyy').format(_fromDate!)}'),
              trailing: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _fromDate!,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() => _fromDate = date);
                  }
                },
              ),
            ),
            // To Date
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('To: ${DateFormat('MMM dd, yyyy').format(_toDate!)}'),
              trailing: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _toDate!,
                    firstDate: _fromDate ?? DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() => _toDate = date);
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Total: $days day(s)',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            // Reason
            TextField(
              controller: _reasonController,
              decoration: InputDecoration(
                labelText: 'Reason',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                hintText: 'Please specify your reason for leave',
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () async {
            if (_reasonController.text.isEmpty) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Please provide a reason')));
              return;
            }

            final days = _toDate!.difference(_fromDate!).inDays + 1;
            final application = LeaveApplication(
              id: 'leave_${DateTime.now().millisecondsSinceEpoch}',
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              employeeId: 'emp_001',
              employeeName: 'Current User',
              leaveType: _selectedType,
              fromDate: _fromDate!,
              toDate: _toDate!,
              numberOfDays: days,
              reason: _reasonController.text,
              status: LeaveStatus.pending,
            );

            await ref.read(leaveNotifierProvider.notifier).applyForLeave(application);

            if (mounted) {
              ref.invalidate(leaveApplicationsProvider);
              ref.invalidate(leaveBalanceProvider);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Leave application submitted successfully')),
              );
            }
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
}

class _ShimmerLoadingCard extends StatelessWidget {
  const _ShimmerLoadingCard();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 20,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: List.generate(
                  3,
                  (index) => Expanded(
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShimmerLeaveApplicationList extends StatelessWidget {
  const _ShimmerLeaveApplicationList();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 16,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Container(
                        height: 24,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 14,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 14,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
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
