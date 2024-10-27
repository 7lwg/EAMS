// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/Cubits/Adding%20Users%20To%20Department%20Or%20Shift/adding_users_to_department_or_shift_cubit.dart';
import 'package:graduation_project/Cubits/Departments_Data/departments_data_cubit.dart';
import 'package:graduation_project/Cubits/Search/search_cubit.dart';
import 'package:graduation_project/Cubits/Shifts_data/shifts_data_cubit.dart';
import 'package:graduation_project/Cubits/Users_data/users_data_cubit.dart';
import 'package:graduation_project/data/Repository/get_departments_repo.dart';
import 'package:graduation_project/data/Repository/get_shifts_repo.dart';
import 'package:graduation_project/data/Repository/get_users_Repo.dart';
import 'package:graduation_project/functions/drawer.dart';
import 'package:graduation_project/functions/style.dart';
import 'package:responsive_framework/responsive_value.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

// ignore: must_be_immutable
class AddingEmployeeToDepartment extends StatefulWidget {
  AddingEmployeeToDepartment({super.key});

  @override
  State<AddingEmployeeToDepartment> createState() =>
      _AddingEmployeeToDepartmentState();
}

class _AddingEmployeeToDepartmentState
    extends State<AddingEmployeeToDepartment> {
  List<String> items_Department = [
    'id',
    'firstName',
    'lastName',
    'age',
    'gender',
    'phone',
    'email',
    'salary',
    'departmentId',
    'shiftId'
  ];

  List<String> sort_items = [
    'id',
    'firstName',
    'lastName',
    'age',
    'phone',
    'email',
    'salary',
    'departmentId',
    'shiftId'
  ];

  List<String> items_Shift = [
    'id',
    'firstName',
    'lastName',
    'age',
    'gender',
    'phone',
    'email',
    'salary',
    'departmentId',
    'shiftId'
  ];

  var male_gender_color = Colors.white;
  var female_gender_color = Colors.white;

  RangeValues salary_values = RangeValues(0, 100000);
  RangeLabels salary_labels = RangeLabels('0', '100000');

  RangeValues age_values = RangeValues(20, 90);
  RangeLabels age_labels = RangeLabels('20', '90');

  RangeValues rating_values = RangeValues(0.0, 5.0);
  RangeLabels rating_labels = RangeLabels('0.0', '5.0');

  bool _isVisible = false;
  List<int> checked_users_id = [];
  String current_department_or_shift = search_users_text;

  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final landscape = mediaQuery.orientation == Orientation.landscape;
    final statusBar = MediaQuery.of(context).viewPadding.top;
    return SafeArea(
      child: Scaffold(
        drawer: myDrawer(),
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
                        onPressed: () {
                          context.read<SearchCubit>().close_search();
                          context.read<SearchCubit>().close_sort();
                          sort_ascending = true;
                          sort = false;
                          if (adding_employee_to_department == true) {
                            selectedUsersItem_department = items_Department[0];
                          } else if (adding_employee_to_shift == true) {
                            selectedUsersItem_department = items_Shift[0];
                          }
                          selectedUsersSortItem = sort_items[0];

                          adding_employee_to_department = false;
                          adding_employee_to_shift = false;
                          isChecked.clear();
                          for (int i = 0; i < users.length; i++) {
                            isChecked.add(false);
                          }
                          exiption_condition = "";
                          editing_employee = false;
                          search_users_text_department = "";
                          _textEditingController.clear();
                          male_gender_color = Colors.white;
                          female_gender_color = Colors.white;
                          Employer_age_start = 20;
                          Employer_age_end = 90;
                          Employer_salary_start = 0;
                          Employer_salary_end = 100000;
                          Employer_rating_start = 0.0;
                          Employer_rating_end = 5.0;
                          context.read<UsersDataCubit>().getUsersData();
                          context.read<ShiftsDataCubit>().getShiftsData();
                          context
                              .read<DepartmentsDataCubit>()
                              .getDepartmentsData();
                          Navigator.pop(
                            context,
                          );
                        },
                        icon: Icon(Icons.arrow_back),
                      )
                    : IconButton(
                        color: Colors.white,
                        onPressed: () async {
                          // ignore: invalid_use_of_protected_member
                          context.read<SearchCubit>().emit(Sort());
                          // sort = context.read<SearchCubit>().sort;
                          context.read<UsersDataCubit>().getUsersData();
                          if (sort_ascending == true) {
                            sort_ascending = false;
                          } else {
                            sort_ascending = true;
                          }
                        },
                        icon: (sort_ascending == true)
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
                            onPressed: () {
                              context.read<SearchCubit>().search_icon();
                              context.read<SearchCubit>().close_sort();
                              if (adding_employee_to_department == true) {
                                selectedUsersItem_department =
                                    items_Department[0];
                              } else if (adding_employee_to_shift == true) {
                                selectedUsersItem_department = items_Shift[0];
                              }
                              search_users_text_department = "";
                              _textEditingController.clear();
                              male_gender_color = Colors.white;
                              female_gender_color = Colors.white;
                              Employer_age_start = 20;
                              Employer_age_end = 90;
                              Employer_salary_start = 0;
                              Employer_salary_end = 100000;
                              Employer_rating_start = 0.0;
                              Employer_rating_end = 5.0;
                              sort = true;
                              if (context.read<SearchCubit>().search == false) {
                                sort = false;
                                selectedUsersSortItem = sort_items[0];
                                sort_ascending = true;
                              }
                              context.read<UsersDataCubit>().getUsersData();
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
                              context.read<UsersDataCubit>().getUsersData();
                              sort_ascending = true;
                              selectedUsersSortItem =
                                  (Department_Employee_List == true)
                                      ? sort_items[0]
                                      : sort_items[0];
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
                      (Department_Employee_List == true)
                          ? "Add Employee to ${departments[departments.indexWhere((element) => element.id == int.parse(search_users_text))].name}"
                          : 'Add Employee to ${shifts[shifts.indexWhere((element) => element.id == int.parse(search_users_text))].name} Shift',
                      style: (landscape)
                          ? getTextWhiteHeader(context)
                          : getTextWhiteHeader(context),
                    ))
                  : (context.read<SearchCubit>().search == true)
                      ?
                      // search case
                      Row(
                          children: [
                            (selectedUsersItem_department == 'salary')
                                ? Expanded(
                                    child: Container(
                                        // height: mediaQuery.size.height * (50 / 800),
                                        child: Center(
                                      child: Text(
                                        "${(Employer_salary_start).toString()} - ${(Employer_salary_end)}",
                                        style: getTextWhite(context),
                                      ),
                                    )),
                                  )
                                : (selectedUsersItem_department == 'age')
                                    ? Expanded(
                                        child: Container(
                                            child: Center(
                                          child: Text(
                                            "${(Employer_age_start).toString()} - ${(Employer_age_end)}",
                                            style: getTextWhite(context),
                                          ),
                                        )),
                                      )
                                    : (selectedUsersItem_department == 'gender')
                                        ? Expanded(
                                            child: Container(
                                                child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                InkWell(
                                                  child: Text("Male",
                                                      style: TextStyle(
                                                          fontSize:
                                                              ResponsiveValue(
                                                            context,
                                                            valueWhen: [
                                                              Condition
                                                                  .smallerThan(
                                                                      name:
                                                                          MOBILE,
                                                                      value:
                                                                          14.0),
                                                              Condition
                                                                  .largerThan(
                                                                      name:
                                                                          MOBILE,
                                                                      value:
                                                                          16.0),
                                                              Condition
                                                                  .smallerThan(
                                                                      name:
                                                                          TABLET,
                                                                      value:
                                                                          18.0),
                                                              Condition
                                                                  .largerThan(
                                                                      name:
                                                                          TABLET,
                                                                      value:
                                                                          20.0),
                                                              Condition
                                                                  .largerThan(
                                                                      name:
                                                                          DESKTOP,
                                                                      value:
                                                                          24.0),
                                                              Condition
                                                                  .largerThan(
                                                                      name:
                                                                          'XL',
                                                                      value:
                                                                          28.0),
                                                            ],
                                                            defaultValue: 12.0,
                                                          ).value,
                                                          color:
                                                              male_gender_color)),
                                                  onTap: () {
                                                    search_users_text_department =
                                                        "Male";
                                                    context
                                                        .read<UsersDataCubit>()
                                                        .getUsersData();
                                                    male_gender_color =
                                                        Colors.black;
                                                    female_gender_color =
                                                        Colors.white;
                                                    context
                                                        .read<SearchCubit>()
                                                        .Gender_color();
                                                  },
                                                ),
                                                InkWell(
                                                  child: Text("Female",
                                                      style: TextStyle(
                                                          fontSize:
                                                              ResponsiveValue(
                                                            context,
                                                            valueWhen: [
                                                              Condition
                                                                  .smallerThan(
                                                                      name:
                                                                          MOBILE,
                                                                      value:
                                                                          14.0),
                                                              Condition
                                                                  .largerThan(
                                                                      name:
                                                                          MOBILE,
                                                                      value:
                                                                          16.0),
                                                              Condition
                                                                  .smallerThan(
                                                                      name:
                                                                          TABLET,
                                                                      value:
                                                                          18.0),
                                                              Condition
                                                                  .largerThan(
                                                                      name:
                                                                          TABLET,
                                                                      value:
                                                                          20.0),
                                                              Condition
                                                                  .largerThan(
                                                                      name:
                                                                          DESKTOP,
                                                                      value:
                                                                          24.0),
                                                              Condition
                                                                  .largerThan(
                                                                      name:
                                                                          'XL',
                                                                      value:
                                                                          28.0),
                                                            ],
                                                            defaultValue: 12.0,
                                                          ).value,
                                                          color:
                                                              female_gender_color)),
                                                  onTap: () {
                                                    search_users_text_department =
                                                        "Female";
                                                    context
                                                        .read<UsersDataCubit>()
                                                        .getUsersData();
                                                    female_gender_color =
                                                        Colors.black;
                                                    male_gender_color =
                                                        Colors.white;
                                                    context
                                                        .read<SearchCubit>()
                                                        .Gender_color();
                                                  },
                                                ),
                                              ],
                                            )),
                                          )
                                        : (selectedUsersItem_department ==
                                                'rating')
                                            ? Expanded(
                                                child: Container(
                                                    child: Center(
                                                  child: Text(
                                                    "${(Employer_rating_start).toString().substring(0, 3)} - ${(Employer_rating_end).toString().substring(0, 3)}",
                                                    style:
                                                        getTextWhite(context),
                                                  ),
                                                )),
                                              )
                                            : Expanded(
                                                child: TextFormField(
                                                  controller:
                                                      _textEditingController,
                                                  style: getTextWhite(context),
                                                  onChanged: (text) {
                                                    search_users_text_department =
                                                        "";
                                                    search_users_text_department =
                                                        text;
                                                    context
                                                        .read<UsersDataCubit>()
                                                        .getUsersData();
                                                  },
                                                  textAlign: TextAlign.left,
                                                  decoration: InputDecoration(
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors
                                                            .white, // Change to your desired color
                                                      ),
                                                    ),
                                                    errorStyle: TextStyle(
                                                        color: Colors.red[400]),
                                                    contentPadding:
                                                        const EdgeInsets.all(
                                                            15),
                                                    filled: true,
                                                    fillColor:
                                                        Colors.transparent,
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
                              value: selectedUsersItem_department,
                              style: getTextWhite(context),
                              items: (adding_employee_to_department == true)
                                  ? items_Department
                                      .map((item) => DropdownMenuItem<String>(
                                          value: item, child: Text(item)))
                                      .toList()
                                  : items_Shift
                                      .map((item) => DropdownMenuItem<String>(
                                          value: item, child: Text(item)))
                                      .toList(),
                              onChanged: (item) {
                                selectedUsersItem_department = item;
                                selectedUsersSortItem =
                                    (selectedUsersItem_department == 'gender')
                                        ? 'id'
                                        : selectedUsersItem_department;
                                sort_ascending = true;
                                search_users_text_department = "";
                                _textEditingController.clear();
                                male_gender_color = Colors.white;
                                female_gender_color = Colors.white;
                                age_values = RangeValues(20, 90);
                                age_labels = RangeLabels('20', '90');
                                salary_values = RangeValues(0, 100000);
                                salary_labels = RangeLabels('0', '100000');
                                rating_values = RangeValues(0.0, 5.0);
                                rating_labels = RangeLabels('0.0', '5.0');
                                Employer_age_start = 20;
                                Employer_age_end = 90;
                                Employer_salary_start = 0;
                                Employer_salary_end = 100000;
                                Employer_rating_start = 0.0;
                                Employer_rating_end = 5.0;
                                // ignore: invalid_use_of_protected_member
                                context
                                    .read<SearchCubit>()
                                    // ignore: invalid_use_of_protected_member
                                    .emit(SearchInitial());
                                context.read<UsersDataCubit>().getUsersData();
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
                                  // ignore: invalid_use_of_protected_member
                                  context.read<SearchCubit>().emit(Sort());
                                  sort = context.read<SearchCubit>().sort;
                                  context.read<UsersDataCubit>().getUsersData();
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
                              value: selectedUsersSortItem,
                              style: getTextWhite(context),
                              items: (Department_Employee_List == true)
                                  ? sort_items
                                      .map((item) => DropdownMenuItem<String>(
                                          value: item, child: Text(item)))
                                      .toList()
                                  : sort_items
                                      .map((item) => DropdownMenuItem<String>(
                                          value: item, child: Text(item)))
                                      .toList(),
                              onChanged: (item) {
                                selectedUsersSortItem = item;
                                sort_ascending = true;
                                context
                                    .read<SearchCubit>()
                                    // ignore: invalid_use_of_protected_member
                                    .emit(SearchInitial());
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
            context.read<ShiftsDataCubit>().getShiftsData();
            context.read<DepartmentsDataCubit>().getDepartmentsData();
            context.read<SearchCubit>().close_search();
            context.read<SearchCubit>().close_sort();
            sort_ascending = true;
            sort = false;
            if (adding_employee_to_department == true) {
              selectedUsersItem_department = items_Department[0];
            } else if (adding_employee_to_shift == true) {
              selectedUsersItem_department = items_Shift[0];
            }
            adding_employee_to_department = false;
            adding_employee_to_shift = false;
            isChecked.clear();
            for (int i = 0; i < users.length; i++) {
              isChecked.add(false);
            }
            sort_ascending = true;
            sort = false;
            exiption_condition = "";
            editing_employee = false;
            search_users_text_department = "";
            Employer_age_start = 20;
            Employer_age_end = 90;
            Employer_salary_start = 0;
            Employer_salary_end = 100000;
            Employer_rating_start = 0.0;
            Employer_rating_end = 5.0;
            _textEditingController.clear();
            male_gender_color = Colors.white;
            female_gender_color = Colors.white;
            context.read<UsersDataCubit>().getUsersData();
            Navigator.pop(
              context,
            );
            return true;
          },
          child: BlocBuilder<AddingUsersToDepartmentOrShiftCubit,
              AddingUsersToDepartmentOrShiftState>(
            builder: (context, state) {
              return Stack(children: [
                BlocBuilder<SearchCubit, SearchState>(
                  builder: (context, state) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                              child: (selectedUsersItem_department == 'age')
                                  ? Container(
                                      height: (landscape)
                                          ? mediaQuery.size.height * 0.08
                                          : mediaQuery.size.height * 0.05,
                                      width: mediaQuery.size.width * 0.7,
                                      child: Container(
                                          child: RangeSlider(
                                        min: 20,
                                        max: 90,
                                        divisions: (90),
                                        values: age_values,
                                        labels: age_labels,
                                        onChanged: (value) {
                                          Employer_age_start =
                                              (value.start.toInt());
                                          Employer_age_end =
                                              (value.end.toInt());
                                          search_users_text_department = 'age';
                                          age_values = value;
                                          age_labels = RangeLabels(
                                              value.start.toInt().toString(),
                                              value.end.toInt().toString());
                                          context
                                              .read<SearchCubit>()
                                              // ignore: invalid_use_of_protected_member
                                              .emit(SearchInitial());
                                          context
                                              .read<UsersDataCubit>()
                                              .getUsersData();
                                        },
                                      )))
                                  : (selectedUsersItem_department == 'salary')
                                      ? Container(
                                          height: (landscape)
                                              ? mediaQuery.size.height * 0.08
                                              : mediaQuery.size.height * 0.05,
                                          width: mediaQuery.size.width * 0.7,
                                          child: RangeSlider(
                                            min: 0,
                                            max: 100000,
                                            divisions: (100000),
                                            values: salary_values,
                                            labels: salary_labels,
                                            onChanged: (value) {
                                              Employer_salary_start =
                                                  (value.start.toInt());
                                              Employer_salary_end =
                                                  (value.end.toInt());
                                              search_users_text_department =
                                                  "salary";

                                              salary_values = value;
                                              salary_labels = RangeLabels(
                                                  '${value.start.toInt().toString()}\$',
                                                  '${value.end.toInt().toString()}\$');
                                              context
                                                  .read<SearchCubit>()
                                                  // ignore: invalid_use_of_protected_member
                                                  .emit(SearchInitial());
                                              context
                                                  .read<UsersDataCubit>()
                                                  .getUsersData();
                                            },
                                          ))
                                      : (selectedUsersItem_department ==
                                              'rating')
                                          ? Container(
                                              height: (landscape)
                                                  ? mediaQuery.size.height *
                                                      0.08
                                                  : mediaQuery.size.height *
                                                      0.05,
                                              width:
                                                  mediaQuery.size.width * 0.7,
                                              child: RangeSlider(
                                                min: 0.0,
                                                max: 5.0,
                                                divisions: (50),
                                                values: rating_values,
                                                labels: rating_labels,
                                                onChanged: (value) {
                                                  Employer_rating_start =
                                                      (value.start.toDouble());
                                                  Employer_rating_end =
                                                      (value.end.toDouble());
                                                  search_users_text_department =
                                                      "rating";

                                                  rating_values = value;
                                                  rating_labels = RangeLabels(
                                                      (value.start
                                                              .toDouble()
                                                              .toString())
                                                          .substring(0, 3),
                                                      (value.end
                                                              .toDouble()
                                                              .toString())
                                                          .substring(0, 3));
                                                  context
                                                      .read<SearchCubit>()
                                                      // ignore: invalid_use_of_protected_member
                                                      .emit(SearchInitial());
                                                  context
                                                      .read<UsersDataCubit>()
                                                      .getUsersData();
                                                },
                                              ))
                                          : Container()),
                          Container(
                            height: (selectedUsersItem_department == 'age' ||
                                    selectedUsersItem_department == 'salary')
                                ? (landscape)
                                    ? (mediaQuery.size.height -
                                        (mediaQuery.size.height * (100 / 800)) -
                                        (statusBar) -
                                        mediaQuery.size.height * 0.08)
                                    : (mediaQuery.size.height -
                                        (mediaQuery.size.height * (70 / 800)) -
                                        (statusBar) -
                                        mediaQuery.size.height * 0.05)
                                : (landscape)
                                    ? (mediaQuery.size.height -
                                        (mediaQuery.size.height * (100 / 800)) -
                                        (statusBar))
                                    : (mediaQuery.size.height -
                                        (mediaQuery.size.height * (70 / 800)) -
                                        (statusBar)),
                            child: BlocBuilder<UsersDataCubit, UsersDataState>(
                              builder: (context, state) {
                                if (state is UsersDataSuccess) {
                                  return ListView.builder(
                                      itemCount: users.length,
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
                                              shape: MaterialStateProperty.all<
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
                                                        child: BlocBuilder<
                                                            UsersDataCubit,
                                                            UsersDataState>(
                                                          builder:
                                                              (context, state) {
                                                            if (state
                                                                is UsersDataError) {
                                                              return const Center(
                                                                  child:
                                                                      CircularProgressIndicator());
                                                            } else if (state
                                                                is UsersDataSuccess) {
                                                              return Container(
                                                                width: mediaQuery
                                                                        .size
                                                                        .width /
                                                                    1.8,
                                                                height: (landscape)
                                                                    ? mediaQuery
                                                                            .size
                                                                            .height *
                                                                        1.5
                                                                    : mediaQuery
                                                                            .size
                                                                            .height /
                                                                        2.5,
                                                                child:
                                                                    SingleChildScrollView(
                                                                  child: Column(
                                                                    children: [
                                                                      Container(
                                                                        child: Image.network(
                                                                            users[index].image),
                                                                        width: (landscape)
                                                                            ? mediaQuery.size.width /
                                                                                2
                                                                            : mediaQuery.size.width /
                                                                                1.8,
                                                                        height: (landscape)
                                                                            ? mediaQuery.size.height /
                                                                                2
                                                                            : mediaQuery.size.height /
                                                                                4.5,
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      Text(
                                                                        "Id : ${users[index].id}",
                                                                      ),
                                                                      Text(
                                                                        "Name : ${users[index].firstName} ${users[index].lastName}",
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                      Text(
                                                                        "Age : ${users[index].age}",
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                      Text(
                                                                        "Gender : ${users[index].gender}",
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                      Text(
                                                                        "Email : ${users[index].email}",
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                      Text(
                                                                        "Phone : ${users[index].phone}",
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                      Text(
                                                                        "Salary : ${users[index].salary}",
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                      Text(
                                                                        "Salary Type : ${users[index].salary_type}",
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                      Text(
                                                                        "Current Salary : ${double.parse(users[index].current_salary).round()}",
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                      Text(
                                                                        "Address : ${users[index].address}",
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                      Text(
                                                                        "Position : ${users[index].position}",
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                      Text(
                                                                        (users[index].departmentId ==
                                                                                'Empty')
                                                                            ? 'department  : ${users[index].departmentId}'
                                                                            : "department  : ${departments[departments.indexWhere((element) => element.id == int.parse(users[index].departmentId!))].name}",
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                      Text(
                                                                        (users[index].shiftId ==
                                                                                'Empty')
                                                                            ? "shift : ${users[index].shiftId}"
                                                                            : "shift : ${shifts[shifts.indexWhere((element) => element.id == int.parse(users[index].shiftId!))].name}",
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                      Text(
                                                                        "Hiring Date : ${users[index].hiring_date}",
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            5,
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
                                                            TextButton(
                                                              child: Text('OK'),
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
                                            child: Container(
                                              alignment: Alignment.centerLeft,
                                              child: Row(children: [
                                                Checkbox(
                                                  value: isChecked[index],
                                                  onChanged: (bool? value) {
                                                    context
                                                        .read<
                                                            AddingUsersToDepartmentOrShiftCubit>()
                                                        .Check_User();
                                                    isChecked[index] =
                                                        value ?? false;                                                   

                                                    if (isChecked
                                                            .contains(true) ==
                                                        false) {
                                                      _isVisible = false;
                                                    } else {
                                                      _isVisible = true;
                                                    }
                                                  },
                                                ),
                                                ClipOval(
                                                    child: Image.network(
                                                  width: (landscape)
                                                      ? mediaQuery.size.height *
                                                          0.12
                                                      : mediaQuery.size.width *
                                                          0.12,
                                                  height: (landscape)
                                                      ? mediaQuery.size.height *
                                                          0.12
                                                      : mediaQuery.size.width *
                                                          0.12,
                                                  users[index].image,
                                                  fit: BoxFit.cover,
                                                )),
                                                SizedBox(
                                                  width: mediaQuery.size.width *
                                                      0.01,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    '${users[index].id} ${users[index].firstName} ${users[index].lastName}',
                                                    style:
                                                        getTextBlack(context),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ]),
                                            ),
                                          ),
                                        );
                                      });
                                } else if (state is UsersDataError) {
                                  return Center(
                                    child: Text(state.errorMessage),
                                  );
                                } else {
                                  return FutureBuilder<void>(
                                    future: context
                                        .read<UsersDataCubit>()
                                        .getUsersData(),
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
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Visibility(
                  visible: _isVisible,
                  child: Align(
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
                            borderRadius: BorderRadius.circular(
                              100,
                            )),
                        child: IconButton(
                          onPressed: () async {
                            // id of the checked users
                            checked_users_id.clear();
                            context.read<SearchCubit>().close_search();
                            context.read<SearchCubit>().close_sort();
                            sort_ascending = true;
                            sort = false;
                            editing_employee = true;
                            for (int i = 0; i < isChecked.length; i++) {
                              if (isChecked[i] == true) {
                               
                                editted_employee_id = users[i].id;
                                putUsersData = {
                                  "id": users[i].id,
                                  "firstName": users[i].firstName,
                                  "lastName": users[i].lastName,
                                  "age": users[i].age,
                                  "gender": users[i].gender,
                                  "email": users[i].email,
                                  "phone": users[i].phone,
                                  "image": users[i].image,
                                  "departmentId":
                                      (adding_employee_to_department == true)
                                          ? current_department_or_shift
                                          : users[i].departmentId,
                                  "shiftId": (adding_employee_to_shift == true)
                                      ? current_department_or_shift
                                      : users[i].shiftId,
                                  "salary": users[i].salary,
                                  "salary_type": users[i].salary_type,
                                  "address": users[i].address,
                                  "position": users[i].position,
                                  "hiring_date": users[i].hiring_date,
                                  "rating": users[i].rating,
                                  "companyName": users[i].companyName,
                                  "password": users[i].password,
                                  "current_salary": users[i].current_salary
                                };
                                context.read<UsersDataCubit>().getUsersData();
                              }
                            }
                          
                            adding_employee_to_department = false;
                            adding_employee_to_shift = false;
                            isChecked.clear();
                            for (int i = 0; i < users.length; i++) {
                              isChecked.add(false);
                            }
                            age_values = RangeValues(20, 90);
                            age_labels = RangeLabels('20', '90');
                            salary_values = RangeValues(0, 100000);
                            salary_labels = RangeLabels('0', '100000');
                            Employer_age_start = 20;
                            Employer_age_end = 90;
                            Employer_salary_start = 0;
                            Employer_salary_end = 100000;
                            exiption_condition = "";
                            editing_employee = false;
                            search_users_text_department = "";
                            selectedUsersItem_department = items_Shift[0];
                            context.read<UsersDataCubit>().getUsersData();
                            Navigator.pop(
                              context,
                            );
                          },
                          icon: FittedBox(child: Icon(Icons.check)),
                        )),
                  ),
                )
              ]);
            },
          ),
        ),
      ),
    );
  }
}
