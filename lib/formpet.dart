import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geopawsfinal/adminbottom.dart';
import 'package:image_picker/image_picker.dart';
import '/services.dart';

void main() {
  runApp(const AdminFormPetPage());
}

// ignore: camel_case_types
class AdminFormPetPage extends StatefulWidget {
  const AdminFormPetPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdminFormPetPage createState() => _AdminFormPetPage();
}

// ignore: camel_case_types
class _AdminFormPetPage extends State<AdminFormPetPage> {
  final _globalKey = GlobalKey<ScaffoldMessengerState>();

  final user = FirebaseAuth.instance.currentUser;
  final TextEditingController typeController = TextEditingController();
  final TextEditingController breedController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController arrivaldateController = TextEditingController();
  final TextEditingController sizeweightController = TextEditingController();
  final TextEditingController sexController = TextEditingController();

  String images = "";

  XFile? image;

  String downloadURL = "";

  Future<void> showImage(ImageSource source) async {
    final img = await ImagePicker().pickImage(source: source);
    setState(() {
      image = img;
    });
    if (img != null) {
      await uploadFirebase(File(img.path));
    }
  }

  Future<void> uploadFirebase(File imageFile) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // Schedule the dialog to close after 3 seconds
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.of(context).pop(true);
        });

        return AlertDialog(
          title: const Text('Waiting...'),
          content: const Text("Waiting to Upload Image to firebase"),
        );
      },
    );

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().toIso8601String()}.png');
      final uploadTask = storageRef.putFile(imageFile);
      await uploadTask.whenComplete(() async {
        downloadURL = await storageRef.getDownloadURL();
        setState(() {
          print("Download URL: $downloadURL");
        });
      });
    } catch (e) {
      print("Error during upload: $e");
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
                    Icons.arrow_left,
                    size: 40,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminBottomPage(),
                        ));
                  },
                ),
                const Text(
                  'Pet Form',
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
          body: ListView(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        showImage(ImageSource.gallery).then((value) {});
                      },
                      child: Container(
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(82, 228, 228, 228),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            image != null
                                ? Image.file(
                                    File(image!.path),
                                    width: 70,
                                    height: 70,
                                  )
                                : images != ''
                                    ? Image.network(
                                        images,
                                        width: 70,
                                        height: 70,
                                      )
                                    : const FaIcon(
                                        FontAwesomeIcons.userCircle,
                                        size: 70,
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
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 30),
                      child: Container(
                        padding: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(82, 228, 228, 228),
                            borderRadius: BorderRadius.circular(30)),
                        child: TextField(
                          controller: typeController,
                          decoration: const InputDecoration(
                              labelText: 'Type',
                              border: InputBorder.none,
                              labelStyle: TextStyle(color: Colors.black)),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 30),
                      child: Container(
                        padding: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(82, 228, 228, 228),
                            borderRadius: BorderRadius.circular(30)),
                        child: TextField(
                          controller: breedController,
                          decoration: const InputDecoration(
                              labelText: 'Breed',
                              border: InputBorder.none,
                              labelStyle: TextStyle(color: Colors.black)),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 30),
                      child: Container(
                        padding: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(82, 228, 228, 228),
                            borderRadius: BorderRadius.circular(30)),
                        child: TextField(
                          controller: ageController,
                          decoration: const InputDecoration(
                              labelText: 'Age',
                              border: InputBorder.none,
                              labelStyle: TextStyle(color: Colors.black)),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 30),
                      child: Container(
                        padding: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(82, 228, 228, 228),
                            borderRadius: BorderRadius.circular(30)),
                        child: TextField(
                          controller: colorController,
                          decoration: const InputDecoration(
                              labelText: 'Color',
                              border: InputBorder.none,
                              labelStyle: TextStyle(color: Colors.black)),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 30),
                      child: Container(
                        padding: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(82, 228, 228, 228),
                            borderRadius: BorderRadius.circular(30)),
                        child: TextField(
                          controller: arrivaldateController,
                          decoration: const InputDecoration(
                              labelText: 'Arrival Date',
                              border: InputBorder.none,
                              labelStyle: TextStyle(color: Colors.black)),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 30),
                      child: Container(
                        padding: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(82, 228, 228, 228),
                            borderRadius: BorderRadius.circular(30)),
                        child: TextField(
                          controller: sizeweightController,
                          decoration: const InputDecoration(
                              labelText: 'Size Weight',
                              border: InputBorder.none,
                              labelStyle: TextStyle(color: Colors.black)),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 30),
                      child: Container(
                        padding: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(82, 228, 228, 228),
                            borderRadius: BorderRadius.circular(30)),
                        child: TextField(
                          controller: sexController,
                          decoration: const InputDecoration(
                              labelText: 'Sex',
                              border: InputBorder.none,
                              labelStyle: TextStyle(color: Colors.black)),
                        ),
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        margin: const EdgeInsets.only(top: 30),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 0, 63, 157),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: SizedBox(
                          child: TextButton(
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('pet')
                                  .doc()
                                  .set({
                                'type': typeController.text,
                                'breed': breedController.text,
                                'age': ageController.text,
                                'color': colorController.text,
                                'arrivaldate': arrivaldateController.text,
                                'sizeweight': sizeweightController.text,
                                'sex': sexController.text,
                                'images': downloadURL,
                                'status': 'Available',
                              }).then((value) {
                                var snackBar = const SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text('Success Submit Pet'));
                                _globalKey.currentState?.showSnackBar(snackBar);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AdminBottomPage()));
                              });
                            },
                            child: const Text(
                              'Save',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        )),
                    Container(margin: const EdgeInsets.only(bottom: 20))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
