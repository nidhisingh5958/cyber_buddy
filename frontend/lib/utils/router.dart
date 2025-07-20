import 'package:cyber_buddy/screens/chat_screen.dart';
import 'package:cyber_buddy/screens/home_screen.dart';
import 'package:cyber_buddy/screens/script_screen.dart';
import 'package:cyber_buddy/screens/settings_screen.dart';
import 'package:cyber_buddy/screens/tools_screen.dart';
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
        GoRoute(
          path: '/tools',
          name: RouteConstants.tools,
          builder: (BuildContext context, GoRouterState state) {
            return ToolsScreen();
          },
        ),
        GoRoute(
          path: '/logs',
          name: RouteConstants.logs,
          builder: (BuildContext context, GoRouterState state) {
            return LogsScreen();
          },
        ),
        GoRoute(
          path: '/scriptGenerator',
          name: RouteConstants.scriptGenerator,
          builder: (BuildContext context, GoRouterState state) {
            return ScriptGeneratorScreen();
          },
        ),
      ],
    ),
    GoRoute(
      path: '/settings',
      name: RouteConstants.settings,
      builder: (BuildContext context, GoRouterState state) {
        return SettingsScreen();
      },
    ),
  ],
);
