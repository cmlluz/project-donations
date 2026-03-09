class CampaignParticipant {
  final int id;
  final int campaignId;
  final String campaignTitle;
  final String participantUid;
  final String participantName;
  final String participantEmail;
  final DateTime registeredAt;

  CampaignParticipant({
    required this.id,
    required this.campaignId,
    required this.campaignTitle,
    required this.participantUid,
    required this.participantName,
    required this.participantEmail,
    required this.registeredAt,
  });

  factory CampaignParticipant.fromJson(Map<String, dynamic> json) {
    return CampaignParticipant(
      id: json['id'],
      campaignId: json['campaignId'],
      campaignTitle: json['campaignTitle'] ?? '',
      participantUid: json['participantUid'],
      participantName: json['participantName'],
      participantEmail: json['participantEmail'],
      registeredAt: DateTime.parse(json['registeredAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'campaignId': campaignId,
      'campaignTitle': campaignTitle,
      'participantUid': participantUid,
      'participantName': participantName,
      'participantEmail': participantEmail,
      'registeredAt': registeredAt.toIso8601String(),
    };
  }
}
