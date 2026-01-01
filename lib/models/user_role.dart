enum UserRole {
  admin('admin', 'Administrateur'),
  employe('employe', 'Employé'),
  client('client', 'Client');

  final String value;
  final String label;

  const UserRole(this.value, this.label);

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (role) => role.value == value,
      orElse: () => UserRole.client,
    );
  }

  @override
  String toString() => value;
}