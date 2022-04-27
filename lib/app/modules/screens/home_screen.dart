import 'package:cached_network_image/cached_network_image.dart';
import 'package:employee/app/data/dio/app_dio.dart';
import 'package:employee/app/modules/screens/add_employee.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';

import '../controllers/auth_controller.dart';
import '../controllers/users_controller.dart';
import 'detail_employee.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthController _authController = Get.put(AuthController());
  final UsersController _usersController = Get.put(UsersController());

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    _usersController.dio = AppDio(context);
    _init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Employees',
        ),
        actions: [
          IconButton(
            onPressed: () {
              _authController.logout(context);
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: GetBuilder<UsersController>(
          init: UsersController(),
          builder: (value) {
            return value.loading.value == true
                ? Center(
                    child: CircularProgressIndicator(
                    backgroundColor: Colors.indigo[500],
                  ))
                : ListView.builder(
                    itemCount: value.user.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.fade,
                                child: DetailEmployee(
                                  firstName: value.user[index].firstName,
                                  lastName: value.user[index].lastName,
                                  avatar: value.user[index].avatar,
                                  email: value.user[index].email,
                                  favorite: value.user[index].favorite,
                                )),
                          );
                          // Get.to(DetailEmployee(
                          //   firstName: value.user[index].firstName,
                          //   lastName: value.user[index].lastName,
                          //   avatar: value.user[index].avatar,
                          //   email: value.user[index].email,
                          //   favorite: value.user[index].favorite,
                          // ));
                        },
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 10),
                                child: ListTile(
                                  title: Text(value.user[index].firstName +
                                      " " +
                                      value.user[index].lastName),
                                  subtitle: Text(value.user[index].email),
                                  trailing: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          value.user[index].favorite =
                                              !value.user[index].favorite;
                                        });
                                      },
                                      child: value.user[index].favorite == true
                                          ? Icon(Icons.star,
                                              color: Colors.indigo[700])
                                          : Icon(Icons.star_border_outlined)),
                                  leading: ClipOval(
                                    child: CachedNetworkImage(
                                      fit: BoxFit.fitHeight,
                                      height: 55,
                                      width: 55,
                                      imageUrl: value.user[index].avatar,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              duration: Duration(milliseconds: 100),
              child: AddEmployee(),
            ),
          );
          // Get.toNamed('/create-employee');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  _init(context) async {
    await _usersController.getUsersList(context);
  }
}
