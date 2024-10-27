import 'dart:convert';
import 'package:graduation_project/Screen/Splash_Screen.dart';
import 'package:graduation_project/data/Models/get_attendance_new_model.dart';
import 'package:graduation_project/data/Repository/get_users_Repo.dart';
import 'package:http/http.dart' as http;


List<GetAttendanceNewModel> new_attendance = [];
bool attending_employee_to_day = false;
bool delete_employee_from_the_table = false;

String url = "";
String? selectedAttendanceCheckInItem = '';
String? selectedAttendanceCheckOutItem = '';
var postAttendanceData;
var putAttendanceData;
String day_of_new_attending = "";
String month_of_new_attending = "";
String id_of_added_employee = "";
var response;
bool return_all_data = false;
bool return_all_data_for_all_days = false;
bool check_out_for_employee_with_face_recognition = false;
int current_day = 0;
bool days_of_attendance_for_a_specific_employee = false;
bool search_in_new_attendance = false;
String search_text_in_new_attendance = '';
String? search_field_in_new_attendance = 'id';
bool sort_attendance = false;
bool sort_ascending_attendacne = true;
String? selectedattendacneSortItem = 'id';
int last_employee_id_in_attendance_table = 0;

bool month = false;

class GetAttendanceNewRepo {
  final supabaseUrl = 'https://oarqjspwajbojrddcvky.supabase.co/rest/v1';
  final supabaseKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9hcnFqc3B3YWpib2pyZGRjdmt5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTE3Mzk2NTQsImV4cCI6MjAyNzMxNTY1NH0.NJ-QaQKrveyPpE2G9-8kizBh6ByFShdQ47xs2Bx8wmQ';
  Future<String?> getAttendanceNewData() async {
    try {
      if (attending_employee_to_day == true) {
        response = await http.post(
          Uri.parse('$supabaseUrl/new_attendance_2'),
          body: jsonEncode(postAttendanceData),
          headers: {
            'Content-Type': 'application/json',
            'apikey': supabaseKey,
          },
        );
        print('posted ///**');
        attending_employee_to_day = false;
      } else if (delete_employee_from_the_table) {
        response = await http.delete(
          Uri.parse(
              '$supabaseUrl/new_attendance_2?employee_id=eq.${deleted_employee_id}&company_name=eq.${Company_Name}'),
          headers: {'apikey': supabaseKey},
        );
        delete_employee_from_the_table = false;
      } else if (check_out_for_employee_with_face_recognition == true) {
        response = await http.patch(
          Uri.parse(
              '$supabaseUrl/new_attendance_2?employee_id=eq.${employeer_id}&date=eq.${current_day}'),
          body: jsonEncode(putAttendanceData),
          headers: {
            'Content-Type': 'application/json',
            'apikey': supabaseKey,
          },
        );
        check_out_for_employee_with_face_recognition = false;
      }

      if (return_all_data == true) {
        url =
            '$supabaseUrl/new_attendance_2?date=eq.${int.parse(day_of_new_attending) + 1}';
      } else if (return_all_data_for_all_days == true) {
        url = '$supabaseUrl/new_attendance_2';
      } else if (days_of_attendance_for_a_specific_employee == true) {
        url =
            '$supabaseUrl/new_attendance_2?employee_id=eq.${employeer_id}&company_name=eq.${Company_Name}&current_month=eq.true';
      } else if (search_in_new_attendance == true) {        
        if (search_field_in_new_attendance == 'id') {
          url =
              '$supabaseUrl/new_attendance_2?employee_id=eq.${search_text_in_new_attendance}&date=eq.${int.parse(day_of_new_attending) + 1}&company_name=eq.${Company_Name}&current_month=eq.true';
        } else {
          url =
              '$supabaseUrl/new_attendance_2?${search_field_in_new_attendance}=ilike.*${search_text_in_new_attendance}*&date=eq.${int.parse(day_of_new_attending) + 1}&company_name=eq.${Company_Name}&current_month=eq.true';
        }
      } else {
        url =
            '$supabaseUrl/new_attendance_2?date=eq.${int.parse(day_of_new_attending) + 1}&company_name=eq.${Company_Name}&current_month=eq.true';
      }
      var attendance_response = await http.get(
        Uri.parse(url),
        headers: {'apikey': supabaseKey},
      );      

      if (attendance_response.statusCode == 200) {
        List<dynamic> decodedResponse = jsonDecode(attendance_response.body);

        new_attendance = decodedResponse
            .map((json) => GetAttendanceNewModel.fromJson(json))
            .toList();

        new_attendance.sort((a, b) => a.id.compareTo(b.id));
        last_employee_id_in_attendance_table = new_attendance.last.id;
        

        if (sort_attendance == true) {
          new_attendance.sort((a, b) {
            switch (selectedattendacneSortItem) {
              case 'id':
                if (sort_ascending_attendacne == true) {                  
                  return a.employee_id.compareTo(b.employee_id);
                } else {                  
                  return b.employee_id.compareTo(a.employee_id);
                }
              case 'firstName':
                if (sort_ascending_attendacne == true) {
                  return a.firstName.compareTo(b.firstName);
                } else {
                  return b.firstName.compareTo(a.firstName);
                }
              case 'lastName':
                if (sort_ascending_attendacne == true) {
                  return a.lastName.compareTo(b.lastName);
                } else {
                  return b.lastName.compareTo(a.lastName);
                }
              default:
                return 0; // If the field is not recognized, no sorting is applied
            }
          });
          
        } else {
          
          if (return_all_data_for_all_days == true) {
            
            new_attendance.sort((a, b) => (a.date - b.date));
          } else {
            
            new_attendance.sort((a, b) => (a.employee_id - b.employee_id));
          }
        }

        if (days_of_attendance_for_a_specific_employee == true) {
          new_attendance.sort((a, b) => (a.date - b.date));
        }

        return_all_data_for_all_days = false;
        search_text_in_new_attendance = "";
        search_in_new_attendance = false;
        
        return "ahmed";
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }
}
