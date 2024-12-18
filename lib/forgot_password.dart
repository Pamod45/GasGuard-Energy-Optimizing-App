import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final String phoneNumber = "+94 70********26";

  const ForgotPasswordScreen({super.key});

  void _onNext(BuildContext context) {
    if (phoneNumber.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Device Not Registered",
            style: GoogleFonts.montserrat(),
          ),
          content: Text(
            "This device is not registered in the system.",
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
    } else {
      Navigator.pushNamed(context, '/otpVerification');
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
                      "Forgot Password ?",
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
                // OTP Information Text
                Text(
                  "OTP will be sent to below number\nif this is the correct number please proceed",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 40),
                // Phone Number Container with Increased Border Radius
                Container(
                  width: 360,
                  height: 110,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade200,
                    borderRadius: BorderRadius.circular(30), // Increased border radius
                    border: Border.all(color: Colors.black54),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/message fill.png', // Use your custom image asset here
                            height: 24,
                            color: const Color.fromARGB(255, 0, 75, 35),
                          ),
                          const SizedBox(width: 60),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "via SMS",
                                style: GoogleFonts.montserrat(
                                  fontSize: 18,
                                  color: const Color.fromARGB(255, 0, 75, 35),
                                ),
                              ),
                              Text(
                                phoneNumber,
                                style: GoogleFonts.montserrat(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Next Button with Increased Border Radius for Curved Edges
                SizedBox(
                  width: 200, // Set the desired width for the button here
                  child: ElevatedButton(
                    onPressed: () => _onNext(context),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: const Color.fromARGB(255, 0, 75, 35),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Increased to 30 for more curved edges
                      ),
                    ),
                    child: Text(
                      "Next",
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
