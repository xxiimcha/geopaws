import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geopawsfinal/bottom.dart';
import 'package:image_picker/image_picker.dart';
import 'services.dart';  // Import Services

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ReportFormPage(),
  ));
}

class ReportFormPage extends StatefulWidget {
  const ReportFormPage({super.key});

  @override
  _ReportFormPageState createState() => _ReportFormPageState();
}

class _ReportFormPageState extends State<ReportFormPage> {
  final _globalKey = GlobalKey<ScaffoldMessengerState>();

  final user = FirebaseAuth.instance.currentUser;
  final TextEditingController petNameController = TextEditingController();
  final TextEditingController lostDateController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController additionalInfoController = TextEditingController();
  final TextEditingController timeController = TextEditingController(); // Added for Time input

  String images = "";
  XFile? image;
  String downloadURL = "";

  final Services _services = Services();  // Instantiate Services

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
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.of(context).pop(true);
        });

        return const AlertDialog(
          title: Text('Uploading...'),
          content: Text("Uploading image to Firebase"),
        );
      },
    );

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('reports/${DateTime.now().toIso8601String()}.png');
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
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, size: 30, color: Colors.white),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BottomPage(),
                    ));
              },
            ),
            title: const Text(
              'Report',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Concern input field
                  buildTextField('What is your concern?', petNameController),
                  const SizedBox(height: 16),

                  // Image Upload Section
                  GestureDetector(
                    onTap: () {
                      showImage(ImageSource.gallery).then((value) {});
                    },
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(82, 228, 228, 228),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          image != null
                              ? Image.file(
                            File(image!.path),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          )
                              : const FaIcon(
                            FontAwesomeIcons.image,
                            size: 70,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Upload Image',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Date and Time input fields
                  Row(
                    children: [
                      Expanded(
                        child: buildTextField('Date', lostDateController),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: buildTextField('Time', timeController),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Location input field
                  buildTextField('Location', locationController),
                  const SizedBox(height: 16),

                  // Additional Information input field
                  buildTextField(
                    'Additional Information',
                    additionalInfoController,
                    maxLines: 5,
                  ),

                  const SizedBox(height: 30),

                  // Submit Report Button
                  Container(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        await _services.createPetReport(
                          petNameController.text,
                          lostDateController.text,
                          locationController.text,
                          additionalInfoController.text,
                          downloadURL,
                          user?.email ?? '',
                        );

                        var snackBar = const SnackBar(
                            backgroundColor: Colors.green,
                            content: Text('Report submitted successfully'));
                        _globalKey.currentState?.showSnackBar(snackBar);

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BottomPage()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 0, 63, 157),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Submit Report',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, TextEditingController controller,
      {int maxLines = 1}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: labelText,
          border: InputBorder.none,
          labelStyle: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
