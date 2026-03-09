class PublicUser {
  final String firebaseUid;
  final String name;
  final String role;
  final String email;
  final String? profilePictureUrl;
  final String? phone;
  final String? bio;
  final String? pixKey;

  PublicUser({
    required this.firebaseUid,
    required this.name,
    required this.role,
    required this.email,
    this.profilePictureUrl,
    this.phone,
    this.bio,
    this.pixKey,
  });

  factory PublicUser.fromJson(Map<String, dynamic> json) {
    return PublicUser(
      firebaseUid: json['firebaseUid'] ?? '',
      name: json['name'] ?? 'Nome não informado',
      role: json['role'] ?? 'ROLE_USER',
      email: json['email'] ?? 'Email não informado',
      profilePictureUrl: json['profilePictureUrl'],
      phone: json['phone'],
      bio: json['bio'],
      pixKey: json['pixKey'],
    );
  }

  PublicUser copyWith({
    String? firebaseUid,
    String? name,
    String? role,
    String? email,
    String? profilePictureUrl,
    String? phone,
    String? bio,
    String? pixKey,
  }) {
    return PublicUser(
      firebaseUid: firebaseUid ?? this.firebaseUid,
      name: name ?? this.name,
      role: role ?? this.role,
      email: email ?? this.email,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
      pixKey: pixKey ?? this.pixKey,
    );
  }
}
