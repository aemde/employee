import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/add_employee_controller.dart';

class AddEmployee extends StatefulWidget {
  AddEmployee({Key? key}) : super(key: key);

  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  final controller = Get.put(CreateEmployeeController());

  void updateDescription() {
    controller.isEdited.value = true;
  }

  void moveToLastScreen() {
    Get.back();
  }

  void showDiscardDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          title: Text(
            "Discard Changes?",
          ),
          content: Text("Are you sure you want to discard changes?",
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
              onPressed: () {
                Navigator.of(context).pop();
                moveToLastScreen();
                controller.resetAll();
              },
            ),
          ],
        );
      },
    );
  }

  Widget nameInput() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 3, 20, 0),
      child: TextFormField(
        controller: controller.firstNameC,
        onChanged: (value) {
          updateDescription();
        },
        style: TextStyle(fontSize: 14, color: Colors.black87),
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.person),
            border: const UnderlineInputBorder(),
            labelText: 'First Name',
            hintText: 'Enter first name'),
      ),
    );
  }

  Widget lastNameInput() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 3, 20, 0),
      child: TextFormField(
        controller: controller.lastNameC,
        onChanged: (value) {
          updateDescription();
        },
        style: TextStyle(fontSize: 14, color: Colors.black87),
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.person_outline),
            border: const UnderlineInputBorder(),
            labelText: 'Last Name',
            hintText: 'Enter last name'),
      ),
    );
  }

  Widget emailInput() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 3, 20, 0),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        controller: controller.emailC,
        onChanged: (value) {
          updateDescription();
        },
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
    return WillPopScope(
      onWillPop: () async {
        controller.isEdited.value
            ? showDiscardDialog(context)
            : moveToLastScreen();
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('Add Employee'),
            leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.save),
                onPressed: () => controller.addEmployee(context),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 40),
                GetBuilder<CreateEmployeeController>(
                  init: CreateEmployeeController(),
                  initState: (_) {},
                  builder: (c) {
                    return ClipOval(
                      child: GestureDetector(
                        onTap: () {
                          c.pickImage();
                          updateDescription();
                        },
                        child: Stack(
                          children: [
                            Container(
                              height: 130,
                              width: 130,
                              color: Colors.indigo[700],
                              child: Center(
                                child: Icon(Icons.camera_alt,
                                    color: Colors.white, size: 40),
                              ),
                            ),
                            controller.image != null
                                ? ClipOval(
                                    child: Material(
                                      color: Colors.transparent,
                                      child: Ink.image(
                                        image: FileImage(File(c.image!.path)),
                                        fit: BoxFit.cover,
                                        width: 130,
                                        height: 130,
                                      ),
                                    ),
                                  )
                                : SizedBox()
                          ],
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 30),
                nameInput(),
                lastNameInput(),
                emailInput(),
                SizedBox(height: 30),
              ],
            ),
          )),
    );
  }
}
