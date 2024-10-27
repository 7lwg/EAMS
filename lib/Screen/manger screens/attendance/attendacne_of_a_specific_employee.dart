import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/Cubits/attendance%20new_data/attendance_new_data_cubit.dart';
import 'package:graduation_project/Screen/Splash_Screen.dart';
import 'package:graduation_project/data/Repository/get_attendance_new_repo.dart';
import 'package:graduation_project/data/Repository/get_shifts_repo.dart';
import 'package:graduation_project/data/Repository/get_users_Repo.dart';
import 'package:graduation_project/functions/style.dart';
import 'package:intl/intl.dart';

class attendanceOfASpecificEmployee extends StatelessWidget {
  const attendanceOfASpecificEmployee({super.key});

  String calculateTimeDifference(String startTime, String endTime) {
    // Define the format for the input times
    final DateFormat format = DateFormat.Hm(); // HH:mm

    // Parse the input times
    final DateTime start = format.parse(startTime);
    final DateTime end = format.parse(endTime);

    // Calculate the difference
    final Duration difference = end.difference(start);

    // Extract hours and minutes
    final int hours = difference.inHours;
    final int minutes = difference.inMinutes % 60;

    // Return formatted result
    return '$hours:$minutes';
  }

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
              days_of_attendance_for_a_specific_employee = false;
              employeer_id = '0';
              Navigator.of(context).pop();
              context.read<AttendanceNewDataCubit>().getAttendanceNewData();
            },
            icon: Icon(Icons.arrow_back),
          );
        }),
        automaticallyImplyLeading: false,
        title: FittedBox(
            child: Text(
          "Attendance Report For ${users[users.indexWhere((element) => element.id == int.parse(employeer_id))].firstName} ${users[users.indexWhere((element) => element.id == int.parse(employeer_id))].lastName}",
          overflow: TextOverflow.ellipsis,
          style: (landscape)
              ? getTextWhiteHeader(context)
              : getTextWhiteHeader(context),
        )),
        centerTitle: true,
      ),
      // ignore: deprecated_member_use
      body: WillPopScope(
        onWillPop: () async {
          days_of_attendance_for_a_specific_employee = false;
          employeer_id = '0';
          Navigator.of(context).pop();
          context.read<AttendanceNewDataCubit>().getAttendanceNewData();
          return true;
        },       
        child: BlocBuilder<AttendanceNewDataCubit, AttendanceNewDataState>(
          builder: (context, state) {
            if (state is AttendanceNewDataError) {
              return const Center(child: Text('No Attended days found'));
            } else if (state is AttendanceNewDataSuccess) {
              return ListView.builder(
                itemCount: new_attendance.length,
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
                                title: Text(
                                  'Day info',                             
                                ),
                                content: SingleChildScrollView(
                                    child: Container(
                                  width: mediaQuery.size.width / 1.8,
                                  height: (users[users.indexWhere((element) =>
                                                  element.id ==
                                                  int.parse(employeer_id))]
                                              .shiftId !=
                                          "Empty")
                                      ? (landscape)
                                          ? mediaQuery.size.height / 3
                                          : mediaQuery.size.height / 4.9
                                      : (landscape)
                                          ? mediaQuery.size.height / 4
                                          : mediaQuery.size.height / 9.8,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Text(
                                          "Day : ${new_attendance[index].date}",
                                        ),
                                        Text(
                                          "Working hours : ${calculateTimeDifference(new_attendance[index].time_in, new_attendance[index].time_out)}",
                                        ),
                                        Text(
                                          "Check in time : ${new_attendance[index].time_in}",
                                        ),
                                        Text(
                                          "Check out time : ${new_attendance[index].time_out}",
                                        ),
                                        (users[users.indexWhere((element) =>
                                                        element.id ==
                                                        int.parse(
                                                            employeer_id))]
                                                    .shiftId !=
                                                "Empty")
                                            ? Text(
                                                "Shift Name : ${shifts[shifts.indexWhere((element) => element.id == int.parse(users[users.indexWhere((element) => element.id == int.parse(employeer_id))].shiftId!))].name}",
                                              )
                                            : SizedBox(),
                                        (users[users.indexWhere((element) =>
                                                        element.id ==
                                                        int.parse(
                                                            employeer_id))]
                                                    .shiftId !=
                                                "Empty")
                                            ? Text(
                                                "Shift Start Time : ${shifts[shifts.indexWhere((element) => element.id == int.parse(users[users.indexWhere((element) => element.id == int.parse(employeer_id))].shiftId!))].start_time}",
                                              )
                                            : SizedBox(),
                                        (users[users.indexWhere((element) =>
                                                        element.id ==
                                                        int.parse(
                                                            employeer_id))]
                                                    .shiftId !=
                                                "Empty")
                                            ? Text(
                                                "Shift End Time : ${shifts[shifts.indexWhere((element) => element.id == int.parse(users[users.indexWhere((element) => element.id == int.parse(employeer_id))].shiftId!))].end_time}",
                                              )
                                            : SizedBox(),
                                        (users[users.indexWhere((element) =>
                                                        element.id ==
                                                        int.parse(
                                                            employeer_id))]
                                                    .shiftId !=
                                                "Empty")
                                            ? Text(
                                                "Shift Working hours : ${calculateTimeDifference(shifts[shifts.indexWhere((element) => element.id == int.parse(users[users.indexWhere((element) => element.id == int.parse(employeer_id))].shiftId!))].start_time + ":00", shifts[shifts.indexWhere((element) => element.id == int.parse(users[users.indexWhere((element) => element.id == int.parse(employeer_id))].shiftId!))].end_time + ":00")}",
                                              )
                                            : SizedBox(),
                                      ],
                                    ),
                                  ),
                                )),
                                actions: <Widget>[
                                  Center(
                                    child: TextButton(
                                      child: Text('OK'),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                    ),
                                  ),
                                ],
                              );
                            });
                      },
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Text(
                          
                              'Day: ${new_attendance[index].date}',
                            
                              style: getTextBlack(context),
                            ),
                            Spacer(),
                            Text(                              
                              '${"Working hours: " + calculateTimeDifference(new_attendance[index].time_in, new_attendance[index].time_out)}',                             
                              style: getTextBlack(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (state is AttendanceNewDataError) {
              return Center(
                child: Text(state.errorMessage),
              );
            } else {
              return FutureBuilder<void>(
                future: context
                    .read<AttendanceNewDataCubit>()
                    .getAttendanceNewData(),
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
