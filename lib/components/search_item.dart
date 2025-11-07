class SearchItem {
  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final SearchCategory category;
  final String? location;
  final String institution;
  final String? institutionImageUrl;
  final DateTime date;
  final int quantity;
  final String postStatus;

  const SearchItem({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.category,
    this.location,
    required this.institution,
    this.institutionImageUrl,
    required this.date,
    required this.quantity,
    required this.postStatus,
  });
}

enum SearchCategory {
  todos('Todos'),
  campanha('Campanhas'),
  doacao('Doação'),
  necessidade('Necessidade'),
  instituicao('Instituição');

  const SearchCategory(this.label);
  final String label;
}
