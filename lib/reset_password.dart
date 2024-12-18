import 'package:flutter/material.dart';
import 'package:gasguard_final/services/firestore_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isFormValid = false;

  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_validateForm);
    _confirmPasswordController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      _passwordError = _getPasswordError(_passwordController.text);
      _confirmPasswordError = _getConfirmPasswordError(_confirmPasswordController.text);
      _isFormValid = _passwordError == null &&
          _confirmPasswordError == null &&
          _passwordController.text == _confirmPasswordController.text;
    });
  }

  String? _getPasswordError(String password) {
    if (password.isEmpty) {
      return "Password is required";
    } else if (password.length < 8) {
      return "Password must be at least 8 characters long";
    } else if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return "Password must contain at least 1 uppercase letter";
    } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return "Password must contain at least 1 special character";
    }
    return null;
  }

  String? _getConfirmPasswordError(String confirmPassword) {
    if (confirmPassword.isEmpty) {
      return "Confirm password is required";
    } else if (confirmPassword != _passwordController.text) {
      return "Passwords do not match";
    }
    return null;
  }

  Future<void> _changePassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    if (_isFormValid) {
      showDialog(
        context: context,
        barrierDismissible: false, // Disable dismissal by tapping outside
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
      Map<String,dynamic> user = {
        "username":username,
        "password":_passwordController.text
      };

      bool passwordUpdated = await FirestoreService().changePassword(user);

      Navigator.pop(context);

      if(passwordUpdated){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password changed Successfully!'),
            backgroundColor: Color(0xFF004B23),
            duration: Duration(seconds: 3),
          ),
        );
        Navigator.pushReplacementNamed(context, '/login');
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password could not be changed.'),
            backgroundColor: Color(0xFF004B23),
            duration: Duration(seconds: 3),
          ),
        );
        Navigator.pop(context);
      }

    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF34BA54), // Start color
              Color(0xFFA3D9A5), // End color
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // Logo and Title
                Column(
                  children: [
                    Image.asset(
                      'assets/logo.png', // Replace with your actual logo path
                      height: 80,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "GAS GUARD",
                      style: GoogleFonts.montserrat(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 242, 255, 201),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Back Button Row with "Create New Password" text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Image.asset(
                          'assets/Chevron Up.png', // Replace with your custom back button image
                          height: 40,
                        ),
                      ),
                    ),
                    const SizedBox(width: 30),
                    Text(
                      "Create New Password",
                      style: GoogleFonts.montserrat(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                // Password TextField
                SizedBox(
                  height: 60, // Adjust height as needed
                  width: 400, // Adjust width as needed
                  child: TextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: GoogleFonts.montserrat(),
                      filled: true,
                      fillColor: Colors.green.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      errorText: _passwordError,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Confirm Password TextField
                SizedBox(
                  height: 60, // Adjust height as needed
                  width: 400, // Adjust width as needed
                  child: TextField(
                    controller: _confirmPasswordController,
                    obscureText: !_isConfirmPasswordVisible,
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
                      labelStyle: GoogleFonts.montserrat(),
                      filled: true,
                      fillColor: Colors.green.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      errorText: _confirmPasswordError,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                // Change Password Button with rounded edges
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: _isFormValid ? _changePassword : null,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: const Color.fromARGB(255, 0, 75, 35),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Curved edges for button
                      ),
                    ),
                    child: Text(
                      "Change",
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
