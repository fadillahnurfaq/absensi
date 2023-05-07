import 'package:absensi/controllers/home/home_controller.dart';
import 'package:absensi/views/details/detail_all_presensi_view.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Home View"),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: HomeController.getDataUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            Map<String, dynamic> user = snapshot.data!.data()!;

            String defaultImage =
                "https://ui-avatars.com/api/?name=$user['name']";

            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        ClipOval(
                          child: SizedBox(
                            width: 75,
                            height: 75,
                            child: Image.network(
                              user['profile'] != null
                                  ? user['profile'] != ""
                                      ? user['profile']
                                      : defaultImage
                                  : defaultImage,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Welcome",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 250,
                              child: Text(user["position"] != null
                                  ? "${user['address']}"
                                  : "Belum ada lokasi."),
                            )
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(20),
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey[200],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${user['job'] ?? "Tidak ada data"}",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "${user['nip'] ?? "Tidak ada data"}",
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "${user['name'] ?? "Tidak ada data"}",
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(top: 20),
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey[200],
                      ),
                      child:
                          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        stream: HomeController.getTodayPresence(),
                        builder: (context, snapToday) {
                          if (snapToday.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          Map<String, dynamic>? dataToday =
                              snapToday.data?.data();

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  const Text("Masuk"),
                                  Text(
                                    dataToday?["masuk"] == null
                                        ? "-"
                                        : DateFormat.jms().format(
                                            DateTime.parse(
                                              dataToday!["masuk"]["date"],
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 2,
                                height: 48,
                                color: Colors.grey,
                              ),
                              Column(
                                children: [
                                  const Text("Keluar"),
                                  Text(
                                    dataToday?["keluar"] == null
                                        ? "-"
                                        : DateFormat.jms().format(
                                            DateTime.parse(
                                              dataToday!["keluar"]["date"],
                                            ),
                                          ),
                                  ),
                                ],
                              )
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Divider(
                      color: Colors.grey[300],
                      thickness: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("5 Hari Terakhir"),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const DetailAllPresensiView(),
                                ));
                          },
                          child: const Text("Lihat Semua"),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: HomeController.getLastPresence(),
                        builder: (context, snapPresence) {
                          if (snapPresence.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox(
                              height: 150,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          if (snapPresence.data!.docs.isEmpty ||
                              snapPresence.data == null) {
                            return const SizedBox(
                              height: 150,
                              child: Center(
                                child: Text("Belum ada data absensei."),
                              ),
                            );
                          }

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapPresence.data!.docs.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> data =
                                  snapPresence.data!.docs[index].data();

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Material(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(15),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(15),
                                    onTap: () {
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //       builder: (context) =>
                                      //           const DetailPresensiView(),
                                      //     ));
                                      Navigator.pushNamed(
                                        context,
                                        'detail-presence',
                                        arguments: data,
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                "Masuk",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                DateFormat.yMMMEd().format(
                                                    DateTime.parse(
                                                        data["date"])),
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            data["masuk"]?["date"] == null
                                                ? "-"
                                                : DateFormat.jms().format(
                                                    DateTime.parse(
                                                      data["masuk"]!["date"],
                                                    ),
                                                  ),
                                          ),
                                          const SizedBox(height: 10),
                                          const Text(
                                            "Keluar",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            data["keluar"]?["date"] == null
                                                ? "-"
                                                : DateFormat.jms().format(
                                                    DateTime.parse(data[
                                                        "keluar"]!["date"])),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                  ],
                )
              ],
            );
          } else {
            return const SizedBox(
              height: 150,
              child: Center(
                child: Text("Tidak dapat memuat database user."),
              ),
            );
          }
        },
      ),
    );
  }
}
