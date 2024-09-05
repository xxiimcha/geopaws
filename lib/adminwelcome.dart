import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:geopawsfinal/admin_view_approved.dart';
import 'package:geopawsfinal/admin_view_request.dart';
import 'package:geopawsfinal/adminpetprofile.dart';

void main() {
  runApp(const AdminWelcomePage());
}

class AdminWelcomePage extends StatefulWidget {
  const AdminWelcomePage({super.key});

  @override
  _AdminWelcomePage createState() => _AdminWelcomePage();
}

class _AdminWelcomePage extends State<AdminWelcomePage> {
  final _globalKey = GlobalKey<ScaffoldMessengerState>();
  final user = FirebaseAuth.instance.currentUser;

  String fullname = "";
  String picture = "";

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('uid', isEqualTo: user.uid)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          var userData =
          querySnapshot.docs.first.data() as Map<String, dynamic>?;

          if (userData != null) {
            setState(() {
              fullname = userData['fullname'] ?? '';
              picture = userData['picture'] ?? '';
            });
          }
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScaffoldMessenger(
        key: _globalKey,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 0, 63, 157),
            title: const Text(
              'Welcome Admin',
              style: TextStyle(color: Colors.white),
            ),
            elevation: 2,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              children: [
                const SizedBox(height: 20),
                Text(
                  fullname,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 28),
                ),
                const SizedBox(height: 10),
                _buildCarouselSlider(),
                const SizedBox(height: 20),
                _sectionHeader('Requests'),
                const SizedBox(height: 10),
                _buildRequestSection('Pending', context, AdminViewRequestPage),
                const SizedBox(height: 10),
                _buildRequestSection('Approved', context, AdminViewApprovedPage),
                const SizedBox(height: 20),
                _sectionHeader('Reports'), // Keep the Reports section
                const SizedBox(height: 10),
                _buildReportsSection(context), // Load data from pet_reports collection here
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCarouselSlider() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 160.0,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
      ),
      items: [
        {
          'image': 'assets/person.png',
          'text': 'Join our',
          'text2': 'Community',
        },
        {
          'image': 'assets/person2.png',
          'text': 'Share your',
          'text2': 'Pet moments',
        },
      ].map((item) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(221, 182, 210, 252),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(
                      item['image']!,
                      width: 90.0,
                      height: 90.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            item['text']!,
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            item['text2']!,
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
          fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black),
    );
  }

  // Requests Section for Pending and Approved
  Widget _buildRequestSection(String status, BuildContext context, Type viewPage) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('request')
          .where('status', isEqualTo: status)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(
            child: Text('No data available'),
          );
        }
        final alldata = snapshot.data!.docs;
        if (alldata.isEmpty) {
          return const Center(
            child: Text('No requests available'),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: alldata.length,
          itemBuilder: (context, index) {
            final data = alldata[index];
            final fullname = data['fullname'] ?? 'Unnamed';
            final petId = data['petId'];
            final uid = data['uid'];
            final docId = data.id;

            return _buildRequestCard(
                data, fullname, petId, uid, docId, status, context, viewPage);
          },
        );
      },
    );
  }

  // Reports Section
  Widget _buildReportsSection(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('pet_reports') // Fetch data from the pet_reports collection
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(
            child: Text('No reports available'),
          );
        }
        final reportData = snapshot.data!.docs;
        if (reportData.isEmpty) {
          return const Center(
            child: Text('No reports available'),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: reportData.length,
          itemBuilder: (context, index) {
            final data = reportData[index];
            final petName = data['pet_name'] ?? 'Unnamed Pet';
            final reportId = data.id;

            return _buildReportCard(context, petName, reportId, data);
          },
        );
      },
    );
  }

  // Request Card Widget
  Widget _buildRequestCard(
      dynamic data,
      String fullname,
      String petId,
      String uid,
      String docId,
      String status,
      BuildContext context,
      Type viewPage,
      ) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 225, 237, 255),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              fullname,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: status == 'Pending' ? Colors.grey : Colors.green,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              status,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
          IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.eye,
              color: Color.fromARGB(255, 0, 63, 157),
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => viewPage == AdminViewRequestPage
                      ? AdminViewRequestPage(petId: petId, uid: uid, docId: docId)
                      : AdminViewApprovedPage(petId: petId, uid: uid, docId: docId),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Report Card Widget for pet_reports collection
  Widget _buildReportCard(BuildContext context, String petName, String reportId, dynamic data) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 225, 237, 255),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              petName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.eye,
              color: Color.fromARGB(255, 0, 63, 157),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReportDetailsPage(data: data),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ReportDetailsPage extends StatelessWidget {
  final dynamic data;

  const ReportDetailsPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 63, 157),
        title: const Text("Report Details"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 5,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Circular Pet Image
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(data['image']),
                  ),
                  const SizedBox(height: 20),

                  // Pet Name Section
                  Text(
                    data['pet_name'] ?? 'Unnamed Pet',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Appearance Section
                  _buildDetailItem(
                    context: context,
                    icon: Icons.pets,
                    title: 'Appearance',
                    subtitle: data['appearance'] ?? 'Not specified',
                  ),
                  const Divider(),

                  // Date Lost Section
                  _buildDetailItem(
                    context: context,
                    icon: Icons.calendar_today,
                    title: 'Date Lost',
                    subtitle: data['date_lost'] ?? 'Not specified',
                  ),
                  const Divider(),

                  // Location Lost Section
                  _buildDetailItem(
                    context: context,
                    icon: Icons.location_on,
                    title: 'Location Lost',
                    subtitle: data['location_lost'] ?? 'Not specified',
                  ),
                  const Divider(),

                  // Additional Information Section
                  _buildDetailItem(
                    context: context,
                    icon: Icons.info_outline,
                    title: 'Additional Info',
                    subtitle: data['additional_info'] ?? 'No additional information',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color.fromARGB(255, 0, 63, 157)),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}