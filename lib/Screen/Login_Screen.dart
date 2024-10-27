// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, prefer_typing_uninitialized_variables, must_be_immutable, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/Cubits/Circular_indicator_cubit/circular_indicator_cubit.dart';
import 'package:graduation_project/Cubits/Companies%20name/companies_name_cubit.dart';
import 'package:graduation_project/Cubits/Search/search_cubit.dart';
import 'package:graduation_project/Cubits/Show%20password/show_password_cubit.dart';
import 'package:graduation_project/Cubits/Show_field_requirments/field_requirments_cubit.dart';
import 'package:graduation_project/Cubits/Users_data/users_data_cubit.dart';
import 'package:graduation_project/Screen/Creating_new_company.dart';
import 'package:graduation_project/Screen/employeer%20screens/employee.dart';
import 'package:graduation_project/Screen/manger%20screens/Home_Screen_manger.dart';
import 'package:graduation_project/Screen/Splash_Screen.dart';
import 'package:graduation_project/data/Repository/get_companies_name_repo.dart';
import 'package:graduation_project/data/Repository/get_users_Repo.dart';
import 'package:graduation_project/functions/style.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  RegExp user_name_regex =
      RegExp(r'^(?=^.{9,}$)([a-zA-Z_0-9])+( [a-zA-Z_0-9]+)*$');

  RegExp password_regex =
      RegExp(r"^(?=.*\d|(?=.*[^\s\w]))(?=.*[a-z])(?=.*[A-Z])(.{9,})$");

  var password;

  bool show_password = true;

  var company_Name_Info = false;

  var user_Name_Info = false;

  var password_Info = false;

  var company_selected_index;

  var select_company_color = Colors.black;

  List<DropdownMenuItem<String>> getCompaniesDropdownItems() {
    List<DropdownMenuItem<String>> items = [];
    for (var company in companies_name) {
      items.add(
        DropdownMenuItem<String>(
          value: company.name,
          child: Text(
            company.name,
            style: TextStyle(color: Colors.black),
          ),
        ),
      );
    }
    return items;
  }

  @override
  void initState() {
    super.initState();
    Future(() async {
      login_page = true;
      context.read<UsersDataCubit>().getUsersData();
      login_page = false;
    });
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
            automaticallyImplyLeading: false,
            title: FittedBox(
                child: Text(
              'Login',
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
                      mediaQuery.size.height * (100 / 800) -
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
                            Container(
                              child: BlocBuilder<CompaniesNameCubit,
                                  CompaniesNameState>(
                                builder: (context, state) {
                                  if (state is CompaniesNameSuccess) {
                                    return BlocBuilder<SearchCubit,
                                        SearchState>(
                                      builder: (context, state) {
                                        return DropdownButton<String>(
                                          menuMaxHeight:
                                              (landscape) ? 150 : 210,
                                          iconEnabledColor:
                                              select_company_color,
                                          iconDisabledColor: Colors.black,
                                          style: getTextBlack(context),
                                          hint: Text(
                                            'Select a company',
                                            // Company Name
                                            style: TextStyle(
                                                color: select_company_color),
                                          ),
                                          value:
                                              selectedCompany, // Initially selected value, if any

                                          onChanged: (item) {
                                            selectedCompany = item;
                                            Company_Name = item!;
                                            select_company_color = Colors.black;

                                            context
                                                .read<SearchCubit>()
                                                .emit(SearchInitial());

                                            for (int i = 0;
                                                i < companies_name.length;
                                                i++) {
                                              if (companies_name[i].name ==
                                                  selectedCompany) {
                                                company_selected_index = i;
                                              }
                                            }
                                          },
                                          items: getCompaniesDropdownItems(),
                                        );
                                      },
                                    );
                                  } else if (state is CompaniesNameError) {
                                    return Center(
                                      child: Text(state.errorMessage),
                                    );
                                  } else {
                                    return FutureBuilder<void>(
                                      future: context
                                          .read<CompaniesNameCubit>()
                                          .getCompainesNameData(),
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
                            SizedBox(
                              height: mediaQuery.size.width / 50,
                            ),
                            //user name
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  constraints: BoxConstraints(maxWidth: 500),
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(
                                      left: mediaQuery.size.width / 20),
                                  width: mediaQuery.size.width * 0.8,
                                  height: (landscape)
                                      ? mediaQuery.size.height / 7
                                      : mediaQuery.size.height / 10,
                                  child: TextFormField(
                                    onChanged: (text) {
                                      User_Name = text;
                                    },
                                    validator: (value) {
                                      if (user_name_regex.hasMatch(value!) ==
                                          false) {
                                        return 'Invalid User Name';
                                      } else {
                                        if (User_Name !=
                                            companies_name[
                                                    company_selected_index]
                                                .Admin_username) {
                                          for (int i = 0;
                                              i < users.length;
                                              i++) {
                                            if (users[i].companyName ==
                                                    companies_name[
                                                            company_selected_index]
                                                        .name &&
                                                User_Name ==
                                                    '${users[i].firstName} ${users[i].lastName}') {
                                              break;
                                            } else if (i == users.length - 1) {
                                              return 'wrong user name';
                                            }
                                          }
                                        }
                                        User_Name = value;
                                        return null;
                                      }
                                    },
                                    textAlign: TextAlign.left,
                                    decoration: InputDecoration(
                                        errorStyle: TextStyle(
                                            color: Colors.red[400],
                                            height: 0.2),
                                        contentPadding:
                                            EdgeInsets.symmetric(vertical: 0.0),
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
                                        hintText: 'User Name',
                                        hintStyle: getTextGrey(context)),
                                  ),
                                ),
                                InkWell(
                                  onTapDown: (_) {
                                    context
                                        .read<FieldRequirmentsCubit>()
                                        .FieldRequirments();
                                    user_Name_Info = true;
                                  },
                                  onTapUp: (_) {
                                    context
                                        .read<FieldRequirmentsCubit>()
                                        .FieldRequirments();
                                    user_Name_Info = false;
                                  },
                                  onTapCancel: () {
                                    context
                                        .read<FieldRequirmentsCubit>()
                                        .FieldRequirments();
                                    user_Name_Info = false;
                                  },
                                  child: IconButton(
                                    icon: Icon(Icons.info,
                                        color:
                                            Color.fromARGB(255, 145, 142, 142)),
                                    onPressed: () {},
                                  ),
                                )
                              ],
                            ),
                            Visibility(
                                visible: user_Name_Info,
                                child: Container(
                                  constraints: BoxConstraints(maxWidth: 400),
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  constraints: BoxConstraints(maxWidth: 500),
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
                                              return ('Invalid Password');
                                            } else if (User_Name ==
                                                    companies_name[
                                                            company_selected_index]
                                                        .Admin_username &&
                                                password !=
                                                    companies_name[
                                                            company_selected_index]
                                                        .Admin_password) {
                                              return 'Wrong Password';
                                            } else if (User_Name !=
                                                companies_name[
                                                        company_selected_index]
                                                    .Admin_username) {
                                              for (int i = 0;
                                                  i < users.length;
                                                  i++) {
                                                if (users[i].companyName ==
                                                        companies_name[
                                                                company_selected_index]
                                                            .name &&
                                                    User_Name ==
                                                        '${users[i].firstName} ${users[i].lastName}' &&
                                                    password ==
                                                        users[i].password) {
                                                  break;
                                                } else if (i ==
                                                    users.length - 1) {
                                                  return 'Wrong Password';
                                                }
                                              }
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
                                              prefixIcon: Image.asset(icons[6],
                                                  scale: 3,
                                                  color: Color.fromARGB(
                                                      255, 145, 142, 142)),
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
                                                      : const Icon(
                                                          Icons.visibility_off,
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
                                        color:
                                            Color.fromARGB(255, 145, 142, 142)),
                                    onPressed: () {},
                                  ),
                                )
                              ],
                            ),
                            Visibility(
                                visible: password_Info,
                                child: Container(
                                  constraints: BoxConstraints(maxWidth: 400),
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
                            // verifying button
                            Container(
                              constraints: BoxConstraints(maxWidth: 500),
                              child: BlocBuilder<CircularIndicatorCubit,
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
                                      ResponsiveRowColumnItem(
                                        child: Container(
                                          child: FittedBox(
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                if (company_selected_index ==
                                                    null) {
                                                  select_company_color =
                                                      Colors.red;
                                                  context
                                                      .read<SearchCubit>()
                                                      .emit(SearchInitial());
                                                } else {
                                                  select_company_color =
                                                      Colors.black;
                                                }
                                                if (_formkey.currentState!
                                                        .validate() &&
                                                    company_selected_index !=
                                                        null) {
                                                  context
                                                      .read<
                                                          CircularIndicatorCubit>()
                                                      .Circular();
                                                  await Future.delayed(
                                                      const Duration(
                                                          seconds: 3));
                                                  if (User_Name ==
                                                          companies_name[
                                                                  company_selected_index]
                                                              .Admin_username &&
                                                      password ==
                                                          companies_name[
                                                                  company_selected_index]
                                                              .Admin_password) {
                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute<void>(
                                                        builder: (BuildContext
                                                                context) =>
                                                            HomeScreenManger(),
                                                      ),
                                                    );
                                                  } else {
                                                    for (int i = 0;
                                                        i < users.length;
                                                        i++) {
                                                      if (users[i].companyName ==
                                                              companies_name[
                                                                      company_selected_index]
                                                                  .name &&
                                                          User_Name ==
                                                              '${users[i].firstName} ${users[i].lastName}' &&
                                                          password ==
                                                              users[i]
                                                                  .password) {
                                                        Navigator
                                                            .pushReplacement(
                                                          context,
                                                          MaterialPageRoute<
                                                              void>(
                                                            builder: (BuildContext
                                                                    context) =>
                                                                EmployeeScreen(),
                                                          ),
                                                        );
                                                        break;
                                                      }
                                                    }
                                                  }
                                                  context
                                                      .read<ShowPasswordCubit>()
                                                      .Show_password = true;
                                                  final prefs =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  if (User_Name ==
                                                          companies_name[
                                                                  company_selected_index]
                                                              .Admin_username &&
                                                      password ==
                                                          companies_name[
                                                                  company_selected_index]
                                                              .Admin_password) {
                                                    Manger_logedin = true;
                                                    Manger_Name = User_Name;
                                                    prefs.setBool(
                                                        'Manger_logedin', true);
                                                    prefs.setString(
                                                        'Manger_Name',
                                                        User_Name);
                                                    prefs.setBool(
                                                        'customer_logedin',
                                                        false);
                                                    customer_logedin = false;
                                                    prefs.setString(
                                                        'User_Name', '');
                                                  } else {
                                                    for (int i = 0;
                                                        i < users.length;
                                                        i++) {
                                                      if (users[i].companyName ==
                                                              companies_name[
                                                                      company_selected_index]
                                                                  .name &&
                                                          User_Name ==
                                                              '${users[i].firstName} ${users[i].lastName}' &&
                                                          password ==
                                                              users[i]
                                                                  .password) {
                                                        customer_logedin = true;
                                                        prefs.setBool(
                                                            'Manger_logedin',
                                                            false);
                                                        Manger_logedin = false;
                                                        prefs.setString(
                                                            'Manger_Name', '');
                                                        prefs.setBool(
                                                            'customer_logedin',
                                                            true);
                                                        prefs.setString(
                                                            'User_Name',
                                                            User_Name);
                                                        prefs.setString(
                                                            'Employeer_id',
                                                            users[i]
                                                                .id
                                                                .toString());
                                                        employeer_id = users[i]
                                                            .id
                                                            .toString();
                                                        break;
                                                      }
                                                    }
                                                  }
                                                  prefs.setString(
                                                      'Company_Name',
                                                      Company_Name);
                                                  context
                                                      .read<ShowPasswordCubit>()
                                                      .Show_password = true;
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
                                                  : Text('verifying',
                                                      style: getTextWhite(
                                                          context)),
                                            ),
                                          ),
                                        ),
                                      ),
                                      ResponsiveRowColumnItem(
                                        child: Container(
                                          child: InkWell(
                                            child: FittedBox(
                                              child: Text(
                                                "Create New Company",
                                                style: getTextBlack(context),
                                              ),
                                            ),
                                            onTap: () {
                                              selectedCompany = null;
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute<void>(
                                                  builder:
                                                      (BuildContext context) =>
                                                          NewCompany(),
                                                ),
                                              );
                                              context
                                                  .read<ShowPasswordCubit>()
                                                  .Show_password = true;
                                            },
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          )),
    );
  }
}
