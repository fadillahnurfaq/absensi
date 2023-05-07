import 'package:absensi/utils/curdex.dart';
import 'package:absensi/utils/error_snacbar.dart';

import 'package:absensi/utils/info_snacbarlogin.dart';
import 'package:absensi/utils/success_snacbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UpdatePasswordController with ChangeNotifier {
  static ValueNotifier<bool> isLoading = ValueNotifier(false);

  static TextEditingController currPasswordC = TextEditingController();
  static TextEditingController newPasswordC = TextEditingController();
  static TextEditingController confirmPasswordC = TextEditingController();

  static FirebaseAuth auth = FirebaseAuth.instance;

  static Future<void> updatePassword() async {
    if (currPasswordC.text.isNotEmpty &&
        newPasswordC.text.isNotEmpty &&
        confirmPasswordC.text.isNotEmpty) {
      if (newPasswordC.text == confirmPasswordC.text) {
        isLoading.value = true;
        try {
          String emailUser = auth.currentUser!.email!;

          await auth.signInWithEmailAndPassword(
              email: emailUser, password: currPasswordC.text);
          await auth.currentUser!.updatePassword(newPasswordC.text);
          Navigator.pop(curdex.currentContext!);
          successSnackbar(
              curdex.currentContext!, "Berhasil", "Berhasil update password");
        } on FirebaseAuthException catch (e) {
          if (e.code == 'wrong-password') {
            errorSnacbar(curdex.currentContext!, "Terjadi kesalahan",
                "Password sekarang yang anda masukkan salah, Tidak dapat update password.");
          } else {
            errorSnacbar(curdex.currentContext!, "Terjadi kesalahan", e.code);
          }
        } catch (e) {
          errorSnacbar(curdex.currentContext!, "Terjadi kesalahan",
              "Tidak dapat update password");
        } finally {
          isLoading.value = false;
        }
      } else {
        errorSnacbar(curdex.currentContext!, "Terjadi kesalahan",
            "Confirm password tidak cocok.");
      }
    } else {
      infoSnackbarLogin(
          curdex.currentContext!, "Informasi", "Semua input harus diisi.");
    }
  }
}
