import 'package:cyber_buddy/screens/chat_screen.dart';
import 'package:cyber_buddy/screens/home_screen.dart';
import 'package:cyber_buddy/utils/route_constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: '/home',
  routes: <RouteBase>[
    GoRoute(
      path: '/home',
      name: RouteConstants.home,
      builder: (BuildContext context, GoRouterState state) {
        return DesktopHomePage();
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/chat',
          name: RouteConstants.chat,
          builder: (BuildContext context, GoRouterState state) {
            return ChatScreen();
          },
        ),
      ],
    ),
  ],
);
