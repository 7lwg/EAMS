import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/Cubits/Circular_indicator_cubit/circular_indicator_cubit.dart';
import 'package:graduation_project/Cubits/Search/search_cubit.dart';
import 'package:graduation_project/Cubits/Users_data/users_data_cubit.dart';
import 'package:graduation_project/Cubits/attendance%20new_data/attendance_new_data_cubit.dart';
import 'package:graduation_project/Screen/Splash_Screen.dart';
import 'package:graduation_project/data/Repository/get_attendance_new_repo.dart';
import 'package:graduation_project/data/Repository/get_shifts_repo.dart';
import 'package:graduation_project/data/Repository/get_users_Repo.dart';
import 'package:graduation_project/functions/style.dart';
import 'package:responsive_framework/responsive_row_column.dart';

// ignore: must_be_immutable
class AddingNewEmployeetoAttendance extends StatelessWidget {
  AddingNewEmployeetoAttendance({super.key});
  RegExp attendance_checkin_checkout_regex =
      RegExp(r'^(?:[1-9]|1[0-9]|2[0-4])$');

  RegExp attendance_day_regex = RegExp(r'^(?:[1-9]|[12][0-9]|3[01])$');

  final GlobalKey<FormState> _formkey1 = GlobalKey<FormState>();

  daysInCurrentMonth() {
    DateTime now = DateTime.now();
    int nextMonth = now.month == 12 ? 1 : now.month + 1;
    int nextMonthYear = now.month == 12 ? now.year + 1 : now.year;

    DateTime firstDayOfNextMonth = DateTime(nextMonthYear, nextMonth, 1);
    DateTime lastDayOfCurrentMonth =
        firstDayOfNextMonth.subtract(Duration(days: 1));

    return lastDayOfCurrentMonth.day;
  }

  bool submitted = false;
  bool form_validate = false;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final landscape = mediaQuery.orientation == Orientation.landscape;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: (landscape)
            ? mediaQuery.size.height * (100 / 800)
            : mediaQuery.size.height * (70 / 800),
        backgroundColor: const Color.fromRGBO(50, 50, 160, 1),
        leading: Builder(builder: (context) {
          return IconButton(
            color: Colors.white,
            onPressed: () {
              attending_employee_to_day = false;
              Navigator.pop(
                context,
              );
            },
            icon: Icon(Icons.arrow_back),
          );
        }),
        automaticallyImplyLeading: false,
        title: BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            return FittedBox(
                child: Text(
              'Attending employee ${users[users.indexWhere((employee) => employee.id == int.parse(id_of_added_employee))].firstName} to day ${int.parse(day_of_new_attending) + 1}',
              style: (landscape)
                  ? getTextWhiteHeader(context)
                  : getTextWhiteHeader(context),
              overflow: TextOverflow.ellipsis,
            ));
          },
        ),
        centerTitle: true,
      ),
      // ignore: deprecated_member_use
      body: WillPopScope(
        onWillPop: () async {
          attending_employee_to_day = false;
          Navigator.pop(
            context,
          );
          return true;
        },
        child: Container(
          width: mediaQuery.size.width,
          height: mediaQuery.size.height,
          child: Form(
            key: _formkey1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // check in time
                Container(
                  width: mediaQuery.size.width * 0.8,
                  child: TextFormField(
                    onChanged: (text) {
                      selectedAttendanceCheckInItem = text;
                    },
                    validator: (value) {
                      if (selectedAttendanceCheckInItem != "") {
                        if (attendance_checkin_checkout_regex
                                .hasMatch(value!) ==
                            false) {
                          return 'Invalid Check in Time';
                        } else {
                          selectedAttendanceCheckInItem = value;
                          return null;
                        }
                      } else {
                        return 'Invalid Check in Time';
                      }
                    },
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                        errorStyle:
                            TextStyle(color: Colors.red[400], height: 0.2),
                        contentPadding: EdgeInsets.symmetric(vertical: 0.0),
                        prefixIcon: const Icon(Icons.person,
                            color: Color.fromARGB(255, 145, 142, 142),
                            size: 30),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: "Enter check in Time",
                        hintStyle: getTextGrey(context)),
                  ),
                ),

                // check out time
                Container(
                  width: mediaQuery.size.width * 0.8,
                  child: TextFormField(
                    onChanged: (text) {
                      selectedAttendanceCheckOutItem = text;
                    },
                    validator: (value) {
                      if (selectedAttendanceCheckOutItem != "") {
                        if (attendance_checkin_checkout_regex
                                .hasMatch(value!) ==
                            false) {
                          return 'Invalid Check out Time';
                        } else {
                          if (int.parse(selectedAttendanceCheckOutItem!) <=
                              int.parse(selectedAttendanceCheckInItem!)) {
                            return 'The Check out Time must be after the Check in Time';
                          } else {
                            selectedAttendanceCheckOutItem = value;
                            return null;
                          }
                        }
                      } else {
                        return 'Invalid Check out Time';
                      }
                    },
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                        errorStyle:
                            TextStyle(color: Colors.red[400], height: 0.2),
                        contentPadding: EdgeInsets.symmetric(vertical: 0.0),
                        prefixIcon: const Icon(Icons.person,
                            color: Color.fromARGB(255, 145, 142, 142),
                            size: 30),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: "Enter check out Time",
                        hintStyle: getTextGrey(context)),
                  ),
                ),
                BlocBuilder<CircularIndicatorCubit, CircularIndicatorState>(
                  builder: (context, state) {
                    return ResponsiveRowColumnItem(
                      child: Container(
                        child: FittedBox(
                          child: ElevatedButton(
                            onPressed: () async {
                              submitted = true;
                              context
                                  .read<CircularIndicatorCubit>()
                                  .Circular_Location();
                              if (_formkey1.currentState!.validate()) {
                                form_validate = true;
                                return_all_data_for_all_days = true;
                                await context
                                    .read<AttendanceNewDataCubit>()
                                    .getAttendanceNewData();
                                return_all_data_for_all_days = false;

                                attending_employee_to_day = true;

                                postAttendanceData = {
                                  "id":
                                      last_employee_id_in_attendance_table + 1,
                                  "employee_id":
                                      int.parse(id_of_added_employee),
                                  "date": int.parse(day_of_new_attending) + 1,
                                  "time_in":
                                      selectedAttendanceCheckInItem.toString() +
                                          ':00',
                                  "time_out": selectedAttendanceCheckOutItem
                                          .toString() +
                                      ':00',
                                  "company_name": Company_Name.toString(),
                                  "firstName": users[users.indexWhere(
                                          (element) =>
                                              element.id ==
                                              int.parse(id_of_added_employee))]
                                      .firstName,
                                  "lastName": users[users.indexWhere(
                                          (element) =>
                                              element.id ==
                                              int.parse(id_of_added_employee))]
                                      .lastName,
                                  "current_month": true,
                                };
                                adding_employee_to_attendance = false;
                                context
                                    .read<AttendanceNewDataCubit>()
                                    .getAttendanceNewData();
                                attending_employee_to_day = false;

                                editing_employee = true;
                                editted_employee_id =
                                    int.parse(id_of_added_employee);
                                int index = users.indexWhere((element) =>
                                    element.id ==
                                    int.parse(id_of_added_employee));
                                int working_hours = (int.parse(
                                        selectedAttendanceCheckOutItem!) -
                                    int.parse(selectedAttendanceCheckInItem!));
                                int shift_working_hours = (users[index].shiftId ==
                                        'Empty')
                                    ? 0
                                    : int.parse(shifts[shifts.indexWhere(
                                                (element) =>
                                                    element.id ==
                                                    int.parse(users[index]
                                                        .shiftId
                                                        .toString()))]
                                            .end_time) -
                                        int.parse(
                                            shifts[shifts.indexWhere((element) => element.id == int.parse(users[index].shiftId.toString()))]
                                                .start_time);
                                putUsersData = {
                                  "id": int.parse(id_of_added_employee),
                                  "firstName": users[index].firstName,
                                  'lastName': users[index].lastName,
                                  'age': users[index].age,
                                  'gender': users[index].gender,
                                  'email': users[index].email,
                                  'phone': users[index].phone,
                                  'image': users[index].image,
                                  'departmentId': users[index].departmentId,
                                  'shiftId': users[index].shiftId,
                                  'companyName': users[index].companyName,
                                  'salary': users[index].salary,
                                  'salary_type': users[index].salary_type,
                                  'address': users[index].address,
                                  'position': users[index].position,
                                  'hiring_date': users[index].hiring_date,
                                  'rating': users[index].rating,
                                  'password': users[index].password,
                                  'current_salary': (users[index].shiftId ==
                                          'Empty')
                                      ?
                                      // if the employee not in a shift so we will caculate the salary on 8 hours per day
                                      (double.parse(
                                                  users[index].current_salary) +
                                              ((users[index].salary_type == ('Monthly') ||
                                                      users[index].salary_type ==
                                                          ('Empty'))
                                                  // if monthly
                                                  ? (((users[index].salary /
                                                              daysInCurrentMonth()) /
                                                          8) *
                                                      working_hours)
                                                  : (users[index].salary_type ==
                                                          ('Weekly'))
                                                      // if week
                                                      ? (((users[index].salary / 7) / 8) *
                                                          working_hours)
                                                      // if day
                                                      : (((users[index].salary) / 8) *
                                                          working_hours)))
                                          .toString()
                                      // if the employee in a shift so we will caculate the salary on the working hours of the shift
                                      : (double.parse(
                                                  users[index].current_salary) +
                                              (users[index].salary_type ==
                                                      ('Monthly')
                                                  // if monthly
                                                  ? (users[index].salary /
                                                      daysInCurrentMonth() /
                                                      shift_working_hours *
                                                      working_hours)
                                                  : (users[index].salary_type ==
                                                          ('Weekly'))
                                                      // if week
                                                      ? ((users[index].salary / 7) /
                                                          shift_working_hours *
                                                          working_hours)
                                                      // if day
                                                      : ((users[index].salary) /
                                                          shift_working_hours *
                                                          working_hours)))
                                          .toString()
                                };

                                context.read<UsersDataCubit>().getUsersData();
                                Navigator.pop(
                                  context,
                                );
                                Navigator.pop(
                                  context,
                                );
                                Navigator.pop(
                                  context,
                                );
                              }
                            },
                            child: Text(
                              "Submit",
                              style: getTextWhite(context),
                            ),
                            style: ElevatedButton.styleFrom(
                                side: (submitted == true &&
                                        form_validate == false)
                                    ? const BorderSide(
                                        color: Colors.red, width: 2)
                                    : null,
                                shadowColor: Colors.black,
                                elevation: 10,
                                backgroundColor:
                                    const Color.fromRGBO(50, 50, 160, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                )),
                          ),
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
