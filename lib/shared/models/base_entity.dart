/// Base entity class for all models
class BaseEntity {
  final String id;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BaseEntity({required this.id, this.createdAt, this.updatedAt});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BaseEntity && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
