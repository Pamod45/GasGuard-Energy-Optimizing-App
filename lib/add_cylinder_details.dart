// add_cylinder_details.dart
import 'package:flutter/material.dart';
import 'package:gasguard_final/services/firestore_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'header.dart';
import 'models/Cylinder.dart'; // Importing the Header widget
import 'package:intl/intl.dart';

class AddCylinderDetails extends StatefulWidget {
  const AddCylinderDetails({super.key});

  @override
  State<AddCylinderDetails> createState() => _AddCylinderDetailsState();
}

class _AddCylinderDetailsState extends State<AddCylinderDetails> {
  final TextEditingController _cylinderNameController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();

  String? _selectedWeight;
  String? _selectedType;

  @override
  void initState() {
    super.initState();
    _startDateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  @override
  void dispose() {
    _cylinderNameController.dispose();
    _startDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 200, 232, 213),
      appBar: const Header(title: 'Cylinder Details'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header
              Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Image.asset(
                          'assets/Chevron Up.png',
                          width: 32,
                          height: 32,
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    "New Cylinder Details",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      color: Color.fromARGB(255, 20, 70, 34),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Cylinder Name Field
              _buildLabel("Cylinder Name*"),
              _buildTextField(_cylinderNameController),
              const SizedBox(height: 16),
              // Cylinder Type Dropdown
              _buildLabel("Cylinder Type*"),
              _buildDropdown(
                ["Litro", "Laugh", "Other"],
                "Select Type",
                _selectedType,
                    (value) {
                  setState(() {
                    _selectedType = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              // Cylinder Weight Dropdown
              _buildLabel("Cylinder Weight*"),
              _buildDropdown(
                ["12.5kg", "5kg", "2kg"],
                "Select Weight",
                _selectedWeight,
                (value) {
                  setState(() {
                    _selectedWeight = value;
                  });
                },
              ),


              const SizedBox(height: 16),
              // Start Date Field
              _buildLabel("Start Date"),
              GestureDetector(
                onTap: () {
                  // _selectDate(context);
                },
                child: _buildTextField(
                  _startDateController,
                  enabled: false,
                ),
              ),
              const SizedBox(height: 32),
              // Buttons
              _buildButton("Discard", const Color(0xFF66BB6A), () {
                // Clear all fields when discard is pressed
                _clearFields();
                // Navigate to cylinder details screen
                Navigator.pushNamed(context, '/cylinderDetails');
              }),
              const SizedBox(height: 16),
              _buildButton("Save", const Color(0xFF004B23), () async {
                if (_cylinderNameController.text.isEmpty || _cylinderNameController.text.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: const Text('Please enter a cylinder name'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                  return;
                }

                if (_selectedType == null || _selectedType == '') {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: const Text('Please select a cylinder type to continue'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                  return;
                }

                if (_selectedWeight == null || _selectedWeight == '') {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: const Text('Please select a cylinder weight to continue'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                  return;
                }
                // Get username from SharedPreferences
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String? username = prefs.getString('username');

                if (username == null) {
                  print('Failed to retrieve username. Please login again.');
                  return;
                }
                String weight = _selectedWeight == null ? '0kg' : _selectedWeight.toString();
                double numericWeight = double.parse(weight.replaceAll("kg", ""));
                final cylinder = Cylinder(
                  name: _cylinderNameController.text,
                  type: _selectedType.toString(),
                  weight: numericWeight,
                  currentWeight: numericWeight,
                  startDate: DateFormat('dd/MM/yyyy').format(DateTime.now())
                );
                showDialog(
                  context: context,
                  barrierDismissible: false,  // Disable dismissal when tapping outside
                  builder: (BuildContext context) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );

                final firestore = FirestoreService();
                int success = await firestore.addCylinder(username, cylinder);
                print("id :$success");

                if (success > -1) {
                  // Show the success dialog
                  Navigator.pop(context);
                  await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Cylinder Added'),
                      content: const Text('New Cylinder is successfully added'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context), // Close the dialog
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                  Navigator.pushReplacementNamed(context, '/cylinderDetails');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Cylinder added Successfully!'),
                      backgroundColor: Color(0xFF004B23),
                      duration: Duration(seconds: 3),
                    ),
                  );
                } else {
                  // Show the error dialog
                  Navigator.pop(context);
                  await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Error'),
                      content: const Text('Please try again, something went wrong.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context), // Close the dialog
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  // Clear all fields
  void _clearFields() {
    _cylinderNameController.clear();
    _startDateController.clear();
    _selectedWeight = null;
    _selectedType = null;
    setState(() {});
  }

  // Label
  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: 'Montserrat',
          color: Color.fromARGB(255, 20, 70, 34),
        ),
      ),
    );
  }

  // TextField
  Widget _buildTextField(TextEditingController controller, {bool enabled = true}) {
    return TextField(
      controller: controller,
      enabled: enabled,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  // Dropdown
  Widget _buildDropdown(List<String> items, String hint, String? value, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
      value: value,
      hint: Text(hint),
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
      onChanged: onChanged,
    );
  }

  // Button
  Widget _buildButton(String text, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'Montserrat',
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // Date Picker
  Future<void> _selectDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      _startDateController.text = "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
    }
  }
}
