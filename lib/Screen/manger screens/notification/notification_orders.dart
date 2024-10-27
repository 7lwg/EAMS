// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/Cubits/Search/search_cubit.dart';
import 'package:graduation_project/Cubits/Shifts_data/shifts_data_cubit.dart';
import 'package:graduation_project/Cubits/Users_data/users_data_cubit.dart';
import 'package:graduation_project/Cubits/attendance%20new_data/attendance_new_data_cubit.dart';
import 'package:graduation_project/Cubits/notifications/notifications_cubit.dart';
import 'package:graduation_project/Screen/Splash_Screen.dart';
import 'package:graduation_project/Screen/employeer%20screens/Take_attendance.dart';
import 'package:graduation_project/Screen/manger%20screens/notification/each_order_of_notificaiont.dart';
import 'package:graduation_project/data/Repository/get_attendance_new_repo.dart';
import 'package:graduation_project/data/Repository/get_departments_repo.dart';
import 'package:graduation_project/data/Repository/get_holidays_notifications_repo.dart';
import 'package:graduation_project/data/Repository/get_shifts_repo.dart';
import 'package:graduation_project/data/Repository/get_users_Repo.dart';
import 'package:graduation_project/functions/style.dart';

class NotificationOrder extends StatelessWidget {
  const NotificationOrder({super.key});

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
              context.read<SearchCubit>().emit(SearchInitial());
              new_notifications_number = notifications.length;
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back),
          );
        }),
        automaticallyImplyLeading: false,
        title: FittedBox(
            child: Text(
          "Notifications",
          overflow: TextOverflow.ellipsis,
          style: (landscape)
              ? getTextWhiteHeader(context)
              : getTextWhiteHeader(context),
        )),
        centerTitle: true,
      ),
      body: Container(
        child: BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (context, state) {
            if (state is NotificationsSuccess) {
              return ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5)),
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
                                  title: const Text(
                                    'Employee\'s info',
                                   
                                  ),
                                  content: SingleChildScrollView(
                                    child: BlocBuilder<UsersDataCubit,
                                        UsersDataState>(
                                      builder: (context, state) {
                                        if (state is UsersDataError) {
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        } else if (state is UsersDataSuccess) {
                                          return Container(
                                            
                                            width: mediaQuery.size.width / 1.8,
                                            height: (landscape)
                                                ? mediaQuery.size.height * 1.5
                                                : mediaQuery.size.height / 2.5,
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  Container(
                                               
                                                    child: Image.network(users[users
                                                            .indexWhere((element) =>
                                                                element.id ==
                                                                notifications[
                                                                        index]
                                                                    .employee_id)]
                                                        .image),
                                                    width: (landscape)
                                                        ? mediaQuery
                                                                .size.width /
                                                            2
                                                        : mediaQuery
                                                                .size.width /
                                                            1.8,
                                                    height: (landscape)
                                                        ? mediaQuery
                                                                .size.height /
                                                            2
                                                        : mediaQuery
                                                                .size.height /
                                                            4.5,
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    "Id : ${users[users.indexWhere((element) => element.id == notifications[index].employee_id)].id}",
                                                    
                                                  ),
                                                  Text(
                                                    "Name : ${users[users.indexWhere((element) => element.id == notifications[index].employee_id)].firstName} ${users[users.indexWhere((element) => element.id == notifications[index].employee_id)].lastName}",
                                                    
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "Age : ${users[users.indexWhere((element) => element.id == notifications[index].employee_id)].age}",
                                                    
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "Gender : ${users[users.indexWhere((element) => element.id == notifications[index].employee_id)].gender}",
                                                    
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "Email : ${users[users.indexWhere((element) => element.id == notifications[index].employee_id)].email}",
                                                    
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "Phone : ${users[users.indexWhere((element) => element.id == notifications[index].employee_id)].phone}",
                                                   
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "Salary : ${users[users.indexWhere((element) => element.id == notifications[index].employee_id)].salary}",
                                                    
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "Salary Type : ${users[users.indexWhere((element) => element.id == notifications[index].employee_id)].salary_type}",
                                                    
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "Current Salary : ${double.parse(users[users.indexWhere((element) => element.id == notifications[index].employee_id)].current_salary).round()}",
                                                    
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "Address : ${users[users.indexWhere((element) => element.id == notifications[index].employee_id)].address}",
                                                   
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "Position : ${users[users.indexWhere((element) => element.id == notifications[index].employee_id)].position}",
                                                    
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    (users[users.indexWhere((element) =>
                                                                    element
                                                                        .id ==
                                                                    notifications[
                                                                            index]
                                                                        .employee_id)]
                                                                .departmentId ==
                                                            'Empty')
                                                        ? "Department : ${users[users.indexWhere((element) => element.id == notifications[index].employee_id)].departmentId}"
                                                        : "Department : ${departments[departments.indexWhere((element) => element.id == int.parse(users[users.indexWhere((element) => element.id == notifications[index].employee_id)].departmentId!))].name}",
                                                    
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    (users[users.indexWhere((element) =>
                                                                    element
                                                                        .id ==
                                                                    notifications[
                                                                            index]
                                                                        .employee_id)]
                                                                .shiftId ==
                                                            'Empty')
                                                        ? "Shift : ${users[users.indexWhere((element) => element.id == notifications[index].employee_id)].shiftId}"
                                                        : "Shift : ${shifts[shifts.indexWhere((element) => element.id == int.parse(users[users.indexWhere((element) => element.id == notifications[index].employee_id)].shiftId!))].name}",
                                                    
                                                  ),
                                                 
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "Hiring Date : ${users[users.indexWhere((element) => element.id == notifications[index].employee_id)].hiring_date}",
                                                   
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "Current Salary : ${double.parse(users[users.indexWhere((element) => element.id == notifications[index].employee_id)].current_salary).round()}",
                                                    
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        } else {
                                          return const Center(
                                              child: Text(
                                                  "Something wrong happened"));
                                        }
                                      },
                                    ),
                                  ),
                                  actions: <Widget>[
                                    Row(
                                      children: [
                                        ElevatedButton(
                                          onPressed: () async {
                                            first_time = true;
                                            return_all_data_for_all_days = true;
                                            await context
                                                .read<AttendanceNewDataCubit>()
                                                .getAttendanceNewData();
                                            context
                                                .read<ShiftsDataCubit>()
                                                .getShiftsData();

                                            return_all_data_for_all_days =
                                                false;
                                            specific_notification_index = index;
                                            Navigator.pop(context);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute<void>(
                                                builder:
                                                    (BuildContext context) =>
                                                        SpecificNotification(),
                                              ),
                                            );                                            
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
                              ClipOval(                                 
                                  child: Image.network(
                                width: (landscape)
                                    ? mediaQuery.size.height * 0.12
                                    : mediaQuery.size.width * 0.12,
                                height: (landscape)
                                    ? mediaQuery.size.height * 0.12
                                    : mediaQuery.size.width * 0.12,
                                users[users.indexWhere((element) =>
                                        element.id ==
                                        notifications[index].employee_id)]
                                    .image,
                                fit: BoxFit.cover,
                              )),
                              SizedBox(
                                width: mediaQuery.size.width * 0.04,
                              ),
                              Expanded(
                                child: Text(
                                  '${users[users.indexWhere((element) => element.id == notifications[index].employee_id)].firstName} ${users[users.indexWhere((element) => element.id == notifications[index].employee_id)].lastName}',
                                  overflow: TextOverflow.ellipsis,
                                  style: getTextBlack(context),
                                ),
                              ),
                              Text(
                                notifications[index].ask_time,
                                overflow: TextOverflow.ellipsis,
                                style: getTextBlack(context),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            } else if (state is NotificationsError) {
              return Center(
                child: Text(state.errorMessage),
              );
            } else {
              return FutureBuilder<void>(
                future:
                    context.read<NotificationsCubit>().getNotificationsData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Center(
                      child: Text("An error occurred while loading data."),
                    );
                  }
                },
              );
            }
          },
        ),
      ),
    );
  }
}
