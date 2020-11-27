import 'package:flutter/material.dart';

class CustomBottom extends StatelessWidget {

  final Function callback;
  final String label;

  const CustomBottom({
    Key key,
    @required this.callback,
    @required this.label
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only( top: 20.0 ),
      child: RaisedButton(
        onPressed: callback,
        elevation: 2.0,
        highlightElevation: 5.0,
        color: Colors.lightBlueAccent,
        shape: StadiumBorder(),
        child: Container(
          height: 30.0,
          width: double.infinity,
          child: Center(child: Text( label, style: TextStyle( color: Colors.white, fontSize: 17.0 ),),),
        ),
      ),
    );
  }
}