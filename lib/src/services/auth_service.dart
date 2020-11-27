import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:chat_app/src/models/login_response.dart';
import 'package:chat_app/src/models/usuario.dart';
import 'package:chat_app/src/global/enviroment.dart';

class AuthService with ChangeNotifier {

  Usuario usuario;
  bool _autenticando = false;

  final _storage = new FlutterSecureStorage();

  bool get autenticando => _autenticando;
  set autenticando( bool valor ) {
    _autenticando = valor;
    notifyListeners();
  }

  static Future<String> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');

    return token;
  } 

  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');

  } 

  Future login( String email, String password ) async {

    autenticando = true;

    final data = {
      'email': email,
      'password': password
    };

    final resp = await http.post('${ Enviroment.apiUrl }/usuarios',
      body: jsonEncode( data ),
      headers: {
        'Content-Type': 'application/json'
      }
    );
    autenticando = false;
    if ( resp.statusCode == 200 ) {

      final loginResponse = loginResponseFromMap( resp.body );
      usuario = loginResponse.usuario;

      await _guardarToken( loginResponse.token );

      return true;
    } else {
      return false;
    }

  }

  Future register( String email, String password, String nombre ) async {

    final data = {
      'nombre': nombre,
      'email' : email,
      'password': password
    };

    final resp = await http.post('${ Enviroment.apiUrl }/usuarios/new',
      body: jsonEncode( data ),
      headers: {
        'Content-Type': 'application/json'
      }
    );
    print( resp.body );

    if ( resp.statusCode == 200 ) {

      final loginResponse = loginResponseFromMap( resp.body );
      usuario = loginResponse.usuario;

      await _guardarToken( loginResponse.token );

      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['mensaje'];
    }
  }

  Future<bool> isLoggedIn() async {

    final token = await _storage.read(key: 'token');
    
    final resp = await http.get('${ Enviroment.apiUrl }/usuarios/renovar',
      headers: {
        'x-token': token,
        'Content-Type': 'application/json'
      }
    );

    if ( resp.statusCode == 200 ) {

      final loginResponse = loginResponseFromMap( resp.body );
      usuario = loginResponse.usuario;

      await _guardarToken( loginResponse.token );

      return true;
    } else {
      this.logout();
      return false;
    }
  }

  Future _guardarToken( String token ) async {

    return await _storage.write(key: 'token', value: token);

  }

  Future logout() async {

    return await _storage.delete(key: 'token');

  }
}