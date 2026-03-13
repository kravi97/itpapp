import 'base_entity.dart';

enum ProjectStatus {
  planning,
  active,
  onHold,
  completed,
  archived;

  String get displayName {
    switch (this) {
      case ProjectStatus.planning:
        return 'Planning';
      case ProjectStatus.active:
        return 'Active';
      case ProjectStatus.onHold:
        return 'On Hold';
      case ProjectStatus.completed:
        return 'Completed';
      case ProjectStatus.archived:
        return 'Archived';
    }
  }
}

class Project extends BaseEntity {
  final String name;
  final String description;
  final String clientName;
  final ProjectStatus status;
  final DateTime startDate;
  final DateTime? endDate;
  final String projectManager;
  final List<String> teamMembers;
  final double budget;
  final double spent;
  final int progressPercentage;

  Project({
    required super.id,
    required DateTime super.createdAt,
    required DateTime super.updatedAt,
    required this.name,
    required this.description,
    required this.clientName,
    required this.status,
    required this.startDate,
    this.endDate,
    required this.projectManager,
    required this.teamMembers,
    required this.budget,
    required this.spent,
    required this.progressPercentage,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      clientName: json['clientName'] ?? '',
      status: ProjectStatus.values.asNameMap()[json['status']] ?? ProjectStatus.active,
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : DateTime.now(),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      projectManager: json['projectManager'] ?? '',
      teamMembers: List<String>.from(json['teamMembers'] ?? []),
      budget: (json['budget'] as num?)?.toDouble() ?? 0.0,
      spent: (json['spent'] as num?)?.toDouble() ?? 0.0,
      progressPercentage: json['progressPercentage'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': (createdAt ?? DateTime.now()).toIso8601String(),
      'updatedAt': (updatedAt ?? DateTime.now()).toIso8601String(),
      'name': name,
      'description': description,
      'clientName': clientName,
      'status': status.name,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'projectManager': projectManager,
      'teamMembers': teamMembers,
      'budget': budget,
      'spent': spent,
      'progressPercentage': progressPercentage,
    };
  }
}
