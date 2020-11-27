import 'package:flutter/cupertino.dart';

mostrarAlerta( BuildContext context,  String titulo, String subtitulo ){
  
  showCupertinoDialog(
    context: context,
    builder: ( _ ) => CupertinoAlertDialog(
      title: Text( titulo ),
      content: Text( subtitulo ),
      actions: [
        CupertinoDialogAction(
          child: Text('Ok'),
          onPressed: () => Navigator.pop(context),
        )
      ],
    )
  );
}