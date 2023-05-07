import 'package:absensi/controllers/login/login_controller.dart';
import 'package:absensi/utils/curdex.dart';

import 'package:absensi/views/details/detail_presensi_view.dart';

import 'package:absensi/views/home/main_page_view.dart';
import 'package:absensi/views/login/login_view.dart';

import 'package:absensi/views/profile/update_profile_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
        return MaterialApp(
          title: "Absensi",
          debugShowCheckedModeBanner: false,
          home: snap.data != null &&
                  snap.data!.emailVerified == true &&
                  LoginController.passC.text != "password"
              ? const MainPage()
              : const LoginView(),
          // home: const DetailPresensiView(),
          navigatorKey: curdex,
          routes: {
            'update-profile': (context) => const UpdateProfileView(),
            'detail-presence': (context) => const DetailPresensiView(),
          },
        );
      },
    );
  }
}
