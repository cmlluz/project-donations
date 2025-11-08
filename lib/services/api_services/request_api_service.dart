import 'dart:convert';
import 'package:appdonationsgestor/services/api_services/api_client.dart';
import 'package:appdonationsgestor/models/request_model.dart';

class RequestApiService {
  final ApiClient _apiClient;

  RequestApiService(this._apiClient);

  Future<Request> createRequest({int? donationId, int? needId}) async {
    final response = await _apiClient.post(
      'requests',
      body: {
        'donationId': donationId,
        'needId': needId,
        'code': null,
      },
    );

    if (response.statusCode == 201) {
      return Request.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      print("Erro ${response.statusCode}: ${response.body}");
      throw Exception('Falha ao criar solicitação');
    }
  }

  Future<Request> approveRequest(int requestId) async {
    final response = await _apiClient.post('requests/$requestId/approve');

    if (response.statusCode == 200) {
      return Request.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      print("Erro ${response.statusCode}: ${response.body}");
      throw Exception('Falha ao aprovar solicitação');
    }
  }

  Future<Request> rejectRequest(int requestId) async {
    final response = await _apiClient.post('requests/$requestId/reject');

    if (response.statusCode == 200) {
      return Request.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      print("Erro ${response.statusCode}: ${response.body}");
      throw Exception('Falha ao rejeitar solicitação');
    }
  }

  Future<Request> deliverRequest(int requestId, String code) async {
    final response = await _apiClient.post(
      'requests/$requestId/deliver',
      body: {
        'donationId': null,
        'needId': null,
        'code': code,
      },
    );

    if (response.statusCode == 200) {
      return Request.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      print("Erro ${response.statusCode}: ${response.body}");
      throw Exception('Falha ao confirmar entrega');
    }
  }

  Future<List<Request>> getPendingRequests() async {
    final response = await _apiClient.get('requests/pending');

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      return body.map((dynamic item) => Request.fromJson(item)).toList();
    } else {
      print("Erro ${response.statusCode}: ${response.body}");
      throw Exception('Falha ao buscar solicitações pendentes');
    }
  }

  Future<List<Request>> getMySentRequests() async {
    final response = await _apiClient.get('requests/my-requests');

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      return body.map((dynamic item) => Request.fromJson(item)).toList();
    } else {
      print("Erro ${response.statusCode}: ${response.body}");
      throw Exception('Falha ao buscar solicitações enviadas');
    }
  }

  Future<List<Request>> getRequestsForItem(
      {int? donationId, int? needId}) async {
    String endpoint = 'requests/item?';
    if (donationId != null) {
      endpoint += 'donationId=$donationId';
    } else if (needId != null) {
      endpoint += 'needId=$needId';
    }

    final response = await _apiClient.get(endpoint);

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      return body.map((dynamic item) => Request.fromJson(item)).toList();
    } else {
      print("Erro ${response.statusCode}: ${response.body}");
      throw Exception('Falha ao buscar solicitações do item');
    }
  }
}
