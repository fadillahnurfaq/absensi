import 'package:absensi/controllers/login/login_controller.dart';
import 'package:absensi/views/login/forgot_password.dart';
import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('LOGIN'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Email"),
            const SizedBox(height: 5),
            TextField(
              autocorrect: false,
              controller: LoginController.emailC,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text("Password"),
            const SizedBox(height: 5),
            TextField(
              autocorrect: false,
              obscureText: true,
              controller: LoginController.passC,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ValueListenableBuilder<bool>(
              valueListenable: LoginController.isLoading,
              builder: (_, value, __) {
                return SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed: () {
                      LoginController.login();
                    },
                    child: value == false
                        ? const Text("Login")
                        : const CircularProgressIndicator(
                            color: Colors.white,
                          ),
                  ),
                );
              },
            ),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ForgotPasswordView(),
                    ),
                  );
                },
                child: const Text("Lupa password ? "),
              ),
            )
          ],
        ),
      ),
    );
  }
}
