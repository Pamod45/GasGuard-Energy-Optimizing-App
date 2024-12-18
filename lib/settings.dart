import 'package:flutter/material.dart';
import 'package:gasguard_final/footer.dart';
import 'package:gasguard_final/services/firestore_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bluetooth_connection.dart';
import 'header.dart';
import 'models/User.dart'; // Import Bluetooth connection screen

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _dailyLimitEnabled = false;
  bool _monthlyLimitEnabled = false;
  bool _predictiveWarningsEnabled = false;
  bool _recommendationAlertsEnabled = false;
  bool _locationPermissionEnabled = false;
  bool _bluetoothEnabled = false; // Bluetooth state

  User? user;
  bool _isLoading = true;

  final _dailyLimitController = TextEditingController(text: '300');
  final _monthlyLimitController = TextEditingController(text: '10');
  final _daysRemainingController = TextEditingController(text: '3');


  @override
  void initState() {
    super.initState();
    _initializeSettings();
    _dailyLimitController.addListener(dailyLimitListener);
    _monthlyLimitController.addListener(monthlyLimitListener);
    _daysRemainingController.addListener(daysRemainingLimitListener);
  }

  void dailyLimitListener(){
    String currentText = _dailyLimitController.text;
    if(double.tryParse(currentText) != null){
      if(double.tryParse(currentText)! > 0 && double.tryParse(currentText) != user?.dailyLimit ){
        setState(() {
          _dailyLimitEnabled = true;
        });
      }else{
        setState(() {
          _dailyLimitEnabled = false;
        });
      }
    }else{
      setState(() {
        _dailyLimitEnabled = false;
      });
    }
  }

  void monthlyLimitListener(){
    String currentText = _monthlyLimitController.text;
    if(double.tryParse(currentText) != null){
      if(double.tryParse(currentText)! > 0 && double.tryParse(currentText) != user?.monthlyLimit ){
        setState(() {
          _monthlyLimitEnabled = true;
        });
      }else{
        setState(() {
          _monthlyLimitEnabled = false;
        });
      }
    }else{
      setState(() {
        _monthlyLimitEnabled = false;
      });
    }
  }

  void daysRemainingLimitListener(){
    String currentText = _daysRemainingController.text;
    if(int.tryParse(currentText) != null){
      if(int.tryParse(currentText)! > 0 && int.tryParse(currentText) != user?.daysRemaining ){
        setState(() {
          _predictiveWarningsEnabled = true;
        });
      }else{
        setState(() {
          _predictiveWarningsEnabled = false;
        });
      }
    }else{
      setState(() {
        _predictiveWarningsEnabled = false;
      });
    }
  }

  @override
  void dispose() {
    _dailyLimitController.dispose();
    _monthlyLimitController.dispose();
    _daysRemainingController.dispose();
    super.dispose();
  }

  Future<void> _initializeSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    user = await FirestoreService().getUserByUsername(username!);
    if (user != null) {
      setState(() {
        _dailyLimitController.text = user?.dailyLimit?.toString() ?? '0';
        _monthlyLimitController.text = user?.monthlyLimit?.toString() ?? '0';
        _daysRemainingController.text = user?.daysRemaining?.toString() ?? '0';
        _locationPermissionEnabled = user?.locationPermission ?? false;
        _bluetoothEnabled = user?.bluetoothPermission ?? false;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(title: "Settings"),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
        color: const Color(0xFFC8E8D5), // Light green background
        child: Center(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 144, 221, 175), // Inner container background color
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ListView(
              children: [
                Text(
                  'These settings will be applied to your selected cylinder',
                  style: GoogleFonts.montserrat(
                    fontStyle: FontStyle.italic,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildSectionTitle('Set usage limits', const Color.fromARGB(255, 20, 70, 34)),
                const SizedBox(height: 20),
                _buildInputFieldWithCheckbox(
                  'Daily Limit (grams)',
                  _dailyLimitController,
                  _dailyLimitEnabled,
                      (value) => setState(() {
                    _dailyLimitEnabled = value!;
                  }),
                ),
                _buildInputFieldWithCheckbox(
                  'Monthly Limit (grams)',
                  _monthlyLimitController,
                  _monthlyLimitEnabled,
                      (value) => setState(() {
                    _monthlyLimitEnabled = value!;
                  }),
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('Predictive warnings', const Color.fromARGB(255, 20, 70, 34)),
                const SizedBox(height: 16),
                _buildInputFieldWithCheckbox(
                  'Set alert for days remaining (days)',
                  _daysRemainingController,
                  _predictiveWarningsEnabled,
                      (value) => setState(() {_predictiveWarningsEnabled = value!;}),
                  labelFontSize: 14,
                ),
                // _buildCheckboxRow(
                //   'Recommendation alerts',
                //   _recommendationAlertsEnabled,
                //       (value) => setState(() => _recommendationAlertsEnabled = value!),
                // ),
                // const SizedBox(height: 16),
                _buildCheckboxRow(
                  'Location permission',
                  _locationPermissionEnabled,
                      (value) => setState(() {
                    _locationPermissionEnabled = value!;
                    if(_locationPermissionEnabled){
                      user?.locationPermission = _locationPermissionEnabled;
                    }
                  }),
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('Device connection', const Color.fromARGB(255, 20, 70, 34)),
                const SizedBox(height: 12),
                _buildSwitchRow(
                  'Bluetooth',
                  _bluetoothEnabled,
                      (value) {
                    setState(() {
                      _bluetoothEnabled = value;
                    });
                    if (value) {

                      // showDialog(
                      //   context: context,
                      //   builder: (BuildContext context) {
                      //     return const BluetoothConnectionScreen();
                      //   },
                      // );
                    }
                  },
                ),
                const SizedBox(height: 16),
                _buildButton("Save", const Color(0xFF004B23), () async {
                  //error handling need to be done
                  // await showDialog(
                  //   context: context,
                  //   builder: (context) => AlertDialog(
                  //     title: const Text('Error'),
                  //     content: const Text('Please try again, something went wrong.'),
                  //     actions: [
                  //       TextButton(
                  //         onPressed: () => Navigator.pop(context), // Close the dialog
                  //         child: const Text('OK'),
                  //       ),
                  //     ],
                  //   ),
                  // );
                  if(_dailyLimitEnabled ){
                    user?.dailyLimit = double.tryParse(_dailyLimitController.text);
                  }
                  if(_monthlyLimitEnabled){
                    user?.monthlyLimit = double.tryParse(_monthlyLimitController.text);
                  }
                  if(_predictiveWarningsEnabled){
                    user?.daysRemaining = int.tryParse(_daysRemainingController.text);
                  }
                  if(_locationPermissionEnabled){
                    user?.locationPermission = true;
                  }else{
                    user?.locationPermission = false;
                  }
                  if(_bluetoothEnabled){
                    user?.bluetoothPermission = true;
                  }else{
                    user?.bluetoothPermission = false;
                  }

                  showDialog(
                    context: context,
                    barrierDismissible: false, // Disable dismissal by tapping outside
                    builder: (BuildContext context) {
                      return const Dialog(
                        backgroundColor: Colors.transparent, // Set the background to transparent
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.green), // Set the spinner color
                          ),
                        ),
                      );
                    },
                  );

                  bool updated = await FirestoreService().updateUserSettings(user!);

                  Navigator.of(context).pop();
                  if(updated){
                    _dailyLimitController.text = user?.dailyLimit?.toString() ?? '0';
                    _monthlyLimitController.text = user?.monthlyLimit?.toString() ?? '0';
                    _daysRemainingController.text = user?.daysRemaining?.toString() ?? '0';
                    _locationPermissionEnabled = user?.locationPermission ?? false;
                    _bluetoothEnabled = user?.bluetoothPermission ?? false;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('User settings updated successfully!'),
                        backgroundColor: Color(0xFF004B23),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('User settings could not be update!'),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                }),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Footer(currentIndex: 4),
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Text(
      title,
      style: GoogleFonts.montserrat(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }

  Widget _buildInputFieldWithCheckbox(
      String label,
      TextEditingController controller,
      bool isChecked,
      ValueChanged<bool?> onChanged, {
        double labelFontSize = 16, // Default font size for the label
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.montserrat(
                fontSize: labelFontSize, // Use the custom font size
                color: const Color.fromARGB(255, 20, 70, 34), // Dark green
              ),
            ),
            Checkbox(
              value: isChecked,
              activeColor: const Color(0xFF008037),
              onChanged: null,
            ),
          ],
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          style: GoogleFonts.montserrat(),
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.white, // White background for the text box
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey), // Border color
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF008037), width: 2.0), // Focus border color
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }


  Widget _buildCheckboxRow(String label, bool isChecked, ValueChanged<bool?> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.montserrat(fontSize: 16),
        ),
        Checkbox(
          value: isChecked,
          activeColor: const Color(0xFF008037),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildSwitchRow(String label, bool isSwitched, ValueChanged<bool> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 16,
            color: const Color.fromARGB(255, 20, 70, 34),
            fontWeight: FontWeight.bold,
          ),
        ),
        Switch(
          value: isSwitched,
          activeColor: const Color(0xFF008037), // Green active color
          inactiveTrackColor: Colors.grey.shade400,
          inactiveThumbColor: Colors.white,
          onChanged: onChanged,
        ),
      ],
    );
  }

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
}


