import 'package:a_flutter_app_tensor/router.dart';
import 'package:flutter/material.dart';

/// Root widget of the application using GoRouter for navigation.
/// Configures the app's theme, title, and router settings.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        // Removes the "debug" banner in top-right corner
        debugShowCheckedModeBanner: false,
        // Application title shown in system UI
        title: 'Capteur Température',
        // Base theme configuration
        theme: ThemeData(primarySwatch: Colors.blue),
        // GoRouter integration
        routerConfig: appRouter,
      );
}

