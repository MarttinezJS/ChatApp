import 'package:chat_app/src/global/enviroment.dart';
import 'package:chat_app/src/models/mensajes_response.dart';
import 'package:chat_app/src/services/auth_service.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:chat_app/src/models/usuario.dart';

class ChatService with ChangeNotifier {

  Usuario usuarioReceptor;

  Future getChat( String usuarioId ) async {

    final resp = await http.get('${ Enviroment.apiUrl }/mensajes/$usuarioId',
      headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken()
      }
    );

    final mensajesResp = chatResponseFromMap( resp.body );

    return mensajesResp.mensajes;
  }
}