import 'package:elgomaa/layout/cubit/cubit.dart';
import 'package:elgomaa/layout/shop_layout.dart';
import 'package:elgomaa/modules/login_screen/login_screen.dart';
import 'package:elgomaa/modules/onbording_screen/onbording_screen.dart';
import 'package:elgomaa/shared/bloc_observer.dart';
import 'package:elgomaa/shared/componants/constants.dart';
import 'package:elgomaa/shared/network/local/cache_helper.dart';
import 'package:elgomaa/shared/network/remote/dio_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();

  bool? isdark = CacheHelper.getData(key: 'isDark');
  bool? onboarding = CacheHelper.getData(key: 'onBoarding');
  token = CacheHelper.getData(key: 'token')??'';
  Widget startwidget = OnboardingScreen();

  if(onboarding != null) {
    if(token != '') {
      startwidget = ShopLayout();
    } else {
      startwidget = ShopLoginScreen();
    }
  } else {
    startwidget = OnboardingScreen();
  }

  // Use cubits...
  runApp(MyApp(
    isDark: isdark,
    startWidget: startwidget,
  ));
}

class MyApp extends StatelessWidget {
  final bool? isDark;
  final Widget? startWidget;
  const MyApp({super.key, this.isDark,this.startWidget});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ShopCubit>(
      create: (BuildContext context) => ShopCubit()
        ..getCategories()
        ..getStartData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: shopLightTheme,
        home: startWidget,
      ),
    );
  }
}
