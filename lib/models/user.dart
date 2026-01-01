import 'user_role.dart';

class User {
  final int id;
  final String name;
  final String email;
  final UserRole role;
  final String? telephone;
  final String? adresse;
  final String? photoProfil;
  final String? bio;
  final DateTime? emailVerifiedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.telephone,
    this.adresse,
    this.photoProfil,
    this.bio,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  // Créer un User à partir d'un JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      role: UserRole.fromString(json['role'] as String? ?? 'client'),
      telephone: json['telephone'] as String?,
      adresse: json['adresse'] as String?,
      photoProfil: json['photo_profil'] as String?,
      bio: json['bio'] as String?,
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.parse(json['email_verified_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  // Convertir un User en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.value,
      'telephone': telephone,
      'adresse': adresse,
      'photo_profil': photoProfil,
      'bio': bio,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Copier un User avec des modifications
  User copyWith({
    int? id,
    String? name,
    String? email,
    UserRole? role,
    String? telephone,
    String? adresse,
    String? photoProfil,
    String? bio,
    DateTime? emailVerifiedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      telephone: telephone ?? this.telephone,
      adresse: adresse ?? this.adresse,
      photoProfil: photoProfil ?? this.photoProfil,
      bio: bio ?? this.bio,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Méthodes utiles pour les permissions
  bool get isAdmin => role == UserRole.admin;
  bool get isEmploye => role == UserRole.employe;
  bool get isClient => role == UserRole.client;
  bool get canManageOrders => role == UserRole.admin || role == UserRole.employe;

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, role: ${role.label})';
  }
}