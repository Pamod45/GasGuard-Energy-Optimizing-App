import 'package:flutter/material.dart';
import 'package:gasguard_final/settings.dart';
import 'home.dart';
import 'cylinder_details.dart';
import 'notification.dart';
import 'analysis_daily.dart';

class Footer extends StatelessWidget {
  final int currentIndex;

  const Footer({super.key, required this.currentIndex});

  void _onItemTapped(BuildContext context, int index) {
    // Navigate to the appropriate page based on the selected index
    switch (index) {
      case 0:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
        break;
      case 1:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const CylinderDetailsScreen()));
        break;
      case 2:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const AnalysisDaily()));
        break;
      case 3:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const NotificationScreen()));
        break;
      case 4:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const SettingsPage()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color.fromARGB(255, 49, 174, 84), // Dark green background
      currentIndex: currentIndex, // Highlight the selected item
      onTap: (index) => _onItemTapped(context, index), // Handle taps
      items: [
        BottomNavigationBarItem(
          icon: Image.asset(
            currentIndex == 0
                ? 'assets/icons/home_light.png' // Light green logo (active)
                : 'assets/icons/home_dark.png', // Dark green logo (inactive)
            height: 24,
          ),
          label: '', // No label
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            currentIndex == 1
                ? 'assets/icons/cylinder_light.png' // Light green logo (active)
                : 'assets/icons/cylinder_dark.png', // Dark green logo (inactive)
            height: 24,
          ),
          label: '', // No label
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            currentIndex == 2
                ? 'assets/icons/analysis_light.png' // Light green logo (active)
                : 'assets/icons/analysis_dark.png', // Dark green logo (inactive)
            height: 24,
          ),
          label: '', // No label
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            currentIndex == 3
                ? 'assets/icons/notifications_light.png' // Light green logo (active)
                : 'assets/icons/notifications_dark.png', // Dark green logo (inactive)
            height: 24,
          ),
          label: '', // No label
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            currentIndex == 4
                ? 'assets/icons/settings_light.png' // Light green logo (active)
                : 'assets/icons/settings_dark.png', // Dark green logo (inactive)
            height: 24,
          ),
          label: '', // No label
        ),
      ],
      type: BottomNavigationBarType.fixed, // Ensure all icons are visible
      selectedItemColor: const Color(0xFFDFF2E0), // Light green color for active icon
      unselectedItemColor: const Color(0xFF004B23), // Dark green for inactive icons
      showSelectedLabels: false, // No text for selected item
      showUnselectedLabels: false, // No text for unselected items
    );
  }
}
