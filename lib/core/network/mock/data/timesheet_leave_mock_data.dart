/// Mock timesheet data for development and testing
class TimesheetMockData {
  /// Mock timesheet entries
  static List<Map<String, dynamic>> mockTimesheetEntries = [
    {
      'entryId': 'TS-001',
      'date': '2026-03-13',
      'hours': 8.5,
      'projectId': 'PROJ-001',
      'projectName': 'Mobile App Redesign',
      'taskId': 'TASK-001',
      'taskName': 'Design system UI components',
      'notes': 'Completed dashboard design mockups',
      'status': 'Submitted',
      'submittedAt': '2026-03-13T17:30:00Z',
    },
    {
      'entryId': 'TS-002',
      'date': '2026-03-12',
      'hours': 7.75,
      'projectId': 'PROJ-001',
      'projectName': 'Mobile App Redesign',
      'taskId': 'TASK-004',
      'taskName': 'Code review for PR #456',
      'notes': 'Code review and feedback',
      'status': 'Submitted',
      'submittedAt': '2026-03-12T17:45:00Z',
    },
    {
      'entryId': 'TS-003',
      'date': '2026-03-11',
      'hours': 0.0,
      'projectId': null,
      'projectName': null,
      'taskId': null,
      'taskName': null,
      'notes': '',
      'status': 'Draft',
    },
  ];

  /// Mock timesheet summary
  static const Map<String, dynamic> mockTimesheetSummary = {
    'totalLoggedHours': 16.25,
    'totalSubmittedHours': 16.25,
    'totalPendingHours': 0.0,
    'weeklyTotal': 16.25,
    'monthlyTotal': 145.5,
    'approvalStatus': 'Approved',
  };

  /// Mock response for get timesheet
  static Map<String, dynamic> mockGetTimesheetResponse() {
    return {
      'success': true,
      'data': {
        'entries': mockTimesheetEntries,
        'summary': mockTimesheetSummary,
        'month': '2026-03',
      },
    };
  }

  /// Mock response for submit timesheet
  static Map<String, dynamic> mockSubmitTimesheetResponse() {
    return {
      'success': true,
      'message': 'Timesheet submitted successfully',
      'data': {
        'submittedAt': DateTime.now().toIso8601String(),
        'totalHours': 8.5,
        'status': 'Submitted',
      },
    };
  }
}

/// Mock leave data for development and testing
class LeaveMockData {
  /// Mock leave types with balances
  static const List<Map<String, dynamic>> mockLeaveTypes = [
    {
      'leaveTypeId': 'LT-001',
      'type': 'Vacation',
      'description': 'Annual paid vacation days',
      'balance': 15,
      'booked': 5,
      'available': 10,
      'annual': 20,
      'carryOver': 2,
      'expiryDate': '2026-12-31T23:59:59Z',
    },
    {
      'leaveTypeId': 'LT-002',
      'type': 'Casual',
      'description': 'Casual leave for urgent matters',
      'balance': 8,
      'booked': 2,
      'available': 6,
      'annual': 10,
      'carryOver': 0,
      'expiryDate': '2026-12-31T23:59:59Z',
    },
    {
      'leaveTypeId': 'LT-003',
      'type': 'Sick',
      'description': 'Sick leave for health issues',
      'balance': 5,
      'booked': 1,
      'available': 4,
      'annual': 5,
      'carryOver': 0,
      'expiryDate': '2026-12-31T23:59:59Z',
    },
    {
      'leaveTypeId': 'LT-004',
      'type': 'Parental',
      'description': 'Parental leave',
      'balance': 30,
      'booked': 0,
      'available': 30,
      'annual': 30,
      'carryOver': 0,
      'expiryDate': '2027-12-31T23:59:59Z',
    },
  ];

  /// Mock leave applications
  static List<Map<String, dynamic>> mockLeaveApplications = [
    {
      'leaveId': 'LEV-001',
      'type': 'Vacation',
      'startDate': '2026-03-20',
      'endDate': '2026-03-24',
      'days': 5,
      'status': 'Approved',
      'reason': 'Family vacation',
      'appliedOn': '2026-02-28T10:00:00Z',
      'approvedOn': '2026-02-28T15:30:00Z',
      'approverName': 'Manager Name',
    },
    {
      'leaveId': 'LEV-002',
      'type': 'Casual',
      'startDate': '2026-03-15',
      'endDate': '2026-03-15',
      'days': 1,
      'status': 'Approved',
      'reason': 'Personal work',
      'appliedOn': '2026-03-13T09:00:00Z',
      'approvedOn': '2026-03-13T10:30:00Z',
      'approverName': 'Manager Name',
    },
    {
      'leaveId': 'LEV-003',
      'type': 'Vacation',
      'startDate': '2026-04-01',
      'endDate': '2026-04-05',
      'days': 5,
      'status': 'Pending',
      'reason': 'Summer holidays',
      'appliedOn': '2026-03-10T14:00:00Z',
      'approvedOn': null,
      'approverName': null,
    },
  ];

  /// Mock response for apply leave
  static Map<String, dynamic> mockApplyLeaveResponse() {
    return {
      'success': true,
      'message': 'Leave application submitted successfully',
      'data': {
        'leaveId': 'LEV-${DateTime.now().millisecondsSinceEpoch}',
        'status': 'Pending',
        'appliedOn': DateTime.now().toIso8601String(),
      },
    };
  }

  /// Mock response for get leave balance
  static Map<String, dynamic> mockGetLeaveBalanceResponse() {
    return {
      'success': true,
      'data': {
        'balance': {
          'annual': 18.0,
          'sick': 10.0,
          'casual': 8.0,
          'maternity': 0.0,
          'paternity': 0.0,
          'unpaid': 5.0,
        },
      },
    };
  }
}
