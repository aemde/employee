import 'package:employee/app/modules/screens/add_employee.dart';
import 'package:employee/app/modules/screens/home_screen.dart';
import 'package:employee/app/modules/screens/sign_in_screen.dart';
import 'package:get/get.dart';

class Routes {
  static final routes = [
    GetPage(
      name: '/signIn',
      page: () => SignInScreen(),
    ),
    GetPage(
      name: '/home',
      page: () => HomeScreen(),
    ),
    GetPage(
      name: '/create-employee',
      page: () => AddEmployee(),
    ),
  ];
}
