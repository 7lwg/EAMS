import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/Cubits/Circular_indicator_cubit/circular_indicator_cubit.dart';
import 'package:graduation_project/Cubits/Departments_Data/departments_data_cubit.dart';
import 'package:graduation_project/Cubits/Show_field_requirments/field_requirments_cubit.dart';
import 'package:graduation_project/Screen/Splash_Screen.dart';
import 'package:graduation_project/data/Repository/get_departments_repo.dart';
import 'package:graduation_project/data/Repository/get_users_Repo.dart';
import 'package:graduation_project/functions/style.dart';
import 'package:responsive_framework/responsive_row_column.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class AddingDepartment extends StatelessWidget {
  AddingDepartment({super.key});

  RegExp department_name_regex =
      RegExp(r'^(?=^.{3,}$)([a-zA-Z0-9_])+( [a-zA-Z0-9_]+)*$');

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  var department_Name_Info = false;

  bool submitted = false;
  bool form_validate = false;

  String selected_manger = '';

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final landscape = mediaQuery.orientation == Orientation.landscape;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: (landscape)
            ? mediaQuery.size.height * (100 / 800)
            : mediaQuery.size.height * (70 / 800),        
        backgroundColor:           
            const Color.fromRGBO(50, 50, 160, 1),
        leading: Builder(builder: (context) {
          return IconButton(
            color: Colors.white,
            onPressed: () {              
              Navigator.pop(
                context,
              );
              Department_Name = "";
              Department_Descreption = "";
            },
            icon: Icon(Icons.arrow_back),
          );
        }),
        automaticallyImplyLeading: false,
        title: FittedBox(
            child: Text(
          "Adding New Department",
          style: (landscape)
              ? getTextWhiteHeader(context)
              : getTextWhiteHeader(context),
        )),
        centerTitle: true,
      ),
      // ignore: deprecated_member_use
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(
            context,
          );
          Department_Name = "";
          Department_Descreption = "";
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
                      //Department Name
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
                                Department_Name = text;
                              },
                              validator: (value) {
                                if (department_name_regex.hasMatch(value!) ==
                                    false) {
                                  return 'Invalid Department Name';
                                } else if (departments.any((element) =>
                                    element.name == (Department_Name))) {
                                  return 'The Department name is already found';
                                } else {
                                  Department_Name = value;
                                  return null;
                                }
                              },
                              textAlign: TextAlign.left,
                              decoration: InputDecoration(
                                  errorStyle: TextStyle(
                                      color: Colors.red[400], height: 0.8),
                                  
                                  prefixIcon: Image.asset(icons[4],
                                      scale: 3,
                                      color:
                                          Color.fromARGB(255, 145, 142, 142)),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  
                                  hintText: 'Department Name',
                                  hintStyle: getTextGrey(context)),
                            ),
                          ),
                          InkWell(
                            onTapDown: (_) {
                              context
                                  .read<FieldRequirmentsCubit>()
                                  .FieldRequirments();
                              department_Name_Info = true;
                            },
                            onTapUp: (_) {
                              context
                                  .read<FieldRequirmentsCubit>()
                                  .FieldRequirments();
                              department_Name_Info = false;
                            },
                            onTapCancel: () {
                              context
                                  .read<FieldRequirmentsCubit>()
                                  .FieldRequirments();
                              department_Name_Info = false;
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
                          visible: department_Name_Info,
                          child: Container(
                            width: mediaQuery.size.width * 0.8,
                            child: Text(
                              'The Department Name must contain at least 3 characters\nThe First Name can only consist of alphanumeric characters (both lowercase and uppercase) and underscores.',
                              style: getSmallTextBlack(context),
                            ),
                          )),
                      SizedBox(height: mediaQuery.size.width / 50),
                      
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
                                  Department_Descreption = text;
                                },
                                textAlign: TextAlign.left,
                                decoration: InputDecoration(
                                    errorStyle: TextStyle(
                                        color: Colors.red[400], height: 0.8),                                    
                                    prefixIcon: const Icon(Icons.person,
                                        color:
                                            Color.fromARGB(255, 145, 142, 142),
                                        size: 30),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),                                    
                                    hintText: 'Department Description',
                                    hintStyle: getTextGrey(context)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: mediaQuery.size.width / 50),

                      Container(                        
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(
                            left: mediaQuery.size.width / 50,
                            right: mediaQuery.size.width / 50),
                        width: mediaQuery.size.width * 0.8,
                        height: (landscape)
                            ? mediaQuery.size.height / 7
                            : mediaQuery.size.height / 10,
                        child: DropdownSearch<String>(
                          items: users
                              .map((person) =>
                                  person.firstName + ' ' + person.lastName)
                              .toList(),
                          dropdownBuilder: (context, selectedItem) {
                            return Text(
                                selectedItem ?? 'Chose Department Manger',
                                style: getTextGrey(context));
                          },
                          compareFn: (item1, item2) {
                            return true;
                          },
                          onChanged: (value) {
                            selected_manger = value!;                       
                          },
                          popupProps: PopupProps.menu(
                              itemBuilder: (context, item, isSelected) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    item,
                                    style: getTextBlack(context),
                                  ),
                                );
                              },
                              constraints: BoxConstraints(
                                
                                maxHeight: (landscape)
                                    ? 150
                                    : 280, // Set your desired height here
                              ),
                              showSearchBox: true,
                              showSelectedItems: true,
                              searchFieldProps: TextFieldProps(
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(10.0),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    hintText: 'Search for Employee',
                                    hintStyle: getTextGrey(context)),
                              )),
                        ),
                      ),

                      SizedBox(height: mediaQuery.size.width / 50),
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
                                      getting_number_of_departments = true;
                                      await GetDepartmentsRepo()
                                          .getDepartmentsData();
                                      getting_number_of_departments = false;                                     
                                      adding_department = true;
                                      postDepartmentData = {
                                        "id": (departments.last.id + 1)
                                            .toString(),
                                        "Name": Department_Name,
                                        "Description": Department_Descreption,
                                        "companyName": Company_Name,
                                        'department_manger': (selected_manger !=
                                                '')
                                            ? users[users.indexWhere(
                                                    (element) =>
                                                        (element.firstName +
                                                            ' ' +
                                                            element.lastName) ==
                                                        selected_manger)]
                                                .id
                                            : 'Empty'
                                      };
                                      context
                                          .read<DepartmentsDataCubit>()
                                          .getDepartmentsData();
                                      adding_department = false;
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.setString('Departments_number',
                                          (departments.length + 1).toString());                                      
                                      Department_Name = "";
                                      Department_Descreption = "";
                                      Navigator.pop(
                                        context,
                                      );
                                      Navigator.pop(
                                        context,
                                      );
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
