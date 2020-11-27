// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromMap(jsonString);

import 'dart:convert';

import 'package:chat_app/src/models/usuario.dart';

LoginResponse loginResponseFromMap(String str) => LoginResponse.fromMap(json.decode(str));

String loginResponseToMap(LoginResponse data) => json.encode(data.toMap());

class LoginResponse {
    LoginResponse({
        this.ok,
        this.usuario,
        this.token,
    });

    bool ok;
    Usuario usuario;
    String token;

    factory LoginResponse.fromMap(Map<String, dynamic> json) => LoginResponse(
        ok: json["ok"],
        usuario: Usuario.fromMap(json["usuario"]),
        token: json["token"],
    );

    Map<String, dynamic> toMap() => {
        "ok": ok,
        "usuario": usuario.toMap(),
        "token": token,
    };
}
