import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/auth_screen.dart';
import 'screens/main_app_shell.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/auth',
      builder: (BuildContext context, GoRouterState state) {
        return const AuthScreen();
      },
    ),
    GoRoute(
      path: '/dashboard',
      builder: (BuildContext context, GoRouterState state) {
        return const MainAppShell();
      },
    ),
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const MainAppShell();
      },
    ),
  ],
  redirect: (BuildContext context, GoRouterState state) {
    final bool loggedIn = Supabase.instance.client.auth.currentUser != null;
    final bool loggingIn = state.matchedLocation == '/auth';

    if (!loggedIn) {
      return loggingIn ? null : '/auth';
    }

    if (loggingIn) {
      return '/dashboard';
    }

    return null;
  },
);
