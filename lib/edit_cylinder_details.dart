import 'package:flutter/material.dart';
import 'package:gasguard_final/services/firestore_service.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'header.dart';
import 'models/Cylinder.dart'; // Importing the Header widget

class EditCylinderDetails extends StatefulWidget {
  final Cylinder cylinder; // Accept a Cylinder object

  const EditCylinderDetails(this.cylinder, {super.key});

  @override
  State<EditCylinderDetails> createState() => _EditCylinderDetailsState();
}

class _EditCylinderDetailsState extends State<EditCylinderDetails> {
  late final TextEditingController _cylinderNameController;
  late final TextEditingController _cylinderWeightController;
  late final TextEditingController _cylinderTypeController;
  late final TextEditingController _startDateController;
  late final TextEditingController _renewalDateController;

  final FirestoreService _firestoreService = FirestoreService();

  final double _labelPadding = 30;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with the Cylinder values
    _cylinderNameController = TextEditingController(text: widget.cylinder.name);
    _cylinderWeightController = TextEditingController(text: widget.cylinder.currentWeight.toString()+"/"+widget.cylinder.weight.toString());
    _cylinderTypeController = TextEditingController(text: widget.cylinder.type ?? '');
    _startDateController = TextEditingController(text: widget.cylinder.startDate ?? '');
    _renewalDateController = TextEditingController(text: widget.cylinder.renewalDate ?? '');
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    _cylinderNameController.dispose();
    _cylinderWeightController.dispose();
    _cylinderTypeController.dispose();
    _startDateController.dispose();
    _renewalDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        controller.text = "${selectedDate.year}/${selectedDate.month}/${selectedDate.day}";
      });
    }
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
              Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Navigate back to the previous UI
                          Navigator.pushNamed(context,'/cylinderDetails');
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
                    "Edit Cylinder Details",
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
              _buildLabel("Cylinder Name*", fontSize: 18, color: const Color.fromARGB(255, 20, 70, 34)),
              _buildTextField(controller: _cylinderNameController, width: 410, height: 52),
              const SizedBox(height: 16),
              _buildLabel("Cylinder weight(kg)*", fontSize: 18, color: const Color.fromARGB(255, 20, 70, 34)),
              _buildTextField(controller: _cylinderWeightController, width: 410, height: 52),
              const SizedBox(height: 16),
              _buildLabel("Cylinder Type*", fontSize: 18, color: const Color.fromARGB(255, 20, 70, 34)),
              _buildTextField(controller: _cylinderTypeController, width: 410, height: 52),
              const SizedBox(height: 16),
              _buildLabel("Start date", fontSize: 18, color: const Color.fromARGB(255, 20, 70, 34)),
              GestureDetector(
                // onTap: () => _selectDate(context, _startDateController),
                child: _buildTextField(controller: _startDateController, width: 410, height: 52, enabled: false, dateField: true),
              ),
              const SizedBox(height: 16),
              _buildLabel("Renewal date", fontSize: 18, color: const Color.fromARGB(255, 20, 70, 34)),
              GestureDetector(
                // onTap: () => _selectDate(context, _renewalDateController),
                child: _buildTextField(controller: _renewalDateController, width: 410, height: 52, enabled: false, dateField: true),
              ),
              const SizedBox(height: 32),
              _buildButton("Renew", const Color(0xFF66BB6A), 410, 39),
              const SizedBox(height: 16),
              _buildButton("Save", const Color(0xFF004B23), 410, 39),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, {double fontSize = 16, Color color = Colors.black}) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: _labelPadding),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required double width,
    required double height,
    bool enabled = false,
    bool dateField = false,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: TextField(
        controller: controller,
        enabled: enabled,
        style: TextStyle(color: dateField ? Colors.black : Colors.black),
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildButton(String text, Color color, double width, double height) {
    return ElevatedButton(
      onPressed: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? username = prefs.getString('username');
        if (text == "Renew") {
          showDialog(
            context: context,
            barrierDismissible: false, // Disable dismissal by tapping outside
            builder: (BuildContext context) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          );
          bool isUpdated = await _firestoreService.renew(username,widget.cylinder.id,widget.cylinder.weight);// here i want to use cylinder weight attribute of the passed cylinder
          Navigator.pop(context);
          if (isUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Cylinder Renewed Successfully!'),
                backgroundColor: Color(0xFF004B23),
                duration: Duration(seconds: 3),
              ),
            );
            Navigator.pushReplacementNamed(context, '/cylinderDetails');
          }else{
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Renew operation cancelled!'),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 3),
              ),
            );
          }
        } else if (text == "Save") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cylinder saved Successfully!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(vertical: height / 2, horizontal: width / 3),
        minimumSize: Size(width, height),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
