import 'package:absensi/utils/curdex.dart';

import 'package:absensi/utils/error_snacbarlogin.dart';

import 'package:absensi/utils/info_snacbarlogin.dart';
import 'package:absensi/utils/success_snacbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class AddPegawaiController with ChangeNotifier {
  static ValueNotifier<bool> isLoading = ValueNotifier(false);
  static ValueNotifier<bool> isLoadingAddPegawai = ValueNotifier(false);

  static TextEditingController nameC = TextEditingController();
  static TextEditingController nipC = TextEditingController();
  static TextEditingController emailC = TextEditingController();
  static TextEditingController passAdminC = TextEditingController();
  static TextEditingController jobC = TextEditingController();

  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<void> processAddPegawai() async {
    if (passAdminC.text.isNotEmpty) {
      isLoadingAddPegawai.value = true;
      try {
        String emailAdmin = auth.currentUser!.email!;

        await auth.signInWithEmailAndPassword(
            email: emailAdmin, password: passAdminC.text);

        UserCredential pegawaiCredential =
            await auth.createUserWithEmailAndPassword(
          email: emailC.text,
          password: "password",
        );

        if (pegawaiCredential.user != null) {
          String uid = pegawaiCredential.user!.uid;

          await firestore.collection("pegawai").doc(uid).set({
            "uid": uid,
            "nip": nipC.text,
            "name": nameC.text,
            "job": jobC.text,
            "email": emailC.text,
            "role": "pegawai",
            "createdAt": DateTime.now().toIso8601String(),
          });

          await pegawaiCredential.user!.sendEmailVerification();

          await auth.signOut();

          await auth.signInWithEmailAndPassword(
            email: emailAdmin,
            password: passAdminC.text,
          );

          Navigator.pop(curdex.currentContext!);

          successSnackbar(
            curdex.currentContext!,
            "Berhasil",
            "Berhasil menambah pegawai",
          );
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          errorSnacbarLogin(curdex.currentContext!, "Terjadi kesalahan",
              "Password yang digunakan terlalu singkat");
        } else if (e.code == 'email-already-in-use') {
          errorSnacbarLogin(curdex.currentContext!, "Terjadi kesalahan",
              "Pegawai sudah tersedia");
        } else if (e.code == 'wrong-password') {
          errorSnacbarLogin(curdex.currentContext!, "Terjadi kesalahan",
              "Admin tidak dapat login. Password salah!");
        } else {
          errorSnacbarLogin(
              curdex.currentContext!, "Terjadi kesalahan", e.code);
        }
      } catch (e) {
        errorSnacbarLogin(curdex.currentContext!, "Terjadi kesalahan",
            "Tidak dapat menambah pegawai.");
      } finally {
        isLoadingAddPegawai.value = false;
      }
    } else {
      errorSnacbarLogin(curdex.currentContext!, "Terjadi kesalahan",
          "Password wajib diisi untuk keperluar validasi");
    }
  }

  static Future<void> addPegawai() async {
    if (nameC.text.isNotEmpty &&
        nipC.text.isNotEmpty &&
        emailC.text.isNotEmpty &&
        jobC.text.isNotEmpty) {
      isLoading.value = true;
      showDialog(
        context: curdex.currentContext!,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Center(
              child: Text("Validasi Admin"),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Masukkan Password untuk validasi admin !",
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: passAdminC,
                  obscureText: true,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  isLoading.value = false;
                  Navigator.pop(context);
                },
                child: const Text("Batal"),
              ),
              ValueListenableBuilder<bool>(
                valueListenable: isLoadingAddPegawai,
                builder: (_, value, __) {
                  return ElevatedButton(
                    onPressed: () async {
                      if (value == false) {
                        await processAddPegawai();
                      }
                      isLoading.value = false;
                    },
                    child: value == false
                        ? const Text("Tambah Pegawai")
                        : const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                  );
                },
              )
            ],
          );
        },
      );
    } else {
      infoSnackbarLogin(curdex.currentContext!, "Terjadi kesalahan",
          "NIP, Nama, Job, dan Email harus diisi.");
    }
  }
}
