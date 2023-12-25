import 'package:elgomaa/modules/login_screen/login_screen.dart';
import 'package:elgomaa/shared/componants/componants.dart';
import 'package:elgomaa/shared/network/local/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

ThemeData lightTheme = ThemeData(
  primarySwatch: Colors.amber,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 30,
    ),
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ),
    backgroundColor: Colors.white,
    elevation: 0.0,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    elevation: 20,
    selectedItemColor: Colors.green,
    showSelectedLabels: false,
  ),
  textTheme: const TextTheme(
      headline1: TextStyle(
        fontSize: 23,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      )
  ),
);
ThemeData darkTheme = ThemeData(
  primarySwatch: Colors.amber,
  scaffoldBackgroundColor: HexColor('444444'),
  appBarTheme: AppBarTheme(
    titleTextStyle: const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 30,
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: HexColor('444444'),
      statusBarIconBrightness: Brightness.light,
    ),
    backgroundColor: HexColor('444444'),
    elevation: 0.0,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    elevation: 0.0,
    backgroundColor: HexColor('444444'),
    selectedItemColor: Colors.green,
    unselectedItemColor: Colors.grey,
    showSelectedLabels: false,
  ),
  textTheme: const TextTheme(
      headline1: TextStyle(
        fontSize: 23,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      )
  ),
);

ThemeData shopLightTheme = ThemeData(
  primarySwatch: Colors.amber,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 30,
    ),
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ),
    backgroundColor: Colors.white,
    elevation: 0.0,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    elevation: 20,
    selectedItemColor: Colors.amber,
    showSelectedLabels: false,
    unselectedItemColor: Colors.grey,
  ),
  textTheme: const TextTheme(
      headline1: TextStyle(
        fontSize: 23,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      )
  ),
);
String token = '';

void signOut (context) {
  CacheHelper.removeData(key: 'token').then((value) {
    navigateAndFinish(context, ShopLoginScreen());
    showSnackBar(context, 'تم تسجيل الخروج بنجاح', SnackState.SUCCESS);
  });
}

List<int> editStringList (List<String> list) {
  List<int> intList = [];
  for (int i = 0; i < list.length; i++) {
    if (list[i] == '1') {
      intList.add(1);
    }else if (list[i] == '2') {
      intList.add(2);
    }else if (list[i] == '3') {
      intList.add(3);
    }else if (list[i] == '4') {
      intList.add(4);
    }else if (list[i] == '5') {
      intList.add(5);
    }else if (list[i] == '6') {
      intList.add(6);
    }
  }

  return intList;
}