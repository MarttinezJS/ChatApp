import 'package:flutter/material.dart';
import 'package:chat_app/src/pages/chat_page.dart';
import 'package:chat_app/src/pages/loading_page.dart';
import 'package:chat_app/src/pages/login_page.dart';
import 'package:chat_app/src/pages/register_page.dart';
import 'package:chat_app/src/pages/usuarios_page.dart';

final Map<String, Widget Function( BuildContext )> appRoutes = {
  'chat'     : ( _ ) => ChatPage(),
  'loading'  : ( _ ) => LoadingPage(),
  'login'    : ( _ ) => LoginPage(),
  'register' : ( _ ) => RegisterPage(),
  'usuarios' : ( _ ) => UsuariosPage(),
};
