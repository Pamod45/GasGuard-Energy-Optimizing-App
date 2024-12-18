import 'package:flutter/material.dart';
import 'package:gasguard_final/footer.dart';
import 'package:gasguard_final/services/firestore_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'header.dart'; // Import your existing header
import 'models/User.dart';
import 'reset_password.dart'; // Import the ResetPasswordScreen

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, String> profileData = {
    'Name': 'Pubudu Perera',
    'Contact No': '+94704556426',
    'Address': 'Pelawatta',
    'User Name': 'Pubudu',
    'Change Password': '',
  };

  //instead of using profile data use the user object to populate things
  User? user;
  bool isLoading = true;

  @override
  void initState()  {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    user = await FirestoreService().getUserByUsername(username!);
    setState(() {
      isLoading = false;
    });
    print(user!.userType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 200, 232, 213),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60.0), // Adjust the height as needed
        child: Header(title: "Profile"), // Use your existing header widget
      ),
      body: isLoading ? const Center(child: CircularProgressIndicator())
      : Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Details Header
            const Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    "Profile Details",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      color: Color.fromARGB(255, 20, 70, 34),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Fields
            _buildProfileField(context, "Name", user!.name),
            const SizedBox(height: 10),
            _buildProfileField(context, "Contact No", user!.contactNo),
            const SizedBox(height: 10),
            _buildProfileField(context, "Address", user!.address),
            const SizedBox(height: 10),
            _buildProfileField(context, "username", user!.username),
            const SizedBox(height: 10),
            user!.userType != 'google'?_buildChangePasswordField(context):Container(),
          ],
        ),
      ),
      bottomNavigationBar: Footer(currentIndex:0),
    );
  }

  Widget _buildProfileField(BuildContext context, String label, String value) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 144, 221, 175),
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold, // Ensuring the labels are bold
              color: Color.fromARGB(137, 0, 0, 0),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 5),
          (label != 'username' && !(label == 'Name' && user!.userType == 'google'))?
            GestureDetector(
              onTap: () {
                _onEditField(context, label, value);
              },
              child: const Icon(
                Icons.edit,
                size: 20,
                color: Colors.black54,
              ),
            ):Container(),
        ],
      ),
    );
  }

  // Special method to handle Change Password field, which opens ResetPasswordScreen
  Widget _buildChangePasswordField(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 144, 221, 175),
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Change Password',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(137, 0, 0, 0),
            ),
          ),
          GestureDetector(
            onTap: () {
              // Navigate to ResetPasswordScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ResetPasswordScreen()),
              );
            },
            child: const Icon(
              Icons.edit,
              size: 20,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  void _onEditField(BuildContext context, String fieldLabel, String currentValue) {
    TextEditingController controller = TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit $fieldLabel'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Enter new $fieldLabel'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
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

                print("From here 218");
                String prevName = user!.name;
                String prevAddress = user!.address;
                String prevContact = user!.contactNo;
                setState(() {
                  if(fieldLabel == "Name"){
                    user!.name = controller.text;
                  }
                  else if(fieldLabel == "Address") {
                    user!.address = controller.text;
                  }
                  else if(fieldLabel == "Contact No") {
                    user!.contactNo = controller.text;
                  }
                });


                FirestoreService fireStoreService = FirestoreService();
                bool isUpdated = await fireStoreService.updateUserSettings(user!);
                if(isUpdated){
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$fieldLabel updated Successfully!'),
                      backgroundColor: const Color(0xFF004B23),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }else{
                  setState(() {
                    if(fieldLabel == "Name")
                      user!.name = prevName;
                    else if(fieldLabel == "Address")
                      user!.address = prevAddress;
                    else if(fieldLabel == "Contact No")
                      user!.contactNo = prevContact;
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
