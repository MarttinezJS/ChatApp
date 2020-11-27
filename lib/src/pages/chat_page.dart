import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:chat_app/src/models/mensajes_response.dart';
import 'package:chat_app/src/services/auth_service.dart';
import 'package:chat_app/src/services/chat_service.dart';
import 'package:chat_app/src/services/socket_service.dart';
import 'package:chat_app/src/widgets/chat_message.dart';


class ChatPage extends StatefulWidget {

  
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {

  final _textCtrl = TextEditingController();
  final _focusNode = FocusNode();

  ChatService chatService;
  SocketService socketService;
  AuthService authService;

  bool estaEscribiendo = false;
  List<ChatMessage> _messages = [];
  @override
  void initState() {
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);

    socketService.socket.on('mensaje-personal', (data) => _escucharMensaje);

    _cargarHistorial( chatService.usuarioReceptor.uid );
    super.initState();
  }
    
  @override
  Widget build(BuildContext context) {

    final usuarioRecptor = chatService.usuarioReceptor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              child: Text( usuarioRecptor.nombre.substring(0,2) , style: TextStyle(fontSize: 12.0),),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
            ),
            Container(
              margin: EdgeInsets.only( left: 5.0 ),
              child: Column(
              children: [
                SizedBox(height: 3.0,),
                Text(usuarioRecptor.nombre, style: TextStyle(color: Colors.black87, fontSize: 12),)
              ],
          ),
            ),
        ]),
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: _messages.length,
                itemBuilder: (_, i) => _messages[i],
                reverse: true,
              ),
            ),
            Divider( height: 1,),
            Container(
              color: Colors.white,
              child: _inputChat(),
            )
          ],
        ),
      ),
    );
  }

  Widget _inputChat(){
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [

            Flexible(
              child: TextField(
                controller: _textCtrl,
                onSubmitted: _handleSubmit,
                onChanged: ( String texto ){
                  if ( texto.trim().length > 0 ) {
                    estaEscribiendo = true;
                  } else {
                    estaEscribiendo = false;
                  }
                  setState(() {});
                },
                decoration: InputDecoration.collapsed(
                  hintText: 'Enviar Mensaje'
                ),
                focusNode: _focusNode,
              )
            ),

            Container(
              margin: EdgeInsets.symmetric( horizontal: 4.0 ),
              child: Container(
                margin: EdgeInsets.all( 4 ),
                child: IconTheme(
                  data: IconThemeData( color: Colors.blue[400] ),
                  child: IconButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    icon: Icon( Icons.send_sharp, ),
                    onPressed: estaEscribiendo 
                    ? () => _handleSubmit( _textCtrl.text.trim() ) 
                    : null,
                  ),
                ),
              ),
              // child: Platform.isAndroid,
            )
          ],
        ),
      ),
    );
  }

  _handleSubmit( String texto ){
  
    if (texto.length == 0) return;

    final newMessage = new ChatMessage(
      uid: authService.usuario.uid,
      texto: texto,
      animationCtrl: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 400)
      ),
    );
    _messages.insert(0, newMessage);
    newMessage.animationCtrl.forward();
    _textCtrl.clear();
    setState(() {
      estaEscribiendo = false;
    });

    socketService.emit('mensaje-personal', {
      'de'  : authService.usuario.uid,
      'para': chatService.usuarioReceptor.uid,
      'mensaje': texto
    });
  }

  void _cargarHistorial(String uid) async {

    List<Mensaje> chat = await chatService.getChat( uid );

    final historial = chat.map((m) => ChatMessage(
      texto: m.mensaje,
      uid: m.de,
      animationCtrl: AnimationController( vsync: this, duration: Duration.zero )..forward()
    ));

    setState(() {
      _messages.insertAll(0, historial);
    });
  }
      
  void _escucharMensaje( dynamic data ) {
    ChatMessage messageIn = ChatMessage(
      texto: data['mensaje'],
      uid: data['mensaje'],
      animationCtrl: AnimationController( vsync: this, duration: Duration( milliseconds: 300 ) ),
    );

    setState(() {
      _messages.add( messageIn );
    });

    messageIn.animationCtrl.forward();
  }

  @override
  void dispose() {
    _messages.forEach((message) {
      message.animationCtrl.dispose();
    });

    socketService.socket.off('mensaje-personal');
    super.dispose();
  }

}