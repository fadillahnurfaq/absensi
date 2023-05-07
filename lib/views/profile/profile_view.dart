import 'package:absensi/controllers/profile/profile_controller.dart';
import 'package:absensi/views/profile/add_pegawai_view.dart';
import 'package:absensi/views/profile/update_password_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('PROFILE'),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: ProfileController.getDataUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData) {
            Map<String, dynamic>? user = snapshot.data?.data();

            String defaultImage =
                "https://ui-avatars.com/api/?name=$user['name']";

            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  ClipOval(
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: Image.network(
                        user?['profile'] != null
                            ? user!['profile'] != ""
                                ? user['profile']
                                : defaultImage
                            : defaultImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user?['name'].toString().toUpperCase() ?? "Tidak ada data",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    user?['email'] ?? "Tidak ada data",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, 'update-profile',
                          arguments: user);
                    },
                    leading: const Icon(Icons.person),
                    title: const Text("Update Profile"),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UpdatePasswordView(),
                        ),
                      );
                    },
                    leading: const Icon(Icons.vpn_key),
                    title: const Text("Update Password"),
                  ),
                  if (user?["role"] == "admin")
                    ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddPegawaiView(),
                          ),
                        );
                      },
                      leading: const Icon(Icons.person_add),
                      title: const Text("Add Pegawai"),
                    ),
                  ListTile(
                    onTap: () {
                      ProfileController.logout();
                    },
                    leading: const Icon(Icons.logout),
                    title: const Text("Logout"),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text("Tidak dapat memuat data user."),
            );
          }
        },
      ),
    );
  }
}
