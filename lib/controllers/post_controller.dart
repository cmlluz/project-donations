import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PostController {
  final _crtlDesc = TextEditingController();
  final _crtlPic = TextEditingController();

  TextEditingController get crtlDesc => _crtlDesc;
  TextEditingController get crtlPic => _crtlPic;

  Future<String> publicarPost({
    required String authorUid,
    required String imageUrl,
    required String caption,
    required bool favorited,
    required String token,
  }) async {
    // definir a url da API 
    final url = '';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'authorUid': authorUid,
        'imageUrl': imageUrl,
        'caption': caption,
        'favorited': favorited,
      }),
    );
    if (response.statusCode == 201) {
      return 'Publicado com sucesso!';
    } else {
      return 'Erro ao publicar!';
    }
  }
}