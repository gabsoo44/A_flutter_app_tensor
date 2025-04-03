import 'package:flutter/material.dart';

/// A reusable form widget that allows the user to manually enter
/// temperature and humidity values.
/// On submission, validated input values are passed back to the parent via a callback.
class DataInputForm extends StatefulWidget {
  /// Callback to return validated input values to the parent widget
  final void Function(double, double) onSubmit;

  /// Requires an `onSubmit` function to process the form values externally.
  const DataInputForm({required this.onSubmit, super.key});

  @override
  State<DataInputForm> createState() => _DataInputFormState();
}

/// State class for the DataInputForm.
/// Handles form state, input validation, and value submission.
class _DataInputFormState extends State<DataInputForm> {
  // Key used to manage the validation state of the form
  final _formKey = GlobalKey<FormState>();

  // Controllers to retrieve text input from the user
  final _tempController = TextEditingController();
  final _humidityController = TextEditingController();

  /// Called when the "Add" button is pressed.
  /// Validates the form, parses input, and sends data through the callback.
  void _submit() {
    if (_formKey.currentState!.validate()) {
      final temp = double.parse(_tempController.text);
      final humidity = double.parse(_humidityController.text);

      // Send valid input values back to the parent
      widget.onSubmit(temp, humidity);

      // Clear input fields after submission
      _tempController.clear();
      _humidityController.clear();
    }
  }

  /// Frees controller resources when the widget is disposed.
  @override
  void dispose() {
    _tempController.dispose();
    _humidityController.dispose();
    super.dispose();
  }

  @override

  /// Builds the form with two input fields and a submit button.
  /// Validates that values are within expected bounds (0–40).
  Widget build(BuildContext context) => Form(
        key: _formKey,
        child: Column(
          children: [
            // Input field for temperature value (expected range: 0–40)
            TextFormField(
              controller: _tempController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Temperature (°C)'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter a temperature';
                }
                final val = double.tryParse(value);
                if (val == null || val < 0 || val > 40) {
                  return 'Invalid value';
                }
                return null;
              },
            ),

            // Input field for humidity value (expected range: 0–40)
            TextFormField(
              controller: _humidityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Humidity (%)'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter humidity';
                }
                final val = double.tryParse(value);
                if (val == null || val < 0 || val > 40) {
                  return 'Invalid value';
                }
                return null;
              },
            ),

            const SizedBox(height: 10),

            // Button to submit the form
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Add'),
            )
          ],
        ),
      );
}
