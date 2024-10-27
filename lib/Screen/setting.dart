import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/Cubits/Circular_indicator_cubit/circular_indicator_cubit.dart';
import 'package:graduation_project/Cubits/Companies%20name/companies_name_cubit.dart';
import 'package:graduation_project/Cubits/Search/search_cubit.dart';
import 'package:graduation_project/Cubits/Show%20password/show_password_cubit.dart';
import 'package:graduation_project/Cubits/Show_field_requirments/field_requirments_cubit.dart';
import 'package:graduation_project/Cubits/Users_data/users_data_cubit.dart';
import 'package:graduation_project/Screen/employeer%20screens/employee.dart';
import 'package:graduation_project/Screen/manger%20screens/Home_Screen_manger.dart';
import 'package:graduation_project/Screen/Splash_Screen.dart';
import 'package:graduation_project/data/Repository/get_companies_name_repo.dart';
import 'package:graduation_project/data/Repository/get_holidays_notifications_repo.dart';
import 'package:graduation_project/data/Repository/get_users_Repo.dart';
import 'package:graduation_project/functions/style.dart';
import 'package:responsive_framework/responsive_row_column.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class Setting extends StatelessWidget {
  Setting({super.key});

  RegExp user_name_regex =
      RegExp(r'^(?=^.{9,}$)([a-zA-Z_0-9])+( [a-zA-Z_0-9]+)*$');

  RegExp password_regex =
      RegExp(r"^(?=.*\d|(?=.*[^\s\w]))(?=.*[a-z])(?=.*[A-Z])(.{9,})$");

  var user_Name_Info = false;
  var password_Info = false;
  String new_password = "";
  String user_name = "";
  String old_password = "";

  bool submitted = false;
  bool form_validate = false;

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final landscape = mediaQuery.orientation == Orientation.landscape;
    return SafeArea(
        child: Scaffold(
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
              context.read<SearchCubit>().close_search();
              context.read<ShowPasswordCubit>().Show_password = true;
              context.read<ShowPasswordCubit>().Show_old_password = true;
              context.read<SearchCubit>().close_sort();
              new_notifications_number = notifications.length;
              Navigator.pop(
                context,
              );
            },
            icon: Icon(Icons.arrow_back),
          );
        }),
        automaticallyImplyLeading: false,
        title: BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            return
                // default case
                FittedBox(
                    child: Text(
              "Setting",
              style: (landscape)
                  ? getTextWhiteHeader(context)
                  : getTextWhiteHeader(context),
            ));
          },
        ),
        centerTitle: true,
      ),
      // ignore: deprecated_member_use
      body: WillPopScope(
        onWillPop: () async {
          context.read<SearchCubit>().close_search();
          context.read<SearchCubit>().close_sort();
          new_notifications_number = notifications.length;
          Navigator.pop(
            context,
          );
          return true;
        },
        child: Form(
          key: _formkey,
          child: BlocBuilder<FieldRequirmentsCubit, FieldRequirmentsState>(
              builder: (context, state) {
            return Center(
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      
                      //New user name
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (Manger_logedin == true)
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
                                  user_name = text;
                                },
                                validator: (value) {
                                  if (user_name != "") {
                                    if (user_name_regex.hasMatch(value!) ==
                                        false) {
                                      return 'Invalid User Name';
                                    } else {
                                      user_name = value;
                                      User_Name = user_name;
                                      return null;
                                    }
                                  }
                                  return null;
                                },
                                textAlign: TextAlign.left,
                                decoration: InputDecoration(
                                    errorStyle: TextStyle(
                                        color: Colors.red[400], height: 0.2),
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 0.0),
                                    prefixIcon: Image.asset(icons[5],
                                        scale: 3,
                                        color:
                                            Color.fromARGB(255, 145, 142, 142)),
                                    filled: true,
                                    fillColor: Colors.white,                                    
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    hintText: 'New User Name',
                                    hintStyle: getTextGrey(context)),
                              ),
                            ),
                          if (Manger_logedin == true)
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
                                    color: Color.fromARGB(255, 145, 142, 142)),
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
                      //old Password
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
                                        .Show_old_password,
                                    obscuringCharacter: "*",
                                    onChanged: (text) {
                                      old_password = text;
                                    },
                                    validator: (value) {                                      
                                      if (new_password != "") {
                                        if (Manger_logedin == true) {
                                          if (old_password != '' &&
                                              companies_name[
                                                          editted_company_index]
                                                      .Admin_password
                                                      .toString() ==
                                                  old_password.toString()) {
                                            if (password_regex
                                                    .hasMatch(value!) ==
                                                false) {
                                              return ('Invalid Password');
                                            } else {
                                              old_password = '';
                                              return null;
                                            }
                                          } else if (old_password == '') {
                                            return 'Enter the old password';
                                          } else {
                                            return 'Wrong old Password';
                                          }
                                        } else {
                                          if (old_password != '' &&
                                              users[users.indexWhere(
                                                          (employee) =>
                                                              employee.id ==
                                                              int.parse(
                                                                  employeer_id))]
                                                      .password
                                                      .toString() ==
                                                  old_password.toString()) {
                                            if (password_regex
                                                    .hasMatch(value!) ==
                                                false) {
                                              return ('Invalid Password');
                                            } else {
                                              old_password = '';
                                              return null;
                                            }
                                          } else if (old_password == '') {
                                            return 'Enter the old password';
                                          } else {
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
                                            EdgeInsets.symmetric(vertical: 0.0),
                                        prefixIcon: Image.asset(icons[6],
                                            scale: 3,
                                            color: Color.fromARGB(
                                                255, 145, 142, 142)),
                                        suffixIcon: TextButton(
                                            onPressed: () {
                                              context
                                                  .read<ShowPasswordCubit>()
                                                  .ole_password();
                                            },
                                            child: (context
                                                        .read<
                                                            ShowPasswordCubit>()
                                                        .Show_old_password ==
                                                    true)
                                                ? const Icon(Icons.visibility,
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
                                        hintText: 'Old Password',
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
                                  color: Color.fromARGB(255, 145, 142, 142)),
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

                      //new Password
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
                                      new_password = text;
                                    },
                                    validator: (value) {
                                      if (new_password != "") {
                                        if (password_regex.hasMatch(value!) ==
                                            false) {
                                          return ('Invalid Password');
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
                                            EdgeInsets.symmetric(vertical: 0.0),
                                        prefixIcon: Image.asset(icons[6],
                                            scale: 3,
                                            color: Color.fromARGB(
                                                255, 145, 142, 142)),
                                        suffixIcon: TextButton(
                                            onPressed: () {
                                              context
                                                  .read<ShowPasswordCubit>()
                                                  .password();
                                            },
                                            child: (context
                                                        .read<
                                                            ShowPasswordCubit>()
                                                        .Show_password ==
                                                    true)
                                                ? const Icon(Icons.visibility,
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
                                        hintText: 'New Password',
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
                                  color: Color.fromARGB(255, 145, 142, 142)),
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
                                    
                                    if (Manger_logedin == true) {
                                      
                                      putcompanyData = {
                                        "id": companies_name[
                                                editted_company_index]
                                            .id,
                                        "Name": companies_name[
                                                editted_company_index]
                                            .name,
                                        "Admin_username": (user_name == "")
                                            ? companies_name[
                                                    editted_company_index]
                                                .Admin_username
                                            : user_name,
                                        "Admin_password": (new_password == "")
                                            ? companies_name[
                                                    editted_company_index]
                                                .Admin_password
                                            : new_password,
                                        "Location": companies_name[
                                                editted_company_index]
                                            .Location,
                                        'Company_diameter': companies_name[
                                                editted_company_index]
                                            .Company_diameter
                                        
                                      };
                                    } else {                                      
                                      putUsersData = {
                                        "id": users[users.indexWhere(
                                                (employee) =>
                                                    employee.id ==
                                                    int.parse(employeer_id))]
                                            .id,
                                        "firstName": users[users.indexWhere(
                                                (employee) =>
                                                    employee.id ==
                                                    int.parse(employeer_id))]
                                            .firstName,
                                        "lastName": users[users.indexWhere(
                                                (employee) =>
                                                    employee.id ==
                                                    int.parse(employeer_id))]
                                            .lastName,
                                        "age": users[users.indexWhere(
                                                (employee) =>
                                                    employee.id ==
                                                    int.parse(employeer_id))]
                                            .age,
                                        "gender": users[users.indexWhere(
                                                (employee) =>
                                                    employee.id ==
                                                    int.parse(employeer_id))]
                                            .gender,
                                        "email": users[users.indexWhere(
                                                (employee) =>
                                                    employee.id ==
                                                    int.parse(employeer_id))]
                                            .email,
                                        "phone": users[users.indexWhere(
                                                (employee) =>
                                                    employee.id ==
                                                    int.parse(employeer_id))]
                                            .phone,
                                        "image": users[users.indexWhere(
                                                (employee) =>
                                                    employee.id ==
                                                    int.parse(employeer_id))]
                                            .image,
                                        "departmentId": users[users.indexWhere(
                                                (employee) =>
                                                    employee.id ==
                                                    int.parse(employeer_id))]
                                            .departmentId,
                                        "shiftId": users[users.indexWhere(
                                                (employee) =>
                                                    employee.id ==
                                                    int.parse(employeer_id))]
                                            .shiftId,
                                        "companyName": users[users.indexWhere(
                                                (employee) =>
                                                    employee.id ==
                                                    int.parse(employeer_id))]
                                            .companyName,
                                        "salary": users[users.indexWhere(
                                                (employee) =>
                                                    employee.id ==
                                                    int.parse(employeer_id))]
                                            .salary,
                                        "salary_type": users[users.indexWhere(
                                                (employee) =>
                                                    employee.id ==
                                                    int.parse(employeer_id))]
                                            .salary_type,
                                        "address": users[users.indexWhere(
                                                (employee) =>
                                                    employee.id ==
                                                    int.parse(employeer_id))]
                                            .address,
                                        "position": users[users.indexWhere(
                                                (employee) =>
                                                    employee.id ==
                                                    int.parse(employeer_id))]
                                            .position,
                                        "hiring_date": users[users.indexWhere(
                                                (employee) =>
                                                    employee.id ==
                                                    int.parse(employeer_id))]
                                            .hiring_date,
                                        "rating": users[users.indexWhere(
                                                (employee) =>
                                                    employee.id ==
                                                    int.parse(employeer_id))]
                                            .rating,
                                       
                                        "password": (new_password == "")
                                            ? users[users.indexWhere(
                                                    (employee) =>
                                                        employee.id ==
                                                        int.parse(
                                                            employeer_id))]
                                                .password
                                            : new_password,
                                        "current_salary": users[
                                                users.indexWhere((employee) =>
                                                    employee.id ==
                                                    int.parse(employeer_id))]
                                            .current_salary
                                      };
                                    }

                                    if (Manger_logedin == true) {
                                      edit_comoany_company = true;
                                      context
                                          .read<CompaniesNameCubit>()
                                          .getCompainesNameData();
                                      edit_comoany_company = false;
                                    } else {
                                      editing_employee = true;
                                      editted_employee_id =
                                          int.parse(employeer_id);
                                      context
                                          .read<UsersDataCubit>()
                                          .getUsersData();
                                      editing_employee = false;
                                    }
                                    
                                    context
                                        .read<CircularIndicatorCubit>()
                                        .Circular();
                                    
                                    if (Manger_logedin == true) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute<void>(
                                          builder: (BuildContext context) =>
                                              HomeScreenManger(),
                                        ),
                                      );
                                    } else {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute<void>(
                                          builder: (BuildContext context) =>
                                              EmployeeScreen(),
                                        ),
                                      );
                                    }
                                    context
                                        .read<ShowPasswordCubit>()
                                        .Show_password = true;
                                    
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    if (Manger_logedin == true) {
                                      prefs.setBool('Manger_logedin', true);
                                      if (user_name != "") {
                                        Manger_Name = user_name;
                                        prefs.setString(
                                            'Manger_Name', Manger_Name);
                                      }
                                      prefs.setBool('customer_logedin', false);
                                      prefs.setString('User_Name', '');
                                      
                                    } else {
                                      prefs.setBool('Manger_logedin', false);
                                      prefs.setString('Manger_Name', '');
                                      prefs.setBool('customer_logedin', true);
                                      if (user_name != '') {
                                        prefs.setString('User_Name', user_name);
                                      }
                                      
                                    }
                                    user_name = "";
                                    new_password = "";
                                    context
                                        .read<ShowPasswordCubit>()
                                        .Show_password = true;
                                    context
                                        .read<ShowPasswordCubit>()
                                        .Show_old_password = true;
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
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    textStyle: const TextStyle(
                                      fontSize: 18,
                                    )),
                                child:                                    
                                    Text('Submit',
                                        style: getTextWhite(context)),
                              ),
                            )),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    ));
  }
}
