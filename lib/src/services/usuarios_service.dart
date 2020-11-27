import 'package:chat_app/src/global/enviroment.dart';
import 'package:chat_app/src/models/usuarios_response.dart';
import 'package:chat_app/src/services/auth_service.dart';
import 'package:http/http.dart' as http;

import 'package:chat_app/src/models/usuario.dart';

class UsuariosService {

  Future<List<Usuario>> getUsuarios() async {

    try {
      final resp = await http.get('${ Enviroment.apiUrl }/usuarios',
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken()
        }
      );

      final usuariosResp = usuariosResponseFromMap( resp.body );

      return usuariosResp.usuarios;
    } catch (e) {
      return [];
    }
  }
}
