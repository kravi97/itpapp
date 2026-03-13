import 'base_entity.dart';

enum LeaveType {
  annual,
  sick,
  casual,
  maternity,
  paternity,
  unpaid;

  String get displayName {
    switch (this) {
      case LeaveType.annual:
        return 'Annual Leave';
      case LeaveType.sick:
        return 'Sick Leave';
      case LeaveType.casual:
        return 'Casual Leave';
      case LeaveType.maternity:
        return 'Maternity Leave';
      case LeaveType.paternity:
        return 'Paternity Leave';
      case LeaveType.unpaid:
        return 'Unpaid Leave';
    }
  }
}

enum LeaveStatus {
  pending,
  approved,
  rejected,
  cancelled;

  String get displayName {
    switch (this) {
      case LeaveStatus.pending:
        return 'Pending';
      case LeaveStatus.approved:
        return 'Approved';
      case LeaveStatus.rejected:
        return 'Rejected';
      case LeaveStatus.cancelled:
        return 'Cancelled';
    }
  }
}

class LeaveApplication extends BaseEntity {
  final String employeeId;
  final String employeeName;
  final LeaveType leaveType;
  final DateTime fromDate;
  final DateTime toDate;
  final int numberOfDays;
  final String reason;
  final LeaveStatus status;
  final String? approverName;
  final String? rejectionReason;

  LeaveApplication({
    required super.id,
    required DateTime super.createdAt,
    required DateTime super.updatedAt,
    required this.employeeId,
    required this.employeeName,
    required this.leaveType,
    required this.fromDate,
    required this.toDate,
    required this.numberOfDays,
    required this.reason,
    required this.status,
    this.approverName,
    this.rejectionReason,
  });

  factory LeaveApplication.fromJson(Map<String, dynamic> json) {
    return LeaveApplication(
      id: json['id'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
      employeeId: json['employeeId'] ?? '',
      employeeName: json['employeeName'] ?? '',
      leaveType: LeaveType.values.asNameMap()[json['leaveType']] ?? LeaveType.annual,
      fromDate: json['fromDate'] != null ? DateTime.parse(json['fromDate']) : DateTime.now(),
      toDate: json['toDate'] != null ? DateTime.parse(json['toDate']) : DateTime.now(),
      numberOfDays: json['numberOfDays'] ?? 1,
      reason: json['reason'] ?? '',
      status: LeaveStatus.values.asNameMap()[json['status']] ?? LeaveStatus.pending,
      approverName: json['approverName'],
      rejectionReason: json['rejectionReason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': (createdAt ?? DateTime.now()).toIso8601String(),
      'updatedAt': (updatedAt ?? DateTime.now()).toIso8601String(),
      'employeeId': employeeId,
      'employeeName': employeeName,
      'leaveType': leaveType.name,
      'fromDate': fromDate.toIso8601String(),
      'toDate': toDate.toIso8601String(),
      'numberOfDays': numberOfDays,
      'reason': reason,
      'status': status.name,
      'approverName': approverName,
      'rejectionReason': rejectionReason,
    };
  }
}
