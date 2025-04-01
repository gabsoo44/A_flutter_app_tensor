import 'package:a_flutter_app_tensor/screens/home_screen.dart';
import 'package:flutter/material.dart';

/// Root widget of the application.
/// Configures the app's theme, title, and initial home screen.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override

  /// Builds the MaterialApp instance, disabling the debug banner
  /// and setting the default theme and home screen.
  Widget build(BuildContext context) => MaterialApp(
        // Removes the "debug" banner in top-right corner
        debugShowCheckedModeBanner: false,
        // Application title shown in system UI
        title: 'Capteur Température',
        // Base theme configuration
        theme: ThemeData(primarySwatch: Colors.blue),
        // First screen displayed on launch
        home: const HomeScreen(),
      );
}
