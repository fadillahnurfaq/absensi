import 'package:absensi/controllers/details/detail_all_presensi_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DetailAllPresensiView extends StatelessWidget {
  const DetailAllPresensiView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SEMUA PRESENSI"),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<DateTime?>(
          valueListenable: DetailAllPresenceController.start,
          builder: (_, value, __) {
            return ValueListenableBuilder<DateTime>(
                valueListenable: DetailAllPresenceController.end,
                builder: (_, value, __) {
                  return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    future: DetailAllPresenceController.getAllPresence(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (snapshot.data!.docs.isEmpty ||
                          snapshot.data == null) {
                        return const SizedBox(
                          height: 150,
                          child: Center(
                            child: Text("Belum ada data absensei."),
                          ),
                        );
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> data =
                              snapshot.data!.docs[index].data();

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
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            DateFormat.yMMMEd().format(
                                                DateTime.parse(data["date"])),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
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
                                                DateTime.parse(
                                                    data["keluar"]!["date"])),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                });
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return Dialog(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    height: 400,
                    child: SfDateRangePicker(
                      monthViewSettings: const DateRangePickerMonthViewSettings(
                          firstDayOfWeek: 1),
                      selectionMode: DateRangePickerSelectionMode.range,
                      showActionButtons: true,
                      onCancel: () {
                        Navigator.pop(context);
                      },
                      onSubmit: (obj) {
                        if (obj != null) {
                          if ((obj as PickerDateRange).endDate != null) {
                            DetailAllPresenceController.pickDate(
                                obj.startDate!, obj.endDate!);
                          }
                        }
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: const Icon(Icons.format_list_bulleted_rounded),
      ),
    );
  }
}
