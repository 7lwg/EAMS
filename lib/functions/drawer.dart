import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/Cubits/Search/search_cubit.dart';
import 'package:graduation_project/Screen/Login_Screen.dart';
import 'package:graduation_project/Screen/Splash_Screen.dart';
import 'package:graduation_project/Screen/setting.dart';
import 'package:graduation_project/data/Repository/get_companies_name_repo.dart';
import 'package:graduation_project/data/Repository/get_holidays_notifications_repo.dart';
import 'package:graduation_project/functions/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class myDrawer extends StatelessWidget {
  const myDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                  onPressed: () {
                    for (int i = 0; i < companies_name.length; i++) {
                      if (companies_name[i].name == Company_Name) {
                        editted_company_index = i;
                        editted_company_id = companies_name[i].id;
                      }
                    }
                    context.read<SearchCubit>().close_sort();
                    new_notifications_number = notifications.length;
                    Navigator.pop(
                      context,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => Setting(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.settings,
                    color: const Color.fromRGBO(50, 50, 160, 1),
                  )),
              Expanded(
                child: Container(
               
                  child: Center(
                    child: Container(
                        width: MediaQuery.of(context).size.width * 1 / 3,
                        height: MediaQuery.of(context).size.height * 1 / 15,
                        
                        child: FittedBox(
                            child: Text(
                          (Manger_logedin == true) ? "Admin" : "Employer",
                          style: TextStyle(
                              color: const Color.fromRGBO(50, 50, 160, 1),
                              fontWeight: FontWeight.w400),
                        ))),
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height * 1 / 5,
            padding: EdgeInsets.only(left: 10),
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Company Name : ${Company_Name}",
                  textAlign: TextAlign.left,
                ),
                if (Manger_logedin == true)
                  Text(
                    "User Name : ${Manger_Name}",
                    textAlign: TextAlign.start,
                  ),
                if (Manger_logedin != true)
                  Text(
                    "User Name : ${User_Name}",
                    textAlign: TextAlign.start,
                  ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 1 / 2,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                selectedCompany = null;
                context.read<SearchCubit>().close_sort();
                new_notifications_number = notifications.length;

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => LoginScreen(),
                  ),
                );
                final prefs = await SharedPreferences.getInstance();
                //manger logout
                prefs.setBool('Manger_logedin', false);
                prefs.setString('Manger_Name', "");
                Manger_Name = "";
                User_Name = "";
                //user logout
                prefs.setBool('customer_logedin', false);
                prefs.setString('User_Name', "");
                prefs.setString('Company_Name', "");
                lat = 0;
              },
              child: Text(
                "Logout",
                style: getTextWhite(context),
              ),
              style: ElevatedButton.styleFrom(
                  shadowColor: Colors.black,
                  elevation: 10,
                  backgroundColor: const Color.fromRGBO(50, 50, 160, 1),
                
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
