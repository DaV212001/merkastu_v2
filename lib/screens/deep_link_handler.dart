import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:logger/logger.dart';
import 'package:merkastu_v2/config/storage_config.dart';

import '../controllers/auth_controller.dart';

class DeepLinkHandler {
  static StreamSubscription? _sub;

  static void initDeepLinkListener() {
    // Cancel any existing subscription
    _sub?.cancel();

    // Listen for incoming deep links
    _sub = AppLinks().uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        _handleDeepLink(uri);
      }
    }, onError: (err) {
      Logger().d("Error processing deep link: $err");
    });
  }

  static Future<void> _handleDeepLink(Uri uri) async {
    // Check for the `token` parameter in the deep link
    final token = uri.queryParameters['token'];
    if (token != null && token.isNotEmpty) {
      // Save the token to ConfigPreferences
      await ConfigPreference.setUserToken(token);

      // Call the UserController to get the logged-in user
      await UserController.getLoggedInUser();
    } else {
      Logger().d("No token found in deep link");
    }
  }

  static void dispose() {
    _sub?.cancel();
  }
}
