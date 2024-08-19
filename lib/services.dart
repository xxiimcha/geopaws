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

  signUp(String firstname, String lastname, String email, String password) async {
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

  // Method to create a pet with additional information
  Future<void> createPet(
      String type,
      String breed,
      String age,
      String color,
      String arrivaldate,
      String sizeweight,
      String sex,
      String rescueLocation, // New field
      String firstOwner, // New field
      String healthIssues, // New field
      String additionalDetails, // New field
      String imageUrl) async {
    await FirebaseFirestore.instance.collection('pet').add({
      'type': type,
      'breed': breed,
      'age': age,
      'color': color,
      'arrivaldate': arrivaldate,
      'sizeweight': sizeweight,
      'sex': sex,
      'rescue_location': rescueLocation, // New field
      'first_owner': firstOwner, // New field
      'health_issues': healthIssues, // New field
      'additional_details': additionalDetails, // New field
      'images': imageUrl,
      'status': 'Available'
    });
  }

  // Method to create a pet report
  Future<void> createPetReport(
      String petName,
      String dateLost,
      String locationLost,
      String appearance,
      String additionalInfo,
      String imageUrl,
      String userEmail) async {
    await FirebaseFirestore.instance.collection('pet_reports').add({
      'pet_name': petName,
      'date_lost': dateLost,
      'location_lost': locationLost,
      'appearance': appearance,
      'additional_info': additionalInfo,
      'image': imageUrl,
      'user': userEmail,
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
