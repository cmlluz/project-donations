class NotaFiscal {
  final int id;
  final String titulo;
  final List<String> imageUrls;
  final DateTime dataEmissao;
  final String authorUid;
  final String authorName;

  NotaFiscal({
    required this.id,
    required this.titulo,
    required this.imageUrls,
    required this.dataEmissao,
    required this.authorUid,
    required this.authorName,
  });

  factory NotaFiscal.fromJson(Map<String, dynamic> json) {
    return NotaFiscal(
      id: json['id'] ?? 0,
      titulo: json['titulo'] ?? '',
      imageUrls:
          json['imageUrls'] != null ? List<String>.from(json['imageUrls']) : [],
      dataEmissao: json['dataEmissao'] != null
          ? DateTime.parse(json['dataEmissao'])
          : DateTime.now(),
      authorUid: json['authorUid'] ?? '',
      authorName: json['authorName'] ?? '',
    );
  }
}
