import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geopawsfinal/adminbottom.dart';
import 'package:geopawsfinal/adminwelcome.dart';
import 'package:geopawsfinal/welcome.dart';

// ignore: camel_case_types
class ViewApprovedPage extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final petId;
  final uid;
  final docId;
  const ViewApprovedPage(
      {super.key, required this.petId, required this.uid, required this.docId});

  @override
  // ignore: library_private_types_in_public_api
  _ViewApprovedPage createState() => _ViewApprovedPage();
}

// ignore: camel_case_types
class _ViewApprovedPage extends State<ViewApprovedPage> {
  final _globalKey = GlobalKey<ScaffoldMessengerState>();

  String type = "";
  String breed = "";
  String age = "";
  String color = "";
  String arrivaldate = "";
  String sizeweight = "";
  String sex = "";
  String petimages = "";

  String firstname = "";
  String lastname = "";
  String contact = "";
  String address = "";
  String email = "";
  String userimages = "";
  String userimages2 = "";
  String userimages3 = "";

  @override
  void initState() {
    super.initState();
    // Fetch data based on the provided UID when the widget initializes
    petData();
    userData();
  }

  Future<void> petData() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('pet')
          .doc(widget
              .petId) // Replace 'your_document_id' with the actual document ID
          .get();

      if (documentSnapshot.exists) {
        var userData = documentSnapshot.data() as Map<String, dynamic>;

        setState(() {
          type = userData['type'] ?? '';
          breed = userData['breed'] ?? '';
          age = userData['age'] ?? '';
          color = userData['contact'] ?? '';
          arrivaldate = userData['address'] ?? '';
          sizeweight = userData['email'] ?? '';
          sex = userData['sex'] ?? '';
          petimages = userData['images'] ?? '';
        });
      } else {}
      // ignore: empty_catches
    } catch (e) {}
  }

  Future<void> userData() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget
              .uid) // Replace 'your_document_id' with the actual document ID
          .get();

      if (documentSnapshot.exists) {
        var userData = documentSnapshot.data() as Map<String, dynamic>;

        setState(() {
          firstname = userData['firstname'] ?? '';
          lastname = userData['lastname'] ?? '';
          contact = userData['contact'] ?? '';
          address = userData['address'] ?? '';
          email = userData['email'] ?? '';
          userimages = userData['images'] ?? '';
          userimages2 = userData['images2'] ?? '';
          userimages3 = userData['images3'] ?? '';
        });
      } else {}
      // ignore: empty_catches
    } catch (e) {}
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
            title: Row(
              children: [
                GestureDetector(
                  child: const Icon(
                    Icons.arrow_left,
                    size: 40,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WelcomePage(),
                        ));
                  },
                ),
                const Text(
                  'Pet Approved',
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
          body: ListView(
            children: [
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                    ),
                    child: Column(
                      children: [
                        Image.network(
                          petimages,
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                        const Text(
                          'Image',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 30),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 0, 63, 157),
                                borderRadius: BorderRadius.circular(30)),
                            child: Text(
                              'Type:  $type',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 30),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 0, 63, 157),
                                borderRadius: BorderRadius.circular(30)),
                            child: Text('Breed: $breed',
                                style: const TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 30),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 0, 63, 157),
                                borderRadius: BorderRadius.circular(30)),
                            child: Text('Age: $age',
                                style: const TextStyle(color: Colors.white)),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 30),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 0, 63, 157),
                                borderRadius: BorderRadius.circular(30)),
                            child: Text('Color: $color',
                                style: const TextStyle(color: Colors.white)),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 30),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 0, 63, 157),
                                borderRadius: BorderRadius.circular(30)),
                            child: Text('Arrival Date: $arrivaldate',
                                style: const TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 30),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 0, 63, 157),
                                borderRadius: BorderRadius.circular(30)),
                            child: Text('Size Weight: $sizeweight',
                                style: const TextStyle(color: Colors.white)),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 30),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 0, 63, 157),
                                borderRadius: BorderRadius.circular(30)),
                            child: Text('Sex: $sex',
                                style: const TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(margin: const EdgeInsets.only(bottom: 20))
                ],
              ),
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 22, top: 50),
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Customer',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClipOval(
                          child: userimages == ''
                              ? FaIcon(
                                  FontAwesomeIcons.userCircle,
                                  size: 50,
                                  color: Colors.grey,
                                )
                              : Image.network(
                                  userimages,
                                  height: 70,
                                  width:
                                      70, // You need to set the width to make it a circle
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 30, left: 30),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 0, 63, 157),
                                borderRadius: BorderRadius.circular(30)),
                            child: Text(
                              'Name:  $firstname $lastname',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 30),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 0, 63, 157),
                                borderRadius: BorderRadius.circular(30)),
                            child: Text('Contact: $contact',
                                style: const TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(top: 30),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 0, 63, 157),
                                  borderRadius: BorderRadius.circular(30)),
                              child: Text('Email: $email',
                                  style: const TextStyle(color: Colors.white)),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 30),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 0, 63, 157),
                                borderRadius: BorderRadius.circular(30)),
                            child: Text('Address: $address',
                                style: const TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomLeft,
                    margin: const EdgeInsets.only(top: 30, left: 20),
                    child: const Text(
                      "Valid ID's",
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: userimages2 == ''
                        ? Text(
                            'No Valid ID',
                            style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey),
                          )
                        : Image.network(
                            userimages2,
                          ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: userimages3 == ''
                        ? Text(
                            'No Valid ID',
                            style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey),
                          )
                        : Image.network(
                            userimages3,
                          ),
                  ),
                  Container(margin: const EdgeInsets.only(bottom: 20))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
