import 'dart:convert';
import 'package:graduation_project/Screen/Splash_Screen.dart';
import 'package:graduation_project/data/Models/get_shifts_model.dart';
import 'package:graduation_project/data/Repository/get_users_Repo.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

List<String> shift_items = [];
List<int> shift_id_items = [];
String? selectedShiftItem_adding;
List<GetShiftsModel> shifts = [];
String search_shift_text = "";
bool deleted_shift = false;
bool adding_shift = false;
bool editing_shift = false;
String deleted_shift_id = "";
int editted_shift_id = 0;
String? selectedshiftItem = 'id';
String shift_Name = "";
String shift_Descreption = "";
String shift_Start_time = "";
String shift_End_time = "";
var postshiftData;
var putshiftData;
String url = "";
var shift_response;
var getting_number_of_shifts;
var editted_shift_index;

class GetShiftsRepo {
  final supabaseUrl = 'https://oarqjspwajbojrddcvky.supabase.co/rest/v1';
  final supabaseKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9hcnFqc3B3YWpib2pyZGRjdmt5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTE3Mzk2NTQsImV4cCI6MjAyNzMxNTY1NH0.NJ-QaQKrveyPpE2G9-8kizBh6ByFShdQ47xs2Bx8wmQ';

  Future<String?> getShiftsData() async {
    try {
      if (deleted_shift == true) {
        response = await http.delete(
          Uri.parse(
              '$supabaseUrl/shifts?id=eq.${deleted_shift_id}&companyName=eq.${Company_Name}'),
          headers: {'apikey': supabaseKey},
        );
        deleted_shift = false;
      } else if (adding_shift == true) {
        response = await http.post(
          Uri.parse('$supabaseUrl/shifts?companyName=eq.${Company_Name}'),
          body: jsonEncode(postshiftData),
          headers: {
            'Content-Type': 'application/json',
            'apikey': supabaseKey,
          },
        );
        adding_shift = false;
      } else if (editing_shift == true) {
        response = await http.put(
          Uri.parse('$supabaseUrl/shifts?id=eq.${editted_shift_id}'),
          body: jsonEncode(putshiftData),
          headers: {
            'Content-Type': 'application/json',
            'apikey': supabaseKey,
          },
        );
        editing_shift = false;
      }

      if (search_shift_text != "") {
        if (selectedshiftItem == 'id') {
          url =
              '$supabaseUrl/shifts?${selectedshiftItem}=eq.${search_shift_text}&companyName=eq.${Company_Name}';
        } else {
          url =
              '$supabaseUrl/shifts?${selectedshiftItem}=ilike.*${search_shift_text}*&companyName=eq.${Company_Name}';
        }
      } else {
     
        url = '$supabaseUrl/shifts?companyName=eq.${Company_Name}';
      }
      if (getting_number_of_shifts == true) {
        url = '$supabaseUrl/shifts';      
      }
      shift_response = await http.get(
        Uri.parse(url),
        headers: {'apikey': supabaseKey},
      );
      if (shift_response.statusCode == 200) {
        List<dynamic> decodedResponse = jsonDecode(shift_response.body);
        shifts = decodedResponse
            .map((json) => GetShiftsModel.fromJson(json))
            .toList();


        if (sort == true) {
          shifts.sort((a, b) {
            switch (selectedshiftItem) {
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
          shifts.sort((a, b) => a.id.compareTo(b.id));
        }      

        final prefs = await SharedPreferences.getInstance();
        prefs.setString('Shifts_number', (shifts.length).toString());
        return "ahmed";
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }
}
