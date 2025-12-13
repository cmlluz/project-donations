class PostModel {
  final int id;
  final String caption;
  final String imageUrl;
  final String authorUid;
  final String authorName;
  final String? authorPhoto;
  final DateTime createdAt;
  final String postStatus;
  final bool favorited;

  const PostModel({
    required this.id,
    required this.caption,
    required this.imageUrl,
    required this.authorUid,
    required this.authorName,
    this.authorPhoto,
    required this.createdAt,
    required this.postStatus,
    this.favorited = false,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] ?? 0,
      caption: json['caption'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      authorUid: json['authorUid'] ?? '',
      authorName: json['authorName'] ?? 'Usuário',
      authorPhoto: json['authorProfilePictureUrl'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      postStatus: json['postStatus'] ?? 'PENDENTE_APROVACAO',
      favorited: json['favorited'] ?? false,
    );
  }
}
