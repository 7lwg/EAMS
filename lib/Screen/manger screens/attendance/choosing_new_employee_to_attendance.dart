// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/Cubits/Search/search_cubit.dart';
import 'package:graduation_project/Cubits/Users_data/users_data_cubit.dart';
import 'package:graduation_project/Cubits/attendance%20new_data/attendance_new_data_cubit.dart';
import 'package:graduation_project/Screen/manger%20screens/attendance/adding_new_attendance.dart';

import 'package:graduation_project/data/Repository/get_attendance_new_repo.dart';
import 'package:graduation_project/data/Repository/get_departments_repo.dart';
import 'package:graduation_project/data/Repository/get_shifts_repo.dart';

import 'package:graduation_project/data/Repository/get_users_Repo.dart';
import 'package:graduation_project/functions/drawer.dart';
import 'package:graduation_project/functions/style.dart';
import 'package:responsive_framework/responsive_value.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

// ignore: must_be_immutable
class AddingNewAttendance extends StatelessWidget {
  AddingNewAttendance({super.key});

  List<String> items = [
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

  var male_gender_color = Colors.white;
  var female_gender_color = Colors.white;

  RangeValues salary_values = RangeValues(0, 100000);
  RangeLabels salary_labels = RangeLabels('0', '100000');

  RangeValues age_values = RangeValues(20, 90);
  RangeLabels age_labels = RangeLabels('20', '90');

  RangeValues rating_values = RangeValues(0.0, 5.0);
  RangeLabels rating_labels = RangeLabels('0.0', '5.0');

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
                        onPressed: () async {
                          context.read<SearchCubit>().close_search();
                          context.read<SearchCubit>().close_sort();
                          selectedUsersItem = items[0];
                          search_users_text = "";
                          _textEditingController.clear();
                          female_gender_color = Colors.white;
                          male_gender_color = Colors.white;
                          Employer_age_start = 20;
                          Employer_age_end = 90;
                          Employer_salary_start = 0;
                          Employer_salary_end = 100000;
                          Employer_rating_start = 0.0;
                          Employer_rating_end = 5.0;
                          sort_ascending = true;
                          sort = false;
                          adding_employee_to_attendance = false;
                          emploees_to_be_attended = "";

                          context
                              .read<AttendanceNewDataCubit>()
                              .getAttendanceNewData();
                          context.read<UsersDataCubit>().getUsersData();
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
                            onPressed: () async {
                              context.read<SearchCubit>().search_icon();
                              context.read<SearchCubit>().close_sort();
                              selectedUsersItem = items[0];
                              search_users_text = "";
                              _textEditingController.clear();
                              female_gender_color = Colors.white;
                              male_gender_color = Colors.white;
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
                              selectedUsersSortItem = sort_items[0];
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
                      'Attending employee to day ${int.parse(day_of_new_attending) + 1}',
                      style: (landscape)
                          ? getTextWhiteHeader(context)
                          : getTextWhiteHeader(context),
                      overflow: TextOverflow.ellipsis,
                    ))
                  : (context.read<SearchCubit>().search == true)
                      ?
                      // search case
                      Row(
                          children: [
                            (selectedUsersItem == 'salary')
                                ? Expanded(
                                    child: Container(
                                      child: Text(
                                        "${Employer_salary_start} - ${Employer_salary_end}",
                                        style: getTextWhite(context),
                                      ),
                                    ),
                                  )
                                : (selectedUsersItem == 'age')
                                    ? Expanded(
                                        child: Container(
                                            child: Center(
                                          child: Text(
                                            "${(Employer_age_start).toString()} - ${(Employer_age_end)}",
                                            style: getTextWhite(context),
                                          ),
                                        )),
                                      )
                                    : (selectedUsersItem == 'gender')
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
                                                    search_users_text = "Male";
                                                    context
                                                        .read<UsersDataCubit>()
                                                        .getUsersData();
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
                                                    search_users_text =
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
                                        : (selectedUsersItem == 'rating')
                                            ? Expanded(
                                                child: Container(
                                                    child: Center(
                                                child: Text(
                                                  "${(Employer_rating_start).toString().substring(0, 3)} - ${(Employer_rating_end).toString().substring(0, 3)}",
                                                  style: getTextWhite(context),
                                                ),
                                              )))
                                            : Expanded(
                                                child: TextFormField(
                                                  controller:
                                                      _textEditingController,
                                                  style: getTextWhite(context),
                                                  onChanged: (text) {
                                                    search_users_text = "";
                                                    search_users_text = text;
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
                              value: selectedUsersItem,
                              style: getTextWhite(context),
                              items: items
                                  .map((item) => DropdownMenuItem<String>(
                                      value: item, child: Text(item)))
                                  .toList(),
                              onChanged: (item) {
                                selectedUsersItem = item;
                                selectedUsersSortItem =
                                    (selectedUsersItem == 'gender')
                                        ? 'id'
                                        : selectedUsersItem;
                                search_users_text = "";
                                _textEditingController.clear();
                                female_gender_color = Colors.white;
                                male_gender_color = Colors.white;
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
                              items: sort_items
                                  .map((item) => DropdownMenuItem<String>(
                                      value: item, child: Text(item)))
                                  .toList(),
                              onChanged: (item) {
                                selectedUsersSortItem = item;
                                sort_ascending = true;
                                // ignore: invalid_use_of_protected_member
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
              context.read<SearchCubit>().close_search();
              context.read<SearchCubit>().close_sort();
              selectedUsersItem = items[0];
              search_users_text = "";
              _textEditingController.clear();
              female_gender_color = Colors.white;
              male_gender_color = Colors.white;
              Employer_age_start = 20;
              Employer_age_end = 90;
              Employer_salary_start = 0;
              Employer_salary_end = 100000;
              Employer_rating_start = 0.0;
              Employer_rating_end = 5.0;
              sort_ascending = true;
              sort = false;
              adding_employee_to_attendance = false;
              emploees_to_be_attended = "";

              context.read<AttendanceNewDataCubit>().getAttendanceNewData();

              Navigator.pop(
                context,
              );
              context.read<UsersDataCubit>().getUsersData();
              return true;
            },
            child: Stack(children: [
              BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                            child: (selectedUsersItem == 'age')
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
                                        Employer_age_end = (value.end.toInt());
                                        search_users_text = 'age';
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
                                : (selectedUsersItem == 'salary')
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
                                            search_users_text = "salary";
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
                                    : (selectedUsersItem == 'rating')
                                        ? Container(
                                            height: (landscape)
                                                ? mediaQuery.size.height * 0.08
                                                : mediaQuery.size.height * 0.05,
                                            width: mediaQuery.size.width * 0.7,
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
                                                search_users_text = "rating";
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
                          height: (selectedUsersItem == 'age' ||
                                  selectedUsersItem == 'salary')
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
                                                      BorderRadius.circular(0)),
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
                                                                          users[index]
                                                                              .image),
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
                                                                      (users[index].departmentId ==
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
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          TextButton(
                                                            child: Text('Open'),
                                                            onPressed:
                                                                () async {
                                                              context
                                                                  .read<
                                                                      SearchCubit>()
                                                                  .close_search();
                                                              selectedUsersItem =
                                                                  items[0];
                                                              id_of_added_employee =
                                                                  users[index]
                                                                      .id
                                                                      .toString();
                                                              search_users_text =
                                                                  "";
                                                              _textEditingController
                                                                  .clear();
                                                              Navigator.pop(
                                                                context,
                                                              );
                                                              context
                                                                  .read<
                                                                      UsersDataCubit>()
                                                                  .getUsersData();

                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute<
                                                                    void>(
                                                                  builder: (BuildContext
                                                                          context) =>
                                                                      AddingNewEmployeetoAttendance(),
                                                                ),
                                                              );
                                                            },
                                                          ),
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
                                                    0.04,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  '${users[index].firstName} ${users[index].lastName}',
                                                  style: getTextBlack(context),
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
            ])),
      ),
    );
  }
}
