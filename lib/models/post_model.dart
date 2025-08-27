class PostModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String location;
  final String institution;
  final String institutionImageUrl;
  final DateTime createdAt;
  final String category;

  const PostModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.location,
    required this.institution,
    required this.institutionImageUrl,
    required this.createdAt,
    required this.category,
  });

  factory PostModel.fromSearchItem(
    String id,
    String title,
    String description,
    String imageUrl,
    String category,
  ) {
    return PostModel(
      id: id,
      title: title,
      description: description,
      imageUrl: imageUrl,
      location: 'Salvador, Bahia',
      institution: 'Instituição Exemplo',
      institutionImageUrl: 'assets/instituicao.png',
      createdAt: DateTime.now(),
      category: category,
    );
  }
}
