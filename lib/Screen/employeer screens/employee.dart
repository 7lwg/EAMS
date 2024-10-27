import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/Cubits/Shifts_data/shifts_data_cubit.dart';
import 'package:graduation_project/Cubits/Users_data/users_data_cubit.dart';
import 'package:graduation_project/Cubits/attendance%20new_data/attendance_new_data_cubit.dart';
import 'package:graduation_project/Cubits/information/information_cubit.dart';
import 'package:graduation_project/Screen/Splash_Screen.dart';
import 'package:graduation_project/Screen/employeer%20screens/Take_attendance.dart';
import 'package:graduation_project/Screen/employeer%20screens/ask_screen.dart';
import 'package:graduation_project/Screen/employeer%20screens/information_screen.dart';
import 'package:graduation_project/Screen/employeer%20screens/salary_screen.dart';
import 'package:graduation_project/data/Repository/get_attendance_new_repo.dart';
import 'package:graduation_project/functions/drawer.dart';
import 'package:graduation_project/functions/style.dart';

// ignore: must_be_immutable
class EmployeeScreen extends StatelessWidget {
  EmployeeScreen({super.key});

  List options = [
    "Take Attendance",
    "Information",
    "Salary",
    "Ask for holiday"
  ];

  List icons = [
    'assets/images/Checked User Male.png',
    'assets/images/Info.png',
    'assets/images/Card Wallet.png',
    'assets/images/Holiday.png'
  ];

  String? shift_id_for_employee_info;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final landscape = mediaQuery.orientation == Orientation.landscape;
    return BlocProvider(
      create: (context) =>
          InformationCubit()..getData(id: 'eq.${employeer_id}'),
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
          centerTitle: true,
        ),
        body: Container(
          height: (landscape)
              ? mediaQuery.size.height - (mediaQuery.size.height * (100 / 800))
              : mediaQuery.size.height - (mediaQuery.size.height * (70 / 800)),
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
                            if (i == 0) {
                              first_time = true;
                              return_all_data_for_all_days = true;
                              await context
                                  .read<AttendanceNewDataCubit>()
                                  .getAttendanceNewData();

                              return_all_data_for_all_days = false;

                              context.read<ShiftsDataCubit>().getShiftsData();
                              context.read<UsersDataCubit>().getUsersData();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TakeAttendance()),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InformationScreen(),
                                ),
                              );
                            }
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
                            if (i == 3) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AskScreen()),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SalaryScreen()),
                              );
                            }
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
        ),
      ),
    );
  }
}
