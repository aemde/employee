import 'package:employee/app/data/dio/app_dio.dart';
import 'package:employee/app/data/models/users_model.dart';
import 'package:employee/core/keys/response_code.dart';

import 'package:employee/core/resources/app_urls.dart';
import 'package:fialogs/fialogs.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class UsersController extends GetxController {
  late AppDio dio;

  RxBool loading = false.obs;
  var responseData;
  List<UsersModel> user = [];
  var logger = Logger(
    printer: PrettyPrinter(),
  );

  @override
  void dispose() {
    super.dispose();
  }

  getUsersList(context) async {
    loading.value = true;

    try {
      var response = await dio.get(
        path: AppUrls.getUsersList,
      );

      var responseStatusCode = response.statusCode;
      responseData = response.data;

      List data = responseData['data'];
      for (var item in data) {
        user.add(UsersModel.fromJson(item));
      }

      logger.i(user);

      if (responseStatusCode == StatusCode.OK) {
        loading.value = false;
        update();
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
      logger.e("Error log");

      logger.e(s);
      errorDialog(
          context, "Error", "Something went wrong please try again later",
          closeOnBackPress: true, neutralButtonText: "Okay");
    }
  }
}
