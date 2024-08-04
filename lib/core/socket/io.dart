//create a singleton socket io instance

import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../constants/app_constants.dart';

class SocketIO {
  static final SocketIO _singleton = SocketIO._internal();
  late IO.Socket socket;

  factory SocketIO() {
    return _singleton;
  }

  SocketIO._internal() {
    socket = IO.io(AppConstants.baseUrl, <String, dynamic>{
      "transports": ["websocket"],
      'autoConnect': true,
    });
  }
}
