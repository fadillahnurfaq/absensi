import 'package:absensi/controllers/profile/update_password_controller.dart';

import 'package:flutter/material.dart';

class UpdatePasswordView extends StatefulWidget {
  const UpdatePasswordView({Key? key}) : super(key: key);

  @override
  State<UpdatePasswordView> createState() => _UpdatePasswordViewState();
}

class _UpdatePasswordViewState extends State<UpdatePasswordView> {
  @override
  void dispose() {
    UpdatePasswordController.currPasswordC.dispose();
    UpdatePasswordController.newPasswordC.dispose();
    UpdatePasswordController.confirmPasswordC.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    UpdatePasswordController.currPasswordC = TextEditingController();
    UpdatePasswordController.newPasswordC = TextEditingController();
    UpdatePasswordController.confirmPasswordC = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('GANTI PASSWORD'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Password sekarang"),
            const SizedBox(height: 5),
            TextField(
              obscureText: true,
              autocorrect: false,
              controller: UpdatePasswordController.currPasswordC,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            const Text("Password baru"),
            const SizedBox(height: 5),
            TextField(
              obscureText: true,
              autocorrect: false,
              controller: UpdatePasswordController.newPasswordC,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            const Text("Konfirmasi password baru"),
            const SizedBox(height: 5),
            TextField(
              obscureText: true,
              autocorrect: false,
              controller: UpdatePasswordController.confirmPasswordC,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ValueListenableBuilder<bool>(
              valueListenable: UpdatePasswordController.isLoading,
              builder: (_, value, __) {
                return SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed: () {
                      UpdatePasswordController.updatePassword();
                    },
                    child: value == false
                        ? const Text("Update Profile")
                        : const CircularProgressIndicator(
                            color: Colors.white,
                          ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
