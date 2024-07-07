import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geopawsfinal/adminbottom.dart';
import 'package:geopawsfinal/adminwelcome.dart';

class AdminViewApprovedPage extends StatefulWidget {
  final petId;
  final uid;
  final docId;
  const AdminViewApprovedPage(
      {super.key, required this.petId, required this.uid, required this.docId});

  @override
  _AdminViewApprovedPage createState() => _AdminViewApprovedPage();
}

class _AdminViewApprovedPage extends State<AdminViewApprovedPage> {
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
    petData();
    userData();
  }

  Future<void> petData() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('pet')
          .doc(widget.petId)
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
          petimages = userData['images'] ?? '';
        });
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error fetching document: $e');
    }
  }

  Future<void> userData() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
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
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error fetching document: $e');
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
                        builder: (context) => AdminWelcomePage(),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 10),
                const Text(
                  'Pet Approved',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildPetInfoSection(),
              const SizedBox(height: 20),
              _buildUserInfoSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPetInfoSection() {
    return Container(
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
              petimages,
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
    );
  }

  Widget _buildUserInfoSection() {
    return Container(
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
          Container(
            margin: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
            alignment: Alignment.bottomLeft,
            child: const Text(
              'Customer',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    ClipOval(
                      child: userimages == ''
                          ? const FaIcon(
                        FontAwesomeIcons.userCircle,
                        size: 50,
                        color: Colors.grey,
                      )
                          : Image.network(
                        userimages,
                        height: 70,
                        width: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildInfoRow('Name', '$firstname $lastname'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildInfoRow('Contact', contact),
                _buildInfoRow('Email', email),
                _buildInfoRow('Address', address),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 16, bottom: 8),
            alignment: Alignment.bottomLeft,
            child: const Text(
              "Valid ID's",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
          ),
          _buildValidIDSection(),
        ],
      ),
    );
  }

  Widget _buildValidIDSection() {
    return Column(
      children: [
        _buildIDImage(userimages2),
        _buildIDImage(userimages3),
      ],
    );
  }

  Widget _buildIDImage(String imageUrl) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: imageUrl == ''
          ? const Text(
        'No Valid ID',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
      )
          : Image.network(
        imageUrl,
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
