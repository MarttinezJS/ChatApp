// To parse this JSON data, do
//
//     final usuario = usuarioFromMap(jsonString);

import 'dart:convert';

Usuario usuarioFromMap(String str) => Usuario.fromMap(json.decode(str));

String usuarioToMap(Usuario data) => json.encode(data.toMap());

class Usuario {
    Usuario({
        this.online,
        this.nombre,
        this.email,
        this.uid,
    });

    bool online;
    String nombre;
    String email;
    String uid;

    factory Usuario.fromMap(Map<String, dynamic> json) => Usuario(
        online: json["online"],
        nombre: json["nombre"],
        email: json["email"],
        uid: json["uid"],
    );

    Map<String, dynamic> toMap() => {
        "online": online,
        "nombre": nombre,
        "email": email,
        "uid": uid,
    };
}
