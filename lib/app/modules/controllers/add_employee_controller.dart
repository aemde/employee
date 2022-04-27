import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CreateEmployeeController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isEdited = false.obs;
  XFile? image;
  TextEditingController firstNameC = TextEditingController();
  TextEditingController lastNameC = TextEditingController();
  TextEditingController emailC = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  void resetAll() {
    image = null;
    firstNameC.text = '';
    lastNameC.text = '';
    emailC.text = '';
    isEdited.value = false;
    update();
  }

  void pickImage() async {
    final ImagePicker _picker = ImagePicker();
    image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      update();
    }
  }

  void addEmployee(context) async {
    if (firstNameC.text.isNotEmpty &&
        lastNameC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      isLoading.value = true;

      Get.back();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.indigo[800],
        content: Text("New employee successfully added"),
        duration: Duration(milliseconds: 1500),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.indigo[800],
        content: Text("All inputs must be filled in"),
        duration: Duration(milliseconds: 1500),
      ));
    }
  }
}
