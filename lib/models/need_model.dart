class Need {
  final int id;
  final String title;
  final String description;
  final DateTime? date;
  final String category;
  final int quantity;
  final String postStatus;
  final String authorName;
  final String? authorUid;
  final String? imageUrl;
  bool isFavorite;

  Need({
    required this.id,
    required this.title,
    required this.description,
    this.date,
    required this.category,
    required this.quantity,
    required this.postStatus,
    required this.authorName,
    this.authorUid,
    this.imageUrl, 
    this.isFavorite = false,
  });

  factory Need.fromJson(Map<String, dynamic> json) {
    return Need(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Necessidade não informada',
      description: json['description'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      category: json['category'] ?? 'OUTROS',
      quantity: json['quantity'] ?? 0,
      postStatus: json['postStatus'] ?? 'PENDENTE_APROVACAO',
      authorName: json['authorName'] ?? 'Autor anônimo',
      authorUid: json['authorUid'],
      imageUrl: json['imageUrl'],
    );
  }
}