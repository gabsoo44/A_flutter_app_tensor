// Import of both screen options: manual mode and automatic mode
import 'package:a_flutter_app_tensor/screens/auto_mode_screen.dart';
import 'package:a_flutter_app_tensor/screens/manual_mode_screen.dart';
import 'package:flutter/material.dart';

/// Home screen of the application.
/// Provides access to manual and automatic telemetry modes via buttons.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override

  /// Builds the UI for the home screen, presenting two buttons to navigate to different modes.
  Widget build(BuildContext context) => Scaffold(
        // Application header with title
        appBar: AppBar(title: const Text('Mode de fonctionnement')),

        // Vertically centered body content
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Button to navigate to the manual input mode
              ElevatedButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text('Mode Manuel'),
                onPressed: () async {
                  // Navigate to the manual mode screen using push
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ManualModeScreen()),
                  );
                },
              ),

              // Spacing between buttons
              const SizedBox(height: 20),

              // Button to navigate to the automatic sensor simulation mode
              ElevatedButton.icon(
                icon: const Icon(Icons.auto_mode),
                label: const Text('Mode Automatique'),
                onPressed: () async {
                  // Navigate to the automatic mode screen using push
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AutoModeScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      );
}
