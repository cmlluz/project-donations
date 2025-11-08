class NotificationModel {
  final int id;
  final String title;
  final String body;
  final bool isRead;
  final DateTime createdAt;
  final String? dataPayload;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
    this.dataPayload,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Sem Título',
      body: json['body'] ?? '',
      isRead: json['read'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      dataPayload: json['dataPayload'],
    );
  }
}
