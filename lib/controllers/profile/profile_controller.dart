import 'package:absensi/utils/curdex.dart';
import 'package:absensi/views/login/login_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class ProfileController with ChangeNotifier {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getDataUser() async* {
    String uid = auth.currentUser!.uid;
    yield* firestore.collection("pegawai").doc(uid).snapshots();
  }

  static void logout() async {
    await auth.signOut();
    Navigator.pushAndRemoveUntil(
        curdex.currentContext!,
        MaterialPageRoute(
          builder: (context) => const LoginView(),
        ),
        (route) => false);
  }
}
