// main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gasguard_final/home.dart';
import 'firebase_options.dart';
import 'loading.dart';
import 'login.dart';
import 'forgot_password.dart';
import 'otp_verification.dart';
import 'reset_password.dart';
import 'register.dart';
import 'footer.dart';
import 'add_cylinder_details.dart';
import 'cylinder_details.dart'; // Import cylinder details
import 'error_screen.dart'; // Import the ErrorScreen widget
import 'package:connectivity_plus/connectivity_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult == ConnectivityResult.none) {
    runApp(const ErrorScreen(
      title: 'No Internet Connection',
      message: 'Please connect to the internet and try again.',
    ));
  } else {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      runApp(const MyApp());
    } catch (e) {
      runApp(MyApp(error: e.toString()));
    }
  }
}

class MyApp extends StatelessWidget {
  final String? error; // Optional error message passed from main()

  const MyApp({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gas Guard',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      initialRoute: error != null ? '/error' : '/', // If there's an error, show the error screen
      routes: {
        '/': (context) => const LoadingScreen(),
        '/login': (context) => const LoginScreen(),
        '/forgotPassword': (context) => const ForgotPasswordScreen(),
        '/otpVerification': (context) => const OtpVerificationScreen(),
        '/resetPassword': (context) => const ResetPasswordScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomePage(),
        '/addCylinderDetails': (context) => const AddCylinderDetails(),
        '/cylinderDetails': (context) => const CylinderDetailsScreen(),
        '/error': (context) => ErrorScreen(
          title: 'Firebase Initialization Error',
          message: error ?? 'An unknown error occurred while initializing Firebase.',
        ), // Error screen route with dynamic title and message
      },
    );
  }
}
