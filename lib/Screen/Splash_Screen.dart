import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/Cubits/Companies%20name/companies_name_cubit.dart';
import 'package:graduation_project/Cubits/Departments_Data/departments_data_cubit.dart';
import 'package:graduation_project/Cubits/Shifts_data/shifts_data_cubit.dart';
import 'package:graduation_project/Cubits/Users_data/users_data_cubit.dart';
import 'package:graduation_project/Cubits/notifications/notifications_cubit.dart';
import 'package:graduation_project/Screen/employeer%20screens/employee.dart';
import 'package:graduation_project/Screen/manger%20screens/Home_Screen_manger.dart';
import 'package:graduation_project/Screen/Login_Screen.dart';
import 'package:graduation_project/Screen/onboarding_Screen2.dart';
import 'package:graduation_project/data/Repository/cach_helper.dart';
import 'package:graduation_project/data/Repository/get_holidays_notifications_repo.dart';
import 'package:graduation_project/functions/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

bool logedin = false;
bool Manger_logedin = false;
bool customer_logedin = false;
String Manger_Name = "";
int Company_diameter = 0;
String Company_Name = "";
String User_Name = "";
double lat = 0;
String employeer_id = '';

double long = 0;

bool splashscreen = false;

bool onboarding = false;

int old_notifications_number = 0;
int new_notifications_number = 0;

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future<bool> getPrefs() async {
      final prefs = await SharedPreferences.getInstance();
      Manger_logedin = prefs.getBool('Manger_logedin') ?? false;

      Manger_Name = prefs.getString('Manger_Name') ?? "";

      User_Name = prefs.getString('User_Name') ?? "";

      Company_Name = prefs.getString('Company_Name') ?? "";

      customer_logedin = prefs.getBool('customer_logedin') ?? false;

      employeer_id = prefs.getString('Employeer_id') ?? '';

      onboarding = CachHelper.getBool(key: 'onboarding')!;

      old_notifications_number = prefs.getInt('notifications_number') ?? 0;

      if (Manger_logedin == true || customer_logedin == true) {
        logedin = true;
      }
      return (logedin);
    }

    getPrefs();

    context.read<CompaniesNameCubit>().getCompainesNameData();
    splashscreen = true;
    context.read<UsersDataCubit>().getUsersData();
    splashscreen = false;

    Future.delayed(Duration(milliseconds: 2000), () async {
      await context.read<NotificationsCubit>().getNotificationsData();
      context.read<ShiftsDataCubit>().getShiftsData();
      context.read<DepartmentsDataCubit>().getDepartmentsData();
      new_notifications_number = notifications.length;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => (onboarding == true)
              ? logedin == true
                  ? (Manger_logedin == true
                      ? HomeScreenManger()
                      : EmployeeScreen())
                  : LoginScreen()
              : OnBoardingScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final landscape = mediaQuery.orientation == Orientation.landscape;
    return Scaffold(
      body: Container(
        width: mediaQuery.size.width,
        height: mediaQuery.size.height,
        color: const Color.fromRGBO(50, 50, 160, 1),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacer(),
              Container(
                width: mediaQuery.size.width,
                margin: EdgeInsets.only(
                    left: mediaQuery.size.width * (20 / 360),
                    right: mediaQuery.size.width * (20 / 360),
                    bottom: mediaQuery.size.height * (20 / 800)),
                child: Text(
                  "Hello",
                  style: getSplashScreen(context),
                ),
              ),
              Container(
                width: mediaQuery.size.width,
                height: (landscape) ? mediaQuery.size.height * 1 / 2 : null,
                margin: EdgeInsets.only(
                    left: mediaQuery.size.width * (20 / 360),
                    right: mediaQuery.size.width * (20 / 360)),
                child: Image.asset(
                  "assets/images/logo.jpg",
                  fit: BoxFit.fitWidth,
                ),
              ),
              Spacer(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Employees Affairs Management System",
                        style: getTextWhite(context),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
      ),
    );
  }
}
