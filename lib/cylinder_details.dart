import 'package:flutter/material.dart';
import 'package:gasguard_final/services/firestore_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'footer.dart';
import 'header.dart'; // Importing the Header widget
import 'edit_cylinder_details.dart'; // Importing the EditCylinderDetails screen
import 'add_cylinder_details.dart';
import 'models/Cylinder.dart'; // Importing the AddCylinderDetails screen

class CylinderDetailsScreen extends StatefulWidget {
  const CylinderDetailsScreen({super.key});

  @override
  State<CylinderDetailsScreen> createState() => _CylinderDetailsScreenState();
}

class _CylinderDetailsScreenState extends State<CylinderDetailsScreen> {
  int _selectedIndex = -1;
  final FirestoreService _firestoreService = FirestoreService();
  List<Cylinder> _cylinders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCylinders();
  }

  Future<void> _loadCylinders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    if (username != null) {
      try {
        // Fetch current selected cylinder ID
        int currentCylinderId = await _firestoreService.getCurrentCylinderId(username);
        // Load cylinder data
        List<Cylinder> cylinders = await _firestoreService.getCylinders(username);

        print("Currently selected ID: ${_selectedIndex}");

        for (var cylinder in cylinders) {
          print('${cylinder.id}: ${cylinder.name}');
        }
        print("Up to here working 44");

        if(currentCylinderId != -1 ){
          print("From here 54");
          Cylinder? currentCylinder = cylinders.firstWhere((cylinder) => cylinder.id == currentCylinderId);

          if (currentCylinder != null) {
            cylinders.remove(currentCylinder); // Remove the selected cylinder
            cylinders.insert(0, currentCylinder); // Add it to the top
          }
        }else{
          print("From here 55");
        }
        print("Up to here working 57");

        setState(() {
          _cylinders = cylinders;
          _isLoading = false;
          _selectedIndex = currentCylinderId;
        });
        // print("Currently selected ID: ${_selectedIndex}");
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        print("Error loading cylinders: $e");
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      print("Username not found in SharedPreferences");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 200, 232, 213),
      appBar: const Header(title: 'Cylinder Details'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddCylinderDetails()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF004B23),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Add Cylinder",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Image.asset(
                    'assets/Add.png',
                    width: 24,
                    height: 24,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _cylinders.length,
                  itemBuilder: (context, index) {
                    Cylinder cylinder = _cylinders[index];
                    bool isCurrentlySelected = _selectedIndex == cylinder.id; // Check if this cylinder is selected
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: _cylinderCard(
                        index: cylinder.id,
                        title: isCurrentlySelected ? "Currently selected" : "Select as current",
                        cylinderName: cylinder.name,
                        startDate: cylinder.startDate ?? "N/A",
                        renewalDate:cylinder.renewalDate ?? "",
                        remainingText: "${cylinder.currentWeight}kg out of ${cylinder.weight} kg",
                        remaining: "Remaining",
                        daysUntilRenewal: "${cylinder.getRemainingDays()} days until renewal",
                        isCurrentlySelected: isCurrentlySelected,
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Footer(currentIndex: 1),
    );
  }

  Widget _cylinderCard({
    required int index,
    required String title,
    required String cylinderName,
    required String startDate,
    required String remainingText,
    required String remaining,
    required String daysUntilRenewal,
    required bool isCurrentlySelected,
    required String renewalDate,
  }) {
    return GestureDetector(
      onTap: () async {
        // Show a loading spinner while changing the cylinder
        showDialog(
          context: context,
          barrierDismissible: false, // Disable dismissal by tapping outside
          builder: (BuildContext context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        );

        try {
          // Update the selected cylinder in the database
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String? username = prefs.getString('username');
          if (username != null) {
            await _firestoreService.setCurrentCylinder(username, index);
            await _loadCylinders(); // Reload the cylinders data
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Current cylinder changed Successfully!'),
                backgroundColor: Color(0xFF004B23),
                duration: Duration(seconds: 3),
              ),
            );
          }
        } catch (e) {
          print("Error setting current cylinder: $e");
        } finally {
          // Close the spinner once the process is done
          if (context.mounted) Navigator.of(context).pop();
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF004B23),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                  ),
                ),
                Icon(
                  isCurrentlySelected ? Icons.check_circle : Icons.radio_button_off,
                  color: Colors.white,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              cylinderName,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontFamily: 'Montserrat',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    "Start Date:",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
                Text(
                  startDate,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    "Renewal Date:",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
                Text(
                  renewalDate,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              remainingText,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontFamily: 'Montserrat',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              remaining,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontFamily: 'Montserrat',
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  daysUntilRenewal,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditCylinderDetails(_cylinders.firstWhere((cylinder) => cylinder.id == index)),
                          ),
                        );
                      },
                      child: Image.asset(
                        'assets/edit_icon.png',
                        width: 24,
                        height: 24,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Cylinder'),
                            content: const Text('Are you sure you want to delete this cylinder?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false, // Disable dismissal by tapping outside
                                    builder: (BuildContext context) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                  );

                                  try {
                                    // Update the selected cylinder in the database
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    String? username = prefs.getString('username');
                                    if (username != null) {
                                      await _firestoreService.deleteCylinder(username, index);
                                      if(index == _selectedIndex){
                                        await _firestoreService.setCurrentCylinder(username, -1);
                                        setState(() {
                                          _selectedIndex = -1 ;
                                        });
                                      }
                                      await _loadCylinders();
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Cylinder deleted Successfully!'),
                                          backgroundColor: Color(0xFF004B23),
                                          duration: Duration(seconds: 3),
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    print("Error deleting cylinder: $e");
                                  } finally {
                                    if (context.mounted) Navigator.of(context).pop();
                                  }
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Image.asset(
                        'assets/trash_icon.png',
                        width: 24,
                        height: 24,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }



}
