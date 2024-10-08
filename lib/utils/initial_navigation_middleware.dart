import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:merkastu_v2/config/storage_config.dart';

class InitialNavigationMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // Check if the user is logged in
    bool isAuthenticated = ConfigPreference.isUserLoggedIn();
    if (!isAuthenticated) {
      return const RouteSettings(name: '/login'); // Redirect to login page
    }
    return null; // Allow the navigation
  }
}
