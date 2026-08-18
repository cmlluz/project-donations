import 'dart:convert';
import 'package:appdonationsgestor/models/post_model.dart';
import 'package:appdonationsgestor/services/api_services/api_client.dart';

class PostApiService {
  final ApiClient _apiClient;

  PostApiService(this._apiClient);

  Future<List<PostModel>> getPosts() async {
    final response = await _apiClient.get('posts');

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      return body.map((dynamic item) => PostModel.fromJson(item)).toList();
    } else {
      throw Exception('Falha ao carregar posts.');
    }
  }

  Future<List<PostModel>> getConcludedPosts() async {
    final response = await _apiClient.get('posts/me/concluded');

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      return body.map((dynamic item) => PostModel.fromJson(item)).toList();
    } else {
      throw Exception('Falha ao carregar posts concluídos.');
    }
  }

  Future<List<PostModel>> getPostsByAuthor(String authorUid) async {
    final response = await _apiClient.get('posts/author/$authorUid');

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      return body.map((dynamic item) => PostModel.fromJson(item)).toList();
    } else {
      throw Exception('Falha ao carregar posts do autor.');
    }
  }

  Future<PostModel> createPost(Map<String, dynamic> postData) async {
    final response = await _apiClient.post('posts', body: postData);

    if (response.statusCode == 201) {
      return PostModel.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Falha ao criar post.');
    }
  }

  Future<void> updatePostCaption(int id, String caption) async {
    final response = await _apiClient.put('posts/$id',
        body: {'caption': caption, 'imageUrl': '', 'favorited': false});

    if (response.statusCode != 200) {
      throw Exception('Falha ao atualizar post.');
    }
  }

  Future<void> deletePost(int id) async {
    final response = await _apiClient.delete('posts/$id');

    if (response.statusCode != 204) {
      throw Exception('Falha ao deletar post.');
    }
  }

  Future<void> approvePost(int id) async {
    final response = await _apiClient.post('posts/$id/approve');
    if (response.statusCode != 200) {
      throw Exception('Falha ao aprovar post.');
    }
  }

  Future<void> rejectPost(int id) async {
    final response = await _apiClient.post('posts/$id/reject');
    if (response.statusCode != 200) {
      throw Exception('Falha ao rejeitar post.');
    }
  }

  Future<PostModel> getPostById(int id) async {
    final response = await _apiClient.get('posts/$id');

    if (response.statusCode == 200) {
      return PostModel.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Falha ao carregar o post.');
    }
  }
}
