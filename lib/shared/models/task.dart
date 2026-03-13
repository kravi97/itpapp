/// Task model
library;

import 'base_entity.dart';

/// Task status enum
enum TaskStatus {
  newTask,
  inProgress,
  overdue,
  completed;

  String get displayName {
    switch (this) {
      case TaskStatus.newTask:
        return 'New';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.overdue:
        return 'Overdue';
      case TaskStatus.completed:
        return 'Completed';
    }
  }

  static TaskStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'new':
        return TaskStatus.newTask;
      case 'in progress':
        return TaskStatus.inProgress;
      case 'overdue':
        return TaskStatus.overdue;
      case 'completed':
        return TaskStatus.completed;
      default:
        return TaskStatus.newTask;
    }
  }
}

/// Priority enum
enum Priority {
  low,
  medium,
  high;

  String get displayName => name[0].toUpperCase() + name.substring(1);

  static Priority fromString(String priority) {
    switch (priority.toLowerCase()) {
      case 'low':
        return Priority.low;
      case 'medium':
        return Priority.medium;
      case 'high':
        return Priority.high;
      default:
        return Priority.medium;
    }
  }
}

class Task extends BaseEntity {
  final String title;
  final String? description;
  final String projectId;
  final String? projectName;
  final TaskStatus status;
  final Priority priority;
  final String category;
  final double estimatedHours;
  final int elapsedSeconds;
  final bool isBillable;
  final DateTime? completedAt;
  final DateTime? startTime;

  Task({
    required super.id,
    required this.title,
    this.description,
    required this.projectId,
    this.projectName,
    required this.status,
    required this.priority,
    required this.category,
    required this.estimatedHours,
    this.elapsedSeconds = 0,
    this.isBillable = true,
    this.completedAt,
    this.startTime,
    super.createdAt,
    super.updatedAt,
  });

  double get elapsedHours => elapsedSeconds / 3600.0;

  bool get isOverdue => status == TaskStatus.overdue;

  bool get isActive => status == TaskStatus.inProgress;

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['taskId'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      projectId: json['projectId'] ?? '',
      projectName: json['projectName'],
      status: TaskStatus.fromString(json['status'] ?? 'New'),
      priority: Priority.fromString(json['priority'] ?? 'Medium'),
      category: json['category'] ?? '',
      estimatedHours: (json['estimatedHours'] ?? 0).toDouble(),
      elapsedSeconds: json['elapsedSeconds'] ?? 0,
      isBillable: json['isBillable'] ?? true,
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      startTime: json['startTime'] != null ? DateTime.parse(json['startTime']) : null,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'taskId': id,
      'title': title,
      'description': description,
      'projectId': projectId,
      'projectName': projectName,
      'status': status.displayName,
      'priority': priority.displayName,
      'category': category,
      'estimatedHours': estimatedHours,
      'elapsedSeconds': elapsedSeconds,
      'isBillable': isBillable,
      'completedAt': completedAt?.toIso8601String(),
      'startTime': startTime?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  Task copyWith({
    String? title,
    String? description,
    String? projectId,
    String? projectName,
    TaskStatus? status,
    Priority? priority,
    String? category,
    double? estimatedHours,
    int? elapsedSeconds,
    bool? isBillable,
    DateTime? completedAt,
    DateTime? startTime,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      projectId: projectId ?? this.projectId,
      projectName: projectName ?? this.projectName,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      estimatedHours: estimatedHours ?? this.estimatedHours,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      isBillable: isBillable ?? this.isBillable,
      completedAt: completedAt ?? this.completedAt,
      startTime: startTime ?? this.startTime,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
