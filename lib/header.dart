import 'package:flutter/material.dart';
import 'package:gasguard_final/profile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final String title; // Add a title parameter

  const Header(
      {super.key, required this.title}); // Add title to the constructor

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false, // Removes the back button
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF3ACF64), // Starting color of the gradient
              Color(0xFF1E6933), // Ending color of the gradient
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
      ),
      title: Stack(
        alignment: Alignment.center,
        children: [
          title == "Cylinder Details"
              ?
              // Centered dynamic text
              Center(
                  child: Text(
                    'Cylinder\nDetails', // Breaks the text into two lines
                    textAlign: TextAlign.center, // Centers the text
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                )
              : Text(
                  title, // Use the dynamic title here
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
          // Row containing logo and profile icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo with adjustable padding for position
              Padding(
                padding: const EdgeInsets.only(
                    left: 8.0), // Adjust left padding as needed
                child: Image.asset(
                  'assets/Frame 181.png', // Replace with your logo path
                  height: 47,
                  width: 110,
                ),
              ),
              // Profile icon with popup menu
              Padding(
                padding: const EdgeInsets.only(
                    right: 8.0), // Adjust right padding as needed
                child: PopupMenuButton<String>(
                  icon: Image.asset(
                    'assets/Profile icon.png', // Replace with your profile icon path
                    height: 30,
                    width: 30,
                  ),
                  color: const Color.fromARGB(255, 53, 186, 90),
                  offset: const Offset(
                      0, 55), // Offset to position below the header
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  onSelected: (value) async {
                    if (value == 'view_profile') {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => const ProfileScreen()),
                      );
                    } else if (value == 'logout') {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.clear();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                        (route) =>
                            false, // This removes all the previous routes from the stack
                      );
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'view_profile',
                      child: Text(
                        'View Profile',
                        style: GoogleFonts.montserrat(color: Colors.white),
                      ),
                    ),
                    const PopupMenuDivider(),
                    PopupMenuItem<String>(
                      value: 'logout',
                      child: Text(
                        'Logout',
                        style: GoogleFonts.montserrat(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}
