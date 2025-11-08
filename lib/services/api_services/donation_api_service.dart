import 'dart:convert';
import 'package:appdonationsgestor/models/donation_model.dart';
import 'package:appdonationsgestor/services/api_services/api_client.dart';

class DonationApiService {
  final ApiClient _apiClient;

  DonationApiService(this._apiClient);

  Future<List<Donation>> getDonations() async {
    final response = await _apiClient.get('donations');

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      return body.map((dynamic item) => Donation.fromJson(item)).toList();
    } else {
      print("Erro ${response.statusCode}: ${response.body}");
      throw Exception('Falha ao carregar as doações.');
    }
  }

  Future<Donation> getDonationById(String id) async {
    final response = await _apiClient.get('donations/$id');

    if (response.statusCode == 200) {
      return Donation.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      print("Erro ${response.statusCode}: ${response.body}");
      throw Exception('Falha ao carregar a doação.');
    }
  }

  Future<Donation> createDonation(Map<String, dynamic> donationData) async {
    final response = await _apiClient.post('donations', body: donationData);

    if (response.statusCode == 201) {
      return Donation.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      print("Erro ${response.statusCode}: ${response.body}");
      throw Exception('Falha ao criar a doação.');
    }
  }

  Future<void> updateDonation(
      String id, Map<String, dynamic> donationData) async {
    final response = await _apiClient.put('donations/$id', body: donationData);

    if (response.statusCode != 200) {
      print("Falha ao atualizar doação: ${response.statusCode}");
      print("Corpo da resposta: ${response.body}");
      throw Exception("Falha ao atualizar doação: ${response.statusCode}");
    }
    print("Doação atualizada com sucesso.");
  }

  Future<void> deleteDonation(String id) async {
    final response = await _apiClient.delete('donations/$id');

    if (response.statusCode != 204) {
      print("Falha ao deletar doação: ${response.statusCode}");
      print("Corpo da resposta: ${response.body}");
      throw Exception("Falha ao deletar doação: ${response.statusCode}");
    }
    print("Doação deletada com sucesso.");
  }

  Future<Donation> approveDonation(String id) async {
    final response = await _apiClient.post('donations/$id/approve');

    if (response.statusCode == 200) {
      return Donation.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      print("Erro ${response.statusCode}: ${response.body}");
      throw Exception('Falha ao aprovar a doação.');
    }
  }

  Future<Donation> rejectDonation(String id) async {
    final response = await _apiClient.post('donations/$id/reject');

    if (response.statusCode == 200) {
      return Donation.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      print("Erro ${response.statusCode}: ${response.body}");
      throw Exception('Falha ao rejeitar a doação.');
    }
  }
}
