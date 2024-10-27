// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/Cubits/Departments_Data/departments_data_cubit.dart';
import 'package:graduation_project/Cubits/Search/search_cubit.dart';
import 'package:graduation_project/Cubits/Users_data/users_data_cubit.dart';
import 'package:graduation_project/Screen/Splash_Screen.dart';
import 'package:graduation_project/Screen/manger%20screens/department_shift_employees.dart';
import 'package:graduation_project/Screen/manger%20screens/departments%20manger/Edit_departments.dart';
import 'package:graduation_project/Screen/manger%20screens/departments%20manger/adding_new_department.dart';
import 'package:graduation_project/data/Repository/get_departments_repo.dart';
import 'package:graduation_project/data/Repository/get_holidays_notifications_repo.dart';
import 'package:graduation_project/data/Repository/get_users_Repo.dart';
import 'package:graduation_project/functions/drawer.dart';
import 'package:graduation_project/functions/style.dart';

// ignore: must_be_immutable
class DepartmentList extends StatelessWidget {
  DepartmentList({super.key});

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
                selectedDepartmentItem = items[0];
                search_department_text = "";
                _textEditingController.clear();
                sort_ascending = true;
                sort = false;
                context.read<DepartmentsDataCubit>().getDepartmentsData();
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
                        : IconButton(
                            color: Colors.white,
                            onPressed: () {
                              context.read<SearchCubit>().search_icon();
                              context.read<SearchCubit>().close_sort();
                              selectedDepartmentItem = items[0];
                              search_department_text = "";
                              _textEditingController.clear();
                              context
                                  .read<DepartmentsDataCubit>()
                                  .getDepartmentsData();
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
                              context
                                  .read<DepartmentsDataCubit>()
                                  .getDepartmentsData();
                              sort_ascending = true;
                              selectedDepartmentItem = items[0];
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
                      "Department List",
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
                                  search_department_text = "";
                                  search_department_text = text;
                                  context
                                      .read<DepartmentsDataCubit>()
                                      .getDepartmentsData();
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
                              value: selectedDepartmentItem,
                              style: getTextWhite(context),
                              items: items
                                  .map((item) => DropdownMenuItem<String>(
                                      value: item, child: Text(item)))
                                  .toList(),
                              onChanged: (item) {
                                selectedDepartmentItem = item;
                                search_department_text = "";
                                _textEditingController.clear();
                                // ignore: invalid_use_of_protected_member
                                context
                                    .read<SearchCubit>()
                                    // ignore: invalid_use_of_protected_member
                                    .emit(SearchInitial());
                                context
                                    .read<DepartmentsDataCubit>()
                                    .getDepartmentsData();
                              },
                            )
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                                color: Colors.white,
                                onPressed: () async {
                                  // ignore: invalid_use_of_protected_member
                                  context.read<SearchCubit>().emit(Sort());
                                  sort = context.read<SearchCubit>().sort;
                                  context
                                      .read<DepartmentsDataCubit>()
                                      .getDepartmentsData();
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
                              value: selectedDepartmentItem,
                              style: getTextWhite(context),
                              items: items
                                  .map((item) => DropdownMenuItem<String>(
                                      value: item, child: Text(item)))
                                  .toList(),
                              onChanged: (item) {
                                selectedDepartmentItem = item;
                                sort_ascending = true;
                                // ignore: invalid_use_of_protected_member
                                context
                                    .read<SearchCubit>()
                                    // ignore: invalid_use_of_protected_member
                                    .emit(SearchInitial());
                                context
                                    .read<DepartmentsDataCubit>()
                                    .getDepartmentsData();
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
            selectedDepartmentItem = items[0];
            search_department_text = "";
            _textEditingController.clear();
            sort_ascending = true;
            sort = false;
            context.read<DepartmentsDataCubit>().getDepartmentsData();
            new_notifications_number = notifications.length;
            Navigator.pop(
              context,
            );
            return true;
          },
          child: Stack(children: [
            BlocBuilder<DepartmentsDataCubit, DepartmentsDataState>(
              builder: (context, state) {
                if (state is DepartmentsDataSuccess) {
                  return ListView.builder(
                      itemCount: departments.length,
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
                                        'Department\'s info',
                                      ),
                                      content: SingleChildScrollView(
                                        child: BlocBuilder<DepartmentsDataCubit,
                                            DepartmentsDataState>(
                                          builder: (context, state) {
                                            if (state is DepartmentsDataError) {
                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            } else if (state
                                                is DepartmentsDataSuccess) {
                                              return Container(
                                                width:
                                                    mediaQuery.size.width / 1.8,
                                                height: (landscape)
                                                    ? mediaQuery.size.height / 5
                                                    : mediaQuery.size.height /
                                                        8,
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        "Id : ${departments[index].id}",
                                                      ),
                                                      Text(
                                                        "Name : ${departments[index].name}",
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        "Descreption : ${departments[index].description}",
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        (departments[index]
                                                                    .department_manger ==
                                                                "Empty")
                                                            ? 'Manger: Empty'
                                                            : "Manger : ${users[users.indexWhere((element) => (element.id) == int.parse(departments[index].department_manger))].firstName} ${users[users.indexWhere((element) => (element.id) == int.parse(departments[index].department_manger))].lastName}",
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
                                                selectedDepartmentItem =
                                                    items[0];
                                                search_department_text = "";
                                                _textEditingController.clear();
                                                Navigator.pop(context);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute<void>(
                                                    builder: (BuildContext
                                                            context) =>
                                                        EditDepartments(),
                                                  ),
                                                );
                                                editted_department_id =
                                                    departments[index].id;
                                                for (int i = 0;
                                                    i < departments.length;
                                                    i++) {
                                                  if (departments[i].id ==
                                                      editted_department_id) {
                                                    editted_department_index =
                                                        i;
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
                                                selectedDepartmentItem =
                                                    items[0];
                                                search_department_text = "";
                                                _textEditingController.clear();

                                                selectedUsersItem =
                                                    "departmentId";
                                                search_users_text =
                                                    (departments[index].id)
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
                                                Department_Employee_List = true;
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
                                    '${departments[index].name}',
                                    style: getTextBlack(context),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Container(
                                                width:
                                                    mediaQuery.size.width / 1.8,
                                                child: Text(
                                                  'Are you sure you want to delete ${departments[index].name}',
                                                ),
                                              ),
                                              content: SingleChildScrollView(
                                                child: BlocBuilder<
                                                    DepartmentsDataCubit,
                                                    DepartmentsDataState>(
                                                  builder: (context, state) {
                                                    if (state
                                                        is DepartmentsDataError) {
                                                      return const Center(
                                                          child:
                                                              CircularProgressIndicator());
                                                    } else if (state
                                                        is DepartmentsDataSuccess) {
                                                      return Container(
                                                        width: mediaQuery
                                                                .size.width /
                                                            1.8,
                                                        height: (landscape)
                                                            ? mediaQuery.size
                                                                    .height /
                                                                5
                                                            : mediaQuery.size
                                                                    .height /
                                                                8,
                                                        child:
                                                            SingleChildScrollView(
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                "Id : ${departments[index].id}",
                                                              ),
                                                              Text(
                                                                "Name : ${departments[index].name}",
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              Text(
                                                                "Descreption : ${departments[index].description}",
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              Text(
                                                                (departments[index]
                                                                            .department_manger ==
                                                                        "Empty")
                                                                    ? 'Manger: Empty'
                                                                    : "Manger : ${users[users.indexWhere((element) => (element.id) == int.parse(departments[index].department_manger))].firstName} ${users[users.indexWhere((element) => (element.id) == int.parse(departments[index].department_manger))].lastName}",
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
                                                        deleted_department =
                                                            true;
                                                        deleted_department_id =
                                                            departments[index]
                                                                .id
                                                                .toString();
                                                        for (int i = 0;
                                                            i < users.length;
                                                            i++) {
                                                          if (users[i]
                                                                  .departmentId ==
                                                              deleted_department_id) {
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
                                                                  "Empty",
                                                              "shiftId":
                                                                  users[i]
                                                                      .shiftId,
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
                                                        context
                                                            .read<
                                                                DepartmentsDataCubit>()
                                                            .getDepartmentsData();
                                                        Navigator.of(context)
                                                            .pop();
                                                        context
                                                            .read<SearchCubit>()
                                                            .close_search();
                                                        context
                                                            .read<SearchCubit>()
                                                            .close_sort();
                                                        sort_ascending = true;
                                                        sort = false;
                                                        selectedDepartmentItem =
                                                            items[0];
                                                        search_department_text =
                                                            "";
                                                        _textEditingController
                                                            .clear();
                                                      },
                                                      child: Text("Delete"),
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
                } else if (state is DepartmentsDataError) {
                  return Center(
                    child: Text(state.errorMessage),
                  );
                } else {
                  return FutureBuilder<void>(
                    future: context
                        .read<DepartmentsDataCubit>()
                        .getDepartmentsData(),
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
                      selectedDepartmentItem = items[0];
                      search_department_text = "";
                      _textEditingController.clear();
                      context.read<DepartmentsDataCubit>().getDepartmentsData();
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => AddingDepartment(),
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
