import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geopawsfinal/adminbottom.dart';
import '/bottom.dart';
import '/register.dart';
import '/services.dart';
import '/forgot_password.dart'; // Import the ForgotPasswordPage

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final _globalKey = GlobalKey<ScaffoldMessengerState>();

  late TextEditingController emailController = TextEditingController();
  late TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _globalKey,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
            padding: const EdgeInsets.all(30),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                  ),
                  const Image(
                    image: AssetImage('assets/logo.png'),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    alignment: Alignment.bottomLeft,
                    child: const Text(
                      'Login!',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: Color.fromARGB(200, 31, 31, 31),
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
                        controller: emailController,
                        decoration: const InputDecoration(
                            labelText: 'Email', border: InputBorder.none),
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
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                            labelText: 'Password', border: InputBorder.none),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 63, 157),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 0, 63, 157),
                            borderRadius: BorderRadius.circular(30)),
                        child: TextButton(
                            onPressed: () {
                              Services()
                                  .signIn(emailController.text,
                                  passwordController.text)
                                  .then((value) {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .where('email',
                                    isEqualTo: emailController.text)
                                    .get()
                                    .then((QuerySnapshot querySnapshot) {
                                  for (QueryDocumentSnapshot doc
                                  in querySnapshot.docs) {
                                    String type = doc['type'];
                                    if (type == 'admin') {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AdminBottomPage()));
                                    } else {
                                      print(type);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  BottomPage()));
                                    }
                                  }
                                });
                              }).catchError((error) {
                                var snackBar = const SnackBar(
                                    content: Text('Invalid Credentials'));
                                _globalKey.currentState?.showSnackBar(snackBar);
                              });
                            },
                            child: const Text(
                              'Login',
                              style:
                              TextStyle(color: Colors.white, fontSize: 22),
                            ))),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    child: RichText(
                      text: TextSpan(
                        text: "You don't have an account? ",
                        style: const TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: 'Register',
                            style: const TextStyle(
                                color: Color.fromARGB(255, 0, 63, 157),
                                fontWeight: FontWeight.w600),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                        const RegisterPage())));
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
