import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? profileImage;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.profileImage,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, email, role];

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? profileImage,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
