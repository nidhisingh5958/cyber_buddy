// In main.dart
import 'package:cyber_buddy/screens/home_screen.dart';
import 'package:cyber_buddy/utils/router.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure window
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = WindowOptions(
    size: Size(1200, 800),
    minimumSize: Size(800, 600),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden, // Custom title bar
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Cubby Buddy',
      debugShowCheckedModeBanner: false,
      // theme: theme(),
      routerConfig: router,
    );
  }
}
