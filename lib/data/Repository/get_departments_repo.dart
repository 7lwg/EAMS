import 'dart:convert';
import 'package:graduation_project/Screen/Splash_Screen.dart';
import 'package:graduation_project/data/Models/get_departments_model.dart';
import 'package:graduation_project/data/Repository/get_users_Repo.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

List<GetDepartmentsModel> departments = [];

List<String> department_items = [];
List<int> department_id_items = [];
String? selectedDepartmentItem_adding;
String search_department_text = "";
bool deleted_department = false;
bool adding_department = false;
bool editing_department = false;
String deleted_department_id = "";
int editted_department_id = 0;
String? selectedDepartmentItem = 'id';
String Department_Name = "";
String Department_Descreption = "";
var postDepartmentData;
var putDepartmentData;
var response;
String url = "";
var getting_number_of_departments;
var editted_department_index;
// getting the total number of departments by getting the whole data in department table for all companies and getting the size of it then getting the data of my company only again

class GetDepartmentsRepo {
  final supabaseUrl = 'https://oarqjspwajbojrddcvky.supabase.co/rest/v1';
  final supabaseKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9hcnFqc3B3YWpib2pyZGRjdmt5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTE3Mzk2NTQsImV4cCI6MjAyNzMxNTY1NH0.NJ-QaQKrveyPpE2G9-8kizBh6ByFShdQ47xs2Bx8wmQ';
  Future<String?> getDepartmentsData() async {
    try {
      if (deleted_department == true) {
        response = await http.delete(
          Uri.parse(
              '$supabaseUrl/departments?id=eq.${deleted_department_id}&companyName=eq.${Company_Name}'),
          headers: {'apikey': supabaseKey},
        );
        deleted_department = false;
      } else if (adding_department == true) {      
        response = await http.post(
          Uri.parse('$supabaseUrl/departments'),
          body: jsonEncode(postDepartmentData),
          headers: {
            'Content-Type': 'application/json',
            'apikey': supabaseKey,
          },
        );
        adding_department = false;
      } else if (editing_department == true) {
        response = await http.put(
          Uri.parse('$supabaseUrl/departments?id=eq.${editted_department_id}'),
          body: jsonEncode(putDepartmentData),
          headers: {
            'Content-Type': 'application/json',
            'apikey': supabaseKey,
          },
        );
        editing_department = false;
      }

      if (search_department_text != "") {
        if (selectedDepartmentItem == 'id') {
          url =
              '$supabaseUrl/departments?${selectedDepartmentItem}=eq.${search_department_text}&companyName=eq.${Company_Name}';
        } else {
          url =
              '$supabaseUrl/departments?${selectedDepartmentItem}=ilike.*${search_department_text}*&companyName=eq.${Company_Name}';
        }
      } else {
        url = '$supabaseUrl/departments?companyName=eq.${Company_Name}';
      }

      if (getting_number_of_departments == true) {
        url = '$supabaseUrl/departments';
       
      }
      var department_response = await http.get(
        Uri.parse(url),
        headers: {'apikey': supabaseKey},
      );
      if (department_response.statusCode == 200) {
        List<dynamic> decodedResponse = jsonDecode(department_response.body);
        departments = decodedResponse
            .map((json) => GetDepartmentsModel.fromJson(json))
            .toList();

        
        if (sort == true) {
          departments.sort((a, b) {
            switch (selectedDepartmentItem) {
              case 'id':
                if (sort_ascending == true) {
                  return a.id.compareTo(b.id);
                } else {
                  return b.id.compareTo(a.id);
                }

              case 'Name':
                if (sort_ascending == true) {
                  return a.name.compareTo(b.name);
                } else {
                  return b.name.compareTo(a.name);
                }

              case 'Description':
                if (sort_ascending == true) {
                  return a.description.compareTo(b.description);
                } else {
                  return b.description.compareTo(a.description);
                }
              default:
                return 0; // If the field is not recognized, no sorting is applied
            }
          });
        } else {
          departments.sort((a, b) => a.id.compareTo(b.id));
        }

        final prefs = await SharedPreferences.getInstance();
        prefs.setString('Departments_number', (departments.length).toString());
        return "ahmed";
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }
}
