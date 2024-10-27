// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/Cubits/Search/search_cubit.dart';
import 'package:graduation_project/Cubits/Users_data/users_data_cubit.dart';
import 'package:graduation_project/Cubits/attendance%20new_data/attendance_new_data_cubit.dart';
import 'package:graduation_project/Screen/Splash_Screen.dart';
import 'package:graduation_project/Screen/manger%20screens/attendance/attendacne_of_a_specific_employee.dart';
import 'package:graduation_project/Screen/manger%20screens/attendance/attendance_list2.dart';
import 'package:graduation_project/data/Repository/get_attendance_new_repo.dart';
import 'package:graduation_project/data/Repository/get_departments_repo.dart';
import 'package:graduation_project/data/Repository/get_holidays_notifications_repo.dart';
import 'package:graduation_project/data/Repository/get_shifts_repo.dart';
import 'package:graduation_project/data/Repository/get_users_Repo.dart';
import 'package:graduation_project/functions/drawer.dart';
import 'package:graduation_project/functions/style.dart';

// ignore: must_be_immutable
class Attendance extends StatelessWidget {
  Attendance({super.key});

  TextEditingController _textEditingController = TextEditingController();

  List<String> items = ['day', 'month', 'employee\'s'];

  String? selectedAttendanceItem = 'day';

  List months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  daysInCurrentMonth() {
    DateTime now = DateTime.now();
    int nextMonth = now.month == 12 ? 1 : now.month + 1;
    int nextMonthYear = now.month == 12 ? now.year + 1 : now.year;

    DateTime firstDayOfNextMonth = DateTime(nextMonthYear, nextMonth, 1);
    DateTime lastDayOfCurrentMonth =
        firstDayOfNextMonth.subtract(Duration(days: 1));

    return lastDayOfCurrentMonth.day;
  }

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
                context.read<SearchCubit>().close_search();
                selectedAttendanceItem = items[0];
                search_users_text = "";
                _textEditingController.clear();
                context.read<AttendanceNewDataCubit>().getAttendanceNewData();
                new_notifications_number = notifications.length;
                Navigator.pop(
                  context,
                );
              },
              icon: Icon(Icons.arrow_back),
            );
          }),
          actions: [
            BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                return IconButton(
                  color: Colors.white,
                  onPressed: () {
                    context.read<SearchCubit>().search_icon();

                    context
                        .read<AttendanceNewDataCubit>()
                        .getAttendanceNewData();
                  },
                  icon: (context.read<SearchCubit>().search == false)
                      ? Icon(Icons.sort)
                      : Icon(Icons.close),
                );
              },
            ),
          ],
          automaticallyImplyLeading: false,
          title: BlocBuilder<SearchCubit, SearchState>(
            builder: (context, state) {
              return !context.read<SearchCubit>().search
                  ? FittedBox(
                      child: Text(
                      "Attendance List",
                      style: (landscape)
                          ? getTextWhiteHeader(context)
                          : getTextWhiteHeader(context),
                    ))
                  : Row(
                      children: [
                        Text(
                          "Attendance List",
                          style: (landscape)
                              ? getTextWhiteHeader(context)
                              : getTextWhite(context),
                        ),
                        Spacer(),
                        DropdownButton<String>(
                          dropdownColor: const Color.fromRGBO(50, 50, 160, 1),
                          iconEnabledColor: Colors.white,
                          iconDisabledColor: Colors.white,
                          value: selectedAttendanceItem ?? items[0],
                          style: getTextWhite(context),
                          items: items
                              .map((item) => DropdownMenuItem<String>(
                                  value: item, child: Text(item)))
                              .toList(),
                          onChanged: (item) {
                            selectedAttendanceItem = item;
                            if (selectedAttendanceItem == items[2]) {
                              context.read<UsersDataCubit>().getUsersData();
                            }
                            // ignore: invalid_use_of_protected_member
                            context.read<SearchCubit>().emit(SearchInitial());
                            context
                                .read<AttendanceNewDataCubit>()
                                .getAttendanceNewData();
                            context.read<UsersDataCubit>().getUsersData();
                          },
                        )
                      ],
                    );
            },
          ),
          centerTitle: true,
        ),
        // ignore: deprecated_member_use
        body: WillPopScope(
          onWillPop: () async {
            context.read<SearchCubit>().close_search();
            selectedAttendanceItem = items[0];
            search_users_text = "";
            _textEditingController.clear();
            context.read<AttendanceNewDataCubit>().getAttendanceNewData();
            new_notifications_number = notifications.length;
            Navigator.pop(
              context,
            );
            return true;
          },
          child: BlocBuilder<AttendanceNewDataCubit, AttendanceNewDataState>(
            builder: (context, state) {
              return ListView.builder(
                itemCount: (selectedAttendanceItem == items[0])
                    ? daysInCurrentMonth()
                    : (selectedAttendanceItem == items[1])
                        ? 12
                        : users.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(5)),
                    margin:
                        (landscape) ? EdgeInsets.all(5) : EdgeInsets.all(10),
                    width: (landscape)
                        ? MediaQuery.of(context).size.height * 0.9
                        : MediaQuery.of(context).size.width * 0.9,
                    height: (landscape)
                        ? MediaQuery.of(context).size.width * 1 / 10
                        : MediaQuery.of(context).size.height * 1 / 10,
                    child: TextButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0)),
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  (selectedAttendanceItem == items[0])
                                      ? 'Day info'
                                      : (selectedAttendanceItem == items[1])
                                          ? 'Month info'
                                          : 'Employee\'s info',
                                ),
                                content: SingleChildScrollView(
                                    child: Container(
                                  width: mediaQuery.size.width / 1.8,
                                  height: (selectedAttendanceItem == items[2])
                                      ? (landscape)
                                          ? mediaQuery.size.height * 1.5
                                          : mediaQuery.size.height / 2.5
                                      : (landscape)
                                          ? mediaQuery.size.height / 5
                                          : mediaQuery.size.height / 15,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Text(
                                          (selectedAttendanceItem == items[0])
                                              ? "Day : ${index + 1}/${DateTime.now().month}/${DateTime.now().year}"
                                              : (selectedAttendanceItem ==
                                                          items[1] &&
                                                      selectedAttendanceItem !=
                                                          items[2])
                                                  ? 'Month: ' +
                                                      months[index].toString()
                                                  : '',
                                        ),
                                        (selectedAttendanceItem == items[0] ||
                                                selectedAttendanceItem ==
                                                    items[1])
                                            ? SizedBox()
                                            : Column(
                                                children: [
                                                  Container(
                                                    child: Image.network(
                                                        users[index].image),
                                                    width: (landscape)
                                                        ? 150
                                                        : mediaQuery
                                                                .size.width /
                                                            1.8,
                                                    height: (landscape)
                                                        ? 150
                                                        : mediaQuery
                                                                .size.height /
                                                            4.5,
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    "Id : ${users[index].id}",
                                                  ),
                                                  Text(
                                                    "Name : ${users[index].firstName} ${users[index].lastName}",
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "Age : ${users[index].age}",
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "Gender : ${users[index].gender}",
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "Email : ${users[index].email}",
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "Phone : ${users[index].phone}",
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "Salary : ${users[index].salary}",
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "Salary Type : ${users[index].salary_type}",
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "Current Salary : ${double.parse(users[index].current_salary).round()}",
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "Address : ${users[index].address}",
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "Position : ${users[index].position}",
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    (users[index]
                                                                .departmentId ==
                                                            'Empty')
                                                        ? 'department  : ${users[index].departmentId}'
                                                        : "department  : ${departments[departments.indexWhere((element) => element.id == int.parse(users[index].departmentId!))].name}",
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    (users[index].shiftId ==
                                                            'Empty')
                                                        ? "shift : ${users[index].shiftId}"
                                                        : "shift : ${shifts[shifts.indexWhere((element) => element.id == int.parse(users[index].shiftId!))].name}",
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "Hiring Date : ${users[index].hiring_date}",
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                ],
                                              ),
                                      ],
                                    ),
                                  ),
                                )),
                                actions: <Widget>[
                                  Row(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          if (selectedAttendanceItem !=
                                              items[2]) {
                                            index.toString();
                                            day_of_new_attending =
                                                index.toString();
                                            month_of_new_attending =
                                                index.toString();
                                            context
                                                .read<AttendanceNewDataCubit>()
                                                .getAttendanceNewData();
                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute<void>(
                                                builder:
                                                    (BuildContext context) =>
                                                        AttendanceList2(),
                                              ),
                                            );
                                            context
                                                .read<SearchCubit>()
                                                .close_search();
                                            if (selectedAttendanceItem ==
                                                items[1]) {
                                              month = true;
                                            }
                                            selectedAttendanceItem = items[0];
                                            search_users_text = "";
                                            _textEditingController.clear();
                                          } else {
                                            employeer_id =
                                                users[index].id.toString();                                            
                                            days_of_attendance_for_a_specific_employee =
                                                true;
                                            context
                                                .read<AttendanceNewDataCubit>()
                                                .getAttendanceNewData();

                                            Navigator.of(context).pop();
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute<void>(
                                                builder: (BuildContext
                                                        context) =>
                                                    attendanceOfASpecificEmployee(),
                                              ),
                                            );
                                            context
                                                .read<SearchCubit>()
                                                .close_search();

                                            search_users_text = "";
                                            _textEditingController.clear();
                                          }
                                        },
                                        child: Text("Open"),
                                      ),
                                      Spacer(),
                                      TextButton(
                                        child: Text('OK'),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Close the dialog
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            });
                      },
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            (selectedAttendanceItem == items[0])
                                ? Text(
                                    'Day ${index + 1}',
                                    style: getTextBlack(context),
                                  )
                                : (selectedAttendanceItem == items[1])
                                    ? Text(months[index].toString(),
                                        style: getTextBlack(context))
                                    : Row(
                                        children: [
                                          ClipOval(
                                              child: Image.network(
                                            width: (landscape)
                                                ? mediaQuery.size.height * 0.12
                                                : mediaQuery.size.width * 0.12,
                                            height: (landscape)
                                                ? mediaQuery.size.height * 0.12
                                                : mediaQuery.size.width * 0.12,
                                            users[index].image,
                                            fit: BoxFit.cover,
                                          )),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                              '${users[index].id} ${users[index].firstName} ${users[index].lastName}',
                                              style: getTextBlack(context))
                                        ],
                                      ),
                            Spacer(),
                            Text(
                              (selectedAttendanceItem == items[0])
                                  ? "${index + 1}/${DateTime.now().month}/${DateTime.now().year}"
                                  : (selectedAttendanceItem == items[1])
                                      ? "${index + 1}/${DateTime.now().year}"
                                      : "",
                              style: getTextBlack(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
