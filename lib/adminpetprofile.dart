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
          .doc(widget.docId)
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
      } else {
        // Document does not exist
        print('Document does not exist');
      }
    } catch (e) {
      // Error handling for document fetch or data extraction
      print('Error fetching document: $e');
    }
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
                  Icons.arrow_back,
                  size: 30,
                  color: Colors.white,
                ),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminPetPage(),
                    ),
                  );
                },
              ),
              const SizedBox(width: 10),
              const Text(
                'Pet Profile',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(10),
                    ),
                    child: Image.network(
                      images,
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildInfoRow('Type', type),
                        _buildInfoRow('Breed', breed),
                        _buildInfoRow('Age', age),
                        _buildInfoRow('Color', color),
                        _buildInfoRow('Arrival Date', arrivaldate),
                        _buildInfoRow('Size Weight', sizeweight),
                        _buildInfoRow('Sex', sex),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
