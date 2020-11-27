import 'package:chat_app/src/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatMessage extends StatelessWidget {

  final String texto;
  final String uid;
  final AnimationController animationCtrl;

  const ChatMessage({
    Key key,
    @required this.texto,
    @required this.uid,
    @required this.animationCtrl
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context, listen: false);

    return SizeTransition(
      sizeFactor: CurvedAnimation(parent: animationCtrl, curve: Curves.bounceOut),
      child: FadeTransition(
        opacity: animationCtrl,
        child: Container(
          child: uid == authService.usuario.uid
          ? _myMessage()
          : _notMyMessage(),
        ),
      ),
    );
  }

  Widget _myMessage() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        margin: EdgeInsets.only( bottom: 5, right: 7, left: 50 ),
        padding: EdgeInsets.all( 8.0 ),
        child: Text( texto, style: TextStyle(color: Colors.white),),
        decoration: BoxDecoration(
          color: Color(0xff4D9EF6),
          borderRadius: BorderRadius.circular(20)
        ),
      ),
    );

  }
  Widget _notMyMessage() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: EdgeInsets.only( bottom: 5, right: 7, left: 5 ),
        padding: EdgeInsets.all( 8.0 ),
        child: Text( texto, style: TextStyle(color: Colors.black87),),
        decoration: BoxDecoration(
          color: Color(0xffE4E5E8),
          borderRadius: BorderRadius.circular(20)
        ),
      ),
    );

  }
}