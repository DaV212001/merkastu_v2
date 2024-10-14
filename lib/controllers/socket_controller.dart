import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import 'auth_controller.dart';

class SocketController extends GetxController {
  var testValue = false.obs;
  final userData = UserController.user.value;
  late var socket = io
      .io(
        'https://merkastu.endevour.org',
        io.OptionBuilder().setTransports(['websocket']).build(),
      )
      .obs;

  var isSocketConnected = false.obs;
  Function(Object data)? eventHandler;

  @override
  void onInit() {
    super.onInit();
    Logger().d('ID ${userData.id}');
    connectToSocket();
    socket.value.onConnect(_onConnect);
    socket.value.on('${userData.id}', _onEvent);
    socket.value.on('all', _onEvent);
    socket.value.onDisconnect(_onDisconnect);
  }

  @override
  void onClose() {
    socket.value.disconnect();
    socket.value.dispose();
    super.onClose();
  }

  void connectToSocket() {
    try {
      socket.value.connect();
    } catch (e, stack) {
      Logger().t(e, stackTrace: stack);
    }
    isSocketConnected.value = true;
  }

  void _onConnect(_) {
    Logger().i('Socket connected');
  }

  void _onEvent(dynamic data) async {
    Logger().i('Socket data $data');
    try {
      // Logger().d(data);

      await eventHandler?.call(data);
    } catch (e, stack) {
      Logger().t(e, stackTrace: stack);
    }
  }

  void setEventHandler(Function(dynamic data) handler) {
    eventHandler = handler;
  }

  void _onDisconnect(_) {}
}
