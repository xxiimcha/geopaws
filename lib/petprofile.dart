import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geopawsfinal/bottom.dart';
import 'package:geopawsfinal/login.dart';
import 'package:geopawsfinal/pet2.dart';

class PetProfilePage extends StatefulWidget {
  final docId;
  const PetProfilePage({super.key, required this.docId});

  @override
  _PetProfilePage createState() => _PetProfilePage();
}

class _PetProfilePage extends State<PetProfilePage> {
  final _globalKey = GlobalKey<ScaffoldMessengerState>();

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
    fetchData();
    userfetchData();
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
        print('Document does not exist');
      }
    } catch (e) {
      print('Error fetching document: $e');
    }
  }

  String fullname = "";

  Future<void> userfetchData() async {
    final user = FirebaseAuth.instance.currentUser;

    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      if (documentSnapshot.exists) {
        var userData = documentSnapshot.data() as Map<String, dynamic>;

        setState(() {
          String firstname = userData['firstname'] ?? '';
          String lastname = userData['lastname'] ?? '';
          fullname = '$firstname $lastname';
        });
      } else {}
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
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
                    Icons.arrow_back,
                    size: 30,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PetPage(),
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
              const SizedBox(height: 20),
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 50),
                  padding: const EdgeInsets.symmetric(horizontal: 90),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xdd2e3131),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: TextButton(
                      onPressed: () {
                        _showConfirmationDialog(context, user);
                      },
                      child: const Text(
                        'Request Adopt',
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w700,
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

  void _showConfirmationDialog(BuildContext context, User? user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Are you sure you want to adopt this pet?"),
          content: const Text("Are you aware about the condition of this pet? No cancellation."),
          actions: <Widget>[
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('request')
                    .where('uid', isEqualTo: user!.uid)
                    .where('status', isEqualTo: 'Pending')
                    .get()
                    .then((QuerySnapshot querySnapshot) {
                  if (querySnapshot.docs.isEmpty) {
                    FirebaseFirestore.instance.collection('request').add({
                      'petId': widget.docId,
                      'uid': user.uid,
                      'fullname': fullname,
                      'status': 'Pending'
                    });

                    Navigator.of(context).pop(); // Close the dialog
                    var snackBar = const SnackBar(
                      backgroundColor: Colors.green,
                      content: Text(
                          'Success Request Adopt Waiting for approval'),
                    );
                    _globalKey.currentState?.showSnackBar(snackBar);
                  } else {
                    Navigator.of(context).pop(); // Close the dialog
                    var snackBar = const SnackBar(
                      content: Text('Already Request'),
                    );
                    _globalKey.currentState?.showSnackBar(snackBar);
                  }
                }).catchError((error) {
                  print("Error getting documents: $error");
                });
              },
            ),
            TextButton(
              child: const Text("No"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
