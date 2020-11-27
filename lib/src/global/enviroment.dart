

import 'dart:io';

class Enviroment {

  static String apiUrl = Platform.isAndroid ? 'http://192.168.20.32:25025' : 'http://localhost:25025';
  static String socketUrl = Platform.isAndroid ? 'http://192.168.20.32:25025' : 'http://localhost:25025';
}