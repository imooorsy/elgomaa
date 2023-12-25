import 'package:flutter/material.dart';

Widget defaultTextFormField(
  context, {
  required TextEditingController controller,
  required TextInputType keyboardtype,
  ValueChanged<String>? submitFunction,
  required FormFieldValidator validator,
  required IconData prefix,
  required String labelText,
  bool isPassword = false,
  IconData? suflix,
  ValueChanged<String>? onchange,
  VoidCallback? suflixpressed,
  VoidCallback? onTap,
  String? value,
  bool autofocus = false,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: keyboardtype,
      autofocus: autofocus,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
        prefixIcon: Icon(prefix),
        suffixIcon: suflix != null
            ? IconButton(icon: Icon(suflix), onPressed: suflixpressed)
            : null,
        border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.amber, width: 5)),
      ),
      obscureText: isPassword,
      onFieldSubmitted: submitFunction,
      onChanged: onchange,
      onTap: onTap,
      validator: validator,
      style: Theme.of(context).textTheme.headline1,
    );

Widget defultButton({
  double width = double.infinity,
  double height = 50,
  Color background = Colors.amber,
  double borderRadius = 5.0,
  required Function() pressfunction,
  required String text,
}) =>
    Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: background,
      ),
      child: MaterialButton(
          onPressed: pressfunction,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 25,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          )),
    );


void navigatorGoto(context, Widget widget) => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ));

void navigateAndFinish(context, Widget widget) => Navigator.pushAndRemoveUntil(
    context, MaterialPageRoute(builder: (context) => widget), (route) => false);

enum SnackState { SUCCESS, ERROR, WARNING }

void showSnackBar(context, msg, SnackState state) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: chooseSnackColor(state),
    ));

Color chooseSnackColor(SnackState state) {
  Color color;
  switch (state) {
    case SnackState.SUCCESS:
      color = Colors.green;
      break;
    case SnackState.ERROR:
      color = Colors.red;
      break;
    case SnackState.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}
