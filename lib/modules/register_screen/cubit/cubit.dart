import 'package:elgomaa/models/login_model.dart';
import 'package:elgomaa/modules/register_screen/cubit/states.dart';
import 'package:elgomaa/shared/componants/constants.dart';
import 'package:elgomaa/shared/componants/end_points.dart';
import 'package:elgomaa/shared/network/remote/dio_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialStates());

  static RegisterCubit get(context) => BlocProvider.of(context);

  IconData suflixIcon = Icons.visibility_outlined;
  IconData repeatSuflixIcon = Icons.visibility_outlined;

  bool isPassword = true;
  bool repeatPasswordHide = true;

  ShopLoginModel? loginMod;

  void userRegister(
    context, {
    required String name,
    required String phone,
    required String email,
    required String password,
  }) {
    emit(RegisterLoadingStates());
    DioHelper.postData(url: REGISTER, data: {
      'name': name,
      'phone': phone,
      'email': email,
      'password': password,
    }).then((value) {
      loginMod = ShopLoginModel.fromJson(value.data);
      token = loginMod!.data!.token!;
      emit(RegisterSuccessStates(loginMod!));
    }).catchError((error) {
      print("sign up error $error");
      emit(RegisterErrorStates(error.toString()));
    });
  }

  void changePasswordShow(int num) {
    if (num == 1) {
      isPassword = !isPassword;
      suflixIcon = isPassword
          ? Icons.visibility_outlined
          : Icons.visibility_off_outlined;
    } else {
      repeatPasswordHide = !repeatPasswordHide;
      repeatSuflixIcon = repeatPasswordHide
          ? Icons.visibility_outlined
          : Icons.visibility_off_outlined;
    }

    emit(RegisterChangePasswordShowStates());
  }
}
