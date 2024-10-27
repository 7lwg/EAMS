// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/Cubits/Search/search_cubit.dart';
import 'package:graduation_project/Cubits/Shifts_data/shifts_data_cubit.dart';
import 'package:graduation_project/Cubits/Users_data/users_data_cubit.dart';
import 'package:graduation_project/Screen/Splash_Screen.dart';
import 'package:graduation_project/Screen/manger%20screens/department_shift_employees.dart';
import 'package:graduation_project/Screen/manger%20screens/shifts%20manger/Edit_shifts.dart';
import 'package:graduation_project/Screen/manger%20screens/shifts%20manger/adding_new_shift.dart';
import 'package:graduation_project/data/Repository/get_holidays_notifications_repo.dart';
import 'package:graduation_project/data/Repository/get_shifts_repo.dart';
import 'package:graduation_project/data/Repository/get_users_Repo.dart';
import 'package:graduation_project/functions/drawer.dart';
import 'package:graduation_project/functions/style.dart';

// ignore: must_be_immutable
class ShiftsList extends StatelessWidget {
  ShiftsList({super.key});

  List<String> items = ['id', 'Name', 'Description'];

  TextEditingController _textEditingController = TextEditingController();

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
                context.read<SearchCubit>().close_sort();
                sort_ascending = true;
                sort = false;
                selectedshiftItem = items[0];

                search_shift_text = "";
                _textEditingController.clear();
                sort = false;
                context.read<ShiftsDataCubit>().getShiftsData();
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
                return Row(
                  children: [
                    (context.read<SearchCubit>().sort == true)
                        ? SizedBox()
                        :
                        // search case
                        IconButton(
                            color: Colors.white,
                            onPressed: () {
                              context.read<SearchCubit>().search_icon();
                              context.read<SearchCubit>().close_sort();
                              selectedshiftItem = items[0];
                              search_shift_text = "";
                              _textEditingController.clear();
                              context.read<ShiftsDataCubit>().getShiftsData();
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
                              sort = context.read<SearchCubit>().sort;
                              context.read<ShiftsDataCubit>().getShiftsData();
                              sort_ascending = true;
                            },
                            icon: (sort == false)
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
                      "Shifts List",
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
                                  search_shift_text = "";
                                  search_shift_text = text;
                                  context
                                      .read<ShiftsDataCubit>()
                                      .getShiftsData();
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
                                  // const Color.fromRGBO(56, 149, 164, 1),
                                  const Color.fromRGBO(50, 50, 160, 1),
                              iconEnabledColor: Colors.white,
                              iconDisabledColor: Colors.white,
                              value: selectedshiftItem,
                              style: getTextWhite(context),
                              items: items
                                  .map((item) => DropdownMenuItem<String>(
                                      value: item, child: Text(item)))
                                  .toList(),
                              onChanged: (item) {
                                selectedshiftItem = item;
                                search_shift_text = "";
                                _textEditingController.clear();
                                // ignore: invalid_use_of_visible_for_testing_member
                                context
                                    .read<SearchCubit>()
                                    // ignore: invalid_use_of_visible_for_testing_member
                                    .emit(SearchInitial());
                                context.read<ShiftsDataCubit>().getShiftsData();
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
                                  // ignore: invalid_use_of_visible_for_testing_member
                                  context.read<SearchCubit>().emit(Sort());
                                  sort = context.read<SearchCubit>().sort;
                                  context
                                      .read<ShiftsDataCubit>()
                                      .getShiftsData();
                                  if (sort_ascending == true) {
                                    sort_ascending = false;
                                  } else {
                                    sort_ascending = true;
                                  }
                                },
                                icon: (sort_ascending == true)
                                    ? Icon(Icons.arrow_downward)
                                    : Icon(Icons.arrow_upward)),
                            DropdownButton<String>(
                              dropdownColor:
                                  const Color.fromRGBO(50, 50, 160, 1),
                              iconEnabledColor: Colors.white,
                              iconDisabledColor: Colors.white,
                              value: selectedshiftItem,
                              style: getTextWhite(context),
                              items: items
                                  .map((item) => DropdownMenuItem<String>(
                                      value: item, child: Text(item)))
                                  .toList(),
                              onChanged: (item) {
                                selectedshiftItem = item;
                                sort_ascending = true;
                                context
                                    .read<SearchCubit>()
                                    // ignore: invalid_use_of_visible_for_testing_member
                                    .emit(SearchInitial());
                                context.read<ShiftsDataCubit>().getShiftsData();
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
            sort_ascending = true;
            sort = false;
            selectedshiftItem = items[0];

            search_shift_text = "";
            _textEditingController.clear();
            sort = false;
            context.read<ShiftsDataCubit>().getShiftsData();
            new_notifications_number = notifications.length;
            Navigator.pop(
              context,
            );
            return true;
          },
          child: Stack(children: [
            BlocBuilder<ShiftsDataCubit, ShiftsDataState>(
              builder: (context, state) {
                if (state is ShiftsDataSuccess) {
                  return ListView.builder(
                      itemCount: shifts.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5)),
                          margin: (landscape)
                              ? EdgeInsets.all(5)
                              : EdgeInsets.all(10),
                          width: (landscape)
                              ? MediaQuery.of(context).size.height * 0.9
                              : MediaQuery.of(context).size.width * 0.9,
                          height: (landscape)
                              ? MediaQuery.of(context).size.width * 1 / 10
                              : MediaQuery.of(context).size.height * 1 / 10,
                          child: TextButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
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
                                        'Shift\'s info',
                                      ),
                                      content: SingleChildScrollView(
                                        child: BlocBuilder<ShiftsDataCubit,
                                            ShiftsDataState>(
                                          builder: (context, state) {
                                            if (state is ShiftsDataError) {
                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            } else if (state
                                                is ShiftsDataSuccess) {
                                              return Container(
                                                width:
                                                    mediaQuery.size.width / 1.8,
                                                height: (landscape)
                                                    ? mediaQuery.size.height / 2
                                                    : mediaQuery.size.height /
                                                        6,
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        "Id : ${shifts[index].id}",
                                                      ),
                                                      Text(
                                                        "Name : ${shifts[index].name}",
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        "Descreption : ${shifts[index].description}",
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        "Start time : ${shifts[index].start_time}",
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        "End time : ${shifts[index].end_time}",
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
                                              onPressed: () {
                                                context
                                                    .read<SearchCubit>()
                                                    .close_search();
                                                context
                                                    .read<SearchCubit>()
                                                    .close_sort();
                                                sort_ascending = true;
                                                sort = false;
                                                selectedshiftItem = items[0];
                                                search_shift_text = "";
                                                _textEditingController.clear();
                                                Navigator.pop(context);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute<void>(
                                                    builder: (BuildContext
                                                            context) =>
                                                        EditShifts(),
                                                  ),
                                                );
                                                editted_shift_id =
                                                    shifts[index].id;
                                                for (int i = 0;
                                                    i < shifts.length;
                                                    i++) {
                                                  if (shifts[i].id ==
                                                      editted_shift_id) {
                                                    editted_shift_index = i;
                                                  }
                                                }
                                              },
                                              child: Text("Edit"),
                                            ),
                                            Spacer(),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                context
                                                    .read<SearchCubit>()
                                                    .close_search();
                                                context
                                                    .read<SearchCubit>()
                                                    .close_sort();
                                                sort_ascending = true;
                                                sort = false;
                                                selectedshiftItem = items[0];
                                                search_shift_text = "";
                                                _textEditingController.clear();
                                                selectedUsersItem = "shiftId";
                                                search_users_text =
                                                    (shifts[index].id)
                                                        .toString();
                                                context
                                                    .read<UsersDataCubit>()
                                                    .getUsersData();
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute<void>(
                                                    builder: (BuildContext
                                                            context) =>
                                                        DepartmentEmployeeList(),
                                                  ),
                                                );
                                                Department_Employee_List =
                                                    false;
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
                              child: Row(children: [
                                Expanded(
                                  child: Text(
                                    '${shifts[index].name}',
                                    overflow: TextOverflow.ellipsis,
                                    style: getTextBlack(context),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: InkWell(
                                    onTap: () async {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Container(
                                                width:
                                                    mediaQuery.size.width / 1.8,
                                                child: Text(
                                                  'Are you sure you want to delete ${shifts[index].name}',
                                                ),
                                              ),
                                              content: SingleChildScrollView(
                                                child: BlocBuilder<
                                                    ShiftsDataCubit,
                                                    ShiftsDataState>(
                                                  builder: (context, state) {
                                                    if (state
                                                        is ShiftsDataError) {
                                                      return const Center(
                                                          child:
                                                              CircularProgressIndicator());
                                                    } else if (state
                                                        is ShiftsDataSuccess) {
                                                      return Container(
                                                        width: mediaQuery
                                                                .size.width /
                                                            1.8,
                                                        height: (landscape)
                                                            ? mediaQuery.size
                                                                    .height /
                                                                2
                                                            : mediaQuery.size
                                                                    .height /
                                                                6,
                                                        child:
                                                            SingleChildScrollView(
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                "Id : ${shifts[index].id}",
                                                              ),
                                                              Text(
                                                                "Name : ${shifts[index].name}",
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              Text(
                                                                "Descreption : ${shifts[index].description}",
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              Text(
                                                                "Start time : ${shifts[index].start_time}",
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              Text(
                                                                "End time : ${shifts[index].end_time}",
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
                                                      child: Text('Delete'),
                                                      onPressed: () {
                                                        deleted_shift = true;
                                                        deleted_shift_id =
                                                            shifts[index]
                                                                .id
                                                                .toString();
                                                        for (int i = 0;
                                                            i < users.length;
                                                            i++) {
                                                          if (users[i]
                                                                  .shiftId ==
                                                              deleted_shift_id) {
                                                            editted_employee_id =
                                                                users[i].id;
                                                            editing_employee =
                                                                true;
                                                            putUsersData = {
                                                              "id": users[i].id,
                                                              "firstName":
                                                                  users[i]
                                                                      .firstName,
                                                              "lastName":
                                                                  users[i]
                                                                      .lastName,
                                                              "age":
                                                                  users[i].age,
                                                              "gender": users[i]
                                                                  .gender,
                                                              "email": users[i]
                                                                  .email,
                                                              "phone": users[i]
                                                                  .phone,
                                                              "image": users[i]
                                                                  .image,
                                                              "departmentId":
                                                                  users[i]
                                                                      .departmentId,
                                                              "shiftId":
                                                                  "Empty",
                                                              "salary": users[i]
                                                                  .salary,
                                                              "salary_type":
                                                                  users[i]
                                                                      .salary_type,
                                                              "address":
                                                                  users[i]
                                                                      .address,
                                                              "position":
                                                                  users[i]
                                                                      .position,
                                                              "hiring_date":
                                                                  users[i]
                                                                      .hiring_date,
                                                              "rating": users[i]
                                                                  .rating,
                                                              "companyName":
                                                                  users[i]
                                                                      .companyName,
                                                              "password":
                                                                  users[i]
                                                                      .password,
                                                              "current_salary":
                                                                  users[i]
                                                                      .current_salary
                                                            };
                                                            context
                                                                .read<
                                                                    UsersDataCubit>()
                                                                .getUsersData();
                                                          }
                                                        }
                                                        shifts.removeAt(0);
                                                        context
                                                            .read<
                                                                ShiftsDataCubit>()
                                                            .getShiftsData();
                                                        Navigator.of(context)
                                                            .pop(); // Close the dialog
                                                      },
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
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      width: (landscape)
                                          ? MediaQuery.of(context).size.width *
                                              0.5 /
                                              10
                                          : MediaQuery.of(context).size.height *
                                              0.5 /
                                              10,
                                      height: (landscape)
                                          ? MediaQuery.of(context).size.width *
                                              0.5 /
                                              10
                                          : MediaQuery.of(context).size.height *
                                              0.5 /
                                              10,
                                      child: Container(
                                        child: FittedBox(
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                          ),
                        );
                      });
                } else if (state is ShiftsDataError) {
                  return Center(
                    child: Text(state.errorMessage),
                  );
                } else {
                  return FutureBuilder<void>(
                    future: context.read<ShiftsDataCubit>().getShiftsData(),
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
            Align(
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
                    onPressed: () {
                      context.read<SearchCubit>().close_search();
                      context.read<SearchCubit>().close_sort();
                      sort_ascending = true;
                      sort = false;
                      selectedshiftItem = items[0];
                      search_shift_text = "";
                      _textEditingController.clear();
                      context.read<ShiftsDataCubit>().getShiftsData();
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => AddingShifts(),
                        ),
                      );
                    },
                    icon: FittedBox(child: Icon(Icons.add)),
                  )),
            )
          ]),
        ),
      ),
    );
  }
}
