import 'dart:async';
import 'dart:convert';
import 'dart:io'; // Import dart:io for File class
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:graduation_project/Cubits/Users_data/users_data_cubit.dart';
import 'package:graduation_project/Cubits/attendance%20new_data/attendance_new_data_cubit.dart';
import 'package:graduation_project/Screen/Splash_Screen.dart';
import 'package:graduation_project/Screen/employeer%20screens/employee.dart';
import 'package:graduation_project/data/Repository/get_attendance_new_repo.dart';
import 'package:graduation_project/data/Repository/get_companies_name_repo.dart';
import 'package:graduation_project/data/Repository/get_shifts_repo.dart';
import 'package:graduation_project/data/Repository/get_users_Repo.dart';
import 'package:graduation_project/functions/distance_between_locations.dart';
import 'package:graduation_project/functions/location.dart';
import 'package:graduation_project/functions/style.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class TakeAttendance extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

var photo;
bool pressed = false;
bool first_time = true;
bool start = false;
String start_time_for_calculating_salary = '';
String end_time_for_calculating_salary = '';

class _CameraScreenState extends State<TakeAttendance> {
  List<dynamic> _capturedImages = [];
  String last_message = '';
  int index = 0;
  var location_status;
  double employeer_long = 0, employeer_lat = 0;
  int employee_company_index = 0;
  double distance = 0;
  String shown_icon = "";

  Future<void> _openFrontCamera() async {
    final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera); // Use pickImage instead of getImage
    if (pickedFile != null) {
      pressed = true;
      first_time = false;
      setState(() {});
      // Check if pickedFile is not null
      _capturedImages.add(pickedFile.path);
      print(pickedFile.path + '//**');
      await _uploadImage();
      setState(() {});
      pressed = false;
      // start = false;
    }
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  daysInCurrentMonth() {
    DateTime now = DateTime.now();
    int nextMonth = now.month == 12 ? 1 : now.month + 1;
    int nextMonthYear = now.month == 12 ? now.year + 1 : now.year;

    DateTime firstDayOfNextMonth = DateTime(nextMonthYear, nextMonth, 1);
    DateTime lastDayOfCurrentMonth =
        firstDayOfNextMonth.subtract(Duration(days: 1));

    return lastDayOfCurrentMonth.day;
  }

  String calculateTimeDifference(String startTime, String endTime) {
    // Define the date format
    final DateFormat dateFormat = DateFormat.Hm();

    // Parse the start and end times
    final DateTime startDateTime = dateFormat.parse(startTime);
    final DateTime endDateTime = dateFormat.parse(endTime);

    // Calculate the difference
    final Duration difference = endDateTime.difference(startDateTime);

    // Convert the difference to hours and minutes as a decimal
    double differenceInHours = difference.inHours.toDouble();
    double differenceInMinutes = (difference.inMinutes % 60).toDouble() / 60;

    // Sum hours and fractional hours
    double totalDifference = differenceInHours + differenceInMinutes;

    // Convert the result to a string
    return totalDifference.toString();
  }

  Future<void> sendId(id) async {
    const String apiUrl = 'http://192.168.1.43:5000/id';

    // Create a MultipartRequest
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

    // Add the 'id' field to the request
    request.fields['id'] = id;

    try {
      // Send the request
      var response = await request.send();

      // Check the response status
      if (response.statusCode == 200) {
        print('The id was sent successfully');
      } else {
        print('Failed to send the id. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending the id: $e');
    }
  }

  // Function to upload the selected image to the Flask API
  Future<void> _uploadImage() async {
    if (_capturedImages.last == null) {
      // ignore: avoid_print
      print('No image selected');
      return;
    }

    const String apiUrl = 'http://192.168.1.43:5000/upload_photo';

    // Your upload logic
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

    photo = await http.MultipartFile.fromPath('photo', _capturedImages.last!);
    request.files.add(photo);

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        // ignore: avoid_print
        print('Image uploaded successfully');
      } else {
        // ignore: avoid_print
        print('Failed to upload image');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error uploading image: $e');
    }
    start = true;
  }

  Future<String> fetchData() async {
    const String apiUrl = 'http://192.168.1.43:5000/hello';
    final Uri apiUri = Uri.parse(apiUrl);
    final response = await http.get(apiUri);
    if (response.statusCode == 200) {
      await getting_ip();
      // ignore: avoid_print
      print(json.decode(response.body)['message']);
      print(index.toString() + '//**');
      return json.decode(response.body)['message'][index];
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  // ignore: non_constant_identifier_names
  Future<String> getting_ip() async {
    const String apiUrl = 'http://192.168.1.43:5000/ip';

    final Uri apiUri = Uri.parse(apiUrl);
    final response = await http.get(apiUri);
    if (response.statusCode == 200) {
      List test = json.decode(response.body)['ip'];
      for (int i = 0; i < test.length; i++) {
        if (test[i] == await getIPAddress()) {
          index = i;
        }
      }
      // ignore: avoid_print
      print("this is the index : " + index.toString());
      // ignore: avoid_print
      print('IPs' + (json.decode(response.body)['ip']).toString());
      return "";
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  // Function to open the image picker and select an image
  // ignore: unused_element
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery); // Use pickImage instead of getImage
    if (pickedFile != null) {
      pressed = true;
      first_time = false;
      setState(() {});
      // Check if pickedFile is not null
      _capturedImages.add(pickedFile.path);
      print(pickedFile.path + '//**');
      await _uploadImage();
      setState(() {});
      pressed = false;
      // start = false;
    }
  }

  Future<String?> getIPAddress() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      // Device is not connected to the internet
      return null;
    }

    try {
      for (var interface in await NetworkInterface.list()) {
        for (var addr in interface.addresses) {
          if (addr.type == InternetAddressType.IPv4) {
            // Return the IPv4 address
            // ignore: avoid_print
            print(addr.address);
            return addr.address;
          }
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print("Failed to get IP address: $e");
    }

    return null; // If no IP address is found
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final landscape = mediaQuery.orientation == Orientation.landscape;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: (landscape)
            ? mediaQuery.size.height * (100 / 800)
            : mediaQuery.size.height * (70 / 800),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, [EmployeeScreen()]);
          },
          icon: Icon(
            Icons.arrow_back,
          ),
        ),
        title: Text(
          'Attendance',
          style: (landscape)
              ? getTextWhiteHeader(context)
              : getTextWhiteHeader(context),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: 40,
            ),
            child: Container(
              child: Container(
                // color: Colors.red,
                width: double.infinity,
                height: 225,
                padding: EdgeInsets.all(25),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: HexColor('FFFFFF'),
                  border: Border.all(
                    color: HexColor('7D7D7D'),
                  ),
                ),
                child: Column(
                  children: [
                    // Image.asset('assets/images/Camera.png'),
                    Container(
                      // color: Colors.red,
                      height: 35,
                      child: FutureBuilder<String>(
                        future: fetchData(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error} Ahmed');
                          } else {
                            return_all_data_for_all_days = true;
                            day_of_new_attending =
                                DateTime.now().day.toString();

                            context
                                .read<AttendanceNewDataCubit>()
                                .getAttendanceNewData();

                            print(new_attendance.length.toString() + ' ahmed');
                            return_all_data_for_all_days = false;
                            // return_all_data = false;
                            if ((snapshot.data == 'it\'s a picture of me!') &&
                                (distance <=
                                    companies_name[employee_company_index]
                                        .Company_diameter) &&
                                start == true) {
                              start = false;
                              print('its a picture of me ahmed');

                              print('condition: ' +
                                  new_attendance
                                      .any((record) =>
                                          (record.employee_id ==
                                              int.parse(employeer_id)) &&
                                          (record.date ==
                                              int.parse(day_of_new_attending)))
                                      .toString() +
                                  ' ahmed');

                              if (new_attendance.any((record) =>
                                      (record.employee_id ==
                                          int.parse(employeer_id)) &&
                                      (record.date ==
                                          int.parse(day_of_new_attending))) ==
                                  false)
                              // employee check in
                              {
                                print('check in ahmed');

                                day_of_new_attending =
                                    (DateTime.now().day - 1).toString();
                                print('day date: ' +
                                    (int.parse(day_of_new_attending))
                                        .toString() +
                                    ' ahmed');

                                print('new_attendance.last.id: ' +
                                    new_attendance.last.id.toString() +
                                    ' ahmed');
                                print("id of the attendance row: " +
                                    last_employee_id_in_attendance_table
                                        .toString() +
                                    'ahmed');

                                attending_employee_to_day = true;
                                print(users[users.indexWhere((element) =>
                                            element.id ==
                                            int.parse(employeer_id))]
                                        .firstName +
                                    ' ahmed1234');
                                print(users[users.indexWhere((element) =>
                                            element.id ==
                                            int.parse(employeer_id))]
                                        .lastName +
                                    ' ahmed1234');
                                postAttendanceData = {
                                  "id":
                                      last_employee_id_in_attendance_table + 1,
                                  "employee_id": int.parse(employeer_id),
                                  "date": int.parse(day_of_new_attending) + 1,
                                  "time_in": DateTime.now().hour.toString() +
                                      ':' +
                                      DateTime.now().minute.toString(),
                                  "time_out": 0,
                                  "company_name": Company_Name.toString(),
                                  "firstName": users[users.indexWhere(
                                          (element) =>
                                              element.id ==
                                              int.parse(employeer_id))]
                                      .firstName,
                                  "lastName": users[users.indexWhere(
                                          (element) =>
                                              element.id ==
                                              int.parse(employeer_id))]
                                      .lastName,
                                  "current_month": true,
                                };
                                start_time_for_calculating_salary =
                                    DateTime.now().hour.toString() +
                                        ':' +
                                        DateTime.now().minute.toString();
                                adding_employee_to_attendance = false;
                                last_employee_id_in_attendance_table = 0;
                                context
                                    .read<AttendanceNewDataCubit>()
                                    .getAttendanceNewData();
                                attending_employee_to_day = false;
                                context.read<UsersDataCubit>().getUsersData();
                                Navigator.pop(
                                  context,
                                );
                              } else if (new_attendance.any((record) =>
                                          (record.employee_id ==
                                              int.parse(employeer_id)) &&
                                          (record.date ==
                                              int.parse(
                                                  day_of_new_attending))) ==
                                      true &&
                                  (new_attendance[new_attendance.indexWhere(
                                              (record) =>
                                                  (record.employee_id ==
                                                      int.parse(
                                                          employeer_id)) &&
                                                  (record.date ==
                                                      int.parse(
                                                          day_of_new_attending)))]
                                          .time_out ==
                                      '0'))
                              // employee check out
                              {
                                print('check out ahmed');
                                print('test ahmed');

                                check_out_for_employee_with_face_recognition =
                                    true;
                                current_day = int.parse(day_of_new_attending);
                                print(current_day.toString() + ' ahmed');
                                putAttendanceData = {
                                  'time_out': DateTime.now().hour.toString() +
                                      ':' +
                                      DateTime.now().minute.toString()
                                };
                                end_time_for_calculating_salary =
                                    DateTime.now().hour.toString() +
                                        ':' +
                                        DateTime.now().minute.toString();
                                context
                                    .read<AttendanceNewDataCubit>()
                                    .getAttendanceNewData();
                                check_out_for_employee_with_face_recognition =
                                    false;
                                current_day = 0;

                                // add the salary of this day to the employee
                                editing_employee = true;
                                editted_employee_id = int.parse(employeer_id);
                                int index = users.indexWhere((element) =>
                                    element.id == int.parse(employeer_id));

                                double working_hours = double.parse(
                                    calculateTimeDifference(
                                        start_time_for_calculating_salary,
                                        end_time_for_calculating_salary));
                                print('test 2 ahmed');

                                int shift_working_hours = (users[index].shiftId ==
                                        'Empty')
                                    ? 0
                                    : int.parse(shifts[shifts.indexWhere(
                                                (element) =>
                                                    element.id ==
                                                    int.parse(users[index]
                                                        .shiftId
                                                        .toString()))]
                                            .end_time) -
                                        int.parse(
                                            shifts[shifts.indexWhere((element) => element.id == int.parse(users[index].shiftId.toString()))]
                                                .start_time);

                                putUsersData = {
                                  "id": int.parse(employeer_id),
                                  "firstName": users[index].firstName,
                                  'lastName': users[index].lastName,
                                  'age': users[index].age,
                                  'gender': users[index].gender,
                                  'email': users[index].email,
                                  'phone': users[index].phone,
                                  'image': users[index].image,
                                  'departmentId': users[index].departmentId,
                                  'shiftId': users[index].shiftId,
                                  'companyName': users[index].companyName,
                                  'salary': users[index].salary,
                                  'salary_type': users[index].salary_type,
                                  'address': users[index].address,
                                  'position': users[index].position,
                                  'hiring_date': users[index].hiring_date,
                                  'rating': users[index].rating,
                                  'password': users[index].password,
                                  'current_salary': (users[index].shiftId ==
                                          'Empty')
                                      ?
                                      // if the employee not in a shift so we will caculate the salary on 8 hours per day
                                      (double.parse(
                                                  users[index].current_salary) +
                                              ((users[index].salary_type == ('Monthly') ||
                                                      users[index].salary_type ==
                                                          ('Empty'))
                                                  // if monthly
                                                  ? (((users[index].salary / daysInCurrentMonth()) / 8) *
                                                      working_hours)
                                                  : (users[index].salary_type ==
                                                          ('Weekly'))
                                                      // if week
                                                      ? (((users[index].salary / 7) / 8) *
                                                          working_hours)
                                                      // if day
                                                      : (((users[index].salary) / 8) *
                                                          working_hours)))
                                          .toString()
                                      // if the employee in a shift so we will caculate the salary on the working hours of the shift
                                      : (double.parse(
                                                  users[index].current_salary) +
                                              ((users[index].salary_type ==
                                                          ('Monthly') ||
                                                      users[index].salary_type ==
                                                          ('Empty'))
                                                  // if monthly
                                                  ? (users[index].salary /
                                                      daysInCurrentMonth() /
                                                      shift_working_hours *
                                                      working_hours)
                                                  : (users[index].salary_type ==
                                                          ('Weekly'))
                                                      // if week
                                                      ? ((users[index].salary / 7) /
                                                          shift_working_hours *
                                                          working_hours)
                                                      // if day
                                                      : ((users[index].salary) /
                                                          shift_working_hours *
                                                          working_hours)))
                                          .toString()
                                };
                                context.read<UsersDataCubit>().getUsersData();

                                Navigator.pop(
                                  context,
                                );
                              }
                            } else {
                              // pressed = false;
                            }
                            start = false;
                            (first_time == true)
                                ? Icon(Icons.question_mark)
                                : ((pressed == true)
                                    ? (CircularProgressIndicator())
                                    : ((snapshot.data == 'Hello, world!')
                                        ? Icon(Icons.person)
                                        : ((snapshot.data ==
                                                    'it\'s a picture of me!') &&
                                                (distance <=
                                                    companies_name[
                                                            employee_company_index]
                                                        .Company_diameter))
                                            ? _showToast(
                                                'Successfully attended')
                                            : _showToast('Incorrect image')));
                            return (first_time == true)
                                ? Icon(Icons.question_mark)
                                : ((pressed == true)
                                    ? (CircularProgressIndicator())
                                    : ((snapshot.data == 'Hello, world!')
                                        ? Icon(Icons.person)
                                        : ((snapshot.data ==
                                                    'it\'s a picture of me!') &&
                                                (distance <=
                                                    companies_name[
                                                            employee_company_index]
                                                        .Company_diameter))
                                            ? Icon(Icons.check)
                                            : Icon(Icons.cancel_outlined)));
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: 180,
                      child: Text(
                        'You should open the camera ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    MaterialButton(
                      onPressed: () async {
                        sendId(employeer_id);

                        await _openFrontCamera();

                        setState(() {});
                        await getLocation().then((value) {
                          if (value.latitude is num) {
                            employeer_lat = value.latitude;
                            employeer_long = value.longitude;
                            if (employeer_lat != 0) {
                              location_status = " Success";
                              print('location success');
                            } else {
                              location_status = " Faild";
                            }
                          }
                        });
                        employee_company_index = companies_name.indexWhere(
                            (company) => company.name == Company_Name);
                        distance = haversine(
                            employeer_lat,
                            employeer_long,
                            double.parse(companies_name[employee_company_index]
                                .Location[0]),
                            double.parse(companies_name[employee_company_index]
                                .Location[1]));
                        start = false;
                      },
                      height: 42,
                      minWidth: 175,
                      color: HexColor('3232A0'),
                      child: Text(
                        'open camera',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(78.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: TakeAttendance(),
  ));
}
