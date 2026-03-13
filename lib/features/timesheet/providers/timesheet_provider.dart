/// Timesheet providers
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itpapp/shared/models/timesheet.dart';
import 'package:itpapp/core/network/mock/mock_api_service.dart';

/// Get all timesheets
final timesheetsProvider = FutureProvider<List<Timesheet>>((ref) async {
  final response = await MockApiService.getTimesheets();

  if (response['success'] == true) {
    final timesheetsList = response['data']['timesheets'] as List?;
    return timesheetsList?.map((ts) => Timesheet.fromJson(ts as Map<String, dynamic>)).toList() ??
        [];
  }

  return [];
});

/// Get current week timesheet
final currentTimesheetProvider = FutureProvider<Timesheet?>((ref) async {
  final response = await MockApiService.getCurrentTimesheet();

  if (response['success'] == true && response['data'] != null) {
    return Timesheet.fromJson(response['data']['timesheet'] as Map<String, dynamic>);
  }

  return null;
});

/// Get timesheet entries for a specific date
final timesheetEntriesProvider = FutureProvider.family<List<TimesheetEntry>, DateTime>((
  ref,
  date,
) async {
  final response = await MockApiService.getTimesheetEntries(date);

  if (response['success'] == true) {
    final entries = response['data']['entries'] as List?;
    return entries?.map((e) => TimesheetEntry.fromJson(e as Map<String, dynamic>)).toList() ?? [];
  }

  return [];
});

/// Get timesheet summary for a week
final timesheetSummaryProvider = FutureProvider.family<Map<String, dynamic>, DateTime>((
  ref,
  weekStart,
) async {
  final response = await MockApiService.getTimesheetSummary(weekStart);

  if (response['success'] == true) {
    return response['data'] as Map<String, dynamic>;
  }

  return {'totalHours': 0.0, 'byProject': {}, 'byStatus': {}};
});

/// Add timesheet entry
class TimesheetNotifier extends StateNotifier<AsyncValue<void>> {
  TimesheetNotifier() : super(const AsyncValue.data(null));

  Future<void> addEntry(TimesheetEntry entry) async {
    state = const AsyncValue.loading();
    try {
      final response = await MockApiService.addTimesheetEntry(entry);
      if (response['success'] == true) {
        state = const AsyncValue.data(null);
      } else {
        state = AsyncValue.error(Exception('Failed to add timesheet entry'), StackTrace.current);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> submitTimesheet(String timesheetId) async {
    state = const AsyncValue.loading();
    try {
      final response = await MockApiService.submitTimesheet(timesheetId);
      if (response['success'] == true) {
        state = const AsyncValue.data(null);
      } else {
        state = AsyncValue.error(Exception('Failed to submit timesheet'), StackTrace.current);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final timesheetNotifierProvider = StateNotifierProvider<TimesheetNotifier, AsyncValue<void>>((ref) {
  return TimesheetNotifier();
});
