class Need {
  final int id;
  final String title;
  final String description;
  final DateTime? date;
  final String category;
  final int quantity;
  final String status;
  final String authorName;
  bool isFavorite;

  Need({
    required this.id,
    required this.title,
    required this.description,
    this.date,
    required this.category,
    required this.quantity,
    required this.status,
    required this.authorName,
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
      status: json['status'] ?? 'PENDENTE',
      authorName: json['authorName'] ?? 'Autor anônimo',
    );
  }
}
