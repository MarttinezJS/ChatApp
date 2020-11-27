// To parse this JSON data, do
//
//     final chatResponse = chatResponseFromMap(jsonString);

import 'dart:convert';

ChatResponse chatResponseFromMap(String str) => ChatResponse.fromMap(json.decode(str));

String chatResponseToMap(ChatResponse data) => json.encode(data.toMap());

class ChatResponse {
    ChatResponse({
        this.ok,
        this.mensajes,
    });

    bool ok;
    List<Mensaje> mensajes;

    factory ChatResponse.fromMap(Map<String, dynamic> json) => ChatResponse(
        ok: json["ok"],
        mensajes: List<Mensaje>.from(json["mensajes"].map((x) => Mensaje.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "ok": ok,
        "mensajes": List<dynamic>.from(mensajes.map((x) => x.toMap())),
    };
}

class Mensaje {
    Mensaje({
        this.de,
        this.para,
        this.mensaje,
        this.createdAt,
        this.updatedAt,
    });

    String de;
    String para;
    String mensaje;
    DateTime createdAt;
    DateTime updatedAt;

    factory Mensaje.fromMap(Map<String, dynamic> json) => Mensaje(
        de        : json["de"],
        para      : json["para"],
        mensaje   : json["mensaje"],
        createdAt : DateTime.parse(json["createdAt"]),
        updatedAt : DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toMap() => {
        "de": de,
        "para": para,
        "mensaje": mensaje,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
    };
}