import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schedcare_admin/providers/firebase_services_provider.dart';
import 'package:schedcare_admin/screens/authentication/login_screen.dart';
import 'package:schedcare_admin/screens/home/home_screen.dart';

final routerProvider = Provider<GoRouter>(
  (ref) {
    final router = RouterNotifier(ref);
    final authStateChangeNotifier = ref.watch(authStateChangeProvider);
    return GoRouter(
        refreshListenable: router,
        redirect: (BuildContext context, GoRouterState state) {
          if (authStateChangeNotifier.isLoading ||
              authStateChangeNotifier.hasError) return null;

          if (![LoginScreen.routePath, HomeScreen.routePath]
              .contains(state.location)) {
            return LoginScreen.routePath;
          }

          final isAuthenticated = authStateChangeNotifier.valueOrNull != null;
          final isLoggingIn = state.location == LoginScreen.routePath;

          if (isLoggingIn) {
            return isAuthenticated ? HomeScreen.routePath : null;
          }

          return isAuthenticated ? null : LoginScreen.routePath;
        },
        initialLocation: LoginScreen.routePath,
        routes: router.routes);
  },
);

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen(
      firebaseServicesProvider,
      (_, __) => notifyListeners(),
    );
  }

  List<GoRoute> get routes => [
        GoRoute(
          name: LoginScreen.routeName,
          path: LoginScreen.routePath,
          builder: (context, state) => LoginScreen(),
        ),
        GoRoute(
          name: HomeScreen.routeName,
          path: HomeScreen.routePath,
          builder: (context, state) => const HomeScreen(),
        )
      ];
}
