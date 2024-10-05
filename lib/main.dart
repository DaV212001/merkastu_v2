import 'package:flutter/material.dart';
import 'package:merkastu_v2/config/storage_config.dart';

import 'merkastu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ConfigPreference.init();
  runApp(const Merkastu());
}
