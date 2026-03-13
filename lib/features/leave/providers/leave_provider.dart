/// Leave providers
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itpapp/shared/models/leave.dart';
import 'package:itpapp/core/network/mock/mock_api_service.dart';

/// Get all leave applications
final leaveApplicationsProvider = FutureProvider<List<LeaveApplication>>((ref) async {
  final response = await MockApiService.getLeaveApplications();

  if (response['success'] == true) {
    final leaveList = response['data']['leaveApplications'] as List?;
    return leaveList
            ?.map((leave) => LeaveApplication.fromJson(leave as Map<String, dynamic>))
            .toList() ??
        [];
  }

  return [];
});

/// Get pending leave applications
final pendingLeaveProvider = FutureProvider<List<LeaveApplication>>((ref) async {
  final allLeaves = await ref.watch(leaveApplicationsProvider.future);
  return allLeaves.where((leave) => leave.status == LeaveStatus.pending).toList();
});

/// Get leave balance
final leaveBalanceProvider = FutureProvider<Map<LeaveType, double>>((ref) async {
  final response = await MockApiService.getLeaveBalance();

  if (response['success'] == true) {
    final balance = response['data']['balance'] as Map<String, dynamic>;
    return {
      for (final key in balance.keys)
        LeaveType.values.asNameMap()[key] ?? LeaveType.annual: (balance[key] as num).toDouble(),
    };
  }

  return {};
});

/// Create and manage leave applications
class LeaveNotifier extends StateNotifier<AsyncValue<void>> {
  LeaveNotifier() : super(const AsyncValue.data(null));

  Future<void> applyForLeave(LeaveApplication application) async {
    state = const AsyncValue.loading();
    try {
      final response = await MockApiService.applyForLeave(application);
      if (response['success'] == true) {
        state = const AsyncValue.data(null);
      } else {
        state = AsyncValue.error(Exception('Failed to apply for leave'), StackTrace.current);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> cancelLeave(String leaveId) async {
    state = const AsyncValue.loading();
    try {
      final response = await MockApiService.cancelLeave(leaveId);
      if (response['success'] == true) {
        state = const AsyncValue.data(null);
      } else {
        state = AsyncValue.error(Exception('Failed to cancel leave'), StackTrace.current);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final leaveNotifierProvider = StateNotifierProvider<LeaveNotifier, AsyncValue<void>>((ref) {
  return LeaveNotifier();
});
