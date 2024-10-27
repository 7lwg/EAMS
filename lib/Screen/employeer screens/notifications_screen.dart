import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final landscape = mediaQuery.orientation == Orientation.landscape;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: (landscape)
            ? mediaQuery.size.height * (100 / 800)
            : mediaQuery.size.height * (70 / 800),
        title: Text(
          'Notifications',
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
          ),
        ),
      ),
    );
  }
}
