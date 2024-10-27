// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/Cubits/Departments_Data/departments_data_cubit.dart';
import 'package:graduation_project/Cubits/Search/search_cubit.dart';
import 'package:graduation_project/Cubits/Shifts_data/shifts_data_cubit.dart';
import 'package:graduation_project/Cubits/Users_data/users_data_cubit.dart';
import 'package:graduation_project/Screen/manger%20screens/adding_employee_to_department_and_to_shift.dart';
import 'package:graduation_project/data/Repository/get_departments_repo.dart';
import 'package:graduation_project/data/Repository/get_shifts_repo.dart';
import 'package:graduation_project/data/Repository/get_users_Repo.dart';
import 'package:graduation_project/functions/drawer.dart';
import 'package:graduation_project/functions/style.dart';
import 'package:responsive_framework/responsive_value.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

// ignore: must_be_immutable
class DepartmentEmployeeList extends StatelessWidget {
  DepartmentEmployeeList({super.key});

  List<String> items_Department = [
    'id',
    'firstName',
    'lastName',
    'age',
    'gender',
    'phone',
    'email',
    'salary',
    'shiftId'
  ];

  List<String> sort_Department_items = [
    'id',
    'firstName',
    'lastName',
    'age',
    'phone',
    'email',
    'salary',
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
    'departmentId'
  ];

  List<String> sort_Shift_items = [
    'id',
    'firstName',
    'lastName',
    'age',
    'phone',
    'email',
    'salary',
    'departmentId'
  ];

  var male_gender_color = Colors.white;
  var female_gender_color = Colors.white;

  RangeValues salary_values = RangeValues(0, 100000);
  RangeLabels salary_labels = RangeLabels('0', '100000');

  RangeValues age_values = RangeValues(20, 90);
  RangeLabels age_labels = RangeLabels('20', '90');

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
          
          backgroundColor:
            
              const Color.fromRGBO(50, 50, 160, 1),
          leading: BlocBuilder<SearchCubit, SearchState>(
            builder: (context, state) {
              return Builder(builder: (context) {
                return (context.read<SearchCubit>().search == false)
                    ? IconButton(
                        color: Colors.white,
                        onPressed: () {
                          context.read<ShiftsDataCubit>().getShiftsData();
                          context
                              .read<DepartmentsDataCubit>()
                              .getDepartmentsData();
                          context.read<SearchCubit>().close_search();
                          context.read<SearchCubit>().close_sort();
                          selectedUsersItem_department =
                              (Department_Employee_List == true)
                                  ? items_Department[0]
                                  : items_Shift[0];                          
                          search_users_text_department = "";
                          Employer_age_start = 20;
                          Employer_age_end = 90;
                          Employer_salary_start = 0;
                          Employer_salary_end = 100000;
                          _textEditingController.clear();
                          sort_ascending = true;
                          sort = false;
                          female_gender_color = Colors.white;
                          male_gender_color = Colors.white;
                          Navigator.pop(
                            context,
                          );
                        },
                        icon: Icon(Icons.arrow_back),
                      )
                    : IconButton(
                        color: Colors.white,
                        onPressed: () async {
                          // ignore: invalid_use_of_visible_for_testing_member
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
                              selectedUsersItem_department =
                                  (Department_Employee_List == true)
                                      ? items_Department[0]
                                      : items_Shift[0];
                              search_users_text_department = "";
                              _textEditingController.clear();
                              female_gender_color = Colors.white;
                              male_gender_color = Colors.white;
                              search_users_text_department = "";
                              Employer_age_start = 20;
                              Employer_age_end = 90;
                              Employer_salary_start = 0;
                              Employer_salary_end = 100000;
                              sort = true;
                              if (context.read<SearchCubit>().search == false) {
                                sort = false;
                                selectedUsersSortItem =
                                    (Department_Employee_List == true)
                                        ? sort_Department_items[0]
                                        : sort_Shift_items[0];
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
                                      ? sort_Department_items[0]
                                      : sort_Shift_items[0];                              
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
                          ? "${departments[departments.indexWhere((element) => element.id == int.parse(search_users_text))].name} Department"
                          : '${shifts[shifts.indexWhere((element) => element.id == int.parse(search_users_text))].name} Shift',
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
                                        
                                        child: Text(
                                      "${Employer_salary_start} - ${Employer_salary_end}",
                                      style: getTextWhite(context),
                                    )                                        
                                        ),
                                  )
                                : (selectedUsersItem_department == 'age')
                                    ? Expanded(
                                        child: Container(
                                          // width: 400,
                                          // height: 100,
                                          child: Text(
                                            "${Employer_age_start} - ${Employer_age_end}",
                                            style: getTextWhite(context),
                                          ),                                          
                                        ),
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
                                                    const EdgeInsets.all(15),
                                                
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
                              value: selectedUsersItem_department,                            
                              style: getTextWhite(context),                             
                              items: (Department_Employee_List == true)
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
                                sort_ascending = true;
                                search_users_text_department = "";
                                _textEditingController.clear();
                                female_gender_color = Colors.white;
                                male_gender_color = Colors.white;
                                age_values = RangeValues(20, 90);
                                age_labels = RangeLabels('20', '90');
                                salary_values = RangeValues(0, 100000);
                                salary_labels = RangeLabels('0', '100000');
                                Employer_age_start = 20;
                                Employer_age_end = 90;
                                Employer_salary_start = 0;
                                Employer_salary_end = 100000;
                                // ignore: invalid_use_of_visible_for_testing_member
                                context
                                    .read<SearchCubit>()
                                    // ignore: invalid_use_of_visible_for_testing_member
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
                                  // ignore: invalid_use_of_visible_for_testing_member
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
                                  ? sort_Department_items
                                      .map((item) => DropdownMenuItem<String>(
                                          value: item, child: Text(item)))
                                      .toList()
                                  : sort_Shift_items
                                      .map((item) => DropdownMenuItem<String>(
                                          value: item, child: Text(item)))
                                      .toList(),
                              onChanged: (item) {
                                selectedUsersSortItem = item;
                                sort_ascending = true;
                                context
                                    .read<SearchCubit>()
                                    // ignore: invalid_use_of_visible_for_testing_member
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
            selectedUsersItem_department = (Department_Employee_List == true)
                ? items_Department[0]
                : items_Shift[0];
           

            search_users_text_department = "";
            _textEditingController.clear();
            Employer_age_start = 20;
            Employer_age_end = 90;
            Employer_salary_start = 0;
            Employer_salary_end = 100000;
            sort_ascending = true;
            sort = false;
            female_gender_color = Colors.white;
            male_gender_color = Colors.white;
            Navigator.pop(
              context,
            );
            return true;
          },
          child: Stack(children: [
            BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                          child: (selectedUsersItem_department == 'age' &&
                                  context.read<SearchCubit>().sort == false)
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
                                      search_users_text_department = 'age';
                                      age_values = value;
                                      age_labels = RangeLabels(
                                          value.start.toInt().toString(),
                                          value.end.toInt().toString());
                                      context
                                          .read<SearchCubit>()
                                          // ignore: invalid_use_of_visible_for_testing_member
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
                                              // ignore: invalid_use_of_visible_for_testing_member
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
                                          ? MediaQuery.of(context).size.height *
                                              0.9
                                          : MediaQuery.of(context).size.width *
                                              0.9,
                                      height: (landscape)
                                          ? MediaQuery.of(context).size.width *
                                              1 /
                                              10
                                          : MediaQuery.of(context).size.height *
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
                                              builder: (BuildContext context) {
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
                                              width:
                                                  mediaQuery.size.width * 0.01,
                                            ),
                                            Expanded(
                                              child: Text(
                                                
                                                '${users[index].id} ${users[index].firstName} ${users[index].lastName}',                                                
                                                style: getTextBlack(context),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            // Spacer(),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: InkWell(
                                                onTap: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: Container(
                                                            width: mediaQuery
                                                                    .size
                                                                    .width /
                                                                1.8,
                                                            child: Text(
                                                              'Are you sure you want to delete ${users[index].firstName}',
                                                              
                                                            ),
                                                          ),
                                                          content:
                                                              SingleChildScrollView(
                                                            child: BlocBuilder<
                                                                UsersDataCubit,
                                                                UsersDataState>(
                                                              builder: (context,
                                                                  state) {
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
                                                                    height: mediaQuery
                                                                            .size
                                                                            .height /
                                                                        2.5,
                                                                    child:
                                                                        SingleChildScrollView(
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Container(
                                                                            child:
                                                                                Image.network(users[index].image),
                                                                            width: (landscape)
                                                                                ? mediaQuery.size.width / 2
                                                                                : mediaQuery.size.width / 1.8,
                                                                            height: (landscape)
                                                                                ? mediaQuery.size.height / 2
                                                                                : mediaQuery.size.height / 4.5,
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
                                                                            (users[index].departmentId == 'Empty')
                                                                                ? 'department  : ${users[index].departmentId}'
                                                                                : "department  : ${departments[departments.indexWhere((element) => element.id == int.parse(users[index].departmentId!))].name}",
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                5,
                                                                          ),
                                                                          Text(
                                                                            (users[index].shiftId == 'Empty')
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
                                                                ElevatedButton(
                                                                  child: Text(
                                                                      'Delete'),
                                                                  onPressed:
                                                                      () {
                                                                    editing_employee =
                                                                        true;
                                                                    editted_employee_id =
                                                                        users[index]
                                                                            .id;
                                                                    putUsersData =
                                                                        {
                                                                      "id": users[
                                                                              index]
                                                                          .id,
                                                                      "firstName":
                                                                          users[index]
                                                                              .firstName,
                                                                      "lastName":
                                                                          users[index]
                                                                              .lastName,
                                                                      "age": users[
                                                                              index]
                                                                          .age,
                                                                      "gender":
                                                                          users[index]
                                                                              .gender,
                                                                      "email": users[
                                                                              index]
                                                                          .email,
                                                                      "phone": users[
                                                                              index]
                                                                          .phone,
                                                                      "image": users[
                                                                              index]
                                                                          .image,
                                                                      "departmentId": (Department_Employee_List ==
                                                                              true)
                                                                          ? "Empty"
                                                                          : users[index]
                                                                              .departmentId,
                                                                      "shiftId": (Department_Employee_List ==
                                                                              true)
                                                                          ? users[index]
                                                                              .shiftId
                                                                          : "Empty",
                                                                      "salary":
                                                                          users[index]
                                                                              .salary,
                                                                      "salary_type":
                                                                          users[index]
                                                                              .salary_type,
                                                                      "address":
                                                                          users[index]
                                                                              .address,
                                                                      "position":
                                                                          users[index]
                                                                              .position,
                                                                      "hiring_date":
                                                                          users[index]
                                                                              .hiring_date,
                                                                      "rating":
                                                                          users[index]
                                                                              .rating,
                                                                      "companyName":
                                                                          users[index]
                                                                              .companyName,
                                                                      "password":
                                                                          users[index]
                                                                              .password,
                                                                      "current_salary":
                                                                          users[index]
                                                                              .current_salary
                                                                    };                                                                    
                                                                    context
                                                                        .read<
                                                                            UsersDataCubit>()
                                                                        .getUsersData();
                                                                    editing_employee =
                                                                        false;
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop(); // Close the dialog
                                                                  },
                                                                ),
                                                                Spacer(),
                                                                TextButton(
                                                                  child: Text(
                                                                      'OK'),
                                                                  onPressed:
                                                                      () {
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
                                                  decoration: BoxDecoration(
                                                      
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  width: (landscape)
                                                      ? MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.5 /
                                                          10
                                                      : MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.5 /
                                                          10,
                                                  height: (landscape)
                                                      ? MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.5 /
                                                          10
                                                      : MediaQuery.of(context)
                                                              .size
                                                              .height *
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
                    onPressed: () async {
                      age_values = RangeValues(20, 90);
                      age_labels = RangeLabels('20', '90');
                      salary_values = RangeValues(0, 100000);
                      salary_labels = RangeLabels('0', '100000');
                      Employer_age_start = 20;
                      Employer_age_end = 90;
                      Employer_salary_start = 0;
                      Employer_salary_end = 100000;
                      selectedUsersItem_department = "";
                      search_users_text_department = "";
                      context.read<SearchCubit>().close_search();
                      context.read<SearchCubit>().close_sort();
                      sort_ascending = true;
                      sort = false;
                      if (Department_Employee_List == true) {
                        adding_employee_to_department = true;
                        adding_employee_to_shift = false;
                      } else {
                        adding_employee_to_shift = true;
                        adding_employee_to_department = false;
                      }
                      search_users_text_department = "";
                      _textEditingController.clear();
                      context.read<UsersDataCubit>().getUsersData();
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              AddingEmployeeToDepartment(),
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
