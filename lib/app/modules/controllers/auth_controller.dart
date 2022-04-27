import 'package:employee/app/data/dio/app_dio.dart';
import 'package:employee/app/data/shared_preferences/shared_preferences.dart';
import 'package:employee/app/modules/screens/home_screen.dart';
import 'package:employee/app/modules/screens/sign_in_screen.dart';
import 'package:employee/core/keys/pref_keys.dart';
import 'package:employee/core/keys/response_code.dart';
import 'package:employee/core/resources/app_urls.dart';
import 'package:fialogs/fialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class AuthController extends GetxController {
  late AppDio dio;

  TextEditingController emailController =
      TextEditingController(text: "eve.holt@reqres.in");
  TextEditingController passwordController =
      TextEditingController(text: "cityslicka");
  RxBool loading = false.obs;
  RxBool isHidden = true.obs;

  var logger = Logger(
    printer: PrettyPrinter(),
  );

  @override
  void dispose() {
    super.dispose();
  }

  signIn(context) async {
    loading.value = true;

    progressDialog(
      context,
      progressDialogType: ProgressDialogType.CIRCULAR,
      contentWidget: Text('Please wait...'),
    );

    var responseData;
    try {
      var response = await dio.postJson(path: AppUrls.signIn, data: {
        "email": emailController.text,
        "password": passwordController.text,
      });

      if (loading.value) {
        Get.back();
        loading.value = false;
      }

      var responseStatusCode = response.statusCode;
      responseData = response.data;

      if (responseStatusCode == StatusCode.OK) {
        String authToken = responseData['token'];
        logger.i(responseData);
        await Prefs.getPrefs().then((prefs) {
          prefs.setString(PrefKey.authorization, authToken);
          prefs.setBool(PrefKey.firstTimeLogin, false);
        });
        await Get.offAll(HomeScreen());
      } else {
        if (responseData != null) {
          errorDialog(context, "Error", responseData['error'],
              closeOnBackPress: true, neutralButtonText: "Okay");
        } else {
          errorDialog(
              context, "Error", "Something went wrong please try again later",
              closeOnBackPress: true, neutralButtonText: "Okay");
        }
      }
    } catch (e, s) {
      logger.e(e);

      logger.e(s);
      errorDialog(
          context, "Error", "Something went wrong please try again later",
          closeOnBackPress: true, neutralButtonText: "Okay");
    }
  }

  logout(context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?',
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(fontSize: 16)),
          actions: <Widget>[
            TextButton(
              child: Text("No", style: Theme.of(context).textTheme.bodyText1!),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Yes", style: Theme.of(context).textTheme.bodyText1!),
              onPressed: () async {
                await Prefs.clear();
                Get.offAll(SignInScreen());
              },
            ),
          ],
        );
      },
    );
  }
}
