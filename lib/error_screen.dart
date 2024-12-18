// lib/error_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ErrorScreen extends StatelessWidget {
  final String title;
  final String message;

  const ErrorScreen({super.key, required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                message,
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Exit the app since the error is critical
                  SystemNavigator.pop();
                },
                child: const Text('Exit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
