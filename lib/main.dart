import 'package:flutter/material.dart';
import 'package:merkastu_v2/config/storage_config.dart';

import 'controllers/auth_controller.dart';
import 'merkastu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ConfigPreference.init();

  UserController.getLoggedInUser();
  runApp(const Merkastu());
}
