// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'analysis_daily.dart';
// import 'footer.dart';
// import 'header.dart';
//
// class AnalysisMonthly extends StatefulWidget {
//   const AnalysisMonthly({super.key});
//
//   @override
//   _AnalysisMonthlyState createState() => _AnalysisMonthlyState();
// }
//
// class _AnalysisMonthlyState extends State<AnalysisMonthly> {
//   // Analysis type
//   String _analysisType = 'Monthly';
//
//   // Dropdown initial values
//   String? _selectedYear = '2024';
//   String? _selectedMonth = 'Sep';
//
//   // Gas usage data array (monthly)
//   final List<Map<String, int>> gasUsageData = [
//     {'grams': 500, 'month': 1}, // January
//     {'grams': 300, 'month': 2}, // February
//     {'grams': 225, 'month': 3}, // March
//     {'grams': 400, 'month': 4}, // April
//     {'grams': 350, 'month': 5}, // May
//     {'grams': 275, 'month': 6}, // June
//     {'grams': 600, 'month': 7}, // July
//     {'grams': 450, 'month': 8}, // August
//     {'grams': 525, 'month': 9}, // September
//     {'grams': 300, 'month': 10}, // October
//     {'grams': 275, 'month': 11}, // November
//     {'grams': 400, 'month': 12}, // December
//   ];
//
//   // Recent gas usage table data
//   final List<Map<String, String>> recentGasUsage = [
//     {'month': 'October', 'usage': '570g'},
//     {'month': 'November', 'usage': '800g'},
//     {'month': 'December', 'usage': '200g'},
//   ];
//
//   // Start from the most recent month
//   int startMonthIndex = 8; // Start with September (index 8)
//
//   @override
//   void initState() {
//     super.initState();
//     startMonthIndex = (gasUsageData.length - 3 >= 0) ? gasUsageData.length - 3 : 0;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const Header(title: 'Analysis'),
//       backgroundColor: const Color(0xFFDFF2E0),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               // Analysis type toggle (Daily, Monthly)
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Row(
//                     children: [
//                       const Text(
//                         'Daily',
//                         style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                       ),
//                       Radio<String>(
//                         value: 'Daily',
//                         groupValue: _analysisType,
//                         onChanged: (value) {
//                           setState(() {
//                             _analysisType = value!;
//                           });
//                           // Navigate to Daily Analysis Screen
//                           if (_analysisType == 'Daily') {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => const AnalysisDaily(),
//                               ),
//                             );
//                           }
//                         },
//                       ),
//                     ],
//                   ),
//                   const SizedBox(width: 24),
//                   Row(
//                     children: [
//                       const Text(
//                         'Monthly',
//                         style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                       ),
//                       Radio<String>(
//                         value: 'Monthly',
//                         groupValue: _analysisType,
//                         onChanged: (value) {
//                           setState(() {
//                             _analysisType = value!;
//                           });
//                         },
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               // Dropdowns for Year and Month
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Expanded(
//                     child: _buildDropdown(
//                       items: ['2024', '2023', '2022'],
//                       selectedValue: _selectedYear,
//                       onChanged: (value) => setState(() => _selectedYear = value),
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: _buildDropdown(
//                       items: [
//                         'Jan',
//                         'Feb',
//                         'Mar',
//                         'Apr',
//                         'May',
//                         'Jun',
//                         'Jul',
//                         'Aug',
//                         'Sep',
//                         'Oct',
//                         'Nov',
//                         'Dec'
//                       ],
//                       selectedValue: _selectedMonth,
//                       onChanged: (value) => setState(() => _selectedMonth = value),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               // Gas usage chart title
//               const Text(
//                 'Gas Usage of September',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   fontFamily: 'Montserrat',
//                   color: Color.fromARGB(255, 0, 75, 35),
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 8),
//               // Bar graph for monthly data
//               Column(
//                 children: [
//                   SizedBox(
//                     height: 200,
//                     child: BarChart(
//                       BarChartData(
//                         titlesData: FlTitlesData(
//                           bottomTitles: AxisTitles(
//                             sideTitles: SideTitles(
//                               showTitles: true,
//                               getTitlesWidget: (value, meta) {
//                                 int monthIndex = value.toInt();
//                                 int actualMonth = monthIndex + 1 + startMonthIndex;
//                                 if (monthIndex >= 0 &&
//                                     monthIndex < 3 &&
//                                     actualMonth <= gasUsageData.length) {
//                                   return Text(
//                                     _getMonthName(actualMonth),
//                                     style: const TextStyle(fontSize: 10, fontFamily: 'Montserrat'),
//                                   );
//                                 }
//                                 return const SizedBox.shrink();
//                               },
//                               interval: 1,
//                             ),
//                           ),
//                           leftTitles: AxisTitles(
//                             sideTitles: SideTitles(
//                               showTitles: true,
//                               getTitlesWidget: (value, meta) {
//                                 if (value % 100 == 0 && value <= 800) {
//                                   return Text(
//                                     '${value.toInt()}',
//                                     style: const TextStyle(fontSize: 10, fontFamily: 'Montserrat'),
//                                   );
//                                 }
//                                 return const SizedBox.shrink();
//                               },
//                               interval: 100,
//                             ),
//                           ),
//                           topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                           rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                         ),
//                         gridData: const FlGridData(show: true),
//                         borderData: FlBorderData(show: true),
//                         minY: 0,
//                         maxY: 800,
//                         barGroups: gasUsageData
//                             .skip(startMonthIndex)
//                             .take(3)
//                             .map((data) {
//                           return BarChartGroupData(
//                             x: gasUsageData.indexOf(data) - startMonthIndex,
//                             barRods: [
//                               BarChartRodData(
//                                 toY: data['grams']!.toDouble(),
//                                 color: const Color.fromARGB(255, 0, 75, 35),
//                               ),
//                             ],
//                           );
//                         }).toList(),
//                       ),
//                     ),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       GestureDetector(
//                         onTap: _showPreviousData,
//                         child: Image.asset('assets/Left.png', width: 40, height: 40),
//                       ),
//                       GestureDetector(
//                         onTap: _showNextData,
//                         child: Image.asset('assets/Right.png', width: 40, height: 40),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               // Average gas usage
//               Text(
//                 'Average gas usage per month: ${(gasUsageData.map((data) => data['grams']!).reduce((a, b) => a + b) / gasUsageData.length).toStringAsFixed(2)}g',
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   fontFamily: 'Montserrat',
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 16),
//               // Recent gas usage table
//               _buildGasUsageTable(),
//             ],
//           ),
//         ),
//       ),
//         bottomNavigationBar: Footer(currentIndex: 2),
//     );
//   }
//
//   String _getMonthName(int month) {
//     const months = [
//       'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
//     ];
//     return months[month - 1];
//   }
//
//   void _showPreviousData() {
//     if (startMonthIndex - 3 >= 0) {
//       setState(() {
//         startMonthIndex -= 3;
//       });
//     }
//   }
//
//   void _showNextData() {
//     if (startMonthIndex + 3 < gasUsageData.length) {
//       setState(() {
//         startMonthIndex += 3;
//       });
//     }
//   }
//
//   Widget _buildDropdown({
//     required List<String> items,
//     required String? selectedValue,
//     required void Function(String?) onChanged,
//   }) {
//     return DropdownButtonFormField<String>(
//       value: selectedValue,
//       items: items.map((String item) {
//         return DropdownMenuItem<String>(
//           value: item,
//           child: Text(item),
//         );
//       }).toList(),
//       onChanged: onChanged,
//       decoration: const InputDecoration(
//         contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
//         border: OutlineInputBorder(),
//       ),
//     );
//   }
//
//   Widget _buildGasUsageTable() {
//     return Container(
//       padding: const EdgeInsets.all(16.0),
//       decoration: BoxDecoration(
//         color: const Color(0xFF184C2E), // Background color
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Recent gas usage table title
//           const Center(
//             child: Text(
//               'Recent Monthly Gas Usage',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 fontFamily: 'Montserrat',
//                 color: Colors.white,
//               ),
//             ),
//           ),
//           const SizedBox(height: 16), // Spacing before table content
//           // Recent gas usage table rows
//           ...recentGasUsage.map((entry) {
//             return Padding(
//               padding: const EdgeInsets.symmetric(vertical: 8.0), // Add spacing between rows
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align data to the corners
//                 children: [
//                   Text(
//                     entry['month']!,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.normal,
//                       fontFamily: 'Montserrat',
//                       color: Colors.white,
//                     ),
//                   ),
//                   Text(
//                     entry['usage']!,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.normal,
//                       fontFamily: 'Montserrat',
//                       color: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }),
//           const SizedBox(height: 16), // Add some spacing
//         ],
//       ),
//     );
//   }
// }


import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gasguard_final/footer.dart';
import 'package:gasguard_final/services/firestore_service.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'analysis_daily.dart';
import 'analysis_monthly.dart';
import 'header.dart';
import 'models/Cylinder.dart';
import 'models/GasUsage.dart';

class AnalysisMonthly extends StatefulWidget {
  const AnalysisMonthly({super.key});

  @override
  _AnalysisMonthlyState createState() => _AnalysisMonthlyState();
}
class _AnalysisMonthlyState extends State<AnalysisMonthly> {

  List<Map<String, int>> gasUsageData = [];
  List<Map<String, String>> upComingGasUsage = [];

  int startMonthIndex = 8;
  String _analysisType = 'Monthly';

  String? _selectedYear = null;
  String? _selectedMonth = null;
  String? _selectedCylinderType = null;
  static const String month = "";

  late FirestoreService firestoreService;
  String? name; // The fetched username
  List<Cylinder> cylinders = [];
  bool isLoading = true; // Loading indicator flag
  List<GasUsage> gasUsageHistory = [];
  List<String> selectedYears = [];
  List<String> selectedMonths = [];
  final int limit = 7 ;

  @override
  void initState() {
    super.initState();
    startMonthIndex = (gasUsageData.length - 3 >= 0) ? gasUsageData.length - 3 : 0;
    firestoreService = FirestoreService();
    _loadData(); // Fetch the data asynchronously
  }

  Future<void> _loadData() async {
    name = await _getUsername();
    if (name != null && name!.isNotEmpty) {
      cylinders = await firestoreService.getAllCylinders(name!);
      for(Cylinder cyl in cylinders){
        print("Cylinder id:${cyl.name}");
      }
    }

    setState(() {
      isLoading = false; // Data has been loaded
    });
  }

  Future<String> _getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? '';
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(title: 'Analysis'),
      backgroundColor: const Color(0xFFDFF2E0),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Analysis type toggle (Daily, Monthly, Custom Range)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Daily',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                          color: Color.fromARGB(255, 0, 75, 35),
                        ),
                      ),
                      Radio<String>(
                        value: 'Daily',
                        groupValue: _analysisType,
                        onChanged: (value) {
                          setState(() {
                            _analysisType = value!;
                          });
                          if (_analysisType == 'Daily') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AnalysisDaily(),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(width: 24), // Adjust the width to increase/decrease spacing
                  Row(
                    children: [
                      const Text(
                        'Monthly',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                          color: Color.fromARGB(255, 0, 75, 35),
                        ),
                      ),
                      Radio<String>(
                        value: 'Monthly',
                        groupValue: _analysisType,
                        onChanged: (value) { // here
                          setState(() {
                            _analysisType = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              Center(
                child: SizedBox(
                  width: 400,
                  child: _buildDropdown(
                    items: cylinders.isEmpty
                        ? ['Loading...']
                        : cylinders.map((cylinder) => cylinder.name).toList(),
                    selectedValue: _selectedCylinderType, // Initially null
                    onChanged: (String? value) async {
                      setState(() {
                        _selectedCylinderType = value;
                        selectedYears = []; // Clear years when a new cylinder is selected
                        selectedMonths = []; // Clear months as well
                        _selectedYear = null; // Reset selected year
                        _selectedMonth = null; // Reset selected month
                      });

                      if (_selectedCylinderType != null) {
                        int selectedCylinderId = cylinders
                            .firstWhere((cylinder) => cylinder.name == _selectedCylinderType)
                            .id;
                        List<GasUsage> fetchedGasUsage =
                        await firestoreService.getGasUsages(name!, selectedCylinderId, 0);
                        for (GasUsage us in fetchedGasUsage) {
                          print("Gas Usage :${us.date}");
                        }
                        setState(() {
                          gasUsageHistory = fetchedGasUsage; // Update the gas usage history
                          if (gasUsageHistory.isNotEmpty) {
                            selectedYears = getYearsFromDates(
                                gasUsageHistory.map((usage) => DateFormat('dd/MM/yyyy').format(usage.date)).toList());
                            for (String year in selectedYears) {
                              print("Year :${year}");
                            }
                          }
                        });
                      }
                    },
                    dropdown: 1,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: SizedBox(
                  width: 400,
                  child: _buildDropdown(
                    items: selectedYears,
                    selectedValue: _selectedYear,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedYear = value;
                        setState(() {
                          if (_selectedYear != null) {
                            gasUsageData = filterAndFormatGasUsage();
                          }else{
                            gasUsageData = [];
                          }
                        });
                      });
                    },
                    dropdown: 2,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _selectedYear == null ? Text('') :
              gasUsageData.isEmpty ?
              Text('') :
              Text(
                "Gas Usage of ${_selectedYear ?? ''}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                  color: Color.fromARGB(255, 0, 75, 35),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              gasUsageData.isEmpty ?
              const Center(
                child: Text(
                  'No data found for the selected year to view data.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ):
              _selectedYear == null ?
              const Center(
                child: Text(
                  'Please select a year to view data.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ) :
              Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: BarChart(
                      BarChartData(
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                int monthIndex = value.toInt();
                                int actualMonth = monthIndex + 1 + startMonthIndex;
                                if (monthIndex >= 0 &&
                                    monthIndex < 3 &&
                                    actualMonth <= gasUsageData.length) {
                                  return Text(
                                    convertToMonth(actualMonth),
                                    style: const TextStyle(fontSize: 10, fontFamily: 'Montserrat'),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                              interval: 1,
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                if (value % 1000 == 0) {
                                  return Text(
                                    '${value.toInt()}',
                                    style: const TextStyle(fontSize: 10, fontFamily: 'Montserrat'),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                              interval: 1000,
                              reservedSize: 32,
                            ),
                          ),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        gridData: const FlGridData(show: true),
                        borderData: FlBorderData(show: true),
                        minY: 0,
                        maxY: gasUsageData.isNotEmpty
                            ? (gasUsageData
                            .map((data) => data['grams']?.toDouble())
                            .where((grams) => grams != null)
                            .reduce((a, b) => a! > b! ? a : b)! * 1.2)
                            : 1000, // Default maxY if no data
                        barGroups: gasUsageData
                            .skip(startMonthIndex)
                            .take(3)
                            .map((data) {
                          return BarChartGroupData(
                            x: gasUsageData.indexOf(data) - startMonthIndex,
                            barRods: [
                              BarChartRodData(
                                toY: data['grams']!.toDouble(),
                                color: const Color.fromARGB(255, 0, 75, 35),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: _showPreviousData,
                        child: Image.asset('assets/Left.png', width: 40, height: 40),
                      ),
                      GestureDetector(
                        onTap: _showNextData,
                        child: Image.asset('assets/Right.png', width: 40, height: 40),
                      ),
                    ],
                  ),
                ],
              ),


              // Column(
              //   children: [
              //     SizedBox(
              //       height: 200,
              //       child: BarChart(
              //         BarChartData(
              //           titlesData: FlTitlesData(
              //             bottomTitles: AxisTitles(
              //               sideTitles: SideTitles(
              //                 showTitles: true,
              //                 getTitlesWidget: (value, meta) {
              //                   int monthIndex = value.toInt();
              //                   int actualMonth = monthIndex + 1 + startMonthIndex;
              //                   if (monthIndex >= 0 &&
              //                       monthIndex < 3 &&
              //                       actualMonth <= gasUsageData.length) {
              //                     return Text(
              //                       convertToMonth(actualMonth),
              //                       style: const TextStyle(fontSize: 10, fontFamily: 'Montserrat'),
              //                     );
              //                   }
              //                   return const SizedBox.shrink();
              //                 },
              //                 interval: 1,
              //               ),
              //             ),
              //             leftTitles: AxisTitles(
              //               sideTitles: SideTitles(
              //                 showTitles: true,
              //                 getTitlesWidget: (value, meta) {
              //                   if (value % 100 == 0 && value <= 800) {
              //                     return Text(
              //                       '${value.toInt()}',
              //                       style: const TextStyle(fontSize: 10, fontFamily: 'Montserrat'),
              //                     );
              //                   }
              //                   return const SizedBox.shrink();
              //                 },
              //                 interval: 100,
              //               ),
              //             ),
              //             topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              //             rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              //           ),
              //           gridData: const FlGridData(show: true),
              //           borderData: FlBorderData(show: true),
              //           minY: 0,
              //           maxY: 800,
              //           barGroups: gasUsageData
              //               .skip(startMonthIndex)
              //               .take(3)
              //               .map((data) {
              //             return BarChartGroupData(
              //               x: gasUsageData.indexOf(data) - startMonthIndex,
              //               barRods: [
              //                 BarChartRodData(
              //                   toY: data['grams']!.toDouble(),//here is the issue ("Null check operator used on a null value")
              //                   color: const Color.fromARGB(255, 0, 75, 35),
              //                 ),
              //               ],
              //             );
              //           }).toList(),
              //         ),
              //       ),
              //     ),
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         GestureDetector(
              //           onTap: _showPreviousData,
              //           child: Image.asset('assets/Left.png', width: 40, height: 40),
              //         ),
              //         GestureDetector(
              //           onTap: _showNextData,
              //           child: Image.asset('assets/Right.png', width: 40, height: 40),
              //         ),
              //       ],
              //     ),
              //   ],
              // ),

              SizedBox(height: 16),
              _selectedYear == null ?
              Text(''):
              gasUsageData.isEmpty ?
              Text('') :
              Text(
                'Average gas usage per month: ${(gasUsageData.map((data) => data['grams']?.toDouble()).reduce((a, b) => a! + b!)! / gasUsageData.length).toStringAsFixed(2)}g',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              _selectedYear == null ? Text('') : gasUsageData.isEmpty ? Text('') :
              _buildGasUsageTable(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Footer(currentIndex: 2),
    );
  }

  Widget _buildGasUsageTable() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF184C2E), // Background color
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Predicted Daily Gas Usage title
          const Center(
            child: Text(
              'Predicted Monthly Gas Usage',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16), // Spacing before table content
          // Recent gas usage table rows
          ...upComingGasUsage.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0), // Add spacing between rows
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align data to the corners
                children: [
                  Text(
                    entry['date']!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "${entry['usage']!}g",//error here again
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 16), // Add some spacing
        ],
      ),
    );
  }


  void _showPreviousData() {
    if (startMonthIndex - 3 >= 0) {
      setState(() {
        startMonthIndex -= 3;
      });
    }
  }

  void _showNextData() {
    if (startMonthIndex + 3 < gasUsageData.length) {
      setState(() {
        startMonthIndex += 3;
      });
    }
  }

  Widget _buildToggleOption(String type) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _analysisType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: _analysisType == type
              ? const Color.fromARGB(255, 0, 75, 35)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _analysisType == type
                ? const Color.fromARGB(255, 0, 75, 35)
                : Colors.grey,
          ),
        ),
        child: Text(
          type,
          style: TextStyle(
            color: _analysisType == type
                ? Colors.white
                : const Color.fromARGB(255, 0, 75, 35),
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
          ),
        ),
      ),
    );
  }
  Widget _buildDropdown({
    required List<String> items, // List of names
    required String? selectedValue, // The selected cylinder name
    required void Function(String?) onChanged, // Callback for when selection changes
    required int dropdown
  }) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      items: [
        DropdownMenuItem<String>(
          value: null, // Placeholder value
          child: Text(
            dropdown == 1 ? 'Select a Cylinder' : dropdown == 2 ? 'Select a year' : 'Select a month',
            style: const TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.grey, // Make placeholder text a different color
              fontSize: 14,
            ),
          ),
        ),
        ...items.map((String item) {
          return DropdownMenuItem<String>(
            value: item, // The name of the cylinder as value
            child: Text(
              item, // Display the name of the cylinder
              style: const TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          );
        }).toList(),
      ],
      onChanged: onChanged,
      style: const TextStyle(
        fontFamily: 'Montserrat',
        color: Colors.black,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  List<String> getYearsFromDates(List<String> dates) {
    // Extract the years from each date and add to a Set to avoid duplicates
    Set<String> years = {};

    for (var date in dates) {
      var dateParts = date.split('/');
      if (dateParts.length == 3) {
        years.add(dateParts[2]);
      }
    }
    return years.toList()..sort((a, b) => b.compareTo(a));
  }

  List<String> getMonthsForYear(List<String> dates, int year) {
    // Create a set to store unique months
    Set<String> months = {};

    for (var date in dates) {
      // Split the date by '/' and get the year and month part
      var dateParts = date.split('/');
      if (dateParts.length == 3) {
        int dateYear = int.parse(dateParts[2]);
        int dateMonth = int.parse(dateParts[1]);

        // If the year matches, add the month to the set
        if (dateYear == year) {
          months.add(convertToMonth(dateMonth));
        }
      }
    }
    return months.toList()..sort();
  }

  String convertToMonth(int index) {
    if (index == 1) {
      return "January";
    } else if (index == 2) {
      return "February";
    } else if (index == 3) {
      return "March";
    } else if (index == 4) {
      return "April";
    } else if (index == 5) {
      return "May";
    } else if (index == 6) {
      return "June";
    } else if (index == 7) {
      return "July";
    } else if (index == 8) {
      return "August";
    } else if (index == 9) {
      return "September";
    } else if (index == 10) {
      return "October";
    } else if (index == 11) {
      return "November";
    } else if (index == 12) {
      return "December";
    } else {
      return "Invalid month"; // Handle invalid index
    }
  }

  List<Map<String, int>> filterAndFormatGasUsage() {
    // Month name to number mapping
    const Map<String, int> monthMapping = {
      'January': 1,
      'February': 2,
      'March': 3,
      'April': 4,
      'May': 5,
      'June': 6,
      'July': 7,
      'August': 8,
      'September': 9,
      'October': 10,
      'November': 11,
      'December': 12,
    };

    // Check if the selected year is valid
    if (_selectedYear == null) {
      throw ArgumentError('Invalid year: $_selectedYear');
    }

    // Filter gas usage data for the selected year
    final List<GasUsage> filteredGasUsage = gasUsageHistory.where((usage) {
      String date = DateFormat('dd/MM/yyyy').format(usage.date);
      if (date.length < 10) return false;
      return date.substring(6) == _selectedYear;
    }).toList();

    // Initialize usage by month with zero values
    final Map<int, double> usageByMonth = {
      for (int month = 1; month <= 12; month++) month: 0.0
    };

    // Aggregate gas usage by month
    for (GasUsage usage in filteredGasUsage) {
      String date = DateFormat('dd/MM/yyyy').format(usage.date);
      final int? month = int.tryParse(date.substring(3, 5));
      if (month != null) {
        usageByMonth[month] = (usageByMonth[month] ?? 0) + usage.usage;
      }
    }

    // Convert usage data into the desired format (List<Map<String, int>>)
    List<Map<String, int>> gasUsageByMonth = usageByMonth.entries.map((entry) {
      return {
        'month': entry.key, // Month as integer
        'grams': (entry.value * 1000).toInt(), // Usage in grams, converted to integer
      };
    }).toList();

    // Update the upcoming gas usage with dummy random data
    setState(() {
      final DateTime currentDate = DateTime.now();
      final Random random = Random();

      upComingGasUsage = List.generate(7, (index) {
        print("Next month :"+convertToMonth((index+1)%12));
        final DateTime nextDate = currentDate.add(Duration(days: index + 1));
        return {
          'date': convertToMonth((index+1)%12),
          'usage': (random.nextInt(1401) + 100).toString(), // Random usage between 100 and 1500 grams
        };
      });
    });

    // Print gas usage for debugging purposes
    for (Map<String, int> monthUsage in gasUsageByMonth) {
      print("Month: ${monthUsage['month']}, Usage: ${monthUsage['grams']}g");
    }

    return gasUsageByMonth;
  }

}
