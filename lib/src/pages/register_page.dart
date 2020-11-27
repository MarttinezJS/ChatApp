import 'package:chat_app/src/helpers/alert_informativa.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:chat_app/src/services/socket_service.dart';
import 'package:chat_app/src/services/auth_service.dart';
import 'package:chat_app/src/widgets/custom_botton_widget.dart';
import 'package:chat_app/src/widgets/custom_input_widget.dart';
import 'package:chat_app/src/widgets/custom_label_widget.dart';
import 'package:chat_app/src/widgets/custom_logo_widget.dart';


class RegisterPage extends StatelessWidget {

  static final routeName = 'login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomLogo(
                  mensaje: 'Registro',
                ),
                _Form(),
                CustomLabel(
                  pregunta: '¿Ya tienes una?',
                  mensaje: 'Ingresa ahora',
                  ruta: 'login',
                ),
                Text('Terminos y condiciones de uso', style: TextStyle(fontWeight: FontWeight.w200),)
              ],
            ),
          ),
        ),
      )
   );
  }
}

class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {

  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final nameCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    return Container(
      margin: EdgeInsets.only(top: 40.0),
      padding: EdgeInsets.symmetric( horizontal: 50.0),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.perm_identity_outlined,
            placeholder: 'Nombre',
            textCtrl: nameCtrl,
          ),
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: 'Correo',
            keyboardType: TextInputType.emailAddress,
            textCtrl: emailCtrl,
          ),
          CustomInput(
            icon: Icons.lock_open_outlined,
            placeholder: 'Contraseña',
            isPassword: true,
            textCtrl: passCtrl,
          ),
          CustomBottom(
            callback: authService.autenticando 
            ? null
            : () async {
              FocusScope.of(context).unfocus();

              final registerOk = await authService.register( emailCtrl.text.trim(), passCtrl.text.trim(),nameCtrl.text.trim() );

              if ( registerOk == true ) {
                socketService.connect();
                Navigator.pushReplacementNamed(context, 'usuarios');
              } else {
                mostrarAlerta(context, 'Error al registrar', registerOk);
              }
            },
            label: 'Ingresar',
          )
        ],
      ),
    );
  }
}
