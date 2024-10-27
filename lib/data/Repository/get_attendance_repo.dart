import 'dart:convert';
import 'package:graduation_project/data/Models/get_attendance_model.dart';
import 'package:graduation_project/data/Models/get_users_data_module.dart';
import 'package:http/http.dart' as http;

List<GetAttendanceModel> attendance = [];

List check_in_employees = [];
List check_out_employees = [];
List<GetUsersModel> attended_employees = [];
List index_of_attended_employees_in_this_company = [];
List index_of_attendance_list_for_attended_employees_in_this_company =
    []; // رقم العنصر الحاضر في مصفوفه الحضور و ذلك لمعرفه رقم العنصر في مصفوفه تاريخ الحضور و مصفوفه تاريخ الانصراف
String? selectedAttendanceItem = 'day';
String url = "";
var day_or_month_index;
bool day_indexing = false;
String? selectedAttendanceDayItem = '';
String? selectedAttendanceCheckInItem = '';
String? selectedAttendanceCheckOutItem = '';
bool attending_employee_to_day = false;
var postAttendanceData;
String day_of_attending = "";
String id_of_added_employee = "";
var response;

class GetAttendanceRepo {
  final supabaseUrl = 'https://oarqjspwajbojrddcvky.supabase.co/rest/v1';
  final supabaseKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9hcnFqc3B3YWpib2pyZGRjdmt5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTE3Mzk2NTQsImV4cCI6MjAyNzMxNTY1NH0.NJ-QaQKrveyPpE2G9-8kizBh6ByFShdQ47xs2Bx8wmQ';
  Future<String?> getAttendanceData() async {
    try {
      if (attending_employee_to_day == true) {
        response = await http.put(
          Uri.parse(
              '$supabaseUrl/attendance_days?id=eq.${(int.parse(day_of_attending) + 1).toString()}'),
          body: jsonEncode(postAttendanceData),
          headers: {
            'Content-Type': 'application/json',
            'apikey': supabaseKey,
          },
        );
        attending_employee_to_day = false;
      }

      if (selectedAttendanceItem == 'day') {
        url = '$supabaseUrl/attendance_days';
      } else {
        url = '$supabaseUrl/attendance_months';
      }
      var attendance_response = await http.get(
        Uri.parse(url),
        headers: {'apikey': supabaseKey},
      );
      

      if (attendance_response.statusCode == 200) {
        List<dynamic> decodedResponse = jsonDecode(attendance_response.body);

        attendance = decodedResponse
            .map((json) => GetAttendanceModel.fromJson(json))
            .toList();
        attendance.sort((a, b) => a.id - b.id);
        
        return "ahmed";
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }
}
