import 'package:flutter/material.dart';

class CustomLabel extends StatelessWidget {

  final String ruta;
  final String pregunta;
  final String mensaje;

  const CustomLabel({
    Key key,
    @required this.ruta,
    @required this.pregunta,
    @required this.mensaje
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(pregunta, style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w300),),
          SizedBox(height: 10.0,),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, ruta);
            },
            child: Text(mensaje, style: TextStyle(color: Colors.lightBlueAccent, fontSize: 18.0, fontWeight: FontWeight.bold),)
          )
        ]
      )
    );
  }
}
