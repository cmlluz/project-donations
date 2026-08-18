class Donation {
  final int id;
  final String title;
  final String description;
  final DateTime? date;
  final String category;
  final int quantity;
  final String postStatus;
  final String donatorName;
  final String? donatorUid;
  final String? imageUrl;
  bool isFavorite;

  Donation({
    required this.id,
    required this.title,
    required this.description,
    this.date,
    required this.category,
    required this.quantity,
    required this.postStatus,
    required this.donatorName,
    this.donatorUid,
    this.imageUrl,
    this.isFavorite = false,
  });

  factory Donation.fromJson(Map<String, dynamic> json) {
    return Donation(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Título não informado',
      description: json['description'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      category: json['category'] ?? 'OUTROS',
      quantity: json['quantity'] ?? 0,
      postStatus: json['postStatus'] ?? 'PENDENTE_APROVACAO',
      donatorName: json['donatorName'] ?? 'Doador anônimo',
      donatorUid: json['donatorUid'],
      imageUrl: json['imageUrl'],
    );
  }
}
