import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/Cubits/Search/search_cubit.dart';
import 'package:graduation_project/Cubits/Users_data/users_data_cubit.dart';
import 'package:graduation_project/Cubits/attendance%20new_data/attendance_new_data_cubit.dart';
import 'package:graduation_project/Screen/manger%20screens/attendance/choosing_new_employee_to_attendance.dart';
import 'package:graduation_project/data/Repository/get_attendance_new_repo.dart';
import 'package:graduation_project/data/Repository/get_departments_repo.dart';
import 'package:graduation_project/data/Repository/get_shifts_repo.dart';
import 'package:graduation_project/data/Repository/get_users_Repo.dart';
import 'package:graduation_project/functions/style.dart';

// ignore: must_be_immutable
class AttendanceList2 extends StatelessWidget {
  AttendanceList2({super.key});

  List<String> items = [
    'id',
    'firstName',
    'lastName',
  ];

  List<String> sort_items = [
    'id',
    'firstName',
    'lastName',
  ];

  TextEditingController _textEditingController = TextEditingController();

  String calculateTimeDifference(String startTime, String endTime) {
    // Parse the times
    List<String> startParts = startTime.split(':');
    List<String> endParts = endTime.split(':');

    // Extract hours and minutes, defaulting minutes to 0 if not provided
    int startHours = int.parse(startParts[0]);
    int startMinutes = startParts.length > 1 ? int.parse(startParts[1]) : 0;

    int endHours = int.parse(endParts[0]);
    int endMinutes = endParts.length > 1 ? int.parse(endParts[1]) : 0;

    // Create DateTime objects for easier manipulation
    DateTime startDateTime = DateTime(0, 1, 1, startHours, startMinutes);
    DateTime endDateTime = DateTime(0, 1, 1, endHours, endMinutes);

    // Calculate the difference
    Duration difference = endDateTime.difference(startDateTime);

    int hours = difference.inHours;
    int minutes = difference.inMinutes % 60;

    // Return the difference as a string
    return "$hours:$minutes";
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final landscape = mediaQuery.orientation == Orientation.landscape;
    final statusBar = MediaQuery.of(context).viewPadding.top;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: (landscape)
              ? mediaQuery.size.height * (100 / 800)
              : mediaQuery.size.height * (70 / 800),
          backgroundColor: const Color.fromRGBO(50, 50, 160, 1),
          leading: BlocBuilder<SearchCubit, SearchState>(
            builder: (context, state) {
              return Builder(builder: (context) {
                return (context.read<SearchCubit>().search == false)
                    ? IconButton(
                        color: Colors.white,
                        onPressed: () async {
                          context.read<SearchCubit>().close_search();
                          context.read<SearchCubit>().close_sort();
                          search_field_in_new_attendance = items[0];
                          _textEditingController.clear();

                          sort_ascending_attendacne = true;
                          sort_attendance = false;
                          month = false;

                          context
                              .read<AttendanceNewDataCubit>()
                              .getAttendanceNewData();
                          Navigator.pop(
                            context,
                          );
                        },
                        icon: Icon(Icons.arrow_back),
                      )
                    : IconButton(
                        color: Colors.white,
                        onPressed: () async {
                          // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                          context.read<SearchCubit>().emit(Sort());

                          context
                              .read<AttendanceNewDataCubit>()
                              .getAttendanceNewData();
                          if (sort_ascending_attendacne == true) {
                            sort_ascending_attendacne = false;
                          } else {
                            sort_ascending_attendacne = true;
                          }
                        },
                        icon: (sort_ascending_attendacne == true)
                            ? Icon(Icons.arrow_downward)
                            : Icon(Icons.arrow_upward));
              });
            },
          ),
          actions: [
            BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                return Row(
                  children: [
                    (context.read<SearchCubit>().sort == true)
                        ? SizedBox()
                        :
                        // search case
                        IconButton(
                            color: Colors.white,
                            onPressed: () async {
                              context.read<SearchCubit>().search_icon();
                              context.read<SearchCubit>().close_sort();
                              search_field_in_new_attendance = items[0];
                              _textEditingController.clear();
                              sort_attendance = true;
                              if (context.read<SearchCubit>().search == false) {
                                sort_attendance = false;
                                selectedattendacneSortItem = sort_items[0];
                                sort_ascending_attendacne = true;
                              }

                              context
                                  .read<AttendanceNewDataCubit>()
                                  .getAttendanceNewData();
                            },
                            icon: (context.read<SearchCubit>().search == false)
                                ? Icon(Icons.search)
                                : Icon(Icons.close),
                          ),
                    (context.read<SearchCubit>().search == false)
                        ?
                        // sort case
                        IconButton(
                            color: Colors.white,
                            onPressed: () async {
                              context.read<SearchCubit>().sort_icon();

                              sort_attendance =
                                  context.read<SearchCubit>().sort;

                              context
                                  .read<AttendanceNewDataCubit>()
                                  .getAttendanceNewData();

                              sort_ascending_attendacne = true;

                              selectedattendacneSortItem = sort_items[0];
                            },
                            icon: (sort_attendance == false)
                                ? Icon(Icons.sort)
                                : Icon(Icons.close))
                        : SizedBox(),
                  ],
                );
              },
            ),
          ],
          automaticallyImplyLeading: false,
          title: BlocBuilder<SearchCubit, SearchState>(
            builder: (context, state) {
              return (!context.read<SearchCubit>().search &&
                      !context.read<SearchCubit>().sort)
                  ?
                  // default case
                  FittedBox(
                      child: Text(
                      (month == false)
                          ? 'Employees attended on day ${int.parse(day_of_new_attending) + 1}'
                          : 'Employees attended on month ${int.parse(month_of_new_attending) + 1}',
                      style: (landscape)
                          ? getTextWhiteHeader(context)
                          : getTextWhiteHeader(context),
                    ))
                  : (context.read<SearchCubit>().search == true)
                      ?
                      // search case
                      Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _textEditingController,
                                style: getTextWhite(context),
                                onChanged: (text) {
                                  search_text_in_new_attendance = "";
                                  search_text_in_new_attendance = text;
                                  context
                                      .read<AttendanceNewDataCubit>()
                                      .getAttendanceNewData();
                                  if (search_text_in_new_attendance == "") {
                                    search_in_new_attendance = false;
                                    context
                                        .read<AttendanceNewDataCubit>()
                                        .getAttendanceNewData();
                                  } else {
                                    search_in_new_attendance = true;
                                    context
                                        .read<AttendanceNewDataCubit>()
                                        .getAttendanceNewData();
                                  }
                                },
                                textAlign: TextAlign.left,
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors
                                          .white, // Change to your desired color
                                    ),
                                  ),
                                  errorStyle: TextStyle(color: Colors.red[400]),
                                  contentPadding: const EdgeInsets.all(15),
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  border: null,
                                  hintText: 'Search',
                                  hintStyle: (landscape)
                                      ? getTextWhite(context)
                                      : getTextWhite(context),
                                ),
                              ),
                            ),
                            DropdownButton<String>(
                              dropdownColor:
                                  const Color.fromRGBO(50, 50, 160, 1),
                              iconEnabledColor: Colors.white,
                              iconDisabledColor: Colors.white,
                              value: search_field_in_new_attendance,
                              style: getTextWhite(context),
                              items: items
                                  .map((item) => DropdownMenuItem<String>(
                                      value: item, child: Text(item)))
                                  .toList(),
                              onChanged: (item) {
                                search_field_in_new_attendance = item;
                                selectedattendacneSortItem =
                                    search_text_in_new_attendance = "";
                                _textEditingController.clear();

                                context
                                    .read<SearchCubit>()
                                    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                                    .emit(SearchInitial());

                                context
                                    .read<AttendanceNewDataCubit>()
                                    .getAttendanceNewData();
                              },
                            )
                          ],
                        )
                      :
                      // sort case
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                                color: Colors.white,
                                onPressed: () async {
                                  // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                                  context.read<SearchCubit>().emit(Sort());

                                  sort_attendance =
                                      context.read<SearchCubit>().sort;

                                  context
                                      .read<AttendanceNewDataCubit>()
                                      .getAttendanceNewData();
                                  if (sort_ascending_attendacne == true) {
                                    sort_ascending_attendacne = false;
                                  } else {
                                    sort_ascending_attendacne = true;
                                  }
                                },
                                icon: (sort_ascending_attendacne == true)
                                    ? Icon(Icons.arrow_downward)
                                    : Icon(Icons.arrow_upward)),
                            DropdownButton<String>(
                              dropdownColor:
                                  const Color.fromRGBO(50, 50, 160, 1),
                              iconEnabledColor: Colors.white,
                              iconDisabledColor: Colors.white,
                              value: selectedattendacneSortItem,
                              style: getTextWhite(context),
                              items: sort_items
                                  .map((item) => DropdownMenuItem<String>(
                                      value: item, child: Text(item)))
                                  .toList(),
                              onChanged: (item) {
                                selectedattendacneSortItem = item;
                                sort_ascending_attendacne = true;
                                // ignore: invalid_use_of_protected_member
                                context
                                    .read<SearchCubit>()
                                    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                                    .emit(SearchInitial());
                                context
                                    .read<AttendanceNewDataCubit>()
                                    .getAttendanceNewData();
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
            context.read<SearchCubit>().close_sort();
            search_field_in_new_attendance = items[0];
            _textEditingController.clear();

            sort_ascending_attendacne = true;
            sort_attendance = false;
            month = false;
            context.read<AttendanceNewDataCubit>().getAttendanceNewData();

            Navigator.pop(
              context,
            );
            return true;
          },
          child: Stack(
            children: [
              BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: (landscape)
                              ? (mediaQuery.size.height -
                                  (mediaQuery.size.height * (100 / 800)) -
                                  (statusBar))
                              : (mediaQuery.size.height -
                                  (mediaQuery.size.height * (70 / 800)) -
                                  (statusBar)),
                          child: BlocBuilder<AttendanceNewDataCubit,
                              AttendanceNewDataState>(
                            builder: (context, state) {
                              if (state is AttendanceNewDataSuccess) {
                                return (month == false)
                                    ? ListView.builder(
                                        itemCount: new_attendance.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            margin: (landscape)
                                                ? EdgeInsets.all(5)
                                                : EdgeInsets.all(10),
                                            width: (landscape)
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.9
                                                : MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.9,
                                            height: (landscape)
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    1 /
                                                    10
                                                : MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    1 /
                                                    10,
                                            child: TextButton(
                                              style: ButtonStyle(
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0)),
                                                ),
                                              ),
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                          'Employee\'s info',
                                                        ),
                                                        content:
                                                            SingleChildScrollView(
                                                                child:
                                                                    Container(
                                                          width: mediaQuery
                                                                  .size.width /
                                                              1.8,
                                                          height: (landscape)
                                                              ? mediaQuery.size
                                                                      .height *
                                                                  1.6
                                                              : mediaQuery.size
                                                                      .height /
                                                                  2.5,
                                                          child:
                                                              SingleChildScrollView(
                                                            child: Column(
                                                              children: [
                                                                Container(
                                                                  child: Image.network(users[users.indexWhere((employee) =>
                                                                          employee
                                                                              .id ==
                                                                          new_attendance[index]
                                                                              .employee_id)]
                                                                      .image),
                                                                  width: (landscape)
                                                                      ? mediaQuery
                                                                              .size
                                                                              .width /
                                                                          2
                                                                      : mediaQuery
                                                                              .size
                                                                              .width /
                                                                          1.8,
                                                                  height: (landscape)
                                                                      ? mediaQuery
                                                                              .size
                                                                              .height /
                                                                          2
                                                                      : mediaQuery
                                                                              .size
                                                                              .height /
                                                                          4.5,
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Text(
                                                                  "Id : ${users[users.indexWhere((employee) => employee.id == new_attendance[index].employee_id)].id}",
                                                                ),
                                                                Text(
                                                                  "Name : ${users[users.indexWhere((employee) => employee.id == new_attendance[index].employee_id)].firstName} ${users[users.indexWhere((employee) => employee.id == new_attendance[index].employee_id)].lastName}",
                                                                ),
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Text(
                                                                  "Age : ${users[users.indexWhere((employee) => employee.id == new_attendance[index].employee_id)].age}",
                                                                ),
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Text(
                                                                  "Gender : ${users[users.indexWhere((employee) => employee.id == new_attendance[index].employee_id)].gender}",
                                                                ),
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Text(
                                                                  "Email : ${users[users.indexWhere((employee) => employee.id == new_attendance[index].employee_id)].email}",
                                                                ),
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Text(
                                                                  "Phone : ${users[users.indexWhere((employee) => employee.id == new_attendance[index].employee_id)].phone}",
                                                                ),
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Text(
                                                                  "Salary : ${users[users.indexWhere((employee) => employee.id == new_attendance[index].employee_id)].salary}",
                                                                ),
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Text(
                                                                  "Salary Type : ${users[users.indexWhere((employee) => employee.id == new_attendance[index].employee_id)].salary_type}",
                                                                ),
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Text(
                                                                  "Current Salary : ${double.parse(users[users.indexWhere((employee) => employee.id == new_attendance[index].employee_id)].current_salary).round()}",
                                                                ),
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Text(
                                                                  "Address : ${users[users.indexWhere((employee) => employee.id == new_attendance[index].employee_id)].address}",
                                                                ),
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Text(
                                                                  "Position : ${users[users.indexWhere((employee) => employee.id == new_attendance[index].employee_id)].position}",
                                                                ),
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Text((users[users.indexWhere((employee) =>
                                                                                employee.id ==
                                                                                new_attendance[index].employee_id)]
                                                                            .departmentId ==
                                                                        'Empty')
                                                                    ? 'Department : ${users[users.indexWhere((employee) => employee.id == new_attendance[index].employee_id)].departmentId}'
                                                                    : "Department : ${departments[departments.indexWhere((element) => element.id == int.parse(users[users.indexWhere((employee) => employee.id == new_attendance[index].employee_id)].departmentId!))].name}"),
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Text((users[users.indexWhere((employee) =>
                                                                                employee.id ==
                                                                                new_attendance[index].employee_id)]
                                                                            .shiftId ==
                                                                        'Empty')
                                                                    ? 'Shift : ${users[users.indexWhere((employee) => employee.id == new_attendance[index].employee_id)].shiftId}'
                                                                    : "Shift : ${shifts[shifts.indexWhere((element) => element.id == int.parse(users[users.indexWhere((employee) => employee.id == new_attendance[index].employee_id)].shiftId!))].name}"),
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Text(
                                                                  "Hiring Date : ${users[users.indexWhere((employee) => employee.id == new_attendance[index].employee_id)].hiring_date}",
                                                                ),
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Text(
                                                                  "check-in : ${new_attendance[index].time_in}",
                                                                ),
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Text(
                                                                  "check-out : ${new_attendance[index].time_out}",
                                                                ),
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )),
                                                        actions: <Widget>[
                                                          Row(
                                                            children: [
                                                              TextButton(
                                                                child:
                                                                    Text('OK'),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(); // Close the dialog
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      );
                                                    });
                                              },
                                              child: BlocBuilder<UsersDataCubit,
                                                      UsersDataState>(
                                                  builder: (context, state) {
                                                if (state is UsersDataSuccess) {
                                                  return Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Row(children: [
                                                      ClipOval(
                                                          child: Image.network(
                                                        width: (landscape)
                                                            ? mediaQuery.size
                                                                    .height *
                                                                0.12
                                                            : mediaQuery.size
                                                                    .width *
                                                                0.12,
                                                        height: (landscape)
                                                            ? mediaQuery.size
                                                                    .height *
                                                                0.12
                                                            : mediaQuery.size
                                                                    .width *
                                                                0.12,
                                                        users[users.indexWhere(
                                                                (employee) =>
                                                                    employee
                                                                        .id ==
                                                                    new_attendance[
                                                                            index]
                                                                        .employee_id)]
                                                            .image,
                                                        fit: BoxFit.cover,
                                                      )),
                                                      SizedBox(
                                                        width: mediaQuery
                                                                .size.width *
                                                            0.04,
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          '${users[users.indexWhere((employee) => (employee.id == new_attendance[index].employee_id))].firstName} ${users[users.indexWhere((employee) => employee.id == new_attendance[index].employee_id)].lastName}',
                                                          style: getTextBlack(
                                                              context),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        'working hours: ${calculateTimeDifference(new_attendance[index].time_in, new_attendance[index].time_out)}',
                                                        style: getTextBlack(
                                                            context),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ]),
                                                  );
                                                } else if (state
                                                    is UsersDataError) {
                                                  return Center(
                                                    child: Text(
                                                        state.errorMessage),
                                                  );
                                                } else {
                                                  return FutureBuilder<void>(
                                                    future: context
                                                        .read<UsersDataCubit>()
                                                        .getUsersData(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        );
                                                      } else {
                                                        return Center(
                                                          child: Text(
                                                              "An error occurred while loading data."),
                                                        );
                                                      }
                                                    },
                                                  );
                                                }
                                              }),
                                            ),
                                          );
                                        })
                                    : SizedBox();
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
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else {
                                      return Center(
                                        child: Text(
                                            "An error occurred while loading data."),
                                      );
                                    }
                                  },
                                );
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
              (month == false)
                  ? Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                          width: (landscape)
                              ? mediaQuery.size.height * (49 / 360)
                              : mediaQuery.size.width * (49 / 360),
                          height: (landscape)
                              ? mediaQuery.size.height * (49 / 360)
                              : mediaQuery.size.width * (49 / 360),
                          margin: EdgeInsets.only(
                            left: (landscape)
                                ? mediaQuery.size.height * (288 / 360)
                                : mediaQuery.size.width * (288 / 360),
                            right: (landscape)
                                ? mediaQuery.size.height * (23 / 360)
                                : mediaQuery.size.width * (23 / 360),
                            bottom: (landscape)
                                ? mediaQuery.size.height * (33 / 800)
                                : mediaQuery.size.width * (33 / 800),
                          ),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(241, 242, 246, 1),
                              borderRadius: BorderRadius.circular(100)),
                          child: IconButton(
                            onPressed: () async {
                              context.read<SearchCubit>().close_search();
                              // selectedUsersItem = items[0];
                              emploees_to_be_attended = "";
                              adding_employee_to_attendance = true;
                              for (int i = 0; i < new_attendance.length; i++) {
                                emploees_to_be_attended += "id=neq." +
                                    new_attendance[i].employee_id.toString() +
                                    "&";
                              }

                              _textEditingController.clear();
                              context.read<UsersDataCubit>().getUsersData();
                              context
                                  .read<AttendanceNewDataCubit>()
                                  .getAttendanceNewData();
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      // Test()
                                      AddingNewAttendance(),
                                  // EmployeeList()
                                ),
                              );
                            },
                            icon: FittedBox(child: Icon(Icons.add)),
                          )),
                    )
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
