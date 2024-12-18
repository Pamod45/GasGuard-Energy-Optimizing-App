import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gasguard_final/models/User.dart';
import 'package:gasguard_final/models/Cylinder.dart';
import 'package:intl/intl.dart';

import '../models/GasUsage.dart';
import '../models/Notification.dart'; // Assuming you have a Cylinder model

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _usersCollection = 'users';

  // Add a user to Firestore and return true if successful, false otherwise
  Future<bool> addUser(User user) async {
    try {
      await _firestore.collection(_usersCollection).add(user.toMap());
      print('User added successfully!');
      return true; // Registration successful
    } catch (e) {
      print('Failed to add user: $e');
      return false; // Registration failed
    }
  }

  // Fetch user by username and return a User object if found, null otherwise
  Future<User?> getUserByUsername(String username) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_usersCollection)
          .where('username', isEqualTo: username)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return User.fromMap(querySnapshot.docs.first.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print('Failed to fetch user: $e');
    }
    return null;
  }

  Future<bool> authenticateUser(String username, String password) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_usersCollection)
          .where('username', isEqualTo: username)
          .where('password', isEqualTo: password)
          .get();

      // Check if any matching document is found
      if (querySnapshot.docs.isNotEmpty) {
        print('Authentication successful for username: $username');
        return true;
      } else {
        print('Authentication failed for username: $username');
        return false;
      }
    } catch (e) {
      print('Failed to authenticate user: $e');
      return false; // Return false in case of errors
    }
  }

  Future<bool> updateUserSettings(User user) async {
    try {
      // Fetch the user document based on the username
      QuerySnapshot querySnapshot = await _firestore
          .collection(_usersCollection)
          .where('username', isEqualTo: user.username)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the user's document reference
        DocumentReference userDocRef = querySnapshot.docs.first.reference;

        // Update all non-null fields in the user's document
        await userDocRef.update(user.toMap());
        print('User settings updated successfully for: ${user.username}');
        return true; // Return true on successful update
      } else {
        print('No user found with username: ${user.username}');
        return false; // Return false if no user is found
      }
    } catch (e) {
      print('Error updating user settings: $e');
      return false; // Return false in case of errors
    }
  }

  Future<bool> changePassword(Map<String,dynamic> user) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_usersCollection)
          .where('username', isEqualTo: user["username"])
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentReference userDocRef = querySnapshot.docs.first.reference;
        await userDocRef.update({"password":user["password"]});
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // Method to fetch the size of the cylinders array for a user
  Future<int> getCylinderCount(String username) async {
    try {
      // Fetch the user document based on the username
      QuerySnapshot querySnapshot = await _firestore
          .collection(_usersCollection)
          .where('username', isEqualTo: username)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the user's document
        DocumentSnapshot userDoc = querySnapshot.docs.first;

        // Get the cylinders array size
        List<dynamic> cylinders = userDoc['cylinders'] ?? [];
        return cylinders.length;
      } else {
        print('No user found with username: $username');
        return 0;
      }
    } catch (e) {
      print('Failed to get cylinder count: $e');
      return 0; // Return 0 in case of errors
    }
  }

  // Method to fetch the last cylinder ID for a user
  Future<int> getLastCylinderId(String username) async {
    try {
      // Fetch the user document based on the username
      QuerySnapshot querySnapshot = await _firestore
          .collection(_usersCollection)
          .where('username', isEqualTo: username)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the user's document
        DocumentSnapshot userDoc = querySnapshot.docs.first;

        // Fetch the cylinders array
        List<dynamic> cylinders = userDoc['cylinders'] ?? [];

        // If there are no cylinders, return 0 as the last ID
        if (cylinders.isEmpty) {
          return 0;
        }

        // Find the highest ID in the cylinders array
        int lastId = cylinders
            .map((cylinder) => cylinder['id'] as int)
            .reduce((curr, next) => curr > next ? curr : next);

        return lastId; // Return the last cylinder ID
      } else {
        print('No user found with username: $username');
        return 0; // Return 0 if no user is found
      }
    } catch (e) {
      print('Failed to fetch last cylinder ID: $e');
      return 0; // Return 0 in case of errors
    }
  }


  // Updated method to add a cylinder with a unique ID
  Future<int> addCylinder(String username, Cylinder cylinder) async {
    try {
      // Fetch the current count of cylinders
      int lastCylinderId = await getLastCylinderId(username);

      // Set the unique ID for the new cylinder
      cylinder.id = lastCylinderId + 1;

      // Fetch the user document based on the username
      QuerySnapshot querySnapshot = await _firestore
          .collection(_usersCollection)
          .where('username', isEqualTo: username)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the user's document reference
        DocumentReference userDocRef = querySnapshot.docs.first.reference;

        // Add the cylinder to the user's cylinders array
        await userDocRef.update({
          'cylinders': FieldValue.arrayUnion([cylinder.toMap()])
        });

        print('Cylinder added successfully for user: $username with cylinder id: ${cylinder.id}');
        return lastCylinderId+1;
      } else {
        print('No user found with username: $username');
        return -1;
      }
    } catch (e) {
      print('Failed to add cylinder: $e');
      return -1; // Return false in case of errors
    }
  }
  // Method to fetch all cylinders for a user
  Future<List<Cylinder>> getCylinders(String username) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_usersCollection)
          .where('username', isEqualTo: username)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;
        List<dynamic> cylindersData = userDoc['cylinders'] ?? [];
        return cylindersData.map((data) => Cylinder.fromMap(data as Map<String, dynamic>)).toList();
      } else {
        print('No user found with username: $username');
        return [];
      }
    } catch (e) {
      print('Failed to fetch cylinders: $e');
      return [];
    }
  }

  Future<int> getCurrentCylinderId(String username) async {
    try {
      // Fetch the user document based on the username
      QuerySnapshot querySnapshot = await _firestore
          .collection(_usersCollection)
          .where('username', isEqualTo: username)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the user's document
        DocumentSnapshot userDoc = querySnapshot.docs.first;

        // Fetch the currentCylinderId field or return -1 if it doesn't exist
        return userDoc['currentCylinderId'] ?? -1;
      } else {
        print('No user found with username: $username');
        return -1; // Default to -1 if no user is found
      }
    } catch (e) {
      print('Failed to fetch current cylinder ID: $e');
      return -1; // Default to -1 in case of errors
    }
  }

  Future<bool> setCurrentCylinder(String username, int cylinderId) async {
    try {
      // Fetch the user document based on the username
      QuerySnapshot querySnapshot = await _firestore
          .collection(_usersCollection)
          .where('username', isEqualTo: username)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the user's document reference
        DocumentReference userDocRef = querySnapshot.docs.first.reference;

        // Update the currentCylinderId field in the user's document
        await userDocRef.update({
          'currentCylinderId': cylinderId,
        });

        print("Current cylinder updated successfully for user: $username");
        return true; // Return true on successful update
      } else {
        print('No user found with username: $username');
        return false; // Return false if no user is found
      }
    } catch (e) {
      print("Error updating current cylinder: $e");
      return false; // Return false if an error occurs
    }
  }

  Future<bool> deleteCylinder(String username, int cylinderId) async {
    try {
      // Fetch the user document based on the username
      QuerySnapshot querySnapshot = await _firestore
          .collection(_usersCollection)
          .where('username', isEqualTo: username)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the user's document reference
        DocumentReference userDocRef = querySnapshot.docs.first.reference;

        // Fetch the cylinders array from the user's document
        DocumentSnapshot userDoc = await userDocRef.get();
        List<dynamic> cylinders = userDoc['cylinders'] ?? [];

        // Find the cylinder to delete by its ID
        List<dynamic> updatedCylinders = cylinders
            .where((cylinder) => cylinder['id'] != cylinderId) // Filter out the cylinder with the given ID
            .toList();

        // Update the cylinders array in Firestore
        await userDocRef.update({
          'cylinders': updatedCylinders, // Set the updated list
        });

        print('Cylinder with ID $cylinderId deleted successfully for user: $username');
        return true; // Return true if successful
      } else {
        print('No user found with username: $username');
        return false; // Return false if no user is found
      }
    } catch (e) {
      print('Failed to delete cylinder: $e');
      return false; // Return false in case of errors
    }
  }

  // Renew method to update cylinder details
  Future<bool> renew(String? username, int cylinderId, double weight) async {
      try {
        if (username == null) {
          print("Username is null. Cannot perform renewal.");
          return false;
        }
        QuerySnapshot querySnapshot = await _firestore
            .collection(_usersCollection)
            .where('username', isEqualTo: username)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          DocumentReference userDocRef = querySnapshot.docs.first.reference;

          DocumentSnapshot userDoc = await userDocRef.get();
          List<dynamic> cylinders = userDoc['cylinders'];

          bool cylinderFound = false;
          for (int i = 0; i < cylinders.length; i++) {
            if (cylinders[i]['id'] == cylinderId) {
              cylinders[i]['currentWeight'] = weight;
              cylinders[i]['renewalDate'] = DateFormat('dd/MM/yyyy').format(DateTime.now());
              cylinderFound = true;
              break;
            }
          }

          if (cylinderFound) {
            await userDocRef.update({
              'cylinders': cylinders,
            });
            print("Renewal process completed for user: $username");
            return true;
          } else {
            print('Cylinder with ID $cylinderId not found for user: $username');
            return false;
          }
        } else {
          print('No user found with username: $username');
          return false;
        }
      } catch (e) {
          print("Error during renewal: $e");
          return false;
      }
  }

  // to update the user
  Future<Cylinder?> getCurrentCylinder(String username) async {
    try {
      // Fetch the user document based on the username
      QuerySnapshot querySnapshot = await _firestore
          .collection(_usersCollection)
          .where('username', isEqualTo: username)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the user's document
        DocumentSnapshot userDoc = querySnapshot.docs.first;

        // Fetch the currentCylinderId field
        int currentCylinderId = userDoc['currentCylinderId'] ?? -1;

        if (currentCylinderId == -1) {
          print('No current cylinder set for user: $username');
          return null;
        }

        // Fetch the cylinders array
        List<dynamic> cylindersData = userDoc['cylinders'] ?? [];

        // Find the cylinder with the matching ID
        for (var cylinderData in cylindersData) {
          if (cylinderData['id'] == currentCylinderId) {
            return Cylinder.fromMap(cylinderData as Map<String, dynamic>);
          }
        }

        print('No cylinder found with ID $currentCylinderId for user: $username');
        return null;
      } else {
        print('No user found with username: $username');
        return null;
      }
    } catch (e) {
      print('Failed to fetch current cylinder: $e');
      return null;
    }
  }

  Future<List<Cylinder>> getAllCylinders(String username) async {
    try {
      // Fetch the user document based on the username
      QuerySnapshot userQuery = await _firestore
          .collection(_usersCollection) // Replace _usersCollection with your actual users collection name
          .where('username', isEqualTo: username)
          .get();

      if (userQuery.docs.isEmpty) {
        print('No user found with username: $username');
        return [];
      }

      // Get the user's document
      DocumentSnapshot userDoc = userQuery.docs.first;

      // Fetch the cylinders array
      List<dynamic> cylindersData = userDoc['cylinders'] ?? [];

      // Convert the cylinders data to a list of Cylinder objects
      List<Cylinder> cylinders = cylindersData.map((cylinderData) {
        return Cylinder.fromMap(cylinderData as Map<String, dynamic>);
      }).toList();

      print('Fetched ${cylinders.length} cylinders for user: $username');
      return cylinders;
    } catch (e) {
      print('Failed to fetch cylinders for user: $username, Error: $e');
      return [];
    }
  }


  // Method to add a new gas usage record
  Future<bool> addGasUsage(String username, int cylinderId, double usage, DateTime date) async {
    try {
      Timestamp fireStoreTimestamp = Timestamp.fromDate(date);
      Map<String, dynamic> gasUsageData = {
        'username': username,
        'cylinderId': cylinderId,
        'usage': usage,
        'date': fireStoreTimestamp,
      };

      // Add the document to the gasUsage collection
      await _firestore.collection("gasUsage").add(gasUsageData);

      print('Gas usage added successfully for user: $username');
      return true; // Successfully added
    } catch (e) {
      print('Failed to add gas usage: $e');
      return false; // Failed to add
    }
  }

  Future<List<GasUsage>> getGasUsages(String username, int cylinderId, int size) async {
    try {
      Query query = _firestore
          .collection("gasUsage")
          .where('username', isEqualTo: username)
          .where('cylinderId', isEqualTo: cylinderId)
          .orderBy('date', descending: true); // Sort by date in descending order

      if (size > 0) {
        query = query.limit(size); // Apply limit if specified
      }

      QuerySnapshot querySnapshot = await query.get();

      // Convert the query results into a list of GasUsage objects
      List<GasUsage> gasUsages = querySnapshot.docs.map((doc) {
        return GasUsage.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      print('Fetched ${gasUsages.length} gas usage records for user: $username');
      return gasUsages;
    } catch (e) {
      print('Failed to fetch gas usages: $e');
      return []; // Return an empty list in case of errors
    }
  }

  Future<bool> addNotification(NotificationModel notification) async {
    try {
      await _firestore
          .collection("notifications")
          .add(notification.toMap());
      print('Notification added successfully for user: ${notification.username}');
      return true; // Notification successfully added
    } catch (e) {
      print('Failed to add notification: $e');
      return false; // Failed to add notification
    }
  }

  Future<List<NotificationModel>> getNotifications(String username) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection("notifications")
          .where('username', isEqualTo: username)
          .orderBy('date', descending: true)
          .get();

      // Map query snapshot to list of Notification objects
      return querySnapshot.docs
          .map((doc) => NotificationModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Failed to fetch notifications: $e');
      return [];
    }
  }

  Future<void> addGasUsageBatch(List<Map<String, dynamic>> gasUsages) async {
    try {
      WriteBatch batch = _firestore.batch();
      for (var gasUsage in gasUsages) {
        DocumentReference docRef = _firestore.collection('gasUsage').doc(); // Auto-generate document ID
        batch.set(docRef, gasUsage);
      }
      await batch.commit();
      print("Batch write completed: Added ${gasUsages.length} gas usage records.");
    } catch (e) {
      print("Error adding gas usage records: $e");
    }
  }





}

// Future<bool> updateUserLimit(String username, String limitType, double limit) async {
//   try {
//     // Fetch the user document based on the username
//     QuerySnapshot querySnapshot = await _firestore
//         .collection(_usersCollection)
//         .where('username', isEqualTo: username)
//         .get();
//
//     if (querySnapshot.docs.isNotEmpty) {
//       // Get the user's document reference
//       DocumentReference userDocRef = querySnapshot.docs.first.reference;
//
//       // Update the dailyLimit field in the user's document
//       await userDocRef.update({
//         limitType: limit,
//       });
//       print('Daily $limitType updated successfully for user: $username');
//       return true; // Return true on successful update
//     } else {
//       print('No user found with username: $username');
//       return false; // Return false if no user is found
//     }
//   } catch (e) {
//     print('Error updating $limitType : $e');
//     return false; // Return false in case of errors
//   }
// }
//
// Future<bool> updateDaysRemaining(String username, int remainingDays) async {
//   try {
//     // Fetch the user document based on the username
//     QuerySnapshot querySnapshot = await _firestore
//         .collection(_usersCollection)
//         .where('username', isEqualTo: username)
//         .get();
//
//     if (querySnapshot.docs.isNotEmpty) {
//       // Get the user's document reference
//       DocumentReference userDocRef = querySnapshot.docs.first.reference;
//
//       // Update the dailyLimit field in the user's document
//       await userDocRef.update({
//         "daysRemaining": remainingDays,
//       });
//       print("Days Remaining updated successfully for user: $username");
//       return true; // Return true on successful update
//     } else {
//       print('No user found with username: $username');
//       return false; // Return false if no user is found
//     }
//   } catch (e) {
//     print('Error updating daily limit: $e');
//     return false; // Return false in case of errors
//   }
// }
//
// Future<bool> updateLocationPermission(String username,String permissionType, bool permission ) async {
//   try {
//     // Fetch the user document based on the username
//     QuerySnapshot querySnapshot = await _firestore
//         .collection(_usersCollection)
//         .where('username', isEqualTo: username)
//         .get();
//
//     if (querySnapshot.docs.isNotEmpty) {
//       // Get the user's document reference
//       DocumentReference userDocRef = querySnapshot.docs.first.reference;
//
//       // Update the dailyLimit field in the user's document
//       await userDocRef.update({
//         permissionType: permission,
//       });
//       print("$permissionType is updated successfully: $username");
//       return true; // Return true on successful update
//     } else {
//       print('No user found with username: $username');
//       return false; // Return false if no user is found
//     }
//   } catch (e) {
//     print('Error updating $permissionType: $e');
//     return false; // Return false in case of errors
//   }
// }

