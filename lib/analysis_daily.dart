import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gasguard_final/footer.dart';
import 'package:gasguard_final/services/firestore_service.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'analysis_monthly.dart';
import 'header.dart';
import 'models/Cylinder.dart';
import 'models/GasUsage.dart';

class AnalysisDaily extends StatefulWidget {
  const AnalysisDaily({super.key});

  @override
  _AnalysisDailyState createState() => _AnalysisDailyState();
}
class _AnalysisDailyState extends State<AnalysisDaily> {

  List<Map<String, int>> gasUsageData = [];
  List<Map<String, String>> upComingGasUsage = [];

  int startDayIndex = 23;
  // Analysis type
  String _analysisType = 'Daily';

  // Dropdown initial values
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
    startDayIndex = (gasUsageData.length - 7 >= 0) ? gasUsageData.length - 7 : 0;
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
                        onChanged: (value) {
                          setState(() {
                            _analysisType = value!;
                          });
                          // Navigate to the monthly analysis page when Monthly is selected
                          if (_analysisType == 'Monthly') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AnalysisMonthly(),
                              ),
                            );
                          }
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
                                gasUsageHistory.map((usage) =>DateFormat('dd/MM/yyyy').format(usage.date)).toList());
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: _buildDropdown(
                      items: selectedYears,
                      selectedValue: _selectedYear,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedYear = value;
                          selectedMonths = []; // Clear months when a new year is selected
                          _selectedMonth = null; // Reset selected month

                          if (_selectedYear != null) {
                            selectedMonths = getMonthsForYear(
                              gasUsageHistory.map((usage) => DateFormat('dd/MM/yyyy').format(usage.date)).toList(),
                              int.parse(_selectedYear!),
                            );
                            print("Updated months: $selectedMonths");
                          }
                        });
                      },
                      dropdown: 2,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDropdown(
                      items: selectedMonths,
                      selectedValue: _selectedMonth,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedMonth = value;
                          setState(() {
                            gasUsageData = filterAndFormatGasUsage();
                          });
                        });
                      },
                      dropdown: 3,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _selectedMonth == null ? Text('') :
              gasUsageData.isEmpty ?
              Text('') :
              Text(
                "Gas Usage of ${_selectedMonth ?? ''}",
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
                  'Please select a month to view data.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ):
              _selectedMonth == null ?
              const Center(
                child: Text(
                  'Please select a month to view data.',
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
                                int dayIndex = value.toInt();
                                int actualDay = dayIndex + 1 + startDayIndex;
                                if (dayIndex >= 0 && dayIndex < 7 && actualDay <= gasUsageData.length) {
                                  return Text(
                                    actualDay.toString(),
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
                                if (value % 100 == 0) {
                                  return Text(
                                    '${value.toInt()}', // Convert the value to an integer for display
                                    style: const TextStyle(fontSize: 10, fontFamily: 'Montserrat'),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                              interval: 200, // Display labels at intervals of 100
                              // Increase the margin to give more room for the labels
                              reservedSize: 32  // Adjust the margin to provide more space on the left
                            ),
                          ),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        gridData: const FlGridData(show: true),
                        borderData: FlBorderData(show: true),
                        minY: 0,
                        // Dynamically set maxY based on the data
                        maxY: gasUsageData.isNotEmpty
                            ? (gasUsageData
                            .map((data) => data['grams']?.toDouble())
                            .where((grams) => grams != null)
                            .reduce((a, b) => a! > b! ? a : b)! * 1.2) // Add 20% padding
                            : 1000, // Default maxY if no data
                        barGroups: gasUsageData
                            .skip(startDayIndex)
                            .take(7)
                            .map((data) {
                          return BarChartGroupData(
                            x: gasUsageData.indexOf(data) - startDayIndex,
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
              SizedBox(height: 16),
              _selectedMonth == null ?
              Text(''):
              gasUsageData.isEmpty ?
              Text('') :
              Text(
                'Average gas usage per day: ${(gasUsageData.map((data) => data['grams']!).reduce((a, b) => a + b) / gasUsageData.length).toStringAsFixed(2)}g',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              _selectedMonth == null ? Text('') : gasUsageData.isEmpty ? Text('') :
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
              'Predicted Daily Gas Usage',
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
                    entry['usage']!,
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
    if (startDayIndex - 7 >= 0) {
      setState(() {
        startDayIndex -= 7;
      });
    }
  }

  void _showNextData() {
    if (startDayIndex + 7 < gasUsageData.length) {
      setState(() {
        startDayIndex += 7;
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

    final int? month = monthMapping[_selectedMonth];
    if (month == null) {
      throw ArgumentError('Invalid month: $_selectedMonth');
    }

    // Filter gas usage history by the selected month and year
    final List<GasUsage> filteredGasUsage = gasUsageHistory.where((usage) {
      String date = DateFormat('dd/MM/yyyy').format(usage.date);
      if (date.length < 10) return false;

      // Check if the date matches the selected month and year
      return int.tryParse(date.substring(3, 5)) == month &&
          date.substring(6) == _selectedYear;
    }).toList();

    // Extract the highest day from the filtered data
    int maxDay = filteredGasUsage.fold<int>(0,(currentMax, usage) {
      String date = DateFormat('dd/MM/yyyy').format(usage.date);
        final int? day = int.tryParse(date.substring(0, 2));
        return (day != null && day > currentMax) ? day : currentMax;
      },
    );
    if (maxDay == 0) return [];
    final Map<int, int> usageByDay = {for (int day = 1; day <= maxDay; day++) day: 0};

    for (GasUsage usage in filteredGasUsage) {
      String date = DateFormat('dd/MM/yyyy').format(usage.date);
      final int? day = int.tryParse(date.substring(0, 2));
      if (day != null) {
        usageByDay[day] = (usage.usage * 1000).toInt(); // Convert to grams
      }
    }
    final List<Map<String, int>> gasUsageData = usageByDay.entries
        .map((entry) => {'day': entry.key, 'grams': entry.value})
        .toList();
    setState(() {
      final DateTime currentDate = DateTime.now();
      final Random random = Random();
      upComingGasUsage = List.generate(7, (index) {
        final DateTime nextDate = currentDate.add(Duration(days: index + 1));
        return {
          'date': DateFormat('dd/MM/yyyy').format(nextDate),
          'usage': '${random.nextInt(1401) + 100}g', // Random usage between 100 and 1500 grams
        };
      });
    });

    return gasUsageData;
  }
}
