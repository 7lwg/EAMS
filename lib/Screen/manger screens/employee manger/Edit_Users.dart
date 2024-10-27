// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/Cubits/Circular_indicator_cubit/circular_indicator_cubit.dart';
import 'package:graduation_project/Cubits/Search/search_cubit.dart';
import 'package:graduation_project/Cubits/Show_field_requirments/field_requirments_cubit.dart';
import 'package:graduation_project/Cubits/Users_data/users_data_cubit.dart';
import 'package:graduation_project/data/Repository/get_departments_repo.dart';
import 'package:graduation_project/data/Repository/get_shifts_repo.dart';
import 'package:graduation_project/data/Repository/get_users_Repo.dart';
import 'package:graduation_project/functions/style.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:responsive_framework/responsive_row_column.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ignore: must_be_immutable
class EditUsers extends StatelessWidget {
  EditUsers({super.key});

  RegExp employer_name_regex =
      RegExp(r'^(?=^.{3,}$)([a-zA-Z0-9_])+( [a-zA-Z0-9_]+)*$');

  RegExp department_id_regex = RegExp(r'^[0-9]+$');

  RegExp shift_id_regex = RegExp(r'^[0-9]+$');

  RegExp Employer_age_regex = RegExp(r'^(2[1-9]|[3-5]\d)$');

  RegExp Employer_email_regex = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail.com$');

  RegExp Employer_phone_regex = RegExp(r'^\+(?:[0-9] ?){6,14}[0-9]$');

  RegExp Employer_salary_regex = RegExp(r'^[1-9]\d*$');

  RegExp Employer_address_regex = RegExp(r'^.{4,}$');

  RegExp Employer_position_regex = RegExp(r'^[A-Za-z]{4,}$');

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  var first_Name_Info = false;
  var last_Name_Info = false;
  var age_Info = false;
  var email_Info = false;
  var phone_Info = false;
  var salary_Info = false;
  var address_Info = false;
  var position_Info = false;
  var department_id_Info = false;
  var shift_id_Info = false;
  var abc;

  String path = '';
  var image;
  bool submitted = false;
  bool form_validate = false;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final landscape = mediaQuery.orientation == Orientation.landscape;

    (users[editted_employee_index].gender == 'Male')
        ? gender_current_option = 0
        : gender_current_option = 1;

    (users[editted_employee_index].salary_type == 'Monthly')
        ? salary_type_current_option = 0
        : (users[editted_employee_index].salary_type == 'Weekly')
            ? salary_type_current_option = 1
            : salary_type_current_option = 2;

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
              selectedDepartmentItem_adding = null;
              selectedShiftItem_adding = null;
              gender_current_option = 0;
              salary_type_current_option = 0;
              Employer_first_Name = "";
              Employer_last_Name = '';
              Employer_age = '';
              Employer_phone = '';
              Employer_email = '';
              Employer_image = '';
              Employer_salary = '';
              Employer_address = '';
              Employer_position = '';

              context.read<UsersDataCubit>().getUsersData();

              Navigator.pop(
                context,
              );
            },
            icon: Icon(Icons.arrow_back),
          );
        }),
        automaticallyImplyLeading: false,
        title: FittedBox(
            child: Text(
          "Edit Employee ${users[editted_employee_index].firstName} ${users[editted_employee_index].lastName}",
          style: (landscape)
              ? getTextWhiteHeader(context)
              : getTextWhiteHeader(context),
        )),
        centerTitle: true,
      ),
      // ignore: deprecated_member_use
      body: WillPopScope(
        onWillPop: () async {
          selectedDepartmentItem_adding = null;
          selectedShiftItem_adding = null;
          gender_current_option = 0;
          salary_type_current_option = 0;
          Employer_first_Name = '';
          Employer_last_Name = '';
          Employer_age = '';
          Employer_phone = '';
          Employer_email = '';
          Employer_image = '';
          Employer_salary = '';
          Employer_address = '';
          Employer_position = '';
          context.read<UsersDataCubit>().getUsersData();
          Navigator.pop(
            context,
          );
          return true;
        },
        child: SingleChildScrollView(
          child: Container(
            child: Form(
              key: _formkey,
              child: BlocBuilder<FieldRequirmentsCubit, FieldRequirmentsState>(
                builder: (context, state) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: mediaQuery.size.height / 50,
                      ),
                      //Employer first Name
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(
                            left: mediaQuery.size.width / 50,
                            right: mediaQuery.size.width / 50),
                        width: mediaQuery.size.width * 0.8,
                        height: (landscape)
                            ? mediaQuery.size.height / 7
                            : mediaQuery.size.height / 10,
                        child: Row(children: [
                          Expanded(
                            child: TextFormField(
                              onChanged: (text) {
                                Employer_first_Name = text;
                              },
                              validator: (value) {
                                if (Employer_first_Name != "") {
                                  if (employer_name_regex.hasMatch(value!) ==
                                      false) {
                                    return 'Invalid Employer First Name';
                                  } else if (users.any((element) =>
                                          element.lastName ==
                                          (Employer_last_Name)) &&
                                      users.any((element) =>
                                          element.firstName ==
                                          (Employer_first_Name)) &&
                                      (users[editted_employee_index]
                                              .firstName !=
                                          Employer_first_Name) &&
                                      (users[editted_employee_index].lastName !=
                                          Employer_last_Name)) {
                                    return 'The employee full name is already found';
                                  } else {
                                    Employer_first_Name = value;
                                    return null;
                                  }
                                }
                                return null;
                              },
                              textAlign: TextAlign.left,
                              decoration: InputDecoration(
                                  errorStyle: TextStyle(
                                      color: Colors.red[400], height: 0.8),
                                  prefixIcon: Image.asset(icons[5],
                                      scale: 3,
                                      color:
                                          Color.fromARGB(255, 145, 142, 142)),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  hintText:
                                      users[editted_employee_index].firstName,
                                  hintStyle: getTextGrey(context)),
                            ),
                          ),
                          InkWell(
                            onTapDown: (_) {
                              context
                                  .read<FieldRequirmentsCubit>()
                                  .FieldRequirments();
                              first_Name_Info = true;
                            },
                            onTapUp: (_) {
                              context
                                  .read<FieldRequirmentsCubit>()
                                  .FieldRequirments();
                              first_Name_Info = false;
                            },
                            onTapCancel: () {
                              context
                                  .read<FieldRequirmentsCubit>()
                                  .FieldRequirments();
                              first_Name_Info = false;
                            },
                            child: IconButton(
                              icon: Icon(Icons.info,
                                  color: Color.fromARGB(255, 145, 142, 142)),
                              onPressed: () {},
                            ),
                          )
                        ]),
                      ),
                      Visibility(
                          visible: first_Name_Info,
                          child: Container(
                            width: mediaQuery.size.width * 0.8,
                            child: Text(
                              'The First Name must contain at least 3 characters\nThe First Name can only consist of alphanumeric characters (both lowercase and uppercase) and underscores.',
                              style: getSmallTextBlack(context),
                            ),
                          )),
                      SizedBox(height: mediaQuery.size.width / 50),
                      //Employer last Name
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(
                            left: mediaQuery.size.width / 50,
                            right: mediaQuery.size.width / 50),
                        width: mediaQuery.size.width * 0.8,
                        height: (landscape)
                            ? mediaQuery.size.height / 7
                            : mediaQuery.size.height / 10,
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                onChanged: (text) {
                                  Employer_last_Name = text;
                                },
                                validator: (value) {
                                  if (Employer_last_Name != "") {
                                    if (employer_name_regex.hasMatch(value!) ==
                                        false) {
                                      return 'Invalid Employer Last Name';
                                    } else if (users.any((element) =>
                                            element.lastName ==
                                            (Employer_last_Name)) &&
                                        users.any((element) =>
                                            element.firstName ==
                                            (Employer_first_Name)) &&
                                        (users[editted_employee_index]
                                                .firstName !=
                                            Employer_first_Name) &&
                                        (users[editted_employee_index]
                                                .lastName !=
                                            Employer_last_Name)) {
                                      return 'The employee full name is already found';
                                    } else {
                                      Employer_last_Name = value;
                                      return null;
                                    }
                                  }
                                  return null;
                                },
                                textAlign: TextAlign.left,
                                decoration: InputDecoration(
                                    errorStyle: TextStyle(
                                        color: Colors.red[400], height: 0.8),
                                    prefixIcon: Image.asset(icons[5],
                                        scale: 3,
                                        color:
                                            Color.fromARGB(255, 145, 142, 142)),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    hintText:
                                        users[editted_employee_index].lastName,
                                    hintStyle: getTextGrey(context)),
                              ),
                            ),
                            InkWell(
                              onTapDown: (_) {
                                context
                                    .read<FieldRequirmentsCubit>()
                                    .FieldRequirments();
                                last_Name_Info = true;
                              },
                              onTapUp: (_) {
                                context
                                    .read<FieldRequirmentsCubit>()
                                    .FieldRequirments();
                                last_Name_Info = false;
                              },
                              onTapCancel: () {
                                context
                                    .read<FieldRequirmentsCubit>()
                                    .FieldRequirments();
                                last_Name_Info = false;
                              },
                              child: IconButton(
                                icon: Icon(Icons.info,
                                    color: Color.fromARGB(255, 145, 142, 142)),
                                onPressed: () {},
                              ),
                            )
                          ],
                        ),
                      ),
                      Visibility(
                          visible: last_Name_Info,
                          child: Container(
                            width: mediaQuery.size.width * 0.8,
                            child: Text(
                              'The Last Name must contain at least 3 characters\nThe Last Name can only consist of alphanumeric characters (both lowercase and uppercase) and underscores.',
                              style: getSmallTextBlack(context),
                            ),
                          )),
                      SizedBox(height: mediaQuery.size.width / 50),
                      //Employer age
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(
                            left: mediaQuery.size.width / 50,
                            right: mediaQuery.size.width / 50),
                        width: mediaQuery.size.width * 0.8,
                        height: (landscape)
                            ? mediaQuery.size.height / 7
                            : mediaQuery.size.height / 10,
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                onChanged: (text) {
                                  Employer_age = text;
                                },
                                validator: (value) {
                                  if (Employer_age != "") {
                                    if (Employer_age_regex.hasMatch(value!) ==
                                        false) {
                                      return 'Invalid Employer Age';
                                    } else {
                                      Employer_age = value;
                                      return null;
                                    }
                                  }
                                  return null;
                                },
                                textAlign: TextAlign.left,
                                decoration: InputDecoration(
                                    errorStyle: TextStyle(
                                        color: Colors.red[400], height: 0.8),
                                    prefixIcon: const Icon(Icons.calendar_month,
                                        color:
                                            Color.fromARGB(255, 145, 142, 142),
                                        size: 30),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    hintText: users[editted_employee_index]
                                        .age
                                        .toString(),
                                    hintStyle: getTextGrey(context)),
                              ),
                            ),
                            InkWell(
                              onTapDown: (_) {
                                context
                                    .read<FieldRequirmentsCubit>()
                                    .FieldRequirments();
                                age_Info = true;
                              },
                              onTapUp: (_) {
                                context
                                    .read<FieldRequirmentsCubit>()
                                    .FieldRequirments();
                                age_Info = false;
                              },
                              onTapCancel: () {
                                context
                                    .read<FieldRequirmentsCubit>()
                                    .FieldRequirments();
                                age_Info = false;
                              },
                              child: IconButton(
                                icon: Icon(Icons.info,
                                    color: Color.fromARGB(255, 145, 142, 142)),
                                onPressed: () {},
                              ),
                            )
                          ],
                        ),
                      ),
                      Visibility(
                          visible: age_Info,
                          child: Container(
                            width: mediaQuery.size.width * 0.8,
                            child: Text(
                              'The age must be between 21 & 60 ',
                              style: getSmallTextBlack(context),
                            ),
                          )),
                      SizedBox(height: mediaQuery.size.width / 50),
                      //Employer email
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(
                            left: mediaQuery.size.width / 50,
                            right: mediaQuery.size.width / 50),
                        width: mediaQuery.size.width * 0.8,
                        height: (landscape)
                            ? mediaQuery.size.height / 7
                            : mediaQuery.size.height / 10,
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                onChanged: (text) {
                                  Employer_email = text;
                                },
                                validator: (value) {
                                  if (Employer_email != "") {
                                    if (Employer_email_regex.hasMatch(value!) ==
                                        false) {
                                      return 'Invalid Email';
                                    } else {
                                      Employer_email = value;
                                      return null;
                                    }
                                  }
                                  return null;
                                },
                                textAlign: TextAlign.left,
                                decoration: InputDecoration(
                                    errorStyle: TextStyle(
                                        color: Colors.red[400], height: 0.8),
                                    prefixIcon: const Icon(Icons.email_outlined,
                                        color:
                                            Color.fromARGB(255, 145, 142, 142),
                                        size: 30),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    hintText:
                                        users[editted_employee_index].email,
                                    hintStyle: getTextGrey(context)),
                              ),
                            ),
                            InkWell(
                              onTapDown: (_) {
                                context
                                    .read<FieldRequirmentsCubit>()
                                    .FieldRequirments();
                                email_Info = true;
                              },
                              onTapUp: (_) {
                                context
                                    .read<FieldRequirmentsCubit>()
                                    .FieldRequirments();
                                email_Info = false;
                              },
                              onTapCancel: () {
                                context
                                    .read<FieldRequirmentsCubit>()
                                    .FieldRequirments();
                                email_Info = false;
                              },
                              child: IconButton(
                                icon: Icon(Icons.info,
                                    color: Color.fromARGB(255, 145, 142, 142)),
                                onPressed: () {},
                              ),
                            )
                          ],
                        ),
                      ),
                      Visibility(
                          visible: email_Info,
                          child: Container(
                            width: mediaQuery.size.width * 0.8,
                            child: Text(
                              'The email address must start with one or more alphanumeric characters, dots, underscores, percent signs, plus signs, or hyphens.\nThe domain part of the email address must be exactly "@gmail.com"',
                              style: getSmallTextBlack(context),
                            ),
                          )),
                      SizedBox(height: mediaQuery.size.width / 50),
                      //Employer phone
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(
                            left: mediaQuery.size.width / 50,
                            right: mediaQuery.size.width / 50),
                        width: mediaQuery.size.width * 0.8,
                        height: (landscape)
                            ? mediaQuery.size.height / 7
                            : mediaQuery.size.height / 10,
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                onChanged: (text) {
                                  Employer_phone = text;
                                },
                                validator: (value) {
                                  if (Employer_phone != "") {
                                    if (Employer_phone_regex.hasMatch(value!) ==
                                        false) {
                                      return 'Invalid Phone';
                                    } else {
                                      Employer_phone = value;
                                      return null;
                                    }
                                  }
                                  return null;
                                },
                                textAlign: TextAlign.left,
                                decoration: InputDecoration(
                                    errorStyle: TextStyle(
                                        color: Colors.red[400], height: 0.8),
                                    prefixIcon: Image.asset(icons[7],
                                        scale: 3,
                                        color:
                                            Color.fromARGB(255, 145, 142, 142)),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    hintText:
                                        users[editted_employee_index].phone,
                                    hintStyle: getTextGrey(context)),
                              ),
                            ),
                            InkWell(
                              onTapDown: (_) {
                                context
                                    .read<FieldRequirmentsCubit>()
                                    .FieldRequirments();
                                phone_Info = true;
                              },
                              onTapUp: (_) {
                                context
                                    .read<FieldRequirmentsCubit>()
                                    .FieldRequirments();
                                phone_Info = false;
                              },
                              onTapCancel: () {
                                context
                                    .read<FieldRequirmentsCubit>()
                                    .FieldRequirments();
                                phone_Info = false;
                              },
                              child: IconButton(
                                icon: Icon(Icons.info,
                                    color: Color.fromARGB(255, 145, 142, 142)),
                                onPressed: () {},
                              ),
                            )
                          ],
                        ),
                      ),
                      Visibility(
                          visible: phone_Info,
                          child: Container(
                            width: mediaQuery.size.width * 0.8,
                            child: Text(
                              'The phone must start with a plus sign followed by digits\nThe digits must be between 7 & 15 digit',
                              style: getSmallTextBlack(context),
                            ),
                          )),
                      //Employer Salary
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(
                            left: mediaQuery.size.width / 50,
                            right: mediaQuery.size.width / 50),
                        width: mediaQuery.size.width * 0.8,
                        height: (landscape)
                            ? mediaQuery.size.height / 7
                            : mediaQuery.size.height / 10,
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                onChanged: (text) {
                                  Employer_salary = text;
                                },
                                validator: (value) {
                                  if (Employer_salary != "") {
                                    if (Employer_salary_regex.hasMatch(
                                            value!) ==
                                        false) {
                                      return 'Invalid Salary';
                                    } else {
                                      Employer_salary = value;
                                      return null;
                                    }
                                  }
                                  return null;
                                },
                                textAlign: TextAlign.left,
                                decoration: InputDecoration(
                                    errorStyle: TextStyle(
                                        color: Colors.red[400], height: 0.8),
                                    prefixIcon: Image.asset(icons[8],
                                        scale: 3,
                                        color:
                                            Color.fromARGB(255, 145, 142, 142)),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    hintText: users[editted_employee_index]
                                        .salary
                                        .toString(),
                                    hintStyle: getTextGrey(context)),
                              ),
                            ),
                            InkWell(
                              onTapDown: (_) {
                                context
                                    .read<FieldRequirmentsCubit>()
                                    .FieldRequirments();
                                salary_Info = true;
                              },
                              onTapUp: (_) {
                                context
                                    .read<FieldRequirmentsCubit>()
                                    .FieldRequirments();
                                salary_Info = false;
                              },
                              onTapCancel: () {
                                context
                                    .read<FieldRequirmentsCubit>()
                                    .FieldRequirments();
                                salary_Info = false;
                              },
                              child: IconButton(
                                icon: Icon(Icons.info,
                                    color: Color.fromARGB(255, 145, 142, 142)),
                                onPressed: () {},
                              ),
                            )
                          ],
                        ),
                      ),
                      Visibility(
                          visible: salary_Info,
                          child: Container(
                            width: mediaQuery.size.width * 0.8,
                            child: Text(
                              'The salary must contain only digits\nStarting with non-zero digit\nMust be decimal',
                              style: getSmallTextBlack(context),
                            ),
                          )),

                      SizedBox(height: mediaQuery.size.width / 50),
                      //Employer Address
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(
                            left: mediaQuery.size.width / 50,
                            right: mediaQuery.size.width / 50),
                        width: mediaQuery.size.width * 0.8,
                        height: (landscape)
                            ? mediaQuery.size.height / 7
                            : mediaQuery.size.height / 10,
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                onChanged: (text) {
                                  Employer_address = text;
                                },
                                validator: (value) {
                                  if (Employer_address != "") {
                                    if (Employer_address_regex.hasMatch(
                                            value!) ==
                                        false) {
                                      return 'Invalid Address';
                                    } else {
                                      Employer_address = value;
                                      return null;
                                    }
                                  }
                                  return null;
                                },
                                textAlign: TextAlign.left,
                                decoration: InputDecoration(
                                    errorStyle: TextStyle(
                                        color: Colors.red[400], height: 0.8),
                                    prefixIcon: Image.asset(icons[9],
                                        scale: 3,
                                        color:
                                            Color.fromARGB(255, 145, 142, 142)),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    hintText: users[editted_employee_index]
                                        .address
                                        .toString(),
                                    hintStyle: getTextGrey(context)),
                              ),
                            ),
                            InkWell(
                              onTapDown: (_) {
                                context
                                    .read<FieldRequirmentsCubit>()
                                    .FieldRequirments();
                                address_Info = true;
                              },
                              onTapUp: (_) {
                                context
                                    .read<FieldRequirmentsCubit>()
                                    .FieldRequirments();
                                address_Info = false;
                              },
                              onTapCancel: () {
                                context
                                    .read<FieldRequirmentsCubit>()
                                    .FieldRequirments();
                                address_Info = false;
                              },
                              child: IconButton(
                                icon: Icon(Icons.info,
                                    color: Color.fromARGB(255, 145, 142, 142)),
                                onPressed: () {},
                              ),
                            )
                          ],
                        ),
                      ),
                      Visibility(
                          visible: address_Info,
                          child: Container(
                            width: mediaQuery.size.width * 0.8,
                            child: Text(
                              'The address must contain at least 4 characters',
                              style: getSmallTextBlack(context),
                            ),
                          )),

                      SizedBox(height: mediaQuery.size.width / 50),
                      //Employer position
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(
                            left: mediaQuery.size.width / 50,
                            right: mediaQuery.size.width / 50),
                        width: mediaQuery.size.width * 0.8,
                        height: (landscape)
                            ? mediaQuery.size.height / 7
                            : mediaQuery.size.height / 10,
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                onChanged: (text) {
                                  Employer_position = text;
                                },
                                validator: (value) {
                                  if (Employer_position != "") {
                                    if (Employer_position_regex.hasMatch(
                                            value!) ==
                                        false) {
                                      return 'Invalid Position';
                                    } else {
                                      Employer_position = value;
                                      return null;
                                    }
                                  }
                                  return null;
                                },
                                textAlign: TextAlign.left,
                                decoration: InputDecoration(
                                    errorStyle: TextStyle(
                                        color: Colors.red[400], height: 0.8),
                                    prefixIcon: Image.asset(icons[10],
                                        scale: 3,
                                        color:
                                            Color.fromARGB(255, 145, 142, 142)),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    hintText: users[editted_employee_index]
                                        .position
                                        .toString(),
                                    hintStyle: getTextGrey(context)),
                              ),
                            ),
                            InkWell(
                              onTapDown: (_) {
                                context
                                    .read<FieldRequirmentsCubit>()
                                    .FieldRequirments();
                                position_Info = true;
                              },
                              onTapUp: (_) {
                                context
                                    .read<FieldRequirmentsCubit>()
                                    .FieldRequirments();
                                position_Info = false;
                              },
                              onTapCancel: () {
                                context
                                    .read<FieldRequirmentsCubit>()
                                    .FieldRequirments();
                                position_Info = false;
                              },
                              child: IconButton(
                                icon: Icon(Icons.info,
                                    color: Color.fromARGB(255, 145, 142, 142)),
                                onPressed: () {},
                              ),
                            )
                          ],
                        ),
                      ),
                      Visibility(
                          visible: position_Info,
                          child: Container(
                            width: mediaQuery.size.width * 0.8,
                            child: Text(
                              'The position must contain only letters\nAt least 4 letters',
                              style: getSmallTextBlack(context),
                            ),
                          )),

                      SizedBox(height: mediaQuery.size.width / 50),
                      //Employer department id
                      BlocBuilder<SearchCubit, SearchState>(
                        builder: (context, state) {
                          return DropdownButton<String>(
                            iconEnabledColor: Colors.black,
                            iconDisabledColor: Colors.black,
                            style: getTextBlack(context),
                            hint: Text(
                              'Select a Department',
                              // Company Name
                              style: TextStyle(color: Colors.black),
                            ),
                            value: (selectedDepartmentItem_adding == "Empty" ||
                                    selectedDepartmentItem_adding!.isEmpty)
                                ? null
                                : department_items[department_id_items.indexOf(
                                    int.parse(selectedDepartmentItem_adding!))],
                            items: department_items
                                .map((item) => DropdownMenuItem<String>(
                                    value: item, child: Text(item)))
                                .toList(),
                            onChanged: (item) {
                              selectedDepartmentItem_adding =
                                  department_id_items[
                                          (department_items.indexOf(item!))]
                                      .toString();

                              context.read<SearchCubit>().emit(SearchInitial());
                            },
                          );
                        },
                      ),

                      //Employer shift id
                      BlocBuilder<SearchCubit, SearchState>(
                        builder: (context, state) {
                          return DropdownButton<String>(
                            iconEnabledColor: Colors.black,
                            iconDisabledColor: Colors.black,
                            style: getTextBlack(context),
                            hint: Text(
                              "Select a Shift",
                              style: TextStyle(color: Colors.black),
                            ),
                            value: (selectedShiftItem_adding == "Empty" ||
                                    selectedShiftItem_adding!.isEmpty)
                                ? null
                                : shift_items[shift_id_items.indexOf(
                                    int.parse(selectedShiftItem_adding!))],
                            items: shift_items
                                .map((item) => DropdownMenuItem<String>(
                                    value: item, child: Text(item)))
                                .toList(),
                            onChanged: (item) {
                              selectedShiftItem_adding =
                                  shift_id_items[(shift_items.indexOf(item!))]
                                      .toString();

                              context.read<SearchCubit>().emit(SearchInitial());
                            },
                          );
                        },
                      ),

                      // upload photo
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(
                            left: mediaQuery.size.width / 50,
                            right: mediaQuery.size.width / 50),
                        width: mediaQuery.size.width * 0.55,
                        height: (landscape)
                            ? mediaQuery.size.height / 7
                            : mediaQuery.size.height / 10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Upload Photo',
                              style: getTextBlack(context),
                            ),
                            BlocBuilder<UsersDataCubit, UsersDataState>(
                              builder: (context, state) {
                                return IconButton(
                                  onPressed: () async {
                                    var pic = await ImagePicker()
                                        .pickImage(source: ImageSource.gallery);
                                    image = File(pic!.path);

                                    context
                                        .read<UsersDataCubit>()
                                        .uploadedImage();
                                  },
                                  icon: Image.asset(icons[11],
                                      scale: 1.7,
                                      color:
                                          Color.fromARGB(255, 145, 142, 142)),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      BlocBuilder<UsersDataCubit, UsersDataState>(
                        builder: (context, state) {
                          return (mediaQuery.size.width > 328)
                              ? Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    width: mediaQuery.size.width * 0.97,
                                    margin: EdgeInsets.only(
                                        left: mediaQuery.size.width / 30,
                                        right: mediaQuery.size.width / 30),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Salary Type :"),
                                        Container(
                                          child: Row(children: [
                                            Radio(
                                                value: 0,
                                                groupValue:
                                                    salary_type_current_option,
                                                onChanged: (value) {
                                                  salary_type_current_option =
                                                      0;
                                                  context
                                                      .read<UsersDataCubit>()
                                                      .SalaryType();
                                                }),
                                            InkWell(
                                              child: Text("Monthly"),
                                              onTap: () {
                                                salary_type_current_option = 0;
                                                context
                                                    .read<UsersDataCubit>()
                                                    .SalaryType();
                                              },
                                            ),
                                          ]),
                                        ),
                                        Container(
                                          child: Row(children: [
                                            Radio(
                                                value: 1,
                                                groupValue:
                                                    salary_type_current_option,
                                                onChanged: (value) {
                                                  salary_type_current_option =
                                                      1;
                                                  context
                                                      .read<UsersDataCubit>()
                                                      .SalaryType();
                                                }),
                                            InkWell(
                                              child: Text("Weekly"),
                                              onTap: () {
                                                salary_type_current_option = 1;
                                                context
                                                    .read<UsersDataCubit>()
                                                    .SalaryType();
                                              },
                                            ),
                                          ]),
                                        ),
                                        Container(
                                          child: Row(children: [
                                            Radio(
                                                value: 2,
                                                groupValue:
                                                    salary_type_current_option,
                                                onChanged: (value) {
                                                  salary_type_current_option =
                                                      2;
                                                  context
                                                      .read<UsersDataCubit>()
                                                      .SalaryType();
                                                }),
                                            InkWell(
                                              child: Text("Daily"),
                                              onTap: () {
                                                salary_type_current_option = 2;
                                                context
                                                    .read<UsersDataCubit>()
                                                    .SalaryType();
                                              },
                                            ),
                                          ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(
                                  margin: EdgeInsets.only(
                                      left: mediaQuery.size.width / 30),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text("Salary Type :"),
                                      Container(
                                        child: Row(children: [
                                          Radio(
                                              value: 0,
                                              groupValue:
                                                  salary_type_current_option,
                                              onChanged: (value) {
                                                salary_type_current_option = 0;
                                                context
                                                    .read<UsersDataCubit>()
                                                    .SalaryType();
                                              }),
                                          InkWell(
                                            child: Text("Monthly"),
                                            onTap: () {
                                              salary_type_current_option = 0;
                                              context
                                                  .read<UsersDataCubit>()
                                                  .SalaryType();
                                            },
                                          ),
                                        ]),
                                      ),
                                      Container(
                                        child: Row(children: [
                                          Radio(
                                              value: 1,
                                              groupValue:
                                                  salary_type_current_option,
                                              onChanged: (value) {
                                                salary_type_current_option = 1;
                                                context
                                                    .read<UsersDataCubit>()
                                                    .SalaryType();
                                              }),
                                          InkWell(
                                            child: Text("Weekly"),
                                            onTap: () {
                                              salary_type_current_option = 1;
                                              context
                                                  .read<UsersDataCubit>()
                                                  .SalaryType();
                                            },
                                          ),
                                        ]),
                                      ),
                                      Container(
                                        child: Row(children: [
                                          Radio(
                                              value: 2,
                                              groupValue:
                                                  salary_type_current_option,
                                              onChanged: (value) {
                                                salary_type_current_option = 2;
                                                context
                                                    .read<UsersDataCubit>()
                                                    .SalaryType();
                                              }),
                                          InkWell(
                                            child: Text("Daily"),
                                            onTap: () {
                                              salary_type_current_option = 2;
                                              context
                                                  .read<UsersDataCubit>()
                                                  .SalaryType();
                                            },
                                          ),
                                        ]),
                                      ),
                                    ],
                                  ),
                                );
                        },
                      ),
                      SizedBox(height: mediaQuery.size.width / 50),
                      // Employer Gender
                      BlocBuilder<UsersDataCubit, UsersDataState>(
                        builder: (context, state) {
                          return (mediaQuery.size.width > 287)
                              ? Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    width: mediaQuery.size.width * 0.7,
                                    margin: EdgeInsets.only(
                                        left: mediaQuery.size.width / 30),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Gender :'),
                                        Container(
                                          child: Row(children: [
                                            Radio(
                                              value: 0,
                                              groupValue: gender_current_option,
                                              onChanged: (value) {
                                                gender_current_option = 0;
                                                context
                                                    .read<UsersDataCubit>()
                                                    .Gender();
                                              },
                                            ),
                                            InkWell(
                                              child: Text('Male'),
                                              onTap: () {
                                                gender_current_option = 0;
                                                context
                                                    .read<UsersDataCubit>()
                                                    .Gender();
                                              },
                                            )
                                          ]),
                                        ),
                                        Container(
                                          child: Row(
                                            children: [
                                              Container(
                                                child: Row(children: [
                                                  Radio(
                                                    value: 1,
                                                    groupValue:
                                                        gender_current_option,
                                                    onChanged: (value) {
                                                      gender_current_option = 1;
                                                      context
                                                          .read<
                                                              UsersDataCubit>()
                                                          .Gender();
                                                    },
                                                  ),
                                                  InkWell(
                                                    child: Text('Female'),
                                                    onTap: () {
                                                      gender_current_option = 1;
                                                      context
                                                          .read<
                                                              UsersDataCubit>()
                                                          .Gender();
                                                    },
                                                  )
                                                ]),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : Container(
                                  margin: EdgeInsets.only(
                                      left: mediaQuery.size.width / 30),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text('Gender :'),
                                      Container(
                                        child: Row(children: [
                                          Radio(
                                            value: 0,
                                            groupValue: gender_current_option,
                                            onChanged: (value) {
                                              gender_current_option = 0;
                                              context
                                                  .read<UsersDataCubit>()
                                                  .Gender();
                                            },
                                          ),
                                          InkWell(
                                            child: Text('Male'),
                                            onTap: () {
                                              gender_current_option = 0;
                                              context
                                                  .read<UsersDataCubit>()
                                                  .Gender();
                                            },
                                          )
                                        ]),
                                      ),
                                      Container(
                                        child: Row(
                                          children: [
                                            Container(
                                              child: Row(children: [
                                                Radio(
                                                  value: 1,
                                                  groupValue:
                                                      gender_current_option,
                                                  onChanged: (value) {
                                                    gender_current_option = 1;
                                                    context
                                                        .read<UsersDataCubit>()
                                                        .Gender();
                                                  },
                                                ),
                                                InkWell(
                                                  child: Text('Female'),
                                                  onTap: () {
                                                    gender_current_option = 1;
                                                    context
                                                        .read<UsersDataCubit>()
                                                        .Gender();
                                                  },
                                                )
                                              ]),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                );
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      BlocBuilder<CircularIndicatorCubit,
                          CircularIndicatorState>(
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
                                    if (_formkey.currentState!.validate()) {
                                      form_validate = true;
                                      if (image != null) {
                                        // start deleting the old image from the server
                                        Supabase.initialize(
                                          url:
                                              'https://oarqjspwajbojrddcvky.supabase.co',
                                          anonKey:
                                              'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9hcnFqc3B3YWpib2pyZGRjdmt5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTE3Mzk2NTQsImV4cCI6MjAyNzMxNTY1NH0.NJ-QaQKrveyPpE2G9-8kizBh6ByFShdQ47xs2Bx8wmQ',
                                        );
                                        await Supabase.instance.client.storage
                                            .from(
                                                'image') // Replace with your bucket name
                                            .remove([
                                          users[editted_employee_index]
                                              .id
                                              .toString()
                                        ]);
                                        // end deleting the old image from the server
                                        // start uploading image to server
                                        Supabase.initialize(
                                          url:
                                              'https://oarqjspwajbojrddcvky.supabase.co',
                                          anonKey:
                                              'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9hcnFqc3B3YWpib2pyZGRjdmt5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTE3Mzk2NTQsImV4cCI6MjAyNzMxNTY1NH0.NJ-QaQKrveyPpE2G9-8kizBh6ByFShdQ47xs2Bx8wmQ',
                                        );
                                        SupabaseClient supabase =
                                            Supabase.instance.client;
                                        path = basename(image.path);
                                        await supabase.storage
                                            .from('image')
                                            .upload(
                                                users[editted_employee_index]
                                                    .id
                                                    .toString(),
                                                image)
                                            .then((value) {});
                                        // end uploading image to server
                                      }

                                      editing_employee = true;
                                      putUsersData = {
                                        "id": users[editted_employee_index].id,
                                        "firstName": (Employer_first_Name == "")
                                            ? users[editted_employee_index]
                                                .firstName
                                            : Employer_first_Name,
                                        "lastName": (Employer_last_Name == "")
                                            ? users[editted_employee_index]
                                                .lastName
                                            : Employer_last_Name,
                                        "age": (Employer_age == "")
                                            ? users[editted_employee_index].age
                                            : int.parse(Employer_age),
                                        "gender": (gender_current_option == 0)
                                            ? "Male"
                                            : "Female",
                                        "salary_type":
                                            (salary_type_current_option == 0)
                                                ? "Monthly"
                                                : (salary_type_current_option ==
                                                        1)
                                                    ? "Weekly"
                                                    : "Daily",
                                        "email": (Employer_email == "")
                                            ? users[editted_employee_index]
                                                .email
                                            : Employer_email,
                                        "phone": (Employer_phone == "")
                                            ? users[editted_employee_index]
                                                .phone
                                            : Employer_phone,
                                        "salary": (Employer_salary == "")
                                            ? users[editted_employee_index]
                                                .salary
                                            : Employer_salary,
                                        "address": (Employer_address == "")
                                            ? users[editted_employee_index]
                                                .address
                                            : Employer_address,
                                        "position": (Employer_position == "")
                                            ? users[editted_employee_index]
                                                .position
                                            : Employer_position,
                                        "hiring_date":
                                            users[editted_employee_index]
                                                .hiring_date,
                                        'rating': users[editted_employee_index]
                                            .rating,
                                        "image":
                                            users[editted_employee_index].image,
                                        "departmentId":
                                            (selectedDepartmentItem_adding !=
                                                    null)
                                                ? selectedDepartmentItem_adding
                                                : "Empty",
                                        "shiftId":
                                            (selectedShiftItem_adding != null)
                                                ? selectedShiftItem_adding
                                                : "Empty",
                                        "password":
                                            users[editted_employee_index]
                                                .password,
                                        "companyName":
                                            users[editted_employee_index]
                                                .companyName,
                                        "current_salary":
                                            users[editted_employee_index]
                                                .current_salary
                                      };
                                      context
                                          .read<UsersDataCubit>()
                                          .getUsersData();
                                      adding_employee = false;
                                      Navigator.pop(
                                        context,
                                      );
                                      Employer_first_Name = "";
                                      Employer_last_Name = "";
                                      Employer_email = "";
                                      Employer_age = "";
                                      Employer_phone = "";
                                      Employer_address = "";
                                      Employer_position = "";
                                      shiftId = "";
                                      gender_current_option = 0;
                                      salary_type_current_option = 0;
                                      selectedDepartmentItem_adding = null;
                                      selectedShiftItem_adding = null;
                                    }
                                  },
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
                                      textStyle: const TextStyle(
                                        fontSize: 18,
                                      )),
                                  child: Text(
                                    "Submit",
                                    style: getTextWhite(context),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
