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

// ignore: camel_case_types
class AdminWelcomePage extends StatefulWidget {
  const AdminWelcomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdminWelcomePage createState() => _AdminWelcomePage();
}

// ignore: camel_case_types
class _AdminWelcomePage extends State<AdminWelcomePage> {
  final _globalKey = GlobalKey<ScaffoldMessengerState>();

  final user = FirebaseAuth.instance.currentUser;

  String fullname = "";
  String picture = "";
  @override
  void initState() {
    super.initState();
    // Fetch data based on the provided UID when the widget initializes
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

              // Update other controllers for other fields accordingly
            });
          }
        }
      }
      // ignore: empty_catches
    } catch (e) {}
  }

  final searchController = TextEditingController();
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
          ),
          body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: [
                  Text(
                    fullname,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 40),
                  ),
                  CarouselSlider(
                    options: CarouselOptions(height: 120.0),
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
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(221, 182, 210, 252),
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 20),
                                  child: Image.asset(
                                    item['image']!,
                                    width: 100.0, // Adjust the width as needed
                                    height:
                                        100.0, // Adjust the height as needed
                                  ),
                                ),
                                const SizedBox(
                                    width:
                                        10.0), // Space between image and text
                                Expanded(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                        item['text']!,
                                        style: const TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                        item['text2']!,
                                        style: const TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ],
                                )),
                              ],
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                  // Container(
                  //   margin: const EdgeInsets.only(top: 20),
                  //   child: const Text(
                  //     'Pet for Adoption',
                  //     style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                  //   ),
                  // ),
                  // Container(
                  //   margin: const EdgeInsets.only(top: 10),
                  //   child: StreamBuilder(
                  //     stream: FirebaseFirestore.instance
                  //         .collection('pet')
                  //         .snapshots(),
                  //     builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  //       if (snapshot.connectionState == ConnectionState.waiting) {
                  //         return const Center(
                  //           child: CircularProgressIndicator(),
                  //         );
                  //       }
                  //       if (!snapshot.hasData || snapshot.data == null) {
                  //         return const Center(
                  //           child: Text('No data available'),
                  //         );
                  //       }
                  //       final alldata = snapshot.data!.docs;

                  //       if (alldata.isEmpty) {
                  //         return const Center(
                  //           child: Text('No pets available for adoption'),
                  //         );
                  //       }
                  //       return ListView.builder(
                  //         shrinkWrap:
                  //             true, // Important to use shrinkWrap inside a ListView
                  //         physics:
                  //             NeverScrollableScrollPhysics(), // Disable scrolling to avoid conflicts
                  //         itemCount: alldata.length,
                  //         itemBuilder: (context, index) {
                  //           final data = alldata[index];
                  //           // Access your fields from Firestore document
                  //           final type = data['type'] ?? 'Unnamed';
                  //           final breed = data['breed'] ?? 'Unnamed';

                  //           final docId = data.id; // Access the document ID here
                  //           // Assuming you have an image field in Firestore

                  //           return Container(
                  //             margin: const EdgeInsets.only(top: 8),
                  //             child: GestureDetector(
                  //                 child: Container(
                  //                   padding: const EdgeInsets.symmetric(
                  //                       horizontal: 10, vertical: 10),
                  //                   decoration: BoxDecoration(
                  //                     color: const Color.fromARGB(
                  //                         255, 239, 239, 239),
                  //                     borderRadius: BorderRadius.circular(20),
                  //                   ),
                  //                   child: Row(
                  //                     children: [
                  //                       Container(
                  //                         width: 60,
                  //                         height: 60,
                  //                         decoration: BoxDecoration(
                  //                           color: Colors.lightBlue,
                  //                           borderRadius:
                  //                               BorderRadius.circular(55),
                  //                         ),
                  //                         child: ClipOval(
                  //                           child: Image.network(
                  //                             data['images'],
                  //                             width: 60,
                  //                             height: 60,
                  //                             fit: BoxFit
                  //                                 .cover, // This ensures the image covers the circular area
                  //                             errorBuilder:
                  //                                 (context, error, stackTrace) {
                  //                               return Image.asset(
                  //                                   'assets/p1.png',
                  //                                   width: 60,
                  //                                   height: 60);
                  //                             },
                  //                           ),
                  //                         ),
                  //                       ),
                  //                       Expanded(
                  //                         child: Container(
                  //                           padding:
                  //                               const EdgeInsets.only(left: 10),
                  //                           child: Column(
                  //                             crossAxisAlignment:
                  //                                 CrossAxisAlignment.start,
                  //                             children: [
                  //                               Text(
                  //                                 type,
                  //                                 style: const TextStyle(
                  //                                   fontWeight: FontWeight.w700,
                  //                                 ),
                  //                               ),
                  //                               Text(
                  //                                 breed,
                  //                                 style: const TextStyle(
                  //                                   fontWeight: FontWeight.w500,
                  //                                 ),
                  //                               ),
                  //                             ],
                  //                           ),
                  //                         ),
                  //                       ),
                  //                       const SizedBox(width: 10.0),
                  //                       Container(
                  //                         padding: const EdgeInsets.all(5),
                  //                         child: const FaIcon(
                  //                           FontAwesomeIcons.chevronCircleRight,
                  //                           color:
                  //                               Color.fromARGB(255, 0, 63, 157),
                  //                         ),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                 ),
                  //                 onTap: () {
                  //                   Navigator.pushReplacement(
                  //                       context,
                  //                       MaterialPageRoute(
                  //                           builder: ((context) =>
                  //                               AdminPetProfilePage(
                  //                                   docId: docId))));
                  //                 }),
                  //           );
                  //         },
                  //       );
                  //     },
                  //   ),
                  // ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: const Text(
                      'Request',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('request')
                          .where('status', isEqualTo: 'Pending')
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                          shrinkWrap:
                              true, // Important to use shrinkWrap inside a ListView
                          physics:
                              NeverScrollableScrollPhysics(), // Disable scrolling to avoid conflicts
                          itemCount: alldata.length,
                          itemBuilder: (context, index) {
                            final data = alldata[index];
                            final fullname = data['fullname'] ?? 'Unnamed';

                            final petId = data['petId'];
                            final uid = data['uid'];
                            final docId = data.id;

                            return Container(
                              margin: const EdgeInsets.only(top: 8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 225, 237, 255),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              fullname,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: data['status'] == 'Pending'
                                              ? Colors
                                                  .grey // Default color when status is empty
                                              : (data['status'] == 'Approved'
                                                  ? Colors
                                                      .green // Color for approved status
                                                  : (data['status'] ==
                                                          'Declined'
                                                      ? Colors
                                                          .red // Color for pending status
                                                      : Colors
                                                          .grey)), // Default color for other statuses
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Text(
                                        '${data['status']}',
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white),
                                      ),
                                      padding: const EdgeInsets.all(5),
                                    ),
                                    GestureDetector(
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        child: const FaIcon(
                                          FontAwesomeIcons.eye,
                                          color:
                                              Color.fromARGB(255, 0, 63, 157),
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    AdminViewRequestPage(
                                                        petId: petId,
                                                        uid: uid,
                                                        docId: docId))));
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: const Text(
                      'Report',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('request')
                          .where('status', isEqualTo: 'Approved')
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                          shrinkWrap:
                              true, // Important to use shrinkWrap inside a ListView
                          physics:
                              NeverScrollableScrollPhysics(), // Disable scrolling to avoid conflicts
                          itemCount: alldata.length,
                          itemBuilder: (context, index) {
                            final data = alldata[index];
                            final fullname = data['fullname'] ?? 'Unnamed';

                            final petId = data['petId'];
                            final uid = data['uid'];
                            final docId = data.id;

                            return Container(
                              margin: const EdgeInsets.only(top: 8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 225, 255, 245),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              fullname,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: data['status'] == 'Pending'
                                              ? Colors
                                                  .grey // Default color when status is empty
                                              : (data['status'] == 'Approved'
                                                  ? Colors
                                                      .green // Color for approved status
                                                  : (data['status'] ==
                                                          'Declined'
                                                      ? Colors
                                                          .red // Color for pending status
                                                      : Colors
                                                          .grey)), // Default color for other statuses
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Text(
                                        '${data['status']}',
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white),
                                      ),
                                      padding: const EdgeInsets.all(5),
                                    ),
                                    GestureDetector(
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        child: const FaIcon(
                                          FontAwesomeIcons.eye,
                                          color:
                                              Color.fromARGB(255, 0, 63, 157),
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    AdminViewApprovedPage(
                                                        petId: petId,
                                                        uid: uid,
                                                        docId: docId))));
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
