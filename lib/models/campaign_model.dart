class Campaign {
  final int id;
  final String titulo;
  final String descricao;
  final String localizacao;
  final String urlImagem;
  final DateTime? dataInicial;
  final DateTime? dataFinal;
  final String authorName;
  bool isFavorite;

  Campaign({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.localizacao,
    required this.urlImagem,
    this.dataInicial,
    this.dataFinal,
    required this.authorName,
    this.isFavorite = false,
  });

  factory Campaign.fromJson(Map<String, dynamic> json) {
    return Campaign(
      id: json['id'] ?? 0,
      titulo: json['titulo'] ?? 'Título não informado',
      descricao: json['descricao'] ?? '',
      localizacao: json['localizacao'] ?? 'Local não informado',
      urlImagem: json['urlImagem'] ?? '',
      dataInicial: json['dataInicial'] != null
          ? DateTime.parse(json['dataInicial'])
          : null,
      dataFinal:
          json['dataFinal'] != null ? DateTime.parse(json['dataFinal']) : null,
      authorName: json['authorName'] ?? 'Autor anônimo',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'localizacao': localizacao,
      'urlImagem': urlImagem,
      'dataInicial': dataInicial?.toIso8601String().split('T')[0],
      'dataFinal': dataFinal?.toIso8601String().split('T')[0],
      'authorName': authorName,
    };
  }

  // Verifica se a campanha está ativa
  bool get isActive {
    if (dataInicial == null || dataFinal == null) return false;
    final now = DateTime.now();
    return now.isAfter(dataInicial!) && now.isBefore(dataFinal!);
  }

  // Calcula os dias restantes
  int get diasRestantes {
    if (dataFinal == null) return 0;
    final now = DateTime.now();
    if (now.isAfter(dataFinal!)) return 0;
    return dataFinal!.difference(now).inDays;
  }
}
