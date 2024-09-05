import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:geopawsfinal/petprofile.dart';
import 'package:geopawsfinal/view_approved.dart';
import 'package:geopawsfinal/view_request.dart';

void main() {
  runApp(const WelcomePage());
}

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  _WelcomePage createState() => _WelcomePage();
}

class _WelcomePage extends State<WelcomePage> {
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

  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 0, 63, 157),
          title: const Text(
            'Welcome',
            style: TextStyle(color: Colors.white, fontSize: 22),
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
                    fontWeight: FontWeight.w700, fontSize: 30),
              ),
              const SizedBox(height: 10),
              _buildCarouselSlider(),
              const SizedBox(height: 20),
              _sectionHeader('Request'),
              const SizedBox(height: 10),
              _buildRequestSection('Pending'),
              const SizedBox(height: 20),
              _sectionHeader('Approved'),
              const SizedBox(height: 10),
              _buildRequestSection('Approved'),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarouselSlider() {
    return CarouselSlider(
      options: CarouselOptions(height: 150.0, autoPlay: true),
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
                  )
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
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            item['text2']!,
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
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
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
    );
  }

  Widget _buildRequestSection(String status) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('request')
          .where('status', isEqualTo: status)
          .where('uid', isEqualTo: user!.uid)
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
            child: Text('No pets available for adoption'),
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

            return _buildRequestCard(data, fullname, petId, uid, docId, status);
          },
        );
      },
    );
  }

  Widget _buildRequestCard(
      dynamic data, String fullname, String petId, String uid, String docId, String status) {
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
              // Navigate to detailed view
              if (status == 'Pending') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewRequestPage(
                      petId: petId,
                      uid: uid,
                      docId: docId,
                    ),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewApprovedPage(
                      petId: petId,
                      uid: uid,
                      docId: docId,
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
