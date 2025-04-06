import 'package:a_flutter_app_tensor/services/thing_client.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  final ThingClient thingClient;

  const HomeScreen({super.key, required this.thingClient});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Mode de fonctionnement')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text('Mode Manuel'),
                onPressed: () {
                  print("→ Mode Manuel cliqué");
                  context.go('/manual');
                } 
              ),
              const SizedBox(height: 20),
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
