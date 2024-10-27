// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, prefer_typing_uninitialized_variables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/Cubits/Circular_indicator_cubit/circular_indicator_cubit.dart';
import 'package:graduation_project/Cubits/Companies%20name/companies_name_cubit.dart';
import 'package:graduation_project/Cubits/Show%20password/show_password_cubit.dart';
import 'package:graduation_project/Cubits/Show_field_requirments/field_requirments_cubit.dart';
import 'package:graduation_project/Screen/manger%20screens/Home_Screen_manger.dart';
import 'package:graduation_project/Screen/Login_Screen.dart';
import 'package:graduation_project/Screen/Splash_Screen.dart';
import 'package:graduation_project/data/Repository/get_companies_name_repo.dart';
import 'package:graduation_project/functions/location.dart';
import 'package:graduation_project/functions/style.dart';
import 'package:responsive_framework/responsive_row_column.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewCompany extends StatelessWidget {
  NewCompany({super.key});

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  RegExp company_name_regex =
      RegExp(r'^(?=^.{3,}$)([a-zA-Z0-9_])+( [a-zA-Z0-9_]+)*$');

  RegExp employer_name_regex =
      RegExp(r'^(?=^.{9,}$)([a-zA-Z_0-9])+( [a-zA-Z_0-9]+)*$');

  RegExp Company_diameter_regex = RegExp(r'^\d+$');

  RegExp password_regex =
      RegExp(r"^(?=.*\d|(?=.*[^\s\w]))(?=.*[a-z])(?=.*[A-Z])(.{9,})$");

  var company_Name_Info = false;
  var manger_Name_Info = false;
  var Company_diameter_Info = false;
  var password_Info = false;

  var password;

  bool true_location = false;

  bool press_location = false;

  String location_status = "";

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
            automaticallyImplyLeading: false,
            title: FittedBox(
                child: Text(
              'Create Company',
              style: (landscape)
                  ? getTextWhiteHeader(context)
                  : getTextWhiteHeader(context),
            )),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Container(
              width: mediaQuery.size.width,
              height: (landscape)
                  ? (MediaQuery.of(context).size.height -
                      mediaQuery.size.height * (10 / 800) -
                      statusBar)
                  : (MediaQuery.of(context).size.height -
                      mediaQuery.size.height * (70 / 800) -
                      statusBar),
              child: Form(
                key: _formkey,
                child:
                    BlocBuilder<FieldRequirmentsCubit, FieldRequirmentsState>(
                  builder: (context, state) {
                    return Center(
                      child: SingleChildScrollView(
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //Company Name
                              Row(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(
                                      left: mediaQuery.size.width / 20,
                                    ),
                                    width: mediaQuery.size.width * 0.8,
                                    height: (landscape)
                                        ? mediaQuery.size.height / 7
                                        : mediaQuery.size.height / 10,
                                    child: TextFormField(
                                      onChanged: (text) {
                                        Company_Name = text;
                                      },
                                      validator: (value) {
                                        if (company_name_regex
                                                .hasMatch(value!) ==
                                            false) {
                                          return 'Invalid Company Name';
                                        } else {
                                          for (int i = 0;
                                              i < companies_name.length;
                                              i++) {
                                            if (companies_name[i].name ==
                                                Company_Name) {
                                              return "There is already signed comapny with this name";
                                            }
                                          }
                                          Company_Name = value;
                                          return null;
                                        }
                                      },
                                      textAlign: TextAlign.left,
                                      decoration: InputDecoration(
                                          errorStyle: TextStyle(
                                              color: Colors.red[400],
                                              height: 0.2),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 0.0),
                                          prefixIcon: Image.asset(icons[4],
                                              scale: 3,
                                              color: Color.fromARGB(
                                                  255, 145, 142, 142)),
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          hintText: 'Company Name',
                                          hintStyle: getTextGrey(context)),
                                    ),
                                  ),
                                  InkWell(
                                    onTapDown: (_) {
                                      context
                                          .read<FieldRequirmentsCubit>()
                                          .FieldRequirments();
                                      company_Name_Info = true;
                                    },
                                    onTapUp: (_) {
                                      context
                                          .read<FieldRequirmentsCubit>()
                                          .FieldRequirments();
                                      company_Name_Info = false;
                                    },
                                    onTapCancel: () {
                                      context
                                          .read<FieldRequirmentsCubit>()
                                          .FieldRequirments();
                                      company_Name_Info = false;
                                    },
                                    child: IconButton(
                                      icon: Icon(Icons.info,
                                          color: Color.fromARGB(
                                              255, 145, 142, 142)),
                                      onPressed: () {},
                                    ),
                                  )
                                ],
                              ),
                              Visibility(
                                  visible: company_Name_Info,
                                  child: Container(
                                    width: mediaQuery.size.width * 0.8,
                                    child: Text(
                                      'The First Name must contain at least 3 characters\nThe First Name can only consist of alphanumeric characters (both lowercase and uppercase) and underscores.',
                                      style: getSmallTextBlack(context),
                                    ),
                                  )),
                              SizedBox(
                                height: mediaQuery.size.width / 50,
                              ),
                              //manger name
                              Row(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(
                                      left: mediaQuery.size.width / 20,
                                    ),
                                    width: mediaQuery.size.width * 0.8,
                                    height: (landscape)
                                        ? mediaQuery.size.height / 7
                                        : mediaQuery.size.height / 10,
                                    child: TextFormField(
                                      onChanged: (text) {
                                        Manger_Name = text;
                                      },
                                      validator: (value) {
                                        if (employer_name_regex
                                                .hasMatch(value!) ==
                                            false) {
                                          return 'Invalid User Name';
                                        } else {
                                          Manger_Name = value;
                                          return null;
                                        }
                                      },
                                      textAlign: TextAlign.left,
                                      decoration: InputDecoration(
                                          errorStyle: TextStyle(
                                              color: Colors.red[400],
                                              height: 0.2),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 0.0),
                                          prefixIcon: Image.asset(icons[5],
                                              scale: 3,
                                              color: Color.fromARGB(
                                                  255, 145, 142, 142)),
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          hintText: 'Employer Name',
                                          hintStyle: getTextGrey(context)),
                                    ),
                                  ),
                                  InkWell(
                                    onTapDown: (_) {
                                      context
                                          .read<FieldRequirmentsCubit>()
                                          .FieldRequirments();
                                      manger_Name_Info = true;
                                    },
                                    onTapUp: (_) {
                                      context
                                          .read<FieldRequirmentsCubit>()
                                          .FieldRequirments();
                                      manger_Name_Info = false;
                                    },
                                    onTapCancel: () {
                                      context
                                          .read<FieldRequirmentsCubit>()
                                          .FieldRequirments();
                                      manger_Name_Info = false;
                                    },
                                    child: IconButton(
                                      icon: Icon(Icons.info,
                                          color: Color.fromARGB(
                                              255, 145, 142, 142)),
                                      onPressed: () {},
                                    ),
                                  )
                                ],
                              ),
                              Visibility(
                                  visible: manger_Name_Info,
                                  child: Container(
                                    width: mediaQuery.size.width * 0.8,
                                    child: Text(
                                      'The Name must contain at least 9 characters\nThe Name can only consist of alphanumeric characters (both lowercase and uppercase) and underscores.',
                                      style: getSmallTextBlack(context),
                                    ),
                                  )),
                              SizedBox(
                                height: mediaQuery.size.width / 50,
                              ),
                              //Password
                              Row(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(
                                      left: mediaQuery.size.width / 20,
                                    ),
                                    width: mediaQuery.size.width * 0.8,
                                    height: (landscape)
                                        ? mediaQuery.size.height / 7
                                        : mediaQuery.size.height / 10,
                                    child: BlocBuilder<ShowPasswordCubit,
                                        ShowPasswordState>(
                                      builder: (context, state) {
                                        return TextFormField(
                                            obscureText: context
                                                .read<ShowPasswordCubit>()
                                                .Show_password,
                                            obscuringCharacter: "*",
                                            onChanged: (text) {
                                              password = text;
                                            },
                                            validator: (value) {
                                              if (password_regex
                                                      .hasMatch(value!) ==
                                                  false) {
                                                return ('invalid Password');
                                              }
                                              return null;
                                            },
                                            textAlign: TextAlign.left,
                                            decoration: InputDecoration(
                                                errorStyle: TextStyle(
                                                    color: Colors.red[400],
                                                    height: 0.2),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 0.0),
                                                prefixIcon: const Icon(
                                                    Icons.password,
                                                    color: Color.fromARGB(
                                                        255, 145, 142, 142),
                                                    size: 30),
                                                suffixIcon: TextButton(
                                                    onPressed: () {
                                                      context
                                                          .read<
                                                              ShowPasswordCubit>()
                                                          .password();
                                                    },
                                                    child: (context.read<ShowPasswordCubit>().Show_password ==
                                                            true)
                                                        ? const Icon(
                                                            Icons.visibility,
                                                            color: Color.fromARGB(
                                                                255, 145, 142, 142),
                                                            size: 30)
                                                        : const Icon(Icons.visibility_off,
                                                            color: Color.fromARGB(
                                                                255, 145, 142, 142),
                                                            size: 30)),
                                                filled: true,
                                                fillColor: Colors.white,
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                hintText: 'Password',
                                                hintStyle: getTextGrey(context)));
                                      },
                                    ),
                                  ),
                                  InkWell(
                                    onTapDown: (_) {
                                      context
                                          .read<FieldRequirmentsCubit>()
                                          .FieldRequirments();
                                      password_Info = true;
                                    },
                                    onTapUp: (_) {
                                      context
                                          .read<FieldRequirmentsCubit>()
                                          .FieldRequirments();
                                      password_Info = false;
                                    },
                                    onTapCancel: () {
                                      context
                                          .read<FieldRequirmentsCubit>()
                                          .FieldRequirments();
                                      password_Info = false;
                                    },
                                    child: IconButton(
                                      icon: Icon(Icons.info,
                                          color: Color.fromARGB(
                                              255, 145, 142, 142)),
                                      onPressed: () {},
                                    ),
                                  )
                                ],
                              ),
                              Visibility(
                                  visible: password_Info,
                                  child: Container(
                                    width: mediaQuery.size.width * 0.8,
                                    child: Text(
                                      'The password must contain at least 9 characters.\nIt must include at least one digit or special character\nAt least one uppercase letter is required\nAt least one lowercase letter is required',
                                      style: getSmallTextBlack(context),
                                    ),
                                  )),

                              SizedBox(
                                  height: (landscape)
                                      ? mediaQuery.size.height / 20
                                      : mediaQuery.size.height / 80),
                              //company field for attendance
                              Row(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(
                                      left: mediaQuery.size.width / 20,
                                    ),
                                    width: mediaQuery.size.width * 0.8,
                                    height: (landscape)
                                        ? mediaQuery.size.height / 7
                                        : mediaQuery.size.height / 10,
                                    child: TextFormField(
                                      onChanged: (text) {
                                        Company_diameter = int.parse(text);
                                      },
                                      validator: (value) {
                                        if (Company_diameter_regex.hasMatch(
                                                value!) ==
                                            false) {
                                          return 'Invalid Company Diameter';
                                        } else {
                                          Company_diameter = int.parse(value);
                                          return null;
                                        }
                                      },
                                      textAlign: TextAlign.left,
                                      decoration: InputDecoration(
                                          errorStyle: TextStyle(
                                              color: Colors.red[400],
                                              height: 0.2),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 0.0),
                                          prefixIcon: const Icon(
                                              Icons.social_distance,
                                              color: Color.fromARGB(
                                                  255, 145, 142, 142),
                                              size: 30),
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          hintText: 'Company Diameter (meter)',
                                          hintStyle: getTextGrey(context)),
                                    ),
                                  ),
                                  InkWell(
                                    onTapDown: (_) {
                                      context
                                          .read<FieldRequirmentsCubit>()
                                          .FieldRequirments();
                                      Company_diameter_Info = true;
                                    },
                                    onTapUp: (_) {
                                      context
                                          .read<FieldRequirmentsCubit>()
                                          .FieldRequirments();
                                      Company_diameter_Info = false;
                                    },
                                    onTapCancel: () {
                                      context
                                          .read<FieldRequirmentsCubit>()
                                          .FieldRequirments();
                                      Company_diameter_Info = false;
                                    },
                                    child: IconButton(
                                      icon: Icon(Icons.info,
                                          color: Color.fromARGB(
                                              255, 145, 142, 142)),
                                      onPressed: () {},
                                    ),
                                  )
                                ],
                              ),
                              Visibility(
                                  visible: Company_diameter_Info,
                                  child: Container(
                                    width: mediaQuery.size.width * 0.8,
                                    child: Text(
                                      'The Company Diameter must be an intger',
                                      style: getSmallTextBlack(context),
                                    ),
                                  )),
                              SizedBox(
                                height: mediaQuery.size.width / 50,
                              ),
                              // landscape
                              BlocBuilder<CircularIndicatorCubit,
                                  CircularIndicatorState>(
                                builder: (context, state) {
                                  return ResponsiveRowColumn(
                                    layout: (landscape)
                                        ? ResponsiveRowColumnType.ROW
                                        : ResponsiveRowColumnType.COLUMN,
                                    rowMainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    columnMainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      // location
                                      ResponsiveRowColumnItem(
                                        child: Container(
                                          child: FittedBox(
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                true_location = false;
                                                press_location = true;

                                                if (lat == 0) {
                                                  getLocation().then((value) {
                                                    if (value.latitude is num) {
                                                      lat = value.latitude;
                                                      long = value.longitude;                                                      
                                                      if (lat != 0) {
                                                        location_status =
                                                            " Success";
                                                      } else {
                                                        location_status =
                                                            " Faild";
                                                      }
                                                    }
                                                  });
                                                  while (lat == 0) {
                                                    context
                                                        .read<
                                                            CircularIndicatorCubit>()
                                                        .Circular_Location();
                                                    await Future.delayed(
                                                        Duration(seconds: 1));
                                                  }
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  side:
                                                      (true_location == true &&
                                                              lat == 0)
                                                          ? const BorderSide(
                                                              color: Colors.red,
                                                              width: 2)
                                                          : null,
                                                  shadowColor: Colors.black,
                                                  elevation: 10,
                                                  backgroundColor:
                                                      const Color.fromRGBO(
                                                          50, 50, 160, 1),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                  ),
                                                  textStyle: const TextStyle(
                                                    fontSize: 18,
                                                  )),
                                              child: context
                                                      .read<
                                                          CircularIndicatorCubit>()
                                                      .isLoading_Location
                                                  ? Container(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            width: 20,
                                                            height: 20,
                                                            child:
                                                                const CircularProgressIndicator(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: (landscape)
                                                                ? MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    80
                                                                : MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    50,
                                                          ),
                                                          Text('Loadding...',
                                                              style:
                                                                  getTextWhite(
                                                                      context))
                                                        ],
                                                      ),
                                                    )
                                                  : Text(
                                                      (lat != 0)
                                                          ? location_status
                                                          : 'Location',
                                                      style:
                                                          getTextWhite(context),
                                                    ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      ResponsiveRowColumnItem(
                                        child: SizedBox(
                                            height:
                                                mediaQuery.size.height / 50),
                                      ),
                                      // verifying
                                      ResponsiveRowColumnItem(
                                        child: Container(
                                          child: FittedBox(
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                if (_formkey.currentState!
                                                        .validate() &&
                                                    (lat != 0)) {
                                                  adding_new_company = true;
                                                  postCompanyName = {
                                                    "id": (companies_name
                                                                .last.id +
                                                            1)
                                                        .toString(),
                                                    "Name": Company_Name,
                                                    "Admin_username":
                                                        Manger_Name,
                                                    "Admin_password": password,
                                                    "Location": [
                                                      lat.toString(),
                                                      long.toString()
                                                    ],
                                                    "Company_diameter":
                                                        Company_diameter
                                                  };
                                                  context
                                                      .read<
                                                          CompaniesNameCubit>()
                                                      .getCompainesNameData();
                                                  adding_new_company = false;
                                                  context
                                                      .read<
                                                          CircularIndicatorCubit>()
                                                      .Circular();
                                                  await Future.delayed(
                                                      const Duration(
                                                          seconds: 3));
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute<void>(
                                                      builder: (BuildContext
                                                              context) =>
                                                          HomeScreenManger(),
                                                    ),
                                                  );
                                                  final prefs =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  prefs.setBool(
                                                      'Manger_logedin', true);
                                                  Manger_logedin = true;
                                                  prefs.setString('Manger_Name',
                                                      Manger_Name);
                                                  prefs.setString(
                                                      'Company_Name',
                                                      Company_Name);
                                                }
                                                if (context
                                                        .read<
                                                            CircularIndicatorCubit>()
                                                        .isLoading_Location ==
                                                    false) {
                                                  if (lat == 0) {
                                                    true_location = true;
                                                    context
                                                        .read<
                                                            CircularIndicatorCubit>()
                                                        .forget_location();
                                                  }
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  shadowColor: Colors.black,
                                                  elevation: 10,
                                                  backgroundColor:
                                                      const Color.fromRGBO(
                                                          50, 50, 160, 1),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                  ),
                                                  textStyle: const TextStyle(
                                                    fontSize: 18,
                                                  )),
                                              child: context
                                                      .read<
                                                          CircularIndicatorCubit>()
                                                      .isLoading
                                                  ? Container(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                            width: 20,
                                                            height: 20,
                                                            child:
                                                                const CircularProgressIndicator(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: mediaQuery
                                                                    .size
                                                                    .width /
                                                                50,
                                                          ),
                                                          Text('Please Wait...',
                                                              style:
                                                                  getTextWhite(
                                                                      context))
                                                        ],
                                                      ),
                                                    )
                                                  : Text(
                                                      'verifying',
                                                      style:
                                                          getTextWhite(context),
                                                    ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      ResponsiveRowColumnItem(
                                        child: Container(
                                          child: InkWell(
                                            child: Text(
                                              "Login",
                                              style: getTextBlack(context),
                                            ),
                                            onTap: () {
                                              lat = 0;
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute<void>(
                                                  builder:
                                                      (BuildContext context) =>
                                                          LoginScreen(),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          )),
    );
  }
}
