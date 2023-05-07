import 'dart:io';

import 'package:absensi/controllers/profile/update_profile_controller.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfileView extends StatelessWidget {
  const UpdateProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> user =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    // print(user);

    UpdateProfileController.nipC.text = user["nip"];
    UpdateProfileController.nameC.text = user["name"];
    UpdateProfileController.emailC.text = user["email"];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("UPDATE PROFILE"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("NIP"),
            const SizedBox(height: 5),
            TextField(
              readOnly: true,
              autocorrect: false,
              controller: UpdateProfileController.nipC,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            const Text("Email"),
            const SizedBox(height: 5),
            TextField(
              autocorrect: false,
              readOnly: true,
              controller: UpdateProfileController.emailC,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            const Text("Nama"),
            const SizedBox(height: 5),
            TextField(
              autocorrect: false,
              controller: UpdateProfileController.nameC,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Foto Profile",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ValueListenableBuilder<ImagePicker>(
                  valueListenable: UpdateProfileController.picker,
                  builder: (_, value, __) {
                    if (UpdateProfileController.image != null) {
                      return ClipOval(
                        child: SizedBox(
                          height: 100,
                          width: 100,
                          child: Image.file(
                            File(UpdateProfileController.image!.path),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    } else {
                      if (user['profile'] != null) {
                        return Column(
                          children: [
                            ClipOval(
                              child: SizedBox(
                                height: 100,
                                width: 100,
                                child: Image.network(
                                  user['profile'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      title: const Center(
                                        child: Text("Verifikasi"),
                                      ),
                                      content: const Text(
                                        "Apakah anda yakin menghapus foto profil ?",
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Batal"),
                                        ),
                                        ElevatedButton(
                                            onPressed: () {
                                              UpdateProfileController
                                                  .deleteProfile(user['uid']);
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Hapus"))
                                      ],
                                    );
                                  },
                                );
                              },
                              child: const Text("Hapus"),
                            )
                          ],
                        );
                      } else {
                        return const Text("Tidak ada foto");
                      }
                    }
                  },
                ),
                TextButton(
                  onPressed: () {
                    UpdateProfileController.pickImage();
                  },
                  child: const Text("Pilih"),
                )
              ],
            ),
            const SizedBox(height: 20),
            ValueListenableBuilder<bool>(
              valueListenable: UpdateProfileController.isLoading,
              builder: (_, value, __) {
                return SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed: () {
                      UpdateProfileController.updateProfile(user["uid"]);
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
