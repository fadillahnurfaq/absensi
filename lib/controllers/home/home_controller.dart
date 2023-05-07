import 'package:absensi/utils/curdex.dart';
import 'package:absensi/utils/info_snacbar.dart';
import 'package:absensi/utils/success_snacbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class HomeController with ChangeNotifier {
  static ValueNotifier<bool> isLoading = ValueNotifier(false);

  static FirebaseAuth auth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getDataUser() async* {
    String uid = auth.currentUser!.uid;
    yield* firestore.collection("pegawai").doc(uid).snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastPresence() async* {
    String uid = auth.currentUser!.uid;
    yield* firestore
        .collection("pegawai")
        .doc(uid)
        .collection("presence")
        .orderBy('date', descending: true)
        .limitToLast(5)
        .snapshots();
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>>
      getTodayPresence() async* {
    String uid = auth.currentUser!.uid;

    String todayId =
        DateFormat.yMd().format(DateTime.now()).replaceAll("/", "-");

    yield* firestore
        .collection("pegawai")
        .doc(uid)
        .collection("presence")
        .doc(todayId)
        .snapshots();
  }

  static Future<Map<String, dynamic>> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return {
        "message":
            "Tidak dapat mengambil lokasi anda, Silahkan nyalakan GPS anda.",
        "error": true,
      };
      // return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return {
          "message": "Izin menggunakan GPS ditolak.",
          "error": true,
        };
        // return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return {
        "message":
            "Settingan hp anda tidak memperbolehkan untuk mengakses GPS, Silahkan ubah pada settingan Hp anda,",
        "error": true,
      };
      // Future.error(
      //     'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position? position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 7),
    );
    return {
      "position": position,
      "message": "Berhasil mendapatkan lokasi anda.",
      "error": false,
    };
  }

  static Future<void> updatePosition(Position position, String address) async {
    String uid = auth.currentUser!.uid;

    firestore.collection("pegawai").doc(uid).update({
      "position": {
        "lat": position.latitude,
        "long": position.longitude,
      },
      "address": address,
    });
  }

  static Future<void> presensi(
      Position position, String address, double distance) async {
    String uid = auth.currentUser!.uid;
// * Membuat sub collection di pegawai
    CollectionReference<Map<String, dynamic>> collectionPresence =
        firestore.collection("pegawai").doc(uid).collection("presence");

    QuerySnapshot<Map<String, dynamic>> snapshotPresence =
        await collectionPresence.get();

    DateTime now = DateTime.now();
    String todayDocID = DateFormat.yMd().format(now).replaceAll("/", "-");

    String status = "Di Luar Area";

    if (distance <= 200) {
      status = "Di Dalam Area";
    }

    if (snapshotPresence.docs.isEmpty) {
      // * Belum pernah absen dan Set absen masuk pertama kalinya

      await showDialog(
        context: curdex.currentContext!,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Center(
              child: Text("Validasi Absen"),
            ),
            content: const Text(
              "Apakah kamu yakin akan mengisi daftar hadir Masuk sekarang ?",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(curdex.currentContext!);
                },
                child: const Text("Batal"),
              ),
              ElevatedButton(
                  onPressed: () async {
                    await collectionPresence.doc(todayDocID).set({
                      "date": now.toIso8601String(),
                      "masuk": {
                        "date": now.toIso8601String(),
                        "lat": position.latitude,
                        "long": position.longitude,
                        "address": address,
                        "status": status,
                        "distance": distance,
                      }
                    });
                    Navigator.pop(curdex.currentContext!);
                    successSnackbar(curdex.currentContext!, "Berhasil",
                        "Kamu telah mengisi daftar hadir masuk");
                  },
                  child: const Text("Yakin"))
            ],
          );
        },
      );
    } else {
      //* Sudah pernah absen -> Cek hari ini sudah absen masuk/keluar blm?
      DocumentSnapshot<Map<String, dynamic>> todayDoc =
          await collectionPresence.doc(todayDocID).get();

      if (todayDoc.exists == true) {
        // * Absen keluar
        Map<String, dynamic>? dataPrecenceToday = todayDoc.data();
        if (dataPrecenceToday?["keluar"] != null) {
          infoSnackbar(curdex.currentContext!, "Informasi",
              "Kamu telah absen masuk & keluar");
        } else {
          await showDialog(
            context: curdex.currentContext!,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                title: const Center(
                  child: Text("Validasi Absen"),
                ),
                content: const Text(
                  "Apakah kamu yakin akan mengisi daftar hadir Keluar sekarang ?",
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(curdex.currentContext!);
                    },
                    child: const Text("Batal"),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        await collectionPresence.doc(todayDocID).update({
                          "keluar": {
                            "date": now.toIso8601String(),
                            "lat": position.latitude,
                            "long": position.longitude,
                            "address": address,
                            "status": status,
                            "distance": distance,
                          }
                        });
                        Navigator.pop(curdex.currentContext!);
                        successSnackbar(curdex.currentContext!, "Berhasil",
                            "Kamu telah mengisi daftar hadir Keluar");
                      },
                      child: const Text("Yakin"))
                ],
              );
            },
          );
        }
      } else {
        // * Absen
        await showDialog(
          context: curdex.currentContext!,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: const Center(
                child: Text("Validasi Absen"),
              ),
              content: const Text(
                "Apakah kamu yakin akan mengisi daftar hadir Masuk sekarang ?",
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(curdex.currentContext!);
                  },
                  child: const Text("Batal"),
                ),
                ElevatedButton(
                    onPressed: () async {
                      await collectionPresence.doc(todayDocID).set({
                        "date": now.toIso8601String(),
                        "masuk": {
                          "date": now.toIso8601String(),
                          "lat": position.latitude,
                          "long": position.longitude,
                          "address": address,
                          "status": status,
                          "distance": distance,
                        }
                      });
                      Navigator.pop(curdex.currentContext!);
                      successSnackbar(curdex.currentContext!, "Berhasil",
                          "Kamu telah mengisi daftar hadir Masuk");
                    },
                    child: const Text("Yakin"))
              ],
            );
          },
        );
      }
    }
  }
}
