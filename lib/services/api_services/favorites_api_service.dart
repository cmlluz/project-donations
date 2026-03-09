import 'dart:convert';
import 'package:appdonationsgestor/models/donation_model.dart';
import 'package:appdonationsgestor/models/need_model.dart';
import 'package:appdonationsgestor/models/campaign_model.dart';
import 'package:appdonationsgestor/services/api_services/api_client.dart';

class FavoriteApiService {
  final ApiClient _apiClient;

  FavoriteApiService(this._apiClient);

  Future<void> addFavoriteDonation(int donationId) async {
    final response = await _apiClient.post('favorites/donations/$donationId');
    if (response.statusCode != 200 && response.statusCode != 201) {
      print("Erro ${response.statusCode}: ${response.body}");
      throw Exception('Falha ao adicionar doação favorita');
    }
    print("Doação $donationId favoritada com sucesso.");
  }

  Future<void> removeFavoriteDonation(int donationId) async {
    final response = await _apiClient.delete('favorites/donations/$donationId');
    if (response.statusCode != 204) {
      print("Erro ${response.statusCode}: ${response.body}");
      throw Exception('Falha ao remover doação favorita');
    }
    print("Doação $donationId desfavoritada com sucesso.");
  }

  Future<PaginatedResponse<Donation>> getFavoriteDonations(
      {int page = 0, int size = 10}) async {
    final response =
        await _apiClient.get('favorites/donations?page=$page&size=$size');
    if (response.statusCode == 200) {
      final Map<String, dynamic> body =
          jsonDecode(utf8.decode(response.bodyBytes));
      return PaginatedResponse.fromJson(
          body, (item) => Donation.fromJson(item));
    } else {
      print("Erro ${response.statusCode}: ${response.body}");
      throw Exception('Falha ao buscar doações favoritas.');
    }
  }

  Future<void> addFavoriteNeed(int needId) async {
    final response = await _apiClient.post('favorites/needs/$needId');
    if (response.statusCode != 200 && response.statusCode != 201) {
      print("Erro ${response.statusCode}: ${response.body}");
      throw Exception('Falha ao adicionar necessidade favorita');
    }
    print("Necessidade $needId favoritada com sucesso.");
  }

  Future<void> removeFavoriteNeed(int needId) async {
    final response = await _apiClient.delete('favorites/needs/$needId');
    if (response.statusCode != 204) {
      print("Erro ${response.statusCode}: ${response.body}");
      throw Exception('Falha ao remover necessidade favorita');
    }
    print("Necessidade $needId desfavoritada com sucesso.");
  }

  Future<PaginatedResponse<Need>> getFavoriteNeeds(
      {int page = 0, int size = 10}) async {
    final response =
        await _apiClient.get('favorites/needs?page=$page&size=$size');
    if (response.statusCode == 200) {
      final Map<String, dynamic> body =
          jsonDecode(utf8.decode(response.bodyBytes));
      return PaginatedResponse.fromJson(body, (item) => Need.fromJson(item));
    } else {
      print("Erro ${response.statusCode}: ${response.body}");
      throw Exception('Falha ao buscar necessidades favoritas.');
    }
  }

  Future<void> addFavoriteUser(String userUid) async {
    final response = await _apiClient.post('favorites/users/$userUid');
    if (response.statusCode != 200 && response.statusCode != 201) {
      print("Erro ${response.statusCode}: ${response.body}");
      throw Exception('Falha ao adicionar usuário favorito');
    }
    print("Usuário $userUid favoritado com sucesso.");
  }

  Future<void> removeFavoriteUser(String userUid) async {
    final response = await _apiClient.delete('favorites/users/$userUid');
    if (response.statusCode != 204) {
      print("Erro ${response.statusCode}: ${response.body}");
      throw Exception('Falha ao remover usuário favorito');
    }
    print("Usuário $userUid desfavoritado com sucesso.");
  }

  Future<PaginatedResponse<Map<String, dynamic>>> getFavoriteUsers(
      {int page = 0, int size = 10}) async {
    final response =
        await _apiClient.get('favorites/users?page=$page&size=$size');
    if (response.statusCode == 200) {
      final Map<String, dynamic> body =
          jsonDecode(utf8.decode(response.bodyBytes));
      return PaginatedResponse.fromJson(
          body, (item) => item as Map<String, dynamic>);
    } else {
      print("Erro ${response.statusCode}: ${response.body}");
      throw Exception('Falha ao buscar usuários favoritos.');
    }
  }

  Future<void> addFavoriteCampaign(int campaignId) async {
    final response = await _apiClient.post('favorites/campaigns/$campaignId');
    if (response.statusCode != 200 && response.statusCode != 201) {
      print("Erro ${response.statusCode}: ${response.body}");
      throw Exception('Falha ao adicionar campanha favorita');
    }
    print("Campanha $campaignId favoritada com sucesso.");
  }

  Future<void> removeFavoriteCampaign(int campaignId) async {
    final response = await _apiClient.delete('favorites/campaigns/$campaignId');
    if (response.statusCode != 204) {
      print("Erro ${response.statusCode}: ${response.body}");
      throw Exception('Falha ao remover campanha favorita');
    }
    print("Campanha $campaignId desfavoritada com sucesso.");
  }

  Future<PaginatedResponse<Campaign>> getFavoriteCampaigns(
      {int page = 0, int size = 10}) async {
    final response =
        await _apiClient.get('favorites/campaigns?page=$page&size=$size');
    if (response.statusCode == 200) {
      final Map<String, dynamic> body =
          jsonDecode(utf8.decode(response.bodyBytes));
      return PaginatedResponse.fromJson(
          body, (item) => Campaign.fromJson(item));
    } else {
      print("Erro ${response.statusCode}: ${response.body}");
      throw Exception('Falha ao buscar campanhas favoritas.');
    }
  }

  Future<Set<int>> getFavoriteDonationIds() async {
    try {
      final response = await getFavoriteDonations(page: 0, size: 200);
      return response.content.map((d) => d.id).toSet();
    } catch (e) {
      print("Erro ao buscar IDs de doações favoritas: $e");
      return {};
    }
  }

  Future<Set<int>> getFavoriteNeedIds() async {
    try {
      final response = await getFavoriteNeeds(page: 0, size: 200);
      return response.content.map((n) => n.id).toSet();
    } catch (e) {
      print("Erro ao buscar IDs de necessidades favoritas: $e");
      return {};
    }
  }

  Future<Set<String>> getFavoriteUserIds() async {
    try {
      final response = await getFavoriteUsers(page: 0, size: 200);
      return response.content.map((u) => u['firebaseUid'] as String).toSet();
    } catch (e) {
      print("Erro ao buscar IDs de usuários favoritos: $e");
      return {};
    }
  }

  Future<Set<int>> getFavoriteCampaignIds() async {
    try {
      final response = await getFavoriteCampaigns(page: 0, size: 200);
      return response.content.map((c) => c.id).toSet();
    } catch (e) {
      print("Erro ao buscar IDs de campanhas favoritas: $e");
      return {};
    }
  }
}
