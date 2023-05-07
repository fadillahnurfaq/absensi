import 'package:absensi/controllers/profile/add_pegawai_controller.dart';
import 'package:flutter/material.dart';

class AddPegawaiView extends StatelessWidget {
  const AddPegawaiView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Tambah Pegawai"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("NIP : "),
            const SizedBox(height: 10),
            TextField(
              autocorrect: false,
              controller: AddPegawaiController.nipC,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            const Text("Nama : "),
            const SizedBox(height: 10),
            TextField(
              autocorrect: false,
              controller: AddPegawaiController.nameC,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            const Text("Job : "),
            const SizedBox(height: 10),
            TextField(
              autocorrect: false,
              controller: AddPegawaiController.jobC,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            const Text("Email : "),
            const SizedBox(height: 10),
            TextField(
              autocorrect: false,
              controller: AddPegawaiController.emailC,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            ValueListenableBuilder<bool>(
              valueListenable: AddPegawaiController.isLoading,
              builder: (_, value, __) {
                return SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed: () {
                      if (value == false) {
                        AddPegawaiController.addPegawai();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: value == false
                        ? const Text("Tambah Pegawai")
                        : const CircularProgressIndicator(
                            color: Colors.white,
                          ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
