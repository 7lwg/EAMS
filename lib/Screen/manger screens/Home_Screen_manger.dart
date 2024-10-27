// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/Cubits/Departments_Data/departments_data_cubit.dart';
import 'package:graduation_project/Cubits/Search/search_cubit.dart';
import 'package:graduation_project/Cubits/Shifts_data/shifts_data_cubit.dart';
import 'package:graduation_project/Cubits/Users_data/users_data_cubit.dart';
import 'package:graduation_project/Cubits/notifications/notifications_cubit.dart';
import 'package:graduation_project/Screen/Splash_Screen.dart';
import 'package:graduation_project/Screen/manger%20screens/attendance/attendance.dart';
import 'package:graduation_project/Screen/manger%20screens/departments%20manger/Departments_list.dart';
import 'package:graduation_project/Screen/manger%20screens/employee%20manger/Employee_list.dart';
import 'package:graduation_project/Screen/manger%20screens/notification/notification_orders.dart';
import 'package:graduation_project/Screen/manger%20screens/shifts%20manger/Shifts_list.dart';
import 'package:graduation_project/data/Repository/get_holidays_notifications_repo.dart';
import 'package:graduation_project/data/Repository/get_users_Repo.dart';
import 'package:graduation_project/functions/drawer.dart';
import 'package:graduation_project/functions/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreenManger extends StatelessWidget {
  HomeScreenManger();

  List options = ["Employee List", "Attendance Repo", "Departments", "Shifts"];

  List icons = [
    'assets/images/Employee_list_logo.png',
    'assets/images/Attendance_report_logo.png',
    'assets/images/Departments_logo.png',
    'assets/images/Shifts_logo.png'
  ];

  List navigators = [
    EmployeeList(),
    Attendance(),
    DepartmentList(),
    ShiftsList()
  ];

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final landscape = mediaQuery.orientation == Orientation.landscape;
    return SafeArea(
      child: Scaffold(
          drawer: myDrawer(),
          appBar: AppBar(
            toolbarHeight: (landscape)
                ? mediaQuery.size.height * (100 / 800)
                : mediaQuery.size.height * (70 / 800),
            backgroundColor: const Color.fromRGBO(50, 50, 160, 1),
            leading: Builder(builder: (context) {
              return IconButton(
                color: Colors.white,
                onPressed: () {
                  context.read<NotificationsCubit>().getNotificationsData();
                  Scaffold.of(context).openDrawer();
                },
                icon: Icon(Icons.menu),
              );
            }),
            automaticallyImplyLeading: false,
            title: Text(
              'EAMS',
              style: (landscape)
                  ? getTextWhiteHeader(context)
                  : getTextWhiteHeader(context),
            ),
            actions: <Widget>[
              Container(
                child: Stack(children: [
                  BlocBuilder<SearchCubit, SearchState>(
                    builder: (context, state) {
                      return IconButton(
                          onPressed: () async {
                            await context.read<UsersDataCubit>().getUsersData();
                            context
                                .read<NotificationsCubit>()
                                .getNotificationsData();
                            final prefs = await SharedPreferences.getInstance();
                            prefs.setInt(
                                'notifications_number', notifications.length);
                            old_notifications_number = notifications.length;

                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    NotificationOrder(),
                              ),
                            );
                          },
                          icon: (old_notifications_number ==
                                  new_notifications_number)
                              ? Image.asset(
                                  'assets/images/notification_off.png',
                                  scale: 3,
                                )
                              : Image.asset(
                                  'assets/images/notification_off_with_bigger_red_circle.png',
                                  scale: 3,
                                ));
                    },
                  ),
                ]),
              )
            ],
            centerTitle: true,
          ),
          body: Container(
            height: (landscape)
                ? mediaQuery.size.height -
                    (mediaQuery.size.height * (100 / 800))
                : mediaQuery.size.height -
                    (mediaQuery.size.height * (70 / 800)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (int i = 0; i < 2; i++)
                      Container(
                          margin: (i == 0)
                              ? EdgeInsets.only(
                                  left: mediaQuery.size.width * (16 / 360),
                                  bottom: mediaQuery.size.width * (40 / 800),
                                )
                              : EdgeInsets.only(
                                  right: mediaQuery.size.width * (16 / 360),
                                  bottom: mediaQuery.size.width * (40 / 800),
                                ),
                          width: (landscape)
                              ? mediaQuery.size.width * (0.4)
                              : mediaQuery.size.width * (146 / 360),
                          height: (landscape)
                              ? mediaQuery.size.height * (0.3)
                              : mediaQuery.size.height * (140 / 800),
                          decoration: BoxDecoration(
                              color: const Color.fromRGBO(50, 50, 160, 1),
                              borderRadius: BorderRadius.circular(15)),
                          child: TextButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0)),
                              ),
                            ),
                            onPressed: () async {
                              context
                                  .read<NotificationsCubit>()
                                  .getNotificationsData();
                              search_users_text = "";
                              context.read<UsersDataCubit>().getUsersData();
                              context
                                  .read<DepartmentsDataCubit>()
                                  .getDepartmentsData();
                              context.read<ShiftsDataCubit>().getShiftsData();
                              await Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      navigators[i],
                                ),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: (landscape)
                                      ? mediaQuery.size.width * 0.3
                                      : mediaQuery.size.width * (41 / 360),
                                  height: (landscape)
                                      ? mediaQuery.size.height * 0.15
                                      : mediaQuery.size.width * (41 / 360),
                                  child: FittedBox(
                                    child: Image.asset(
                                      icons[i],
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Text(
                                  options[i],
                                  textAlign: TextAlign.center,
                                  style: getTextWhite(context),
                                ),
                              ],
                            ),
                          ))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (int i = 2; i < 4; i++)
                      Container(
                          margin: (i == 2)
                              ? EdgeInsets.only(
                                  left: mediaQuery.size.width * (16 / 360),
                                )
                              : EdgeInsets.only(
                                  right: mediaQuery.size.width * (16 / 360),
                                ),
                          width: (landscape)
                              ? mediaQuery.size.width * (0.4)
                              : mediaQuery.size.width * (146 / 360),
                          height: (landscape)
                              ? mediaQuery.size.height * (0.3)
                              : mediaQuery.size.height * (140 / 800),
                          decoration: BoxDecoration(
                              color: const Color.fromRGBO(50, 50, 160, 1),
                              borderRadius: BorderRadius.circular(15)),
                          child: TextButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0)),
                              ),
                            ),
                            onPressed: () {
                              context
                                  .read<NotificationsCubit>()
                                  .getNotificationsData();
                              search_users_text = "";
                              context.read<UsersDataCubit>().getUsersData();
                              context
                                  .read<DepartmentsDataCubit>()
                                  .getDepartmentsData();
                              context.read<ShiftsDataCubit>().getShiftsData();
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      navigators[i],
                                ),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: (landscape)
                                      ? mediaQuery.size.width * 0.3
                                      : mediaQuery.size.width * (41 / 360),
                                  height: (landscape)
                                      ? mediaQuery.size.height * 0.15
                                      : mediaQuery.size.width * (41 / 360),
                                  child: FittedBox(
                                    child: Image.asset(
                                      icons[i],
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Text(
                                  options[i],
                                  textAlign: TextAlign.center,
                                  style: getTextWhite(context),
                                ),
                              ],
                            ),
                          ))
                  ],
                )
              ],
            ),
          )),
    );
  }
}
