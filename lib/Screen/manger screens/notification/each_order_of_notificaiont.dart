import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/Cubits/Search/search_cubit.dart';
import 'package:graduation_project/Cubits/Users_data/users_data_cubit.dart';
import 'package:graduation_project/Cubits/attendance%20new_data/attendance_new_data_cubit.dart';
import 'package:graduation_project/Cubits/notifications/notifications_cubit.dart';
import 'package:graduation_project/Screen/Splash_Screen.dart';
import 'package:graduation_project/data/Repository/get_attendance_new_repo.dart';
import 'package:graduation_project/data/Repository/get_holidays_notifications_repo.dart';
import 'package:graduation_project/data/Repository/get_shifts_repo.dart';
import 'package:graduation_project/data/Repository/get_users_Repo.dart';
import 'package:graduation_project/functions/style.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class SpecificNotification extends StatelessWidget {
  SpecificNotification({super.key});

  daysInCurrentMonth() {
    DateTime now = DateTime.now();
    int nextMonth = now.month == 12 ? 1 : now.month + 1;
    int nextMonthYear = now.month == 12 ? now.year + 1 : now.year;

    DateTime firstDayOfNextMonth = DateTime(nextMonthYear, nextMonth, 1);
    DateTime lastDayOfCurrentMonth =
        firstDayOfNextMonth.subtract(Duration(days: 1));

    return lastDayOfCurrentMonth.day;
  }

  String calculateTimeDifference(String startTime, String endTime) {
    // Define the date format
    final DateFormat dateFormat = DateFormat.Hm();

    // Parse the start and end times
    final DateTime startDateTime = dateFormat.parse(startTime);
    final DateTime endDateTime = dateFormat.parse(endTime);

    // Calculate the difference
    final Duration difference = endDateTime.difference(startDateTime);

    // Convert the difference to hours and minutes as a decimal
    double differenceInHours = difference.inHours.toDouble();
    double differenceInMinutes = (difference.inMinutes % 60).toDouble() / 60;

    // Sum hours and fractional hours
    double totalDifference = differenceInHours + differenceInMinutes;

    // Convert the result to a string
    return totalDifference.toString();
  }

  double current_salary = double.parse(users[users.indexWhere((element) =>
          element.id == notifications[specific_notification_index].employee_id)]
      .current_salary);

  int nextMonth = (DateTime.now().month % 12) + 1;
  int nextYear = DateTime.now().month == 12
      ? DateTime.now().year + 1
      : DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final landscape = mediaQuery.orientation == Orientation.landscape;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: (landscape)
            ? mediaQuery.size.height * (100 / 800)
            : mediaQuery.size.height * (70 / 800),
        
        backgroundColor:
            
            const Color.fromRGBO(50, 50, 160, 1),
        leading: Builder(builder: (context) {
          return IconButton(
            color: Colors.white,
            onPressed: () async {
              context.read<SearchCubit>().close_sort();
              new_notifications_number = notifications.length;
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back),
          );
        }),
        automaticallyImplyLeading: false,
        title: FittedBox(
            child: Text(
          "Review Request",
          overflow: TextOverflow.ellipsis,
          style: (landscape)
              ? getTextWhiteHeader(context)
              : getTextWhiteHeader(context),
        )),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(
                top: 50,
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  users[users.indexWhere((element) =>
                          element.id ==
                          notifications[specific_notification_index]
                              .employee_id)]
                      .image,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
                users[users.indexWhere((element) =>
                            element.id ==
                            notifications[specific_notification_index]
                                .employee_id)]
                        .firstName +
                    ' ' +
                    users[users.indexWhere((element) =>
                            element.id ==
                            notifications[specific_notification_index]
                                .employee_id)]
                        .lastName,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontSize: 24,
                )),
            SizedBox(
              height: 39,
            ),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 12,
              ),
              child: Container(
                child: Row(
                  children: [
                    Text(
                      'Days:',
                      style: TextStyle(
                        fontSize: 24,
                        color: HexColor('3232A0'),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                        child: Text(
                      ((notifications[specific_notification_index].end_holiday -
                                  notifications[specific_notification_index]
                                      .start_holiday +
                                  1) >=
                              1)
                          ? ((notifications[specific_notification_index]
                                              .end_holiday -
                                          notifications[
                                                  specific_notification_index]
                                              .start_holiday) +
                                      1)
                                  .toString() +
                              ' days'
                          : ((notifications[specific_notification_index]
                                              .end_holiday +
                                          (daysInCurrentMonth() -
                                              notifications[
                                                      specific_notification_index]
                                                  .start_holiday)) +
                                      1)
                                  .toString() +
                              ' day',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    )),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 14,
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 12,
              ),
              child: Container(
                height: 1,
                width: double.infinity,
                color: HexColor('7D7D7D'),
              ),
            ),
            SizedBox(
              height: 27,
            ),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 12,
              ),
              child: Container(
                child: Row(
                  children: [
                    Text(
                      'From:',
                      style: TextStyle(
                        fontSize: 24,
                        color: HexColor('3232A0'),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                        child: (notifications[specific_notification_index]
                                    .start_holiday >=
                                DateTime.now().day)
                            ? Text(
                                // '${cubit.informationModel?.phone ?? ''}',
                                notifications[specific_notification_index]
                                        .start_holiday
                                        .toString() +
                                    '/' +
                                    DateTime.now().month.toString() +
                                    '/' +
                                    DateTime.now().year.toString(),
                                maxLines: 1,
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 24,
                                ),
                              )
                            : Text(
                                notifications[specific_notification_index]
                                        .start_holiday
                                        .toString() +
                                    '/' +
                                    nextMonth.toString() +
                                    '/' +
                                    nextYear.toString(),
                                maxLines: 1,
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 24,
                                ),
                              )),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 14,
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 12,
              ),
              child: Container(
                height: 1,
                width: double.infinity,
                color: HexColor('7D7D7D'),
              ),
            ),
            SizedBox(
              height: 27,
            ),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 12,
              ),
              child: Container(
                child: Row(
                  children: [
                    Text(
                      'To: ',
                      style: TextStyle(
                        fontSize: 24,
                        color: HexColor('3232A0'),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                        child: (notifications[specific_notification_index]
                                    .end_holiday >=
                                DateTime.now().day)
                            ? Text(                                
                                notifications[specific_notification_index]
                                        .end_holiday
                                        .toString() +
                                    '/' +
                                    DateTime.now().month.toString() +
                                    '/' +
                                    DateTime.now().year.toString(),
                                maxLines: 1,
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 24,
                                ),
                              )
                            : Text(
                                notifications[specific_notification_index]
                                        .end_holiday
                                        .toString() +
                                    '/' +
                                    nextMonth.toString() +
                                    '/' +
                                    nextYear.toString(),
                                maxLines: 1,
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 24,
                                ),
                              )),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 14,
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 12,
              ),
              child: Container(
                height: 1,
                width: double.infinity,
                color: HexColor('7D7D7D'),
              ),
            ),
            SizedBox(
              height: 27,
            ),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 12,
              ),
              child: Container(
                child: Row(
                  children: [
                    Text(
                      'Reason:',
                      style: TextStyle(
                        fontSize: 24,
                        color: HexColor('3232A0'),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Text(                       
                        notifications[specific_notification_index]
                            .reason
                            .toString(),
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 14,
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 12,
              ),
              child: Container(
                height: 1,
                width: double.infinity,
                color: HexColor('7D7D7D'),
              ),
            ),
            // Spacer(),
            SizedBox(
              height: 80,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {                                      
                    // هنا بنشوف اليوم اللي الاجازه هتبداء و تنتهي فيه ده في نفس الشهر اللي احنا فيه ولا لاء
                    if (notifications[specific_notification_index]
                                .start_holiday >
                            DateTime.now().day &&
                        notifications[specific_notification_index].end_holiday >
                            DateTime.now().day) {
                      for (int i = notifications[specific_notification_index]
                              .start_holiday;
                          i <=
                              notifications[specific_notification_index]
                                  .end_holiday;
                          i++) {
                        day_of_new_attending =
                            (DateTime.now().day - 1).toString();
                        // هنا لو الموظف في شيفت يبقى هاخد ساعات عمل الشيفت
                        attending_employee_to_day = true;
                        postAttendanceData = {
                          "id": (last_employee_id_in_attendance_table + 1) +
                              (i -
                                  notifications[specific_notification_index]
                                      .start_holiday),
                          "employee_id":
                              notifications[specific_notification_index]
                                  .employee_id,
                          "date": i,
                          "time_in": (users[users.indexWhere((element) =>
                                          element.id ==
                                          notifications[specific_notification_index]
                                              .employee_id)]
                                      .shiftId !=
                                  'Empty')
                              ? shifts[shifts.indexWhere((element) =>
                                          element.id ==
                                          int.parse(users[users.indexWhere((element) =>
                                                  element.id ==
                                                  notifications[specific_notification_index]
                                                      .employee_id)]
                                              .shiftId
                                              .toString()))]
                                      .start_time +
                                  ':00'
                              : '8:00',
                          "time_out": (users[users.indexWhere((element) =>
                                          element.id ==
                                          notifications[specific_notification_index]
                                              .employee_id)]
                                      .shiftId !=
                                  'Empty')
                              ? shifts[shifts.indexWhere((element) =>
                                          element.id ==
                                          int.parse(users[users.indexWhere(
                                                  (element) =>
                                                      element.id ==
                                                      notifications[specific_notification_index]
                                                          .employee_id)]
                                              .shiftId
                                              .toString()))]
                                      .end_time +
                                  ':00'
                              : '16:00',
                          "company_name":
                              notifications[specific_notification_index]
                                  .company_name
                                  .toString(),
                          "firstName": users[users.indexWhere((element) =>
                                  element.id ==
                                  notifications[specific_notification_index]
                                      .employee_id)]
                              .firstName,
                          "lastName": users[users.indexWhere((element) =>
                                  element.id ==
                                  notifications[specific_notification_index]
                                      .employee_id)]
                              .lastName,
                          "current_month": true,
                        };
                        adding_employee_to_attendance = false;
                        context
                            .read<AttendanceNewDataCubit>()
                            .getAttendanceNewData();
                        attending_employee_to_day = false;

                        // add the salary of this day to the employee
                        editing_employee = true;
                        editted_employee_id =
                            notifications[specific_notification_index]
                                .employee_id;
                        int index = users.indexWhere((element) =>
                            element.id ==
                            notifications[specific_notification_index]
                                .employee_id);
                        current_salary += (users[users.indexWhere((element) =>
                                        element.id ==
                                        notifications[
                                                specific_notification_index]
                                            .employee_id)]
                                    .shiftId !=
                                'Empty')
                            ?
                            // if the employee not in a shift so we will caculate the salary on 8 hours per day
                            (((users[index].salary_type == ('Monthly') ||
                                    users[index].salary_type == ('Empty'))
                                // if monthly
                                ? (((users[index].salary /
                                    daysInCurrentMonth())))
                                : (users[index].salary_type == ('Weekly'))
                                    // if week
                                    ? (((users[index].salary / 7)))
                                    // if day
                                    : (((users[index].salary)))))

                            // if the employee in a shift so we will caculate the salary on the working hours of the shift
                            : (((users[index].salary_type == ('Monthly') ||
                                    users[index].salary_type == ('Empty'))
                                // if monthly
                                ? (users[index].salary / daysInCurrentMonth())
                                : (users[index].salary_type == ('Weekly'))
                                    // if week
                                    ? ((users[index].salary / 7))
                                    // if day
                                    : ((users[index].salary))));

                        putUsersData = {
                          "id": notifications[specific_notification_index]
                              .employee_id,
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
                          'current_salary': current_salary
                          
                        };
                        context.read<UsersDataCubit>().getUsersData();
                      }
                    }
                    // او لو عايز ياخد اخر ايام في الشهر اللي احنا فيه اجازه مع ايام في الشهر الجديد اجازه
                    // كده لو الاجازه مطلوبه اخر ايام من الشهر مع بدايه الشهر الجديد
                    else if (notifications[specific_notification_index]
                                .start_holiday >
                            DateTime.now().day &&
                        notifications[specific_notification_index].end_holiday <
                            DateTime.now().day) {
                      // هنا هيبقى فيه ايام هتتعمل انها في الشهر الحالي و ايام هتتعمل في الشهر الجديد
                      

                      for (int i = notifications[specific_notification_index]
                              .start_holiday;
                          i <= daysInCurrentMonth();
                          i++) {
                        day_of_new_attending =
                            (DateTime.now().day - 1).toString();
                        
                        // هنا لو الموظف في شيفت يبقى هاخد ساعات عمل الشيفت
                        attending_employee_to_day = true;
                        postAttendanceData = {
                          "id": (last_employee_id_in_attendance_table + 1) +
                              (i -
                                  notifications[specific_notification_index]
                                      .start_holiday),
                          "employee_id":
                              notifications[specific_notification_index]
                                  .employee_id,
                          "date": i,
                          "time_in": (users[users.indexWhere((element) =>
                                          element.id ==
                                          notifications[specific_notification_index]
                                              .employee_id)]
                                      .shiftId !=
                                  'Empty')
                              ? shifts[shifts.indexWhere((element) =>
                                          element.id ==
                                          int.parse(users[users.indexWhere((element) =>
                                                  element.id ==
                                                  notifications[specific_notification_index]
                                                      .employee_id)]
                                              .shiftId
                                              .toString()))]
                                      .start_time +
                                  ':00'
                              : '8:00',
                          "time_out": (users[users.indexWhere((element) =>
                                          element.id ==
                                          notifications[specific_notification_index]
                                              .employee_id)]
                                      .shiftId !=
                                  'Empty')
                              ? shifts[shifts.indexWhere((element) =>
                                          element.id ==
                                          int.parse(users[users.indexWhere(
                                                  (element) =>
                                                      element.id ==
                                                      notifications[specific_notification_index]
                                                          .employee_id)]
                                              .shiftId
                                              .toString()))]
                                      .end_time +
                                  ':00'
                              : '16:00',
                          "company_name":
                              notifications[specific_notification_index]
                                  .company_name
                                  .toString(),
                          "firstName": users[users.indexWhere((element) =>
                                  element.id ==
                                  notifications[specific_notification_index]
                                      .employee_id)]
                              .firstName,
                          "lastName": users[users.indexWhere((element) =>
                                  element.id ==
                                  notifications[specific_notification_index]
                                      .employee_id)]
                              .lastName,
                          "current_month": true,
                        };                  
                        adding_employee_to_attendance = false;
                        context
                            .read<AttendanceNewDataCubit>()
                            .getAttendanceNewData();
                        attending_employee_to_day = false;

                        // add the salary of this day to the employee
                        editing_employee = true;
                        editted_employee_id =
                            notifications[specific_notification_index]
                                .employee_id;
                        int index = users.indexWhere((element) =>
                            element.id ==
                            notifications[specific_notification_index]
                                .employee_id);

                        current_salary += (users[users.indexWhere((element) =>
                                        element.id ==
                                        notifications[
                                                specific_notification_index]
                                            .employee_id)]
                                    .shiftId !=
                                'Empty')
                            ?
                            // if the employee not in a shift so we will caculate the salary on 8 hours per day
                            (((users[index].salary_type == ('Monthly') ||
                                    users[index].salary_type == ('Empty'))
                                // if monthly
                                ? (((users[index].salary /
                                    daysInCurrentMonth())))
                                : (users[index].salary_type == ('Weekly'))
                                    // if week
                                    ? (((users[index].salary / 7)))
                                    // if day
                                    : (((users[index].salary)))))
                            // if the employee in a shift so we will caculate the salary on the working hours of the shift
                            : (((users[index].salary_type == ('Monthly') ||
                                    users[index].salary_type == ('Empty'))
                                // if monthly
                                ? (users[index].salary / daysInCurrentMonth())
                                : (users[index].salary_type == ('Weekly'))
                                    // if week
                                    ? ((users[index].salary / 7))
                                    // if day
                                    : ((users[index].salary))));
                        

                        putUsersData = {
                          "id": notifications[specific_notification_index]
                              .employee_id,
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
                          'current_salary': current_salary
                        };
                        context.read<UsersDataCubit>().getUsersData();
                      }

                      for (int i = 1;
                          i <=
                              notifications[specific_notification_index]
                                  .end_holiday;
                          i++) {                      
                        day_of_new_attending =
                            (DateTime.now().day - 1).toString();                        
                        // هنا لو الموظف في شيفت يبقى هاخد ساعات عمل الشيفت
                        attending_employee_to_day = true;
                        postAttendanceData = {
                          "id": last_employee_id_in_attendance_table +
                              i +
                              (daysInCurrentMonth() -
                                  notifications[specific_notification_index]
                                      .start_holiday +
                                  1),
                          "employee_id":
                              notifications[specific_notification_index]
                                  .employee_id,
                          "date": i,
                          "time_in": (users[users.indexWhere((element) =>
                                          element.id ==
                                          notifications[specific_notification_index]
                                              .employee_id)]
                                      .shiftId !=
                                  'Empty')
                              ? shifts[shifts.indexWhere((element) =>
                                          element.id ==
                                          int.parse(users[users.indexWhere((element) =>
                                                  element.id ==
                                                  notifications[specific_notification_index]
                                                      .employee_id)]
                                              .shiftId
                                              .toString()))]
                                      .start_time +
                                  ':00'
                              : '8:00',
                          "time_out": (users[users.indexWhere((element) =>
                                          element.id ==
                                          notifications[specific_notification_index]
                                              .employee_id)]
                                      .shiftId !=
                                  'Empty')
                              ? shifts[shifts.indexWhere((element) =>
                                          element.id ==
                                          int.parse(users[users.indexWhere(
                                                  (element) =>
                                                      element.id ==
                                                      notifications[specific_notification_index]
                                                          .employee_id)]
                                              .shiftId
                                              .toString()))]
                                      .end_time +
                                  ':00'
                              : '16:00',
                          "company_name":
                              notifications[specific_notification_index]
                                  .company_name
                                  .toString(),
                          "firstName": users[users.indexWhere((element) =>
                                  element.id ==
                                  notifications[specific_notification_index]
                                      .employee_id)]
                              .firstName,
                          "lastName": users[users.indexWhere((element) =>
                                  element.id ==
                                  notifications[specific_notification_index]
                                      .employee_id)]
                              .lastName,
                          "current_month": false,
                        };                       
                        adding_employee_to_attendance = false;               
                        context
                            .read<AttendanceNewDataCubit>()
                            .getAttendanceNewData();                        
                        attending_employee_to_day = false;
                        context.read<UsersDataCubit>().getUsersData();
                      }
                    }
                    // لو ايام الاجازه المطلوبه ديه رقم اليوم بتاعها عدى بس هوا عايز ياخد اليوم ده في الشهر الجديد اجازه
                    // كده لو الكوظف عايز ياخد ايام من الشهر الجديد اجازه بس بشرط انها تبقى اقل من رقم اليوم بتاع انهارده
                    else if (notifications[specific_notification_index]
                                .start_holiday <
                            DateTime.now().day &&
                        notifications[specific_notification_index].end_holiday <
                            DateTime.now().day) {
                      for (int i = notifications[specific_notification_index]
                              .start_holiday;
                          i <=
                              notifications[specific_notification_index]
                                  .end_holiday;
                          i++) {                                                                     
                        day_of_new_attending =
                            (DateTime.now().day - 1).toString();                       
                        // هنا لو الموظف في شيفت يبقى هاخد ساعات عمل الشيفت
                        attending_employee_to_day = true;
                        postAttendanceData = {
                          "id": (last_employee_id_in_attendance_table + 1) +
                              (i -
                                  notifications[specific_notification_index]
                                      .start_holiday),
                          "employee_id":
                              notifications[specific_notification_index]
                                  .employee_id,
                          "date": i,
                          "time_in": (users[users.indexWhere((element) =>
                                          element.id ==
                                          notifications[specific_notification_index]
                                              .employee_id)]
                                      .shiftId !=
                                  'Empty')
                              ? shifts[shifts.indexWhere((element) =>
                                          element.id ==
                                          int.parse(users[users.indexWhere((element) =>
                                                  element.id ==
                                                  notifications[specific_notification_index]
                                                      .employee_id)]
                                              .shiftId
                                              .toString()))]
                                      .start_time +
                                  ':00'
                              : '8:00',
                          "time_out": (users[users.indexWhere((element) =>
                                          element.id ==
                                          notifications[specific_notification_index]
                                              .employee_id)]
                                      .shiftId !=
                                  'Empty')
                              ? shifts[shifts.indexWhere((element) =>
                                          element.id ==
                                          int.parse(users[users.indexWhere(
                                                  (element) =>
                                                      element.id ==
                                                      notifications[specific_notification_index]
                                                          .employee_id)]
                                              .shiftId
                                              .toString()))]
                                      .end_time +
                                  ':00'
                              : '16:00',
                          "company_name":
                              notifications[specific_notification_index]
                                  .company_name
                                  .toString(),
                          "firstName": users[users.indexWhere((element) =>
                                  element.id ==
                                  notifications[specific_notification_index]
                                      .employee_id)]
                              .firstName,
                          "lastName": users[users.indexWhere((element) =>
                                  element.id ==
                                  notifications[specific_notification_index]
                                      .employee_id)]
                              .lastName,
                          "current_month": false,
                        };
                        adding_employee_to_attendance = false;
                        context
                            .read<AttendanceNewDataCubit>()
                            .getAttendanceNewData();
                        
                        attending_employee_to_day = false;
                      }                      
                      // هنا كل الايام هتتعمل في الشهر الجديد
                      // "current_month": false,
                    }
                    context.read<SearchCubit>().close_sort();
                    new_notifications_number = notifications.length - 1;
                    old_notifications_number = notifications.length - 1;
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setInt(
                        'notifications_number', notifications.length - 1);

                    delete_notification = true;
                    context.read<NotificationsCubit>().getNotificationsData();
                    return_all_data_for_all_days = true;
                    return_all_data = false;
                    context
                        .read<AttendanceNewDataCubit>()
                        .getAttendanceNewData();
                    context.read<UsersDataCubit>().getUsersData();
                    last_employee_id_in_attendance_table = 0;
                    current_day = 0;
                    current_salary = 0;
                    Navigator.of(context).pop();                    
                  },
                  child: Text('Accept', style: getTextWhite(context)),
                  style: ElevatedButton.styleFrom(
                      shadowColor: Colors.black,
                      elevation: 10,
                      backgroundColor: const Color.fromRGBO(50, 50, 160, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 18,
                      )),
                ),
                ElevatedButton(
                  onPressed: () async {
                    context.read<SearchCubit>().close_sort();
                    new_notifications_number = notifications.length - 1;
                    old_notifications_number = notifications.length - 1;
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setInt(
                        'notifications_number', notifications.length - 1);
                    delete_notification = true;
                    context.read<NotificationsCubit>().getNotificationsData();

                    Navigator.of(context).pop();
                  },
                  child: Text('Refuse', style: getTextWhite(context)),
                  style: ElevatedButton.styleFrom(
                      shadowColor: Colors.black,
                      elevation: 10,
                      backgroundColor: const Color.fromRGBO(160, 50, 50, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 18,
                      )),
                ),
              ],
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
