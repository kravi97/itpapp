/// Timer state class
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itpapp/core/storage/local_storage_service.dart';
import 'package:itpapp/core/storage/storage_keys.dart';
import 'package:itpapp/core/network/mock/mock_api_service.dart';
import 'package:itpapp/features/auth/providers/auth_provider.dart';

class TimerState {
  final bool isRunning;
  final int elapsedSeconds;
  final String activeTaskId;
  final DateTime startTime;
  final DateTime? pauseTime;

  TimerState({
    required this.isRunning,
    required this.elapsedSeconds,
    required this.activeTaskId,
    required this.startTime,
    this.pauseTime,
  });

  int get currentElapsedSeconds {
    if (!isRunning) return elapsedSeconds;

    final now = DateTime.now();
    final diff = now.difference(startTime).inSeconds;
    return elapsedSeconds + diff;
  }

  TimerState copyWith({
    bool? isRunning,
    int? elapsedSeconds,
    String? activeTaskId,
    DateTime? startTime,
    DateTime? pauseTime,
  }) {
    return TimerState(
      isRunning: isRunning ?? this.isRunning,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      activeTaskId: activeTaskId ?? this.activeTaskId,
      startTime: startTime ?? this.startTime,
      pauseTime: pauseTime ?? this.pauseTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isRunning': isRunning,
      'elapsedSeconds': elapsedSeconds,
      'activeTaskId': activeTaskId,
      'startTime': startTime.toIso8601String(),
      'pauseTime': pauseTime?.toIso8601String(),
    };
  }

  factory TimerState.fromJson(Map<String, dynamic> json) {
    return TimerState(
      isRunning: json['isRunning'] ?? false,
      elapsedSeconds: json['elapsedSeconds'] ?? 0,
      activeTaskId: json['activeTaskId'] ?? '',
      startTime: DateTime.parse(json['startTime'] ?? DateTime.now().toIso8601String()),
      pauseTime: json['pauseTime'] != null ? DateTime.parse(json['pauseTime']) : null,
    );
  }
}

/// Timer notifier for managing timer state
class TimerNotifier extends StateNotifier<TimerState?> {
  final Ref ref;
  late LocalStorageService _storage;

  TimerNotifier(this.ref) : super(null) {
    _init();
  }

  Future<void> _init() async {
    _storage = ref.read(localStorageProvider);
    await _storage.init();
    _loadSavedTimer();
  }

  void _loadSavedTimer() {
    try {
      final timerJson = _storage.getString(StorageKeys.timerState);
      if (timerJson != null && timerJson.isNotEmpty) {
        // For simplicity, we're not persisting complex state in this demo
        // In production, you'd want to serialize/deserialize properly
      }
    } catch (e) {
      // Error loading saved timer
    }
  }

  /// Start a new timer for a task
  Future<void> startTask(String taskId) async {
    final now = DateTime.now();
    state = TimerState(
      isRunning: true,
      elapsedSeconds: 0,
      activeTaskId: taskId,
      startTime: now,
      pauseTime: null,
    );

    // Call API to start task
    await MockApiService.startTask(taskId);

    // Save state
    await _saveTimerState();
  }

  /// Pause the current timer
  Future<void> pauseTask() async {
    if (state == null) return;

    final updatedState = state!.copyWith(
      isRunning: false,
      elapsedSeconds: state!.currentElapsedSeconds,
      pauseTime: DateTime.now(),
    );
    state = updatedState;

    // Call API to pause task
    await MockApiService.pauseTask(
      taskId: state!.activeTaskId,
      elapsedSeconds: state!.currentElapsedSeconds,
    );

    await _saveTimerState();
  }

  /// Resume the paused timer
  void resumeTask() {
    if (state == null || state!.isRunning) return;

    final now = DateTime.now();
    state = state!.copyWith(isRunning: true, startTime: now, pauseTime: null);

    _saveTimerState();
  }

  /// Complete the current timer
  Future<void> completeTask() async {
    if (state == null) return;

    final totalTime = state!.currentElapsedSeconds;
    final taskId = state!.activeTaskId;

    // Call API to complete task
    await MockApiService.completeTask(taskId: taskId, totalElapsedSeconds: totalTime);

    state = null;
    await _storage.remove(StorageKeys.timerState);
  }

  /// Save timer state to storage
  Future<void> _saveTimerState() async {
    if (state == null) return;

    try {
      final json = state!.toJson();
      // In production, properly serialize to JSON string
      await _storage.saveString(StorageKeys.timerState, json.toString());
    } catch (e) {
      // Error saving timer state
    }
  }
}

/// Timer provider
final timerProvider = StateNotifierProvider<TimerNotifier, TimerState?>((ref) {
  return TimerNotifier(ref);
});

/// Current elapsed time provider (updates every second)
final timerCounterProvider = StreamProvider<int>((ref) async* {
  final timer = ref.watch(timerProvider);

  if (timer == null || !timer.isRunning) {
    yield 0;
    return;
  }

  // Emit initial value
  yield timer.currentElapsedSeconds;

  // Emit updated values every second
  await for (final _ in Stream.periodic(const Duration(seconds: 1))) {
    yield timer.currentElapsedSeconds;
  }
});
