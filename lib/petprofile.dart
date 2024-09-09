import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geopawsfinal/bottom.dart';
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
  String rescueLocation = "";
  String firstOwner = "";
  String healthIssues = "";
  String additionalDetails = "";
  String fullname = "";

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
          rescueLocation = userData['rescue_location'] ?? '';
          firstOwner = userData['first_owner'] ?? '';
          healthIssues = userData['health_issues'] ?? '';
          additionalDetails = userData['additional_details'] ?? '';
        });
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error fetching document: $e');
    }
  }

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
            backgroundColor: Colors.blue, // Set background to blue
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white), // Set back icon to white
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PetPage(),
                  ),
                );
              },
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      child: Image.network(
                        images,
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildInfoCard('Age', age),
                              _buildInfoCard('Weight', sizeweight),
                              _buildInfoCard('Sex', sex),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildInfoRow('Type', type),
                          _buildInfoRow('Breed', breed),
                          _buildInfoRow('Color', color),
                          _buildInfoRow('Arrival Date', arrivaldate),
                          const SizedBox(height: 16),
                          _buildInfoRow('Rescue Location', rescueLocation),
                          _buildInfoRow('First Owner', firstOwner),
                          _buildInfoRow('Health Issues', healthIssues),
                          _buildInfoRow('Additional Details', additionalDetails),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.pets, color: Colors.white),
                  label: const Text('Adopt'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                  ),
                  onPressed: () {
                    _showConfirmationDialog(context, user);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF3FC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
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
              color: Colors.black,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
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
          content: const Text(
              "Adopting a pet is a big responsibility and a long-term commitment. This furry friend will rely on you for love, care, and support for many years to come. Please confirm that you are ready to welcome this pet into your home and provide the necessary care and attention they deserve."),
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
                      content: Text('Already Requested'),
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
