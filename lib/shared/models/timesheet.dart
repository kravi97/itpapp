import 'base_entity.dart';

enum TimesheetStatus {
  draft,
  submitted,
  approved,
  rejected;

  String get displayName {
    switch (this) {
      case TimesheetStatus.draft:
        return 'Draft';
      case TimesheetStatus.submitted:
        return 'Submitted';
      case TimesheetStatus.approved:
        return 'Approved';
      case TimesheetStatus.rejected:
        return 'Rejected';
    }
  }
}

class TimesheetEntry extends BaseEntity {
  final String taskId;
  final String taskName;
  final DateTime date;
  final double hoursWorked;
  final String? notes;
  final String projectId;
  final String projectName;

  TimesheetEntry({
    required super.id,
    required DateTime super.createdAt,
    required DateTime super.updatedAt,
    required this.taskId,
    required this.taskName,
    required this.date,
    required this.hoursWorked,
    required this.projectId,
    required this.projectName,
    this.notes,
  });

  factory TimesheetEntry.fromJson(Map<String, dynamic> json) {
    return TimesheetEntry(
      id: json['id'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
      taskId: json['taskId'] ?? '',
      taskName: json['taskName'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      hoursWorked: (json['hoursWorked'] as num?)?.toDouble() ?? 0.0,
      projectId: json['projectId'] ?? '',
      projectName: json['projectName'] ?? '',
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': (createdAt ?? DateTime.now()).toIso8601String(),
      'updatedAt': (updatedAt ?? DateTime.now()).toIso8601String(),
      'taskId': taskId,
      'taskName': taskName,
      'date': date.toIso8601String(),
      'hoursWorked': hoursWorked,
      'projectId': projectId,
      'projectName': projectName,
      'notes': notes,
    };
  }
}

class Timesheet extends BaseEntity {
  final String userId;
  final DateTime weekStartDate;
  final TimesheetStatus status;
  final List<TimesheetEntry> entries;
  final double totalHours;

  Timesheet({
    required super.id,
    required DateTime super.createdAt,
    required DateTime super.updatedAt,
    required this.userId,
    required this.weekStartDate,
    required this.status,
    required this.entries,
    required this.totalHours,
  });

  factory Timesheet.fromJson(Map<String, dynamic> json) {
    return Timesheet(
      id: json['id'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
      userId: json['userId'] ?? '',
      weekStartDate: json['weekStartDate'] != null
          ? DateTime.parse(json['weekStartDate'])
          : DateTime.now(),
      status: TimesheetStatus.values.asNameMap()[json['status']] ?? TimesheetStatus.draft,
      entries:
          (json['entries'] as List?)
              ?.map((e) => TimesheetEntry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalHours: (json['totalHours'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': (createdAt ?? DateTime.now()).toIso8601String(),
      'updatedAt': (updatedAt ?? DateTime.now()).toIso8601String(),
      'userId': userId,
      'weekStartDate': weekStartDate.toIso8601String(),
      'status': status.name,
      'entries': entries.map((e) => e.toJson()).toList(),
      'totalHours': totalHours,
    };
  }
}
