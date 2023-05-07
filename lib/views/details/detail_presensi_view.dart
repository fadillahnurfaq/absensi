import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailPresensiView extends StatelessWidget {
  const DetailPresensiView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: const Text("DETAIL PRESENSI"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey[200],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    DateFormat.yMMMEd().format(DateTime.now()),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const Text(
                  "Masuk",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(data["masuk"]?["date"] == null
                    ? "Jam : -"
                    : "Jam : ${DateFormat.jms().format(
                        DateTime.parse(
                          data["masuk"]!["date"],
                        ),
                      )}"),
                Text(data["masuk"]?["status"] == null
                    ? "Status : - "
                    : "Status : ${data["masuk"]?["status"]}"),
                Text(data["masuk"]?["distance"] == null
                    ? "Distance : - "
                    : "Distance : ${data["masuk"]?["distance"].toString().split(".").first} Meter"),
                Text(data["masuk"]?["lat"] == null &&
                        data["masuk"]?["long"] == null
                    ? "Posisi - "
                    : "Posisi : ${data["masuk"]["lat"]}, ${data["masuk"]["long"]}"),
                Text(data["masuk"]?["address"] == null
                    ? "Alamat : -"
                    : "Alamat : ${data["masuk"]?["address"]}"),
                const SizedBox(height: 10),
                const Text(
                  "Keluar",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(data["keluar"]?["date"] == null
                    ? "Jam : -"
                    : "Jam : ${DateFormat.jms().format(
                        DateTime.parse(
                          data["keluar"]!["date"],
                        ),
                      )}"),
                Text(data["keluar"]?["status"] == null
                    ? "Status : - "
                    : "Status : ${data["keluar"]?["status"]}"),
                Text(data["keluar"]?["distance"] == null
                    ? "Distance : - "
                    : "Distance : ${data["keluar"]?["distance"].toString().split(".").first} Meter"),
                Text(data["keluar"]?["lat"] == null &&
                        data["keluar"]?["long"] == null
                    ? "Posisi - "
                    : "Posisi : ${data["keluar"]["lat"]}, ${data["keluar"]["long"]}"),
                Text(data["keluar"]?["address"] == null
                    ? "Alamat : -"
                    : "Alamat : ${data["keluar"]?["address"]}"),
              ],
            ),
          )
        ],
      ),
    );
  }
}
