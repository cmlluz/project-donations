class PostModel {
  final String id;
  final String title;
  final String description;
  final int? quantity;
  final String imageUrl;
  final String location;
  final String institution;
  final String institutionImageUrl;
  final DateTime createdAt;
  final String category;
  final String postStatus; // ADICIONADO

  const PostModel({
    required this.id,
    required this.title,
    required this.description,
    this.quantity,
    required this.imageUrl,
    required this.location,
    required this.institution,
    required this.institutionImageUrl,
    required this.createdAt,
    required this.category,
    this.postStatus = 'DISPONIVEL',
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
      quantity: null,
      imageUrl: imageUrl,
      location: 'Salvador, Bahia',
      institution: 'Instituição Exemplo',
      institutionImageUrl: 'assets/instituicao.png',
      createdAt: DateTime.now(),
      category: category,
      postStatus: 'DISPONIVEL',
    );
  }
}
