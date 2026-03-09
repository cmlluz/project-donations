class Campaign {
  final int id;
  final String titulo;
  final String descricao;
  final String localizacao;
  final String urlImagem;
  final DateTime? dataInicial;
  final DateTime? dataFinal;
  final String authorUid;
  bool isFavorite;

  Campaign({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.localizacao,
    required this.urlImagem,
    this.dataInicial,
    this.dataFinal,
    required this.authorUid,
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
      authorUid: json['authorUid'] ?? '',
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
      'authorUid': authorUid,
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

  // Verifica se o usuário é o autor desta campanha
  bool isAuthoredBy(String? userUid) {
    if (userUid == null || userUid.isEmpty) return false;
    return authorUid == userUid;
  }

  // Verifica se a campanha tem um autor válido
  bool get hasValidAuthor {
    return authorUid.isNotEmpty;
  }

  // Getter para verificar se é uma campanha válida (tem autor e dados básicos)
  bool get isValid {
    return hasValidAuthor &&
        titulo.isNotEmpty &&
        descricao.isNotEmpty &&
        localizacao.isNotEmpty;
  }
}
