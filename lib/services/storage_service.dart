import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class StorageService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final String _baseUrl = 'http://192.168.1.3:8080/api/storage';

  Future<String?> uploadImage(File imageFile, String folder) async {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception('Utilizador não autenticado.');
    }

    try {
      final token = await user.getIdToken();
      final uri = Uri.parse('$_baseUrl/upload');

      var request = http.MultipartRequest('POST', uri);

      request.headers['Authorization'] = 'Bearer $token';

      request.fields['folder'] = folder;

      final mimeTypeData = lookupMimeType(imageFile.path)!.split('/');

      request.files.add(await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
      ));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Upload com sucesso: ${data['url']}");
        return data['url'];
      } else {
        print('Falha no upload: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Erro ao fazer upload da imagem para o backend: $e');
      return null;
    }
  }
}
