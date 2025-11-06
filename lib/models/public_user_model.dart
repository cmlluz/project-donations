class PublicUser {
  final String firebaseUid;
  final String name;
  final String role;
  final String email;
  final String? profilePictureUrl;
  final String? phone;

  PublicUser({
    required this.firebaseUid,
    required this.name,
    required this.role,
    required this.email,
    this.profilePictureUrl,
    this.phone,
  });

  factory PublicUser.fromJson(Map<String, dynamic> json) {
    return PublicUser(
      firebaseUid: json['firebaseUid'] ?? '',
      name: json['name'] ?? 'Nome não informado',
      role: json['role'] ?? 'ROLE_USER',
      email: json['email'] ?? 'Email não informado',
      profilePictureUrl: json['profilePictureUrl'],
      phone: json['phone'],
    );
  }
}
