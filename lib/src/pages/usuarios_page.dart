import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:chat_app/src/services/auth_service.dart';
import 'package:chat_app/src/services/chat_service.dart';
import 'package:chat_app/src/services/usuarios_service.dart';
import 'package:chat_app/src/services/socket_service.dart';
import 'package:chat_app/src/models/usuario.dart';


class UsuariosPage extends StatefulWidget {
  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {

  final usuariosServ = UsuariosService();
  
  RefreshController _refreshController = RefreshController(initialRefresh: false);


  List<Usuario> usuarios = [];

  @override
  void initState() {
    _cargarUsuarios();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context);
    final authService = Provider.of<AuthService>(context);
    final usuario = authService.usuario;

    return Scaffold(
      appBar: AppBar(
        title: Text( usuario.nombre , style: TextStyle(color: Colors.lightBlueAccent),),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon( Icons.exit_to_app_outlined, color: Colors.lightBlueAccent ),
          onPressed: () {
            socketService.disconect();
            Navigator.pushReplacementNamed(context, 'login');
            AuthService.deleteToken();
          }
        ),
        actions: [
          Container(
            margin: EdgeInsets.only( right: 10.0 ),
            child: socketService.serverStatus == ServerStatus.Online 
              ? Icon( Icons.check_circle_outline_outlined, color: Colors.green, )
              : Icon( Icons.wifi_off_outlined, color: Colors.red, ),
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _cargarUsuarios,
        header: WaterDropHeader(
          complete: Icon( Icons.check, color: Colors.blue[400],) ,
          waterDropColor: Colors.blue[400],
        ),
        child: _usuarioListView(),
      ),
   );
  }

  ListView _usuarioListView() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemCount: usuarios.length,
      separatorBuilder: (BuildContext context, int index) {
      return Divider();
     },
      itemBuilder: (BuildContext context, int index) {
      return _usuarioListTile( usuarios[index] );
     },
    );
  }

  ListTile _usuarioListTile(Usuario usuario) {
    return ListTile(
        title: Text(usuario.nombre),
        subtitle: Text( usuario.email ),
        leading: CircleAvatar(
          child: Text(usuario.nombre.substring( 0, 2 )),
          backgroundColor: Colors.blue[100],
        ),
        trailing: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: usuario.online? Colors.green : Colors.red,
            borderRadius: BorderRadius.circular(10)
          ),
        ),
        onTap: () {
          final chatServ = Provider.of<ChatService>(context, listen: false);
          chatServ.usuarioReceptor = usuario;
          Navigator.pushNamed(context, 'chat');
        }
      );
  }

  _cargarUsuarios() async {

    usuarios = await usuariosServ.getUsuarios();

    setState(() {});
    _refreshController.refreshCompleted();
  }
}