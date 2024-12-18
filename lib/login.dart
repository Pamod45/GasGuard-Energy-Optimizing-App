import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:gasguard_final/bluetooth_device_screen.dart';
import 'package:gasguard_final/models/User.dart' as appUser;
import 'package:gasguard_final/services/firestore_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'forgot_password.dart'; // Import the Forgot Password screen
import 'bluetooth_connection.dart'; // Import the Bluetooth connection screen

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _login() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: const Text('Please enter your username and password to login.'),
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

    // Show a loading indicator while the authentication is in progress
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    FirestoreService firestoreService = FirestoreService();

    try {
      // Add a timeout of 5 seconds to the authentication process
      final isAuthenticated = await firestoreService
          .authenticateUser(username, password)
          .timeout(const Duration(seconds: 5));

      // Close the loading dialog
      Navigator.pop(context);

      if (isAuthenticated) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', username);
        await prefs.setString('userType', 'default');

        showDialog(
          context: context,
          builder: (context) => const BluetoothConnectionScreen(),
          // builder: (context) => const BluetoothDevicesScreen(),
        );
      } else {
        // Show an error dialog if authentication fails
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Login Failed'),
            content: const Text('Invalid username or password. Please try again.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } on TimeoutException {
      // Close the loading dialog
      Navigator.pop(context);

      // Show a connection timeout error
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Connection Error'),
          content: const Text('The connection timed out. Please try again later.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      // Close the loading dialog
      Navigator.pop(context);

      // Handle other errors (e.g., Firestore errors)
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('An error occurred: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _loginWithGoogle() async {
    try {
      // Show a loading spinner while Google sign-in is in progress
      showDialog(
        context: context,
        barrierDismissible: false,  // Disable dismissal when tapping outside
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      // Start the Google sign-in process with a timeout
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn().timeout(
        const Duration(seconds: 10), // Timeout for Google SignIn
        onTimeout: () {
          throw TimeoutException('Google Sign-in timed out.');
        },
      );

      if (googleUser == null) {
        // The user canceled the sign-in
        print('Google sign-in canceled');
        Navigator.pop(context);  // Close the spinner
        return;
      }

      // Obtain the Google authentication details with a timeout
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication.timeout(
        const Duration(seconds: 10), // Timeout for Google Authentication
        onTimeout: () {
          throw TimeoutException('Google authentication timed out.');
        },
      );

      // Create a new credential using the Google authentication details
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential with a timeout
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential).timeout(
        const Duration(seconds: 10), // Timeout for Firebase sign-in
        onTimeout: () {
          throw TimeoutException('Firebase sign-in timed out.');
        },
      );

      final firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        // Create the User object with email from Google as the username
        final user = appUser.User.google( // Use the alias to refer to your User class
          name: firebaseUser.displayName ?? 'No Name',
          username: firebaseUser.email ?? 'default_username',
        );
        print(firebaseUser.displayName);
        print(firebaseUser.email);

        // Check if the user already exists in Firestore using the email as username
        final querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('username', isEqualTo: firebaseUser.email)
            .get()
            .timeout(
          const Duration(seconds: 10), // Timeout for Firestore query
          onTimeout: () {
            throw TimeoutException('Firestore query timed out.');
          },
        );

        if (querySnapshot.docs.isEmpty) {
          await FirestoreService().addUser(user).timeout(
            const Duration(seconds: 10), // Timeout for adding user to Firestore
            onTimeout: () {
              throw TimeoutException('Adding user to Firestore timed out.');
            },
          );
          print("New user created in Firestore.");
        } else {
          print("User already exists in Firestore.");
        }

        // Save user session in SharedPreferences with a timeout
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', firebaseUser.email.toString()).timeout(
          const Duration(seconds: 10), // Timeout for SharedPreferences
          onTimeout: () {
            throw TimeoutException('Saving username to SharedPreferences timed out.');
          },
        );
        await prefs.setString('userType', 'google');
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) => const BluetoothConnectionScreen(),
          // builder: (context) => const BluetoothDevicesScreen(),
        );
        return;

        print("Google login successful!");
      }

      // Close the spinner once the login process is done
      Navigator.pop(context);
    } catch (e) {
      // Close the spinner on error
      Navigator.pop(context);
      if (e is TimeoutException) {
        print('Timeout occurred: ${e.message}');
      } else {
        print('Error during Google sign-in: $e');
      }
    }
  }

  void _loginWithFacebook() {
    print("Facebook login");
  }

  void _forgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
    );
  }

  void _signUp() {
    Navigator.pushNamed(context, '/register');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Prevent bottom overflow
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF34BA54), // Starting color of the gradient
              Color(0xFFA3D9A5), // Ending color of the gradient
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ListView(
            children: [
              const SizedBox(height: 50),
              Image.asset('assets/logo.png', height: 100, width: 100),
              const SizedBox(height: 30),
              Text(
                "GAS GUARD",
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 242, 255, 201),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Login",
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 352,
                height: 44,
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: 'Username*',
                    hintStyle: GoogleFonts.montserrat(color: Colors.black54),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 198, 231, 212),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 352,
                height: 44,
                child: TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    hintText: 'Password*',
                    hintStyle: GoogleFonts.montserrat(color: Colors.black54),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 198, 231, 212),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.black54,
                      ),
                      onPressed: _togglePasswordVisibility,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _loginWithGoogle,
                    icon: Image.asset(
                      'assets/Google.png',
                      height: 30,
                      width: 30,
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: _loginWithFacebook,
                    icon: const Icon(Icons.facebook, color: Color(0xFF004B23), size: 38),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 0, 75, 35),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Login', style: GoogleFonts.montserrat()),
              ),
              const SizedBox(height: 30),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Forgot password?',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 20, 70, 34),
                  ),
                  recognizer: TapGestureRecognizer()..onTap = _forgotPassword,
                ),
              ),
              const SizedBox(height: 30),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "Don't have an account? ",
                  style: GoogleFonts.montserrat(color: const Color.fromARGB(255, 20, 70, 34)),
                  children: [
                    TextSpan(
                      text: "Sign Up",
                      style: GoogleFonts.montserrat(
                        color: const Color.fromARGB(255, 20, 70, 34),
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = _signUp,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );


    // return Scaffold(
    //   body: Container(
    //     decoration: const BoxDecoration(
    //       gradient: LinearGradient(
    //         colors: [
    //           Color(0xFF34BA54), // Starting color of the gradient
    //           Color(0xFFA3D9A5), // Ending color of the gradient
    //         ],
    //         begin: Alignment.topLeft,
    //         end: Alignment.bottomRight,
    //       ),
    //     ),
    //     child: Padding(
    //       padding: const EdgeInsets.symmetric(horizontal: 20.0),
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: [
    //           const SizedBox(height: 50),
    //           Image.asset('assets/logo.png', height: 100, width: 100),
    //           const SizedBox(height: 30),
    //           Text(
    //             "GAS GUARD",
    //             style: GoogleFonts.montserrat(
    //               fontSize: 26,
    //               fontWeight: FontWeight.bold,
    //               color: const Color.fromARGB(255, 242, 255, 201),
    //             ),
    //           ),
    //           const SizedBox(height: 10),
    //           Text(
    //             "Login",
    //             style: GoogleFonts.montserrat(
    //               fontSize: 36,
    //               fontWeight: FontWeight.bold,
    //               color: Colors.white,
    //             ),
    //           ),
    //           const SizedBox(height: 20),
    //           SizedBox(
    //             width: 352,
    //             height: 44,
    //             child: TextField(
    //               controller: _usernameController,
    //               decoration: InputDecoration(
    //                 hintText: 'Username*', // Changed to hintText
    //                 hintStyle: GoogleFonts.montserrat(color: Colors.black54),
    //                 filled: true,
    //                 fillColor: const Color.fromARGB(255, 198, 231, 212),
    //                 border: OutlineInputBorder(
    //                   borderRadius: BorderRadius.circular(8),
    //                 ),
    //               ),
    //             ),
    //           ),
    //           const SizedBox(height: 40),
    //           SizedBox(
    //             width: 352,
    //             height: 44,
    //             child: TextField(
    //               controller: _passwordController,
    //               obscureText: !_isPasswordVisible,
    //               decoration: InputDecoration(
    //                 hintText: 'Password*', // Changed to hintText
    //                 hintStyle: GoogleFonts.montserrat(color: Colors.black54),
    //                 filled: true,
    //                 fillColor: const Color.fromARGB(255, 198, 231, 212),
    //                 border: OutlineInputBorder(
    //                   borderRadius: BorderRadius.circular(8),
    //                 ),
    //                 suffixIcon: IconButton(
    //                   icon: Icon(
    //                     _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
    //                     color: Colors.black54,
    //                   ),
    //                   onPressed: _togglePasswordVisibility,
    //                 ),
    //               ),
    //             ),
    //           ),
    //           const SizedBox(height: 20),
    //           Row(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               IconButton(
    //                 onPressed: _loginWithGoogle,
    //                 icon: Image.asset(
    //                   'assets/Google.png',
    //                   height: 30,
    //                   width: 30,
    //                 ),
    //               ),
    //               const SizedBox(height: 20, width: 10),
    //               IconButton(
    //                 onPressed: _loginWithFacebook,
    //                 icon: const Icon(Icons.facebook, color: Color(0xFF004B23), size: 38),
    //               ),
    //             ],
    //           ),
    //           const SizedBox(height: 20),
    //           ElevatedButton(
    //             onPressed: _login,
    //             style: ElevatedButton.styleFrom(
    //               backgroundColor: const Color.fromARGB(255, 0, 75, 35),
    //               foregroundColor: Colors.white,
    //               padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
    //               shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(8),
    //               ),
    //             ),
    //             child: Text('Login', style: GoogleFonts.montserrat()),
    //           ),
    //           const SizedBox(height: 30),
    //           RichText(
    //             text: TextSpan(
    //               text: 'Forgot password?',
    //               style: GoogleFonts.montserrat(
    //                 fontWeight: FontWeight.bold,
    //                 color: const Color.fromARGB(255, 20, 70, 34),
    //               ),
    //               recognizer: TapGestureRecognizer()..onTap = _forgotPassword,
    //             ),
    //           ),
    //           const SizedBox(height: 30),
    //           RichText(
    //             text: TextSpan(
    //               text: "Don't have an account? ",
    //               style: GoogleFonts.montserrat(color: const Color.fromARGB(255, 20, 70, 34)),
    //               children: [
    //                 TextSpan(
    //                   text: "Sign Up",
    //                   style: GoogleFonts.montserrat(
    //                     color: const Color.fromARGB(255, 20, 70, 34),
    //                     fontWeight: FontWeight.bold,
    //                   ),
    //                   recognizer: TapGestureRecognizer()..onTap = _signUp,
    //                 ),
    //               ],
    //             ),
    //           ),
    //           const Spacer(flex: 2), // Bottom space
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
