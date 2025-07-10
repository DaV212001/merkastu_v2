import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:merkastu_v2/constants/constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import 'auth_controller.dart';

class SocketController extends GetxController {
  var testValue = false.obs;
  final userData = UserController.user.value;
  late var socket = io
      .io(
        '$kApiBaseUrl/',
        io.OptionBuilder().setTransports(['websocket']).build(),
      )
      .obs;

  var isSocketConnected = false.obs;
  List<Function(Object data)?> eventHandlers = [];
  Function(Object data)? onAcceptOrderError;
  Function(Object data)? onCancelOrderError;

  @override
  void onInit() {
    super.onInit();
    Logger().d('ID ${userData.id}');
    connectToSocket();
    socket.value.onConnect(_onConnect);
    socket.value.on('${userData.id}-orderAcceptedByDeliveryPerson', _onEvent);
    socket.value.on('all', _onEvent);
    socket.value.on('${userData.id}-cancelOrderError', _onEvent);
    socket.value.on('${userData.id}-orderRecievError', _onAcceptOrderError);
    socket.value.on('${userData.id}-error', _onEvent);
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

  void _onCancelOrderError(data) {
    Logger().i('Socket data $data');
    try {
      onCancelOrderError?.call(data);
    } catch (e, stack) {
      Logger().t(e, stackTrace: stack);
    }
  }

  void _onAcceptOrderError(data) {
    Logger().i('Socket data $data');
    try {
      onAcceptOrderError?.call(data);
    } catch (e, stack) {
      Logger().t(e, stackTrace: stack);
    }
  }

  void _onEvent(dynamic data) async {
    Logger().i('Socket data $data');
    try {
      for (var eventHandler in eventHandlers) {
        await eventHandler?.call(data);
      }
    } catch (e, stack) {
      Logger().t(e, stackTrace: stack);
    }
  }

  void setEventHandler(Function(dynamic data) handler) {
    eventHandlers.add(handler);
  }

  void setCancelOrderErrorHandler(Function(dynamic data) handler) {
    onCancelOrderError = handler;
  }

  void setAcceptOrderErrorHandler(Function(dynamic data) handler) {
    onAcceptOrderError = handler;
  }

  void _onDisconnect(_) {}
}
