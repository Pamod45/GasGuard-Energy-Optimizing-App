//
// import 'dart:typed_data';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
//
// class BluetoothDevicesScreen extends StatefulWidget {
//   const BluetoothDevicesScreen({Key? key}) : super(key: key);
//
//   @override
//   _BluetoothDevicesScreenState createState() => _BluetoothDevicesScreenState();
// }
//
// class _BluetoothDevicesScreenState extends State<BluetoothDevicesScreen> {
//   List<BluetoothDevice> pairedDevices = [];
//   List<BluetoothDiscoveryResult> discoveredDevices = [];
//   bool isDiscovering = false;
//   BluetoothConnection? connection;
//
//   @override
//   void initState() {
//     super.initState();
//     _checkBluetoothPermissions();
//     _getPairedDevices();
//   }
//
//   Future<void> _checkBluetoothPermissions() async {
//     try {
//       bool isEnabled = await FlutterBluetoothSerial.instance.isEnabled ?? false;
//       if (!isEnabled) {
//         bool? requestResult =
//         await FlutterBluetoothSerial.instance.requestEnable();
//         if (requestResult == false) {
//           debugPrint('Bluetooth not enabled!');
//           return;
//         }
//       }
//
//       bool isDiscoverable =
//           await FlutterBluetoothSerial.instance.isDiscoverable ?? false;
//       if (!isDiscoverable) {
//         debugPrint('Ensure the Bluetooth device is in discoverable mode.');
//       }
//     } catch (e) {
//       debugPrint('Error checking Bluetooth permissions: $e');
//     }
//   }
//
//   Future<void> _getPairedDevices() async {
//     try {
//       final devices = await FlutterBluetoothSerial.instance.getBondedDevices();
//       setState(() {
//         pairedDevices = devices;
//       });
//       debugPrint('Paired devices: $pairedDevices');
//     } catch (e) {
//       debugPrint('Error getting paired devices: $e');
//     }
//   }
//
//   void _startDiscovery() {
//     setState(() {
//       isDiscovering = true;
//       discoveredDevices.clear();
//     });
//
//     FlutterBluetoothSerial.instance.startDiscovery().listen((result) {
//       setState(() {
//         // Avoid duplicates
//         if (!discoveredDevices.any(
//                 (r) => r.device.address == result.device.address)) {
//           discoveredDevices.add(result);
//         }
//       });
//       debugPrint(
//           'Discovered device: ${result.device.name} - ${result.device.address}');
//     }).onDone(() {
//       setState(() {
//         isDiscovering = false;
//       });
//       debugPrint('Discovery finished.');
//     });
//   }
//
//   // Function to connect to the HC-05 device
//   Future<void> _connectToDevice(BluetoothDevice device) async {
//     try {
//       // Disconnect any existing connection
//       connection?.dispose();
//
//       // Connect to the HC-05
//       const String hc05Uuid = "00001101-0000-1000-8000-00805F9B34FB";
//       int? discoverable = await FlutterBluetoothSerial.instance.requestDiscoverable(300);
//       if (discoverable!>0) {
//         debugPrint('Device is discoverable for 300 seconds');
//       } else {
//         debugPrint('Failed to make device discoverable');
//       }
//       // connection = await BluetoothConnection.toAddress(device.address);
//       connection = await BluetoothConnection.toAddress(
//         device.address,
//       );
//       debugPrint('Connected to the device');
//
//       setState(() {});
//     } catch (e) {
//       debugPrint('Error connecting to the device: $e');
//     }
//   }
//
//   // Function to send data to the HC-05
//   Future<void> _sendData(String data) async {
//     if (connection != null && connection!.isConnected) {
//       connection!.output.add(Uint8List.fromList(data.codeUnits));
//       await connection!.output.allSent;
//       debugPrint('Data sent: $data');
//     }
//   }
//
//   // Function to receive data from the HC-05
//   void _receiveData() {
//     connection!.input?.listen((data) {
//       String receivedData = String.fromCharCodes(data);
//       debugPrint('Received from HC-05: $receivedData');
//     });
//   }
//
//   @override
//   void dispose() {
//     connection?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Bluetooth Devices'),
//         actions: [
//           IconButton(
//             icon: Icon(isDiscovering ? Icons.stop : Icons.search),
//             onPressed: isDiscovering ? null : _startDiscovery,
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           const Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Text(
//               'Paired Devices',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: pairedDevices.length,
//               itemBuilder: (context, index) {
//                 final device = pairedDevices[index];
//                 return ListTile(
//                   title: Text(device.name ?? 'Unknown Device'),
//                   subtitle: Text(device.address),
//                   onTap: () {
//                     _connectToDevice(device);
//                   },
//                 );
//               },
//             ),
//           ),
//           const Divider(height: 2, thickness: 2),
//           const Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Text(
//               'Discovered Devices',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: discoveredDevices.length,
//               itemBuilder: (context, index) {
//                 final result = discoveredDevices[index];
//                 final device = result.device;
//                 return ListTile(
//                   title: Text(device.name ?? 'Unknown Device'),
//                   subtitle: Text(device.address),
//                   trailing: ElevatedButton(
//                     onPressed: () {
//                       // Pairing functionality (if needed)
//                       debugPrint('Pairing with ${device.name}');
//                     },
//                     child: const Text('Pair'),
//                   ),
//                 );
//               },
//             ),
//           ),
//           if (connection != null && connection!.isConnected)
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 children: [
//                   ElevatedButton(
//                     onPressed: () => _sendData('Hello HC-05'),
//                     child: Text('Send Data to HC-05'),
//                   ),
//                   ElevatedButton(
//                     onPressed: _receiveData,
//                     child: Text('Receive Data from HC-05'),
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
