import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:geopawsfinal/adminbottom.dart';
import 'package:geopawsfinal/adminpetprofile.dart';
import 'package:geopawsfinal/formpet.dart';

void main() {
  runApp(const AdminPetPage());
}

// ignore: camel_case_types
class AdminPetPage extends StatefulWidget {
  const AdminPetPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdminPetPage createState() => _AdminPetPage();
}

// ignore: camel_case_types
class _AdminPetPage extends State<AdminPetPage> {
  final _globalKey = GlobalKey<ScaffoldMessengerState>();
  final searchController = TextEditingController();
  String searchQuery = "";

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
                        builder: (context) => AdminBottomPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 10),
                const Text(
                  'Pet',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminFormPetPage(),
                          ),
                        );
                      },
                      child: const FaIcon(
                        FontAwesomeIcons.plusSquare,
                        color: Color.fromARGB(255, 0, 63, 157),
                        size: 50,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'ADD PET',
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 63, 157),
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    labelText: "Search Pet",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value.toLowerCase();
                    });
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'Pet for Adoption',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 10),
                StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('pet').snapshots(),
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

                    final filteredData = alldata.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final type = data['type'].toString().toLowerCase();
                      final breed = data['breed'].toString().toLowerCase();
                      return type.contains(searchQuery) ||
                          breed.contains(searchQuery);
                    }).toList();

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: filteredData.length,
                      itemBuilder: (context, index) {
                        final data = filteredData[index];
                        final type = data['type'] ?? 'Unnamed';
                        final breed = data['breed'] ?? 'Unnamed';
                        final docId = data.id;

                        return Container(
                          margin: const EdgeInsets.only(top: 8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 239, 239, 239),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.lightBlue,
                                    borderRadius: BorderRadius.circular(55),
                                  ),
                                  child: ClipOval(
                                    child: Image.network(
                                      data['images'],
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset('assets/p1.png',
                                            width: 60, height: 60);
                                      },
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          type,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          breed,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                                GestureDetector(
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    child: const FaIcon(
                                      FontAwesomeIcons.chevronCircleRight,
                                      color: Color.fromARGB(255, 0, 63, 157),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: ((context) =>
                                            AdminPetProfilePage(docId: docId)),
                                      ),
                                    );
                                  },
                                ),
                                GestureDetector(
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    child: const FaIcon(
                                      FontAwesomeIcons.trash,
                                      color: Colors.red,
                                    ),
                                  ),
                                  onTap: () {
                                    FirebaseFirestore.instance
                                        .collection('pet')
                                        .doc(docId)
                                        .delete()
                                        .then((value) {
                                      var snackBar = const SnackBar(
                                        backgroundColor: Colors.green,
                                        content: Text('Success Delete Data'),
                                      );
                                      _globalKey.currentState
                                          ?.showSnackBar(snackBar);
                                    });
                                  },
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
