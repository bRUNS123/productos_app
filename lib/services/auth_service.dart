import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService extends ChangeNotifier {
  // final String _baseURL2 = '206.189.99.159:3000';
  // final String _token = '';
  final String _baseURL = '10.0.2.2:3000';

  final storage = const FlutterSecureStorage();

  Future<String?> createUser(
      String email, String password, String nombre) async {
    final Map<String, dynamic> authData = {
      'nombre': nombre,
      'correo': email,
      'password': password,
      'role': 'USER_ROLE',
    };
    final url = Uri.http(_baseURL, '/api/usuarios');
    final resp = await http.post(url,
        body: json.encode(authData),
        headers: {"Content-Type": "application/json"});
    final Map<String, dynamic> decodedResp = json.decode(resp.body);
    // if (decodedResp.containsKey('estado') && resp.statusCode ==200) {

    // }
    if (!decodedResp.containsKey('errors') && resp.statusCode == 200) {
      print('Cuenta creada');
      loginUser(email, password);
    } else {
      print(json.encode(authData));
      print((decodedResp['errors']));

      return decodedResp['errors'].toString();
    }
  }

  Future<String?> loginUser(String email, String password) async {
    final Map<String, dynamic> authData = {
      'correo': email,
      'password': password,
    };
    final url = Uri.http(_baseURL, '/api/auth/login');
    final resp = await http.post(url,
        body: json.encode(authData),
        headers: {"Content-Type": "application/json"});
    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (decodedResp.containsKey('token')) {
      print(decodedResp['token']);
      await storage.write(key: 'token', value: decodedResp['token']);
      print(json.encode(authData));
      print(decodedResp);
      print('Tenemos Token');
      return null;
      //Guardar token en lugar seguro decodedResp['token'];

    } else {
      //arreglar
      // return decodedResp['errors']['param'];
      return 'Arreglar Error';
    }
  }

  Future logout() async {
    await storage.delete(key: 'token');
    return;
  }

  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }
}
