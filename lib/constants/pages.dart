import 'package:get/get.dart';
import 'package:merkastu_v2/screens/auth/log_in_screen.dart';
import 'package:merkastu_v2/screens/auth/login_prompter.dart';
import 'package:merkastu_v2/screens/auth/phone_verification_screen.dart';
import 'package:merkastu_v2/screens/auth/sign_up_screen.dart';
import 'package:merkastu_v2/screens/favorites/favorite_products_screen.dart';
import 'package:merkastu_v2/screens/favorites/favorite_restaurants_screen.dart';
import 'package:merkastu_v2/screens/favorites/favorites_screen.dart';
import 'package:merkastu_v2/screens/home/store_detail_screen.dart';
import 'package:merkastu_v2/screens/home/store_list_screen.dart';
import 'package:merkastu_v2/screens/main_layout_screen.dart';
import 'package:merkastu_v2/screens/order/check_out_screen.dart';
import 'package:merkastu_v2/screens/order/order_detail_screen.dart';
import 'package:merkastu_v2/screens/settings/password/forgot_password_screen.dart';
import 'package:merkastu_v2/screens/settings/settings_screen.dart';
import 'package:merkastu_v2/screens/settings/wallet/wallet_history_screen.dart';
import 'package:merkastu_v2/utils/initial_navigation_middleware.dart';

import '../screens/order/cart_screen.dart';
import '../screens/order/order_history_screen.dart';
import '../screens/settings/app_documentation/about_us_screen.dart';
import '../screens/settings/app_documentation/privacy_policy_screen.dart';
import '../screens/settings/app_documentation/terms_and_conditions_screen.dart';
import '../screens/settings/password/change_password_screen.dart';
import '../screens/settings/profile/profile_screen.dart';
import '../screens/settings/wallet/fill_wallet_screen.dart';

class Routes {
  static String get initialRoute => '/home';
  static String get loginRoute => '/login';
  static String get signupRoute => '/signup';
  static String get favoritesProductsRoute => '/f_products';
  static String get favoritesRestaurantsRoute => '/f_restaurants';
  static String get favoritesRoute => '/favorites';
  static String get restaurantsRoute => '/restaurants';
  static String get restaurantDetailRoute => '/restaurant_detail';
  static String get checkoutRoute => '/checkout';
  static String get ordersHistoryRoute => '/orders_history';
  static String get orderDetailRoute => '/order_detail';
  static String get cartRoute => '/orders';
  static String get aboutRoute => '/about';
  static String get privacyRoute => '/privacy';
  static String get termsRoute => '/terms';
  static String get changePasswordRoute => '/change_password';
  static String get forgotPasswordRoute => '/forgot_password';
  static String get profileRoute => '/profile';
  static String get walletHistoryRoute => '/wallet_history';
  static String get fillWalletRoute => '/fill_wallet';
  static String get settingsRoute => '/settings';
  static String get phoneVerifyRoute => '/phone_verify';
  static String get loginPromptRoute => '/login_prompt';
}

class Pages {
  static final pages = [
    GetPage(
      name: Routes.initialRoute,
      page: () => MainLayoutScreen(),
    ),
    /////////////////////////////////
    //auth
    GetPage(
      name: Routes.loginRoute,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: Routes.signupRoute,
      page: () => const SignUpScreen(),
    ),
    GetPage(
        name: Routes.phoneVerifyRoute,
        page: () => const PhoneVerificationScreen()),
    //////////////////////////////////
    //favorites
    GetPage(
      name: Routes.favoritesProductsRoute,
      page: () => const FavoriteProductsScreen(),
    ),
    GetPage(
      name: Routes.favoritesRestaurantsRoute,
      page: () => const FavoriteRestaurantsScreen(),
    ),
    GetPage(
      name: Routes.favoritesRoute,
      page: () => FavoritesScreen(),
      middlewares: [
        InitialNavigationMiddleware(),
      ],
    ),
    //////////////////////////////////
    //home
    GetPage(
      name: Routes.restaurantsRoute,
      page: () => StoreListScreen(),
    ),
    GetPage(
      name: Routes.restaurantDetailRoute,
      page: () => StoreDetailScreen(),
    ),
    ///////////////////////////////////
    //order
    GetPage(
      name: Routes.checkoutRoute,
      page: () => CheckOutScreen(),
      middlewares: [
        InitialNavigationMiddleware(),
      ],
    ),
    GetPage(
      name: Routes.ordersHistoryRoute,
      page: () => OrderHistoryScreen(),
      middlewares: [
        InitialNavigationMiddleware(),
      ],
    ),
    GetPage(
      name: Routes.orderDetailRoute,
      page: () => OrderDetailScreen(),
      middlewares: [
        InitialNavigationMiddleware(),
      ],
    ),
    GetPage(
      name: Routes.cartRoute,
      page: () => CartScreen(),
    ),
    ////////////////////////////////////
    //settings
    GetPage(
      name: Routes.aboutRoute,
      page: () => const AboutUsScreen(),
    ),
    GetPage(
      name: Routes.privacyRoute,
      page: () => const PrivacyPolicyScreen(),
    ),
    GetPage(
      name: Routes.termsRoute,
      page: () => const TermsAndConditionsScreen(),
    ),
    GetPage(
      name: Routes.changePasswordRoute,
      page: () => const ChangePasswordScreen(),
    ),
    GetPage(
      name: Routes.forgotPasswordRoute,
      page: () => const ForgotPasswordScreen(),
    ),
    GetPage(
      name: Routes.profileRoute,
      page: () => const ProfileScreen(),
      middlewares: [
        InitialNavigationMiddleware(),
      ],
    ),
    GetPage(name: Routes.walletHistoryRoute, page: () => WalletHistoryScreen()),
    GetPage(name: Routes.fillWalletRoute, page: () => FillWalletScreen()),
    GetPage(name: Routes.loginPromptRoute, page: () => const LoginPrompter()),
    GetPage(
      name: Routes.settingsRoute,
      page: () => SettingsScreen(),
    ),
  ];
}
