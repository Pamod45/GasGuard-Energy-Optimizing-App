import 'package:flutter/material.dart';
import 'package:gasguard_final/services/firestore_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cylinder_details.dart';
import 'header.dart'; // Import your custom header
import 'footer.dart';
import 'models/Cylinder.dart';
import 'models/GasUsage.dart'; // Import the Footer widget

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late FirestoreService firestoreService;
  String? name; // The fetched username
  Cylinder? cylinder; // The fetched cylinder data
  bool isLoading = true; // Loading indicator flag
  List<GasUsage> gasUsageHistory = [];
  final int limit = 7 ;

  @override
  void initState() {
    super.initState();
    firestoreService = FirestoreService();
    _loadData(); // Fetch the data asynchronously
  }

  Future<void> _loadData() async {
    name = await _getUsername();
    if (name != null && name!.isNotEmpty) {
      cylinder = await firestoreService.getCurrentCylinder(name!);
      // comment the below line
       //addSampleGasUsageRecords();
      if (cylinder != null) {
        print("Current cylinder id"+cylinder!.id.toString());
        gasUsageHistory = await firestoreService.getGasUsages(name!, cylinder!.id,limit);
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
      backgroundColor: const Color.fromARGB(255, 200, 232, 213),
      appBar: const Header(title: "Home"), // Header always displayed
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(), // Spinner for middle section
      )
          : SingleChildScrollView(
        physics: const BouncingScrollPhysics(), // Smooth scrolling
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Padding(
                padding: const EdgeInsets.only(left: 18),
                child: Text(
                  'Welcome back, ${name ?? "Guest"}', // Use fetched username
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Remaining Gas Container (Handles case when cylinder is null)
              Center(
                child: SizedBox(
                  width: 420,
                  height: 180,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 20, 70, 34),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: cylinder != null
                        ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cylinder!.name, // Display cylinder name
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${cylinder!.currentWeight}kg out of ${cylinder!.weight}kg', // Display weight
                          style: GoogleFonts.montserrat(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Remaining',
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${cylinder!.getRemainingDays()} days until renewal', // Display renewal days
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                        : Center(
                      child: Text(
                        'No current cylinder assigned. Please add or change a cylinder.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Current Connection Section
              Padding(
                padding: const EdgeInsets.only(left: 18),
                child: Text(
                  'Current Connection',
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: SizedBox(
                  width: 420,
                  height: 100,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 235, 248, 238),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: const Color.fromARGB(255, 20, 70, 34),
                        width: 1.5,
                      ),
                    ),
                    child: cylinder != null
                        ? Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Left section
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              cylinder!.name,
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${cylinder!.currentWeight}kg',
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                color: const Color.fromARGB(
                                    255, 20, 70, 34),
                              ),
                            ),
                          ],
                        ),
                        // Right section
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const CylinderDetailsScreen()));
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 0),
                          ),
                          child: Text(
                            'Change Cylinder',
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    )
                        : Center(
                      child: Text(
                        'No connection found. Add a cylinder to get started.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Usage History Section
              Padding(
                padding: const EdgeInsets.only(left: 18),
                child: Text(
                  'Usage History',
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: SizedBox(
                  width: 420,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 20, 70, 34),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: cylinder != null && gasUsageHistory.isNotEmpty
                        ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Date',
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Usage(kg)',
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        for (var usage in gasUsageHistory)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  DateFormat('dd/MM/yyyy').format(usage.date),
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  usage.usage.toString(),
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    )
                        : Center(
                      child: Text(
                        'No usage history available.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Footer(currentIndex: 0), // Footer always displayed
    );
  }

  // to add dummy data to the pubupere32@gmail.com user
  void addSampleGasUsageRecords() async {
    final format = DateFormat('dd/MM/yyyy');
    // final gasUsageVishan = [
    // //november
    //   {
    //     'cylinderId': 1,
    //     'date': format.parse('10/12/2024'),
    //     'usage': 0.6,
    //     'username': 'vishanperera0@gmail.com',
    //   },
    //   {
    //     'cylinderId': 1,
    //     'date': format.parse('11/12/2024'),
    //     'usage': 0.5,
    //     'username': 'vishanperera0@gmail.com',
    //   },
    //   {
    //     'cylinderId': 1,
    //     'date': format.parse('12/12/2024'),
    //     'usage': 0.3,
    //     'username': 'vishanperera0@gmail.com',
    //   },
    //   {
    //     'cylinderId': 1,
    //     'date': format.parse('13/12/2024'),
    //     'usage': 0.6,
    //     'username': 'vishanperera0@gmail.com',
    //   },
    //   {
    //     'cylinderId': 1,
    //     'date': format.parse('14/12/2024'),
    //     'usage': 0.4,
    //     'username': 'vishanperera0@gmail.com',
    //   },
    //   {
    //     'cylinderId': 1,
    //     'date': format.parse('15/12/2024'),
    //     'usage': 0.3,
    //     'username': 'vishanperera0@gmail.com',
    //   },
    //   {
    //     'cylinderId': 1,
    //     'date': format.parse('16/12/2024'),
    //     'usage': 0.3,
    //     'username': 'vishanperera0@gmail.com',
    //   },
    // ];
    final gasUsages = [
      //november
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('26/11/2024'),
      //   'usage': 0.4,
      //   'username': 'pubupere32@gmail.com',
      // },
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('23/11/2024'),
      //   'usage': 0.3,
      //   'username': 'pubupere32@gmail.com',
      // },
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('20/11/2024'),
      //   'usage': 0.8,
      //   'username': 'pubupere32@gmail.com',
      // },
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('17/11/2024'),
      //   'usage': 0.1,
      //   'username': 'pubupere32@gmail.com',
      // },
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('10/11/2024'),
      //   'usage': 0.6,
      //   'username': 'pubupere32@gmail.com',
      // },
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('09/11/2024'),
      //   'usage': 0.6,
      //   'username': 'pubupere32@gmail.com',
      // },{
      //   'cylinderId': 3,
      //   'date': format.parse('08/11/2024'),
      //   'usage': 0.2,
      //   'username': 'pubupere32@gmail.com',
      // },
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('05/11/2024'),
      //   'usage': 0.4,
      //   'username': 'pubupere32@gmail.com',
      // },
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('04/11/2024'),
      //   'usage': 0.1,
      //   'username': 'pubupere32@gmail.com',
      // },{
      //   'cylinderId': 3,
      //   'date': format.parse('02/11/2024'),
      //   'usage': 0.5,
      //   'username': 'pubupere32@gmail.com',
      // },
      // August 2024
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('30/08/2024'),
      //   'usage': 0.6,
      //   'username': 'pubupere32@gmail.com',
      // },
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('28/08/2024'),
      //   'usage': 0.4,
      //   'username': 'pubupere32@gmail.com',
      // },
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('25/08/2024'),
      //   'usage': 0.8,
      //   'username': 'pubupere32@gmail.com',
      // },
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('22/08/2024'),
      //   'usage': 0.5,
      //   'username': 'pubupere32@gmail.com',
      // },
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('20/08/2024'),
      //   'usage': 0.7,
      //   'username': 'pubupere32@gmail.com',
      // },
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('18/08/2024'),
      //   'usage': 0.3,
      //   'username': 'pubupere32@gmail.com',
      // },
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('16/08/2024'),
      //   'usage': 0.2,
      //   'username': 'pubupere32@gmail.com',
      // },
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('15/08/2024'),
      //   'usage': 0.9,
      //   'username': 'pubupere32@gmail.com',
      // },
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('08/08/2024'),
      //   'usage': 0.6,
      //   'username': 'pubupere32@gmail.com',
      // },
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('05/08/2024'),
      //   'usage': 0.4,
      //   'username': 'pubupere32@gmail.com',
      // },
      // may
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('30/05/2024'),
      //   'usage': 0.8,
      //   'username': 'pubupere32@gmail.com',
      // },
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('28/05/2024'),
      //   'usage': 0.5,
      //   'username': 'pubupere32@gmail.com',
      // },
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('25/05/2024'),
      //   'usage': 0.6,
      //   'username': 'pubupere32@gmail.com',
      // },
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('20/05/2024'),
      //   'usage': 0.7,
      //   'username': 'pubupere32@gmail.com',
      // },
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('18/05/2024'),
      //   'usage': 0.2,
      //   'username': 'pubupere32@gmail.com',
      // },
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('15/05/2024'),
      //   'usage': 0.4,
      //   'username': 'pubupere32@gmail.com',
      // },
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('12/05/2024'),
      //   'usage': 0.9,
      //   'username': 'pubupere32@gmail.com',
      // },
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('10/05/2024'),
      //   'usage': 0.6,
      //   'username': 'pubupere32@gmail.com',
      // },
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('08/05/2024'),
      //   'usage': 0.3,
      //   'username': 'pubupere32@gmail.com',
      // },
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('05/05/2024'),
      //   'usage': 0.5,
      //   'username': 'pubupere32@gmail.com',
      // },
      // //
      // // February 2024
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('28/02/2024'),
      //   'usage': 0.7,
      //   'username': 'pubupere32@gmail.com',
      // },
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('25/02/2024'),
      //   'usage': 0.6,
      //   'username': 'pubupere32@gmail.com',
      // },
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('22/02/2024'),
      //   'usage': 0.3,
      //   'username': 'pubupere32@gmail.com',
      // },
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('20/02/2024'),
      //   'usage': 0.8,
      //   'username': 'pubupere32@gmail.com',
      // },
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('18/02/2024'),
      //   'usage': 0.4,
      //   'username': 'pubupere32@gmail.com',
      // },
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('15/02/2024'),
      //   'usage': 0.9,
      //   'username': 'pubupere32@gmail.com',
      // },
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('12/02/2024'),
      //   'usage': 0.5,
      //   'username': 'pubupere32@gmail.com',
      // },
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('10/02/2024'),
      //   'usage': 0.6,
      //   'username': 'pubupere32@gmail.com',
      // },
      // {
      //   'cylinderId': 3,
      //   'date': ('08/02/2024'),
      //   'usage': 0.3,
      //   'username': 'pubupere32@gmail.com',
      // },
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('05/02/2024'),
      //   'usage': 0.7,
      //   'username': 'pubupere32@gmail.com',
      // },
      // //2023/07
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('30/07/2023'),
      //   'usage': 0.7,
      //   'username': 'pubupere32@gmail.com',
      // },
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('28/07/2023'),
      //   'usage': 0.6,
      //   'username': 'pubupere32@gmail.com',
      // },
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('25/07/2023'),
      //   'usage': 0.8,
      //   'username': 'pubupere32@gmail.com',
      // },
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('22/07/2023'),
      //   'usage': 0.3,
      //   'username': 'pubupere32@gmail.com',
      // },
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('20/07/2023'),
      //   'usage': 0.5,
      //   'username': 'pubupere32@gmail.com',
      // },
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('18/07/2023'),
      //   'usage': 0.9,
      //   'username': 'pubupere32@gmail.com',
      // },
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('15/07/2023'),
      //   'usage': 0.2,
      //   'username': 'pubupere32@gmail.com',
      // },
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('12/07/2023'),
      //   'usage': 0.4,
      //   'username': 'pubupere32@gmail.com',
      // },
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('10/07/2023'),
      //   'usage': 0.6,
      //   'username': 'pubupere32@gmail.com',
      // },
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('05/07/2023'),
      //   'usage': 0.8,
      //   'username': 'pubupere32@gmail.com',
      // },
      // // //2021/03
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('30/03/2021'),
      //   'usage': 0.4,
      //   'username': 'pubupere32@gmail.com',
      // },
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('28/03/2021'),
      //   'usage': 0.5,
      //   'username': 'pubupere32@gmail.com',
      // },
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('25/03/2021'),
      //   'usage': 0.7,
      //   'username': 'pubupere32@gmail.com',
      // },
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('22/03/2021'),
      //   'usage': 0.3,
      //   'username': 'pubupere32@gmail.com',
      // },
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('20/03/2021'),
      //   'usage': 0.6,
      //   'username': 'pubupere32@gmail.com',
      // },
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('18/03/2021'),
      //   'usage': 0.9,
      //   'username': 'pubupere32@gmail.com',
      // },
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('15/03/2021'),
      //   'usage': 0.8,
      //   'username': 'pubupere32@gmail.com',
      // },
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('12/03/2021'),
      //   'usage': 0.4,
      //   'username': 'pubupere32@gmail.com',
      // },
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('10/03/2021'),
      //   'usage': 0.5,
      //   'username': 'pubupere32@gmail.com',
      // },
      // {
      //   'cylinderId': 3,
      //   'date': format.parse('05/03/2021'),
      //   'usage': 0.6,
      //   'username': 'pubupere32@gmail.com',
      // },
    ];
    // Call the batch insert function
    //await firestoreService.addGasUsageBatch(gasUsageVishan);
  }


}
