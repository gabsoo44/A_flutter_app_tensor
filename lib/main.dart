import 'package:a_flutter_app_tensor/screens/home_screen.dart';
import 'package:flutter/material.dart';

// Point d'entrée principal de l'application
void main() => runApp(MyApp());

// Widget principal de l'application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false, // Supprime le bandeau "debug" en haut à droite
        title: 'Capteur Température',       // Nom de l'application
        theme: ThemeData(primarySwatch: Colors.blue), // Thème de base
        home: const HomeScreen(),           // Premier écran affiché au lancement
      );
}
