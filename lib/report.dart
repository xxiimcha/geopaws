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
  final TextEditingController appearanceController = TextEditingController();
  final TextEditingController additionalInfoController = TextEditingController();

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
            title: Row(
              children: [
                GestureDetector(
                  child: const Icon(
                    Icons.arrow_back,
                    size: 40,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BottomPage(),
                        ));
                  },
                ),
                const Text(
                  'Report Pet',
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
          body: ListView(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
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
                              FontAwesomeIcons.image,
                              size: 70,
                            ),
                            const Text(
                              'Add Image of Pet',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    buildTextField('Pet Name', petNameController),
                    buildTextField('Date Lost', lostDateController),
                    buildTextField('Location Lost', locationController),
                    buildTextField('Appearance (Color, Size, etc.)', appearanceController, maxLines: 5),
                    buildTextField('Additional Information', additionalInfoController, maxLines: 5),
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
                          onPressed: () async {
                            await _services.createPetReport(
                              petNameController.text,
                              lostDateController.text,
                              locationController.text,
                              appearanceController.text,
                              additionalInfoController.text,
                              downloadURL,
                              user?.email ?? '',
                            );

                            var snackBar = const SnackBar(
                                backgroundColor: Colors.green,
                                content: Text('Pet report submitted successfully'));
                            _globalKey.currentState?.showSnackBar(snackBar);

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BottomPage()));
                          },
                          child: const Text(
                            'Submit Report',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    ),
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

  Widget buildTextField(String labelText, TextEditingController controller, {int maxLines = 1}) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
          color: const Color.fromARGB(82, 228, 228, 228),
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
            labelText: labelText,
            border: InputBorder.none,
            labelStyle: const TextStyle(color: Colors.black)),
      ),
    );
  }
}
