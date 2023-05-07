import 'package:absensi/utils/curdex.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class DetailAllPresenceController with ChangeNotifier {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static ValueNotifier<DateTime?> start = ValueNotifier(null);
  static ValueNotifier<DateTime> end = ValueNotifier(DateTime.now());

  static Future<QuerySnapshot<Map<String, dynamic>>> getAllPresence() async {
    String uid = auth.currentUser!.uid;

    if (start.value == null) {
      //* Mendapatkan seluruh presensi sampai saat ini
      return await firestore
          .collection("pegawai")
          .doc(uid)
          .collection("presence")
          .where("date", isLessThan: end.value.toIso8601String())
          .orderBy("date", descending: true)
          .get();
    } else {
      return await firestore
          .collection("pegawai")
          .doc(uid)
          .collection("presence")
          .where("date", isGreaterThan: start.value?.toIso8601String())
          .where("date", isLessThan: end.value.toIso8601String())
          .orderBy("date", descending: true)
          .get();
    }
  }

  static void pickDate(DateTime pickStart, DateTime pickEnd) {
    start.value = pickStart;
    end.value = pickEnd;
    start.notifyListeners();
    end.notifyListeners();
    Navigator.pop(curdex.currentContext!);
  }
}
