import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Home screen of the application.
/// Provides access to manual and automatic telemetry modes via navigation buttons.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        // AppBar with screen title
        appBar: AppBar(title: const Text('Mode de fonctionnement')),

        // Centered body with two mode selection buttons
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Button to navigate to the manual input mode via GoRouter
              ElevatedButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text('Mode Manuel'),
                onPressed: () {
                  context.go('/manual');
                },
              ),

              // Spacing between buttons
              const SizedBox(height: 20),

              // Button to navigate to the automatic sensor simulation mode via GoRouter
              ElevatedButton.icon(
                icon: const Icon(Icons.auto_mode),
                label: const Text('Mode Automatique'),
                onPressed: () {
                  context.go('/auto');
                },
              ),
            ],
          ),
        ),
      );
}
