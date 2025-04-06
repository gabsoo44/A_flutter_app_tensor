import 'package:a_flutter_app_tensor/services/thing_client.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// HomeScreen is the entry point of the app allowing the user
/// to select between Manual and Automatic operation modes.
/// It uses navigation via `go_router` to switch between screens.
class HomeScreen extends StatelessWidget {
  /// WebSocket client used to pass to other screens if needed
  final ThingClient thingClient;

  const HomeScreen({super.key, required this.thingClient});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Mode de fonctionnement')),

        // Centered layout with navigation buttons
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Button to navigate to Manual Mode screen
              ElevatedButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text('Mode Manuel'),
                onPressed: () {
                  print("→ Mode Manuel clicked");
                  context.go('/manual'); // GoRouter navigation
                },
              ),
              
              const SizedBox(height: 20),

              // Button to navigate to Automatic Mode screen
              ElevatedButton.icon(
                icon: const Icon(Icons.auto_mode),
                label: const Text('Mode Automatique'),
                onPressed: () => context.go('/auto'),
              ),
            ],
          ),
        ),
      );
}
