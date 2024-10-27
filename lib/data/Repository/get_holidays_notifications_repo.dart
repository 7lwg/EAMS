import 'dart:convert';
import 'package:graduation_project/Screen/Splash_Screen.dart';
import 'package:graduation_project/data/Models/get_holidays_asks_model.dart';
import 'package:http/http.dart' as http;

List<GetHolidaysAsksModel> notifications = [];
String url = "";
var response;
bool get_notifications = false;
bool delete_notification = false;
int specific_notification_index = 0;

class GetNotificationsRepo {
  final supabaseUrl = 'https://oarqjspwajbojrddcvky.supabase.co/rest/v1';
  final supabaseKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9hcnFqc3B3YWpib2pyZGRjdmt5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTE3Mzk2NTQsImV4cCI6MjAyNzMxNTY1NH0.NJ-QaQKrveyPpE2G9-8kizBh6ByFShdQ47xs2Bx8wmQ';
  Future<String?> getNotificationsData() async {  
    try {
      if (delete_notification) {
        response = await http.delete(
          Uri.parse(
              '$supabaseUrl/ask_for_holiday?id=eq.${notifications[specific_notification_index].id}&company_name=eq.${Company_Name}'),
          headers: {'apikey': supabaseKey},
        );
        delete_notification = false;
      }

      url = '$supabaseUrl/ask_for_holiday?company_name=eq.${Company_Name}';
      var notification_response = await http.get(
        Uri.parse(url),
        headers: {'apikey': supabaseKey},
      );

      if (notification_response.statusCode == 200) {
        List<dynamic> decodedResponse = jsonDecode(notification_response.body);
        notifications = decodedResponse
            .map((json) => GetHolidaysAsksModel.fromJson(json))
            .toList();
        notifications.sort((a, b) => a.id - b.id);

        return "ahmed";
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }
}
