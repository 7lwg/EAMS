// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:graduation_project/Screen/Splash_Screen.dart';
import 'package:graduation_project/functions/drawer.dart';
import 'package:graduation_project/functions/style.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  List options = [
    "Tack Attendance",
    "My data",
    "Salary & Ratting",
    "Ask for holiday"
  ];

  List icons = [
    Icons.photo_camera,
    Icons.paste_rounded,
    Icons.attach_money_outlined,
    Icons.festival_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final landscape = mediaQuery.orientation == Orientation.landscape;
    return SafeArea(
      child: Scaffold(
        drawer: myDrawer(),
        appBar: AppBar(
          toolbarHeight: (landscape)
              ? mediaQuery.size.height * (100 / 800)
              : mediaQuery.size.height * (70 / 800),
          backgroundColor: const Color.fromRGBO(50, 50, 160, 1),
          leading: Builder(builder: (context) {
            return IconButton(
              color: Colors.black,
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(Icons.menu),
            );
          }),
          automaticallyImplyLeading: false,
          title: Text(
            'Employee Mangement System',
            style: (landscape)
                ? getTextBlackHeader(context)
                : getTextBlack(context),
          ),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: mediaQuery.size.height * 1 / 5,
              alignment: Alignment.center,
              child: Text(
                "Hi ${User_Name}",
                style: getTextBlack(context),
              ),
            ),
            Expanded(
              child: Container(
                width: mediaQuery.size.width,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blueGrey,
                ),
                child: Column(
                  children: [
                    for (int i = 0; i < 4; i++)
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(5)),
                        margin: (landscape)
                            ? EdgeInsets.all(5)
                            : EdgeInsets.all(10),
                        width: mediaQuery.size.width * 0.9,
                        height: mediaQuery.size.height * 1 / 10,
                        child: TextButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0)),
                            ),
                          ),
                          onPressed: () {},
                          child: Row(
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5)),
                                  width: mediaQuery.size.height / 20,
                                  height: mediaQuery.size.height / 20,
                                  child: FittedBox(
                                      child: Icon(
                                    icons[i],
                                    color: Colors.black,
                                  ))),
                              SizedBox(
                                width: mediaQuery.size.width * 1 / 30,
                              ),
                              Text(
                                options[i],
                                style: getTextBlack(context),
                              ),
                              Spacer(),
                              Container(
                                  padding: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5)),
                                  width: mediaQuery.size.height / 30,
                                  height: mediaQuery.size.height / 30,
                                  child: FittedBox(
                                      child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.black,
                                  ))),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
