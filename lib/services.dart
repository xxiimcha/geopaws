import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Services {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential?> signInwithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;
      if (user == null) {
        return null;
      }

      // Step 5: Get user details from Google account
      final String uid = user.uid;
      final String email = user.email ?? '';
      final String displayName = user.displayName ?? '';
      final List<String> nameParts = displayName.split(' ');
      final String firstName = nameParts.isNotEmpty ? nameParts.first : '';
      final String lastName =
      nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      // Step 6: Store user information in Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'firstname': firstName,
        'lastname': lastName,
        'age': '',
        'contact': '',
        'address': '',
        'images': '',
        'type': 'customer',
        'email': email,
      });

      return userCredential;
    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
  }

  signUp(
      String firstname, String lastname, String email, String password) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    String? uid = userCredential.user?.uid;

    FirebaseFirestore.instance.collection('users').doc(uid).set({
      'uid': uid,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'age': '',
      'contact': '',
      'address': '',
      'images': '',
      'images2': '',
      'images3': '',
      'type': 'customer',
    });
  }

  // ignore: non_constant_identifier_names
  Profile(
      String uid,
      String firstname,
      String lastname,
      String age,
      String contact,
      String address,
      String images,
      String images2,
      String images3,
      String email) {
    FirebaseFirestore.instance.collection('users').doc(uid).set({
      'uid': uid,
      'firstname': firstname,
      'lastname': lastname,
      'age': age,
      'contact': contact,
      'address': address,
      'images': images,
      'images2': images2,
      'images3': images3,
      'type': 'customer',
      'email': email,
    });
  }

  // ignore: non_constant_identifier_names
  AdminProfile(String uid, String firstname, String lastname, String age,
      String contact, String address, String images, String email) {
    FirebaseFirestore.instance.collection('users').doc(uid).set({
      'uid': uid,
      'firstname': firstname,
      'lastname': lastname,
      'age': age,
      'contact': contact,
      'address': address,
      'images': images,
      'type': 'admin',
      'email': email,
    });
  }

  // ignore: non_constant_identifier_names
  // Feedback(String uid, String firstname, String lastname, String feedback) {
  //   FirebaseFirestore.instance.collection('feedback').doc().set({
  //     'uid': uid,
  //     'firstname': firstname,
  //     'lastname': lastname,
  //     'feedback': feedback,
  //   });
  // }

  // ignore: non_constant_identifier_names
  CreatePet(String type, String breed, String age, String color,
      String arrivaldate, String sizeweight, String sex) {
    FirebaseFirestore.instance.collection('pet').doc().set({
      'type': type,
      'breed': breed,
      'age': age,
      'color': color,
      'arrivaldate': arrivaldate,
      'sizeweight': sizeweight,
      'sex': sex,
      'status': 'Available'
    });
  }

  Future<bool> checkEmailExists(String email) async {
    final result = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    return result.docs.isNotEmpty;
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
