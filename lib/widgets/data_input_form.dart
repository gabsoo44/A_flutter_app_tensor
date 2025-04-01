import 'package:flutter/material.dart';

// Widget permettant à l'utilisateur de saisir manuellement des données de température et d'humidité
class DataInputForm extends StatefulWidget {
  final void Function(double, double) onSubmit;

  // Le formulaire prend une fonction onSubmit pour transmettre les valeurs saisies
  const DataInputForm({required this.onSubmit, super.key});

  @override
  State<DataInputForm> createState() => _DataInputFormState();
}

class _DataInputFormState extends State<DataInputForm> {
  final _formKey = GlobalKey<FormState>();

  // Contrôleurs pour récupérer les saisies utilisateur
  final _tempController = TextEditingController();
  final _humidityController = TextEditingController();

  // Fonction appelée lors du clic sur "Ajouter"
  void _submit() {
    if (_formKey.currentState!.validate()) {
      final temp = double.parse(_tempController.text);
      final humidity = double.parse(_humidityController.text);

      // Envoie les données au parent via la fonction fournie
      widget.onSubmit(temp, humidity);

      // Réinitialise les champs après validation
      _tempController.clear();
      _humidityController.clear();
    }
  }

  // Libère les ressources des TextEditingController quand le widget est détruit
  @override
  void dispose() {
    _tempController.dispose();
    _humidityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Form(
        key: _formKey,
        child: Column(
          children: [
            // Champ de saisie pour la température
            TextFormField(
              controller: _tempController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Température (°C)'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Entrez une température';
                }
                final val = double.tryParse(value);
                if (val == null || val < 0 || val > 50) {
                  return 'Valeur invalide';
                }
                return null;
              },
            ),

            // Champ de saisie pour l’humidité
            TextFormField(
              controller: _humidityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Humidité (%)'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Entrez une humidité';
                }
                final val = double.tryParse(value);
                if (val == null || val < 0 || val > 100) {
                  return 'Valeur invalide';
                }
                return null;
              },
            ),

            const SizedBox(height: 10),

            // Bouton pour valider la saisie
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Ajouter'),
            )
          ],
        ),
      );
}
