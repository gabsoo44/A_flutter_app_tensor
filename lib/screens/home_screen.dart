// Import des deux écrans possibles (mode manuel / mode automatique)
import 'package:a_flutter_app_tensor/screens/auto_mode_screen.dart';
import 'package:a_flutter_app_tensor/screens/manual_mode_screen.dart';
import 'package:flutter/material.dart';

// Écran d'accueil de l'application
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Mode de fonctionnement')),

        // Contenu centré verticalement
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Bouton pour accéder au mode manuel
              ElevatedButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text('Mode Manuel'),
                onPressed: () async {
                  // Navigation vers l'écran de saisie manuelle
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ManualModeScreen()),
                  );
                },
              ),
              const SizedBox(height: 20), // Espace entre les boutons

              // Bouton pour accéder au mode automatique
              ElevatedButton.icon(
                icon: const Icon(Icons.auto_mode),
                label: const Text('Mode Automatique'),
                onPressed: () async {
                  // Navigation vers l'écran automatique
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
