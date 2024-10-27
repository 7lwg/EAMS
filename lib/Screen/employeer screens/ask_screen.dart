import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/Cubits/ask_for_holiday/ask_cubit.dart';
import 'package:graduation_project/Cubits/ask_for_holiday/ask_state.dart';
import 'package:graduation_project/Screen/Splash_Screen.dart';
import 'package:graduation_project/Screen/employeer%20screens/components.dart';
import 'package:graduation_project/Screen/employeer%20screens/employee.dart';
import 'package:graduation_project/functions/style.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

var startDateController = TextEditingController();
var endDateController = TextEditingController();
var reasonController = TextEditingController();
var formKey = GlobalKey<FormState>();
int? startday;
int? endday;
int? day;

var ask_date = DateTime.now();
Future selectDate(context, int handelday) async {
  var year = DateTime.now().year;
  var month = DateTime.now().month;
  var day_now = DateTime.now().day;
  DateTime dateTime = DateTime(year, month, day_now + 1);
  if (handelday != 0) {
    dateTime = DateTime(year, month, handelday);
  }
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: dateTime,
    firstDate: dateTime,
    lastDate: DateTime.now().add(Duration(days: 30)),
  );

  if (picked != null) {
    day = picked.day;
  }
  return picked;
}

class AskScreen extends StatelessWidget {
  const AskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final landscape = mediaQuery.orientation == Orientation.landscape;
    return BlocProvider(
      create: (context) => AskCubit()..getHolidaysData(),
      child: BlocConsumer<AskCubit, AskStates>(
        listener: (context, state) {
          if (state is PostDataSccess) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => EmployeeScreen()),
              (route) => false,
            );
            startDateController.text = '';
            endDateController.text = '';
            reasonController.text = '';
          } else if (state is PostDataError) {
            showToast(
              txt: 'an error occurred',
              state: toaststate.ERROR,
            );
          }
        },
        builder: (context, state) {
          var cubit = AskCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: (landscape)
                  ? mediaQuery.size.height * (100 / 800)
                  : mediaQuery.size.height * (70 / 800),
              title: Text(
                'Ask for holiday',
                style: (landscape)
                    ? getTextWhiteHeader(context)
                    : getTextWhiteHeader(context),
              ),
              leading: IconButton(
                onPressed: () {
                  startDateController.text = '';
                  endDateController.text = '';
                  reasonController.text = '';
                  startday = null;
                  Navigator.pop(context, [EmployeeScreen()]);
                },
                icon: Icon(
                  Icons.arrow_back,
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        defultFormField(
                          ontap: () async {
                            await selectDate(context, 0).then((value) {
                              if (value != null) {
                                var formatdate =
                                    DateFormat.yMMMMd('en_US').format(value!);
                                startDateController.text = formatdate;
                                startday = day;
                              }
                            });
                            endDateController.text = '';
                            endday = null;
                          },
                          readonly: true,
                          controller: startDateController,
                          labeltext: 'Start date',
                          prefixicon: Icons.calendar_month_sharp,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'You must enter the date';
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(
                          height: 27,
                        ),
                        defultFormField(
                          ontap: () {
                            if (startday != null) {
                              selectDate(context, startday ?? 0).then((value) {
                                if (value != null) {
                                  var formatdate =
                                      DateFormat.yMMMMd('en_US').format(value);
                                  endDateController.text = formatdate;
                                
                                  endday = day;
                                }
                              });
                            } else {
                              showToast(
                                txt: 'You must enter the start date',
                                state: toaststate.ERROR,
                              );
                            }
                          },
                          readonly: true,
                          controller: endDateController,
                          labeltext: 'End date',
                          prefixicon: Icons.calendar_month_sharp,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'You must enter the date';
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(
                          height: 27,
                        ),
                        defultFormField(
                          ontap: () {},
                          controller: reasonController,
                          labeltext: 'reason',
                          prefixicon: Icons.info,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'You must enter the reason';
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(
                          height: 74,
                        ),
                        state is PostDataLoading
                            ? Center(child: CircularProgressIndicator())
                            : MaterialButton(
                                onPressed: () {                    
                                  if (formKey.currentState!.validate()) {
                                    cubit.postAsk(
                                      
                                      id: cubit.id_ + 1,
                                      employee_id: 'eq.' + employeer_id,
                                      askTime: DateTime.now().hour.toString() +
                                          ':' +
                                          DateTime.now().minute.toString() +
                                          '  ' +
                                          DateFormat.yMMMMd('en_US')
                                              .format(ask_date),
                                      startDate: startday ?? 0,
                                      endDate: endday ?? 0,
                                      reasone: reasonController.text,
                                    );
                                  }
                                  startday = null;
                                },
                                height: 53,
                                minWidth: 224,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                color: HexColor('3232A0'),
                                child: Text(
                                  'send',
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
