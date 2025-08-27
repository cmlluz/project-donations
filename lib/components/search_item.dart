class SearchItem {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final SearchCategory category;
  final DateTime createdAt;
  final String location;
  final String institution;
  final String institutionImageUrl;

  const SearchItem({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.createdAt,
    required this.location,
    required this.institution,
    required this.institutionImageUrl,
  });
}

enum SearchCategory {
  todos('Todos'),
  doacao('Doação'),
  necessidade('Necessidade'),
  instituicao('Instituição');

  const SearchCategory(this.label);
  final String label;
}
