/// Mock project data for development and testing
class ProjectMockData {
  /// Mock projects list assigned to the employee
  static List<Map<String, dynamic>> mockProjects = [
    {
      'id': 'PROJ-001',
      'name': 'Mobile App Redesign',
      'description': 'Complete redesign of the mobile application UI/UX',
      'clientName': 'Acme Corp',
      'projectManager': 'John Doe',
      'startDate': '2026-02-01T00:00:00Z',
      'endDate': '2026-04-30T23:59:59Z',
      'status': 'active',
      'progressPercentage': 35,
      'teamMembers': ['John Doe', 'Jane Smith', 'Bob Johnson', 'Alice Brown', 'Charlie Davis'],
      'budget': 150000.0,
      'spent': 75000.0,
      'createdAt': '2026-01-01T00:00:00Z',
      'updatedAt': '2026-03-13T00:00:00Z',
    },
    {
      'id': 'PROJ-002',
      'name': 'Backend Optimization',
      'description': 'Optimize backend APIs for better performance',
      'clientName': 'TechBureau Inc',
      'projectManager': 'Alice Brown',
      'startDate': '2026-01-15T00:00:00Z',
      'endDate': '2026-03-31T23:59:59Z',
      'status': 'active',
      'progressPercentage': 65,
      'teamMembers': ['John Doe', 'Alice Brown'],
      'budget': 100000.0,
      'spent': 65000.0,
      'createdAt': '2026-01-01T00:00:00Z',
      'updatedAt': '2026-03-13T00:00:00Z',
    },
    {
      'id': 'PROJ-003',
      'name': 'Security Audit',
      'description': 'Comprehensive security audit and compliance review',
      'clientName': 'GlobalTech Solutions',
      'projectManager': 'Jane Smith',
      'startDate': '2026-02-15T00:00:00Z',
      'endDate': '2026-04-15T23:59:59Z',
      'status': 'planning',
      'progressPercentage': 20,
      'teamMembers': ['John Doe', 'Jane Smith'],
      'budget': 200000.0,
      'spent': 40000.0,
      'createdAt': '2026-01-01T00:00:00Z',
      'updatedAt': '2026-03-13T00:00:00Z',
    },
  ];

  /// Mock response for get projects
  static Map<String, dynamic> mockGetProjectsResponse() {
    return {
      'success': true,
      'data': {'projects': mockProjects, 'total': mockProjects.length},
    };
  }

  /// Mock response for get project detail
  static Map<String, dynamic> mockGetProjectDetailResponse(String projectId) {
    final project = mockProjects.firstWhere(
      (p) => p['id'] == projectId,
      orElse: () => mockProjects.first,
    );
    return {'success': true, 'data': project};
  }
}
