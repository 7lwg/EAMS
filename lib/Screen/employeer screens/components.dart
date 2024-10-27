import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';

Widget bottumItem({
  required VoidCallback ontaped,
  required String icon,
  required String text,
}) =>
    GestureDetector(
      onTap: ontaped,
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: 18,
        ),
        child: Container(
          padding: EdgeInsets.all(10),
          width: 146,
          height: 123,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: HexColor('#3232A0'),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(icon),
              Expanded(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

Widget defultFormField({
  required VoidCallback ontap,
  required TextEditingController controller,
  TextInputType keyboardtype = TextInputType.text,
  required String labeltext,
  required IconData prefixicon,
  required Function validator,
  bool readonly = false,
}) =>
    TextFormField(
      readOnly: readonly,
      onTap: ontap,
      controller: controller,
      keyboardType: keyboardtype,
      decoration: InputDecoration(
        labelText: labeltext,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        prefixIcon: Icon(
          prefixicon,
        ),
      ),
      validator: (value) => validator(value),
      strutStyle: StrutStyle(),
    );

showToast({
  required String txt,
  required toaststate state,
}) {
  Fluttertoast.showToast(
    msg: txt,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: ChoseColor(state),
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

enum toaststate { SUCCES, ERROR, WARNING }

Color ChoseColor(toaststate state) {
  switch (state) {
    case toaststate.SUCCES:
      return Colors.green;
    case toaststate.ERROR:
      return Colors.red;
    case toaststate.WARNING:
      return HexColor('3232A0');
  }
}
