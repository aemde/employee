import 'package:employee/app/data/dio/app_dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final controller = Get.put(AuthController());
  final _loginFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controller.dio = AppDio(context);
  }

  Widget passwordInput() {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 3, 15, 0),
      child: Obx(() => TextField(
            obscureText: controller.isHidden.value,
            controller: controller.passwordController,
            autocorrect: false,
            decoration: InputDecoration(
              labelText: "Password",
              border: const UnderlineInputBorder(),
              prefixIcon: Icon(Icons.lock),
              suffixIcon: IconButton(
                onPressed: () => controller.isHidden.toggle(),
                icon: Icon(controller.isHidden.isTrue
                    ? Icons.remove_red_eye
                    : Icons.remove_red_eye_outlined),
              ),
            ),
          )),
    );
  }

  Widget emailInput() {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 3, 15, 0),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        controller: controller.emailController,
        style: TextStyle(fontSize: 14, color: Colors.black87),
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.email),
            border: const UnderlineInputBorder(),
            labelText: 'Email',
            hintText: 'Enter email'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(0.0),
          child: AppBar(
            elevation: 0,
          )),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 12),
          child: SingleChildScrollView(
            child: Form(
              key: _loginFormKey,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(height: 15),
                    Text(
                      "Login",
                      style: TextStyle(fontSize: 30),
                    ),
                    SizedBox(height: 30),
                    emailInput(),
                    passwordInput(),
                    SizedBox(height: 50),
                    Obx(
                      () => Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            onPrimary: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 15),
                          ),
                          onPressed: () {
                            if (controller.loading.isFalse) {
                              controller.signIn(context);
                            }
                          },
                          child: Text(controller.loading.isFalse
                              ? "Sign In"
                              : "LOADING..."),
                        ),
                      ),
                    ),
                    SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
