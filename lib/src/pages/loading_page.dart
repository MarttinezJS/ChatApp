import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:chat_app/src/pages/login_page.dart';
import 'package:chat_app/src/pages/usuarios_page.dart';
import 'package:chat_app/src/services/auth_service.dart';
import 'package:chat_app/src/services/socket_service.dart';

class LoadingPage extends StatelessWidget {

  static final routeName = 'loading';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState( context ),
        builder: (context, snapshot) {
          return Center(
            child: Text('Espere....'),
          );
        },
      ),
   );
  }

  Future checkLoginState( BuildContext context ) async {

    final authService = Provider.of<AuthService>(context, listen: false);
    final autenticado = await authService.isLoggedIn();

    if ( autenticado ) {
      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.connect();
      Navigator.pushReplacement(context,
        PageRouteBuilder(
          pageBuilder: ( _, __, ___) => UsuariosPage(),
          transitionDuration: Duration(microseconds: 0)
        )
      );
    } else {
      Navigator.pushReplacement(context,
        PageRouteBuilder(
          pageBuilder: ( _, __, ___) => LoginPage(),
          transitionDuration: Duration(microseconds: 0)
        )
      );
    }
  }
}