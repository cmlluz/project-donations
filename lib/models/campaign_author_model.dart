class CampaignAuthor {
  final String uid;
  final String name;
  final String? profilePictureUrl;
  final String? email;

  CampaignAuthor({
    required this.uid,
    required this.name,
    this.profilePictureUrl,
    this.email,
  });

  factory CampaignAuthor.fromJson(Map<String, dynamic> json) {
    return CampaignAuthor(
      uid: json['uid'] ?? json['firebaseUid'] ?? '',
      name: json['name'] ?? json['displayName'] ?? 'Autor anônimo',
      profilePictureUrl: json['profilePictureUrl'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'profilePictureUrl': profilePictureUrl,
      'email': email,
    };
  }
}
