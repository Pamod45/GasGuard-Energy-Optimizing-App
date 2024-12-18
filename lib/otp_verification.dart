// otp_verification.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();

  void _verifyOtp() {
    if (_otpController.text.length == 4) {
      Navigator.pushNamed(context, '/resetPassword');
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(
            "Please enter a valid 4-digit OTP.",
            style: GoogleFonts.montserrat(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "OK",
                style: GoogleFonts.montserrat(),
              ),
            ),
          ],
        ),
      );
    }
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
                // Back Button Row with "Forgot Password" text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MouseRegion(
                      cursor: SystemMouseCursors.click, // Changes cursor to a hand
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Image.asset(
                          'assets/Chevron Up.png', // Use your custom image asset here
                          height: 40,
                        ),
                      ),
                    ),
                    const SizedBox(width: 30),
                    Text(
                      "Verify OTP",
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
                // OTP Instruction Text
                Text(
                  "Please enter the code sent to your phone number",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                // OTP TextField
                TextField(
                  controller: _otpController,
                  maxLength: 4,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: "----",
                    counterText: "",
                    filled: true,
                    fillColor: Colors.green.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const Spacer(), // Pushes the button to the bottom
                // Verify Button with Curved Edges
                SizedBox(
                  width: 200, // Set the desired width for the button here
                  child: ElevatedButton(
                    onPressed: _verifyOtp,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: const Color.fromARGB(255, 0, 75, 35),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Increased to 30 for more curved edges
                      ),
                    ),
                    child: Text(
                      "Verify",
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40), // Space below the button
              ],
            ),
          ),
        ),
      ),
    );
  }
}
