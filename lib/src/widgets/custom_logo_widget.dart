import 'package:flutter/material.dart';

class CustomLogo extends StatelessWidget {

  final String mensaje;

  const CustomLogo({Key key, @required this.mensaje}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
        child: Container(
          width: 300.0,
          child: Column(
            children: [
              Image(image: AssetImage('assets/UChatLogo.png'),),
              Text( mensaje, style: TextStyle(fontSize: 30.0),)
            ],
          ),
        ),
      )
    );
  }
}