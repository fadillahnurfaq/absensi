import 'package:absensi/controllers/home/home_controller.dart';
import 'package:absensi/utils/curdex.dart';
import 'package:absensi/utils/error_snacbar.dart';

import 'package:absensi/views/home/home_view.dart';
import 'package:absensi/views/profile/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: customBottomNav(),
      floatingActionButton: fingerButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: tabs[_currentIndex],
    );
  }

  int _currentIndex = 0;

  final tabs = [
    const HomeView(),
    const ProfileView(),
  ];

  Widget fingerButton() {
    return FloatingActionButton(
      onPressed: () async {
        //* Mendapatkat data dari GPS
        Map<String, dynamic> dataResponse =
            await HomeController.determinePosition();
        if (dataResponse["error"] != true) {
          Position position = dataResponse["position"];

          //* Mendapatkan alamat

          List<Placemark> placemarks = await placemarkFromCoordinates(
              position.latitude, position.longitude);

          String address =
              "${placemarks[0].street}, ${placemarks[0].subLocality}, ${placemarks[0].locality}";
          await HomeController.updatePosition(position, address);

          //* Mendapatkan jarak untuk absen
          double distance = Geolocator.distanceBetween(
              -6.2873921, 106.9258534, position.latitude, position.longitude);

          //* Absen

          await HomeController.presensi(position, address, distance);
        } else {
          errorSnacbar(curdex.currentContext!, "Terjadi Kesalahan",
              dataResponse["message"]);
        }
      },
      backgroundColor: Colors.white,
      child: const Icon(
        Icons.fingerprint,
        color: Colors.black,
      ),
    );
  }

  Widget customBottomNav() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 10,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: BottomNavigationBar(
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Icon(
                Icons.home,
                color: _currentIndex == 0
                    ? Colors.white
                    : Colors.white.withOpacity(.7),
              ),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Icon(
                Icons.person,
                color: _currentIndex == 1
                    ? Colors.white
                    : Colors.white.withOpacity(.7),
              ),
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
