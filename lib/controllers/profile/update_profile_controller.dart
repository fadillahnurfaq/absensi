import 'dart:io';

import 'package:absensi/utils/curdex.dart';
import 'package:absensi/utils/error_snacbar.dart';

import 'package:absensi/utils/info_snacbarlogin.dart';
import 'package:absensi/utils/success_snacbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UpdateProfileController with ChangeNotifier {
  static ValueNotifier<bool> isLoading = ValueNotifier(false);

  static TextEditingController nipC = TextEditingController();
  static TextEditingController emailC = TextEditingController();
  static TextEditingController nameC = TextEditingController();

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static ValueNotifier<ImagePicker> picker = ValueNotifier(ImagePicker());

  static XFile? image;

  static firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  static Future<void> updateProfile(String uid) async {
    if (nipC.text.isNotEmpty &&
        nameC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      isLoading.value = true;

      try {
        Map<String, dynamic> data = {
          "name": nameC.text,
        };
        if (image != null) {
          File file = File(image!.path);
          String ext = image!.path.split(".").last;

          await storage.ref('$uid/profile.$ext').putFile(file);

          String urlImage =
              await storage.ref('$uid/profile.$ext').getDownloadURL();
          data.addAll({
            "profile": urlImage,
          });
        }
        await firestore.collection("pegawai").doc(uid).update(data);
        image = null;
        Navigator.pop(curdex.currentContext!);
        successSnackbar(
            curdex.currentContext!, "Berhasil", "Berhasil update profile.");
      } catch (e) {
        successSnackbar(curdex.currentContext!, "Terjadi kesalahan",
            "Tidak dapat update profile.");
      } finally {
        isLoading.value = false;
      }
    } else {
      infoSnackbarLogin(
        curdex.currentContext!,
        "Terjadi kesalahan",
        "NIP, Email, Dan Nama wajib diisi.",
      );
    }
  }

  static void pickImage() async {
    image = await picker.value.pickImage(source: ImageSource.gallery);
    picker.notifyListeners();
  }

  static void deleteProfile(String uid) async {
    try {
      await firestore.collection("pegawai").doc(uid).update({
        "profile": FieldValue.delete(),
      });
      Navigator.pop(curdex.currentContext!);
      successSnackbar(curdex.currentContext!, "Berhasil",
          "Berhasil menghapus foto profile.");
    } catch (e) {
      errorSnacbar(curdex.currentContext!, "Terjadi kesalahan",
          "Tidak dapat delete profile picture.");
    } finally {
      picker.notifyListeners();
    }
  }
}
