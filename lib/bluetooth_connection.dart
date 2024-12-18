import 'package:flutter/material.dart';

class BluetoothConnectionScreen extends StatefulWidget {
  const BluetoothConnectionScreen({super.key});

  @override
  _BluetoothConnectionScreenState createState() => _BluetoothConnectionScreenState();
}

class _BluetoothConnectionScreenState extends State<BluetoothConnectionScreen> {
  String? _selectedDevice;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8, // 80% of the screen width
        child: AlertDialog(
          backgroundColor: const Color.fromARGB(255, 200, 232, 213), // Light green background
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          titlePadding: const EdgeInsets.only(top: 20),
          title: const Center(
            child: Text(
              'Bluetooth Connection',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 18,
                fontFamily: 'Montserrat', // Use Montserrat font
              ),
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select your Bluetooth connection \n for measuring device with the app',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontFamily: 'Montserrat', // Use Montserrat font
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDevice = 'Bluetooth Measure 1';
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: _selectedDevice == 'Bluetooth Measure 1'
                            ? const Color.fromARGB(255, 80, 83, 71) // Dark green background if selected
                            : const Color.fromARGB(208, 140, 250, 184), // Yellowish background if not selected
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Bluetooth Measure 1',
                            style: TextStyle(
                              fontSize: 16,
                              color: _selectedDevice == 'Bluetooth Measure 1'
                                  ? Colors.white // White text if selected
                                  : Colors.black, // Black text if not selected
                              fontFamily: 'Montserrat', // Use Montserrat font
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDevice = 'Bluetooth Measure 2';
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: _selectedDevice == 'Bluetooth Measure 2'
                            ? const Color.fromARGB(255, 80, 83, 71) // Dark green background if selected
                            : const Color.fromARGB(208, 140, 250, 184), // Yellowish background if not selected
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Bluetooth Measure 2',
                            style: TextStyle(
                              fontSize: 16,
                              color: _selectedDevice == 'Bluetooth Measure 2'
                                  ? Colors.white // White text if selected
                                  : Colors.black, // Black text if not selected
                              fontFamily: 'Montserrat', // Use Montserrat font
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actionsPadding: const EdgeInsets.only(bottom: 10),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_selectedDevice != null) {
                    Navigator.pushReplacementNamed(context, '/home'); // Navigate to HomePage
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select a device to connect.')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF004B23), // Dark green color for button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                ),
                child: const Text(
                  'Connect',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Montserrat', // Use Montserrat font
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}