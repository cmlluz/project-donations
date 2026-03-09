import 'package:appdonationsgestor/models/donation_model.dart';
import 'package:appdonationsgestor/models/need_model.dart';
import 'package:appdonationsgestor/models/public_user_model.dart';

class Request {
  final int id;
  final PublicUser solicitante;
  final PublicUser dono;
  final Donation? donation;
  final Need? need;
  final String status;
  final DateTime createdAt;
  final String? confirmationCode;

  Request({
    required this.id,
    required this.solicitante,
    required this.dono,
    this.donation,
    this.need,
    required this.status,
    required this.createdAt,
    this.confirmationCode,
  });

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      id: json['id'],
      solicitante: PublicUser.fromJson(json['solicitante']),
      dono: PublicUser.fromJson(json['dono']),
      donation:
          json['donation'] != null ? Donation.fromJson(json['donation']) : null,
      need: json['need'] != null ? Need.fromJson(json['need']) : null,
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      confirmationCode: json['confirmationCode'],
    );
  }
}
