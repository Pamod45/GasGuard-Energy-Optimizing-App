// class User {
//   String name;
//   String contactNo;
//   String address;
//   String username;
//   String password;
//   int currentCylinderId;
//
//   // Regular constructor
//   User({
//     required this.name,
//     required this.contactNo,
//     required this.address,
//     required this.username,
//     required this.password,
//     this.currentCylinderId = -1
//   });
//
//   User.google({
//     required this.name,
//     required this.username, // Email as username
//   })  : contactNo = '',  // Default empty string for contactNo
//         address = '',      // Default empty string for address
//         password = '',    // No password for Google login
//         currentCylinderId = -1;
//
//   // Convert User object to Firestore document
//   Map<String, dynamic> toMap() {
//     return {
//       'name': name,
//       'contactNo': contactNo,
//       'address': address,
//       'username': username,
//       'password': password,
//     };
//   }
//
//   // Create User object from Firestore document
//   factory User.fromMap(Map<String, dynamic> map) {
//     return User(
//       name: map['name'],
//       contactNo: map['contactNo'],
//       address: map['address'],
//       username: map['username'],
//       password: map['password'],
//     );
//   }
// }

class User {
  String name;
  String contactNo;
  String address;
  String username;
  String password;
  String userType;
  int currentCylinderId;

  // New optional fields for settings
  double? dailyLimit;
  double? monthlyLimit;
  int? daysRemaining;
  bool? locationPermission;
  bool? bluetoothPermission;

  // Regular constructor
  User({
    required this.name,
    required this.contactNo,
    required this.address,
    required this.username,
    required this.password,
    this.userType = 'default',
    this.currentCylinderId = -1,
    this.dailyLimit,
    this.monthlyLimit,
    this.daysRemaining,
    this.locationPermission,
    this.bluetoothPermission,
  });

  // Constructor for Google login
  User.google({
    required this.name,
    required this.username, // Email as username
  })  : contactNo = '',
        address = '',
        password = '',
        currentCylinderId = -1,
        userType = 'google',
        dailyLimit = null,
        monthlyLimit = null,
        daysRemaining = null,
        locationPermission = null,
        bluetoothPermission = null;

  // Convert User object to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'contactNo': contactNo,
      'address': address,
      'username': username,
      'password': password,
      'userType':userType,
      'currentCylinderId': currentCylinderId,
      if (dailyLimit != null) 'dailyLimit': dailyLimit,
      if (monthlyLimit != null) 'monthlyLimit': monthlyLimit,
      if (daysRemaining != null) 'daysRemaining': daysRemaining,
      if (locationPermission != null) 'locationPermission': locationPermission,
      if (bluetoothPermission != null) 'bluetoothPermission': bluetoothPermission,
    };
  }

  // Create User object from Firestore document
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'],
      contactNo: map['contactNo'],
      address: map['address'],
      username: map['username'],
      password: map['password'],
      userType: map['userType'],
      currentCylinderId: map['currentCylinderId'] ?? -1,
      dailyLimit: map['dailyLimit'],
      monthlyLimit: map['monthlyLimit'],
      daysRemaining: map['daysRemaining'],
      locationPermission: map['locationPermission'],
      bluetoothPermission: map['bluetoothPermission'],
    );
  }
}

