import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geopawsfinal/pet.dart';

// ignore: camel_case_types
class AdminPetProfilePage extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final docId;
  const AdminPetProfilePage({super.key, required this.docId});

  @override
  // ignore: library_private_types_in_public_api
  _AdminPetProfilePage createState() => _AdminPetProfilePage();
}

// ignore: camel_case_types
class _AdminPetProfilePage extends State<AdminPetProfilePage> {
  String type = "";
  String breed = "";
  String age = "";
  String color = "";
  String arrivaldate = "";
  String sizeweight = "";
  String sex = "";
  String images = "";

  String email = "";

  @override
  void initState() {
    super.initState();
    // Fetch data based on the provided UID when the widget initializes
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('pet')
          .doc(widget
              .docId) // Replace 'your_document_id' with the actual document ID
          .get();

      if (documentSnapshot.exists) {
        var userData = documentSnapshot.data() as Map<String, dynamic>;

        setState(() {
          type = userData['type'] ?? '';
          breed = userData['breed'] ?? '';
          age = userData['age'] ?? '';
          color = userData['color'] ?? '';
          arrivaldate = userData['arrivaldate'] ?? '';
          sizeweight = userData['sizeweight'] ?? '';
          sex = userData['sex'] ?? '';
          images = userData['images'] ?? '';
        });
      } else {}
      // ignore: empty_catches
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
                        builder: (context) => const AdminPetPage(),
                      ));
                },
              ),
              const Text(
                'Pet Profile',
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
                        images,
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
            )
          ],
        ),
      ),
    );
  }
}
