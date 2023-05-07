import 'package:absensi/controllers/login/forgot_password_controller.dart';
import 'package:flutter/material.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  @override
  void dispose() {
    ForgotPasswordController.emailC.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    ForgotPasswordController.emailC = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Lupa Password"),
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
              controller: ForgotPasswordController.emailC,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ValueListenableBuilder<bool>(
              valueListenable: ForgotPasswordController.isLoading,
              builder: (context, value, child) {
                return SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed: () {
                      if (value == false) {
                        ForgotPasswordController.sendEmail();
                      }
                    },
                    child: value == false
                        ? const Text("Send Reset Password")
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
