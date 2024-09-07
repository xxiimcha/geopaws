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

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;
      if (user == null) {
        return null;
      }

      final String uid = user.uid;
      final String email = user.email ?? '';
      final String displayName = user.displayName ?? '';
      final List<String> nameParts = displayName.split(' ');
      final String firstName = nameParts.isNotEmpty ? nameParts.first : '';
      final String lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      // Store user information in Firestore
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

  Profile(String uid, String firstname, String lastname, String age, String contact, String address, String images, String images2, String images3, String email) {
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

  AdminProfile(String uid, String firstname, String lastname, String age, String contact, String address, String images, String email) {
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

  Future<void> createPet(String type, String breed, String age, String color, String arrivaldate, String sizeweight, String sex, String rescueLocation, String firstOwner, String healthIssues, String additionalDetails, String imageUrl) async {
    await FirebaseFirestore.instance.collection('pet').add({
      'type': type,
      'breed': breed,
      'age': age,
      'color': color,
      'arrivaldate': arrivaldate,
      'sizeweight': sizeweight,
      'sex': sex,
      'rescue_location': rescueLocation,
      'first_owner': firstOwner,
      'health_issues': healthIssues,
      'additional_details': additionalDetails,
      'images': imageUrl,
      'status': 'Available'
    });
  }

  Future<void> createPetReport(String petName, String dateLost, String locationLost, String additionalInfo, String imageUrl, String userEmail) async {
    await FirebaseFirestore.instance.collection('pet_reports').add({
      'pet_name': petName,
      'date_lost': dateLost,
      'location_lost': locationLost,
      'additional_info': additionalInfo,
      'image': imageUrl,
      'user': userEmail,
      'status': 'In Progress', // Add default status for new reports
    });
  }

  // New function to update report status
  Future<void> updateReportStatus(String reportId, String status) async {
    try {
      await FirebaseFirestore.instance.collection('pet_reports').doc(reportId).update({
        'status': status,
      });
    } catch (e) {
      print('Error updating report status: $e');
    }
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
