import 'package:buildcondition/buildcondition.dart';
import 'package:elgomaa/shared/componants/componants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elgomaa/layout/cubit/cubit.dart';
import 'package:elgomaa/layout/cubit/states.dart';

class EditPasswordScreen extends StatelessWidget {
  const EditPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        ShopCubit cubit = ShopCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 30,
                )),
            leadingWidth: 80,
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: const Text('change password',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
          ),
          body: BuildCondition(
            condition: state is! ShopLoadingChangePasswordState,
            builder: (context) => SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: cubit.editPasswordFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      defaultTextFormField(context,
                          controller: cubit.oldPasswordController,
                          keyboardtype: TextInputType.text,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'password Can\'t be empty';
                            } else if (value.toString().length < 6) {
                              return 'Password can\'t be less than 6';
                            }else {
                              return null;
                            }
                          },
                          autofocus: true,
                          isPassword: cubit.oldPasswordHide,
                          prefix: Icons.password,
                          suflix: cubit.oldPasswordHide ? Icons.visibility : Icons.visibility_off,
                          suflixpressed: (){
                            cubit.changePasswordShow(1);
                          },
                          labelText: 'current password'),
                      const SizedBox(
                        height: 30,
                      ),
                      defaultTextFormField(context,
                          controller: cubit.newPasswordController,
                          keyboardtype: TextInputType.text,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your new password';
                            } else if (value.toString().length < 6) {
                              return 'Password can\'t be less than 6';
                            }
                            return null;
                          },
                          isPassword: cubit.newPasswordHide,
                          suflix: cubit.newPasswordHide ? Icons.visibility : Icons.visibility_off,
                          suflixpressed: (){
                        cubit.changePasswordShow(2);
                          },
                          prefix: Icons.lock,
                          labelText: 'new password'),
                      const SizedBox(
                        height: 30,
                      ),
                      defaultTextFormField(
                        context,
                        controller: cubit.repeatNewPasswordController,
                        keyboardtype: TextInputType.text,
                        validator: (value) {
                          if(value.isEmpty) {
                            return 'Please enter your new password';
                          } else if (value.toString().length < 6) {
                            return 'Password can\'t be less than 6';
                          }else if(value != cubit.newPasswordController.text){
                            return 'Password did\'t match';
                          }
                          return null;
                        },
                        isPassword: cubit.repeatPasswordHide,
                        suflix: cubit.repeatPasswordHide ? Icons.visibility : Icons.visibility_off,
                        suflixpressed: (){
                          cubit.changePasswordShow(3);
                        },
                        prefix: Icons.lock,
                        labelText: 'repeat new password',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      defultButton(pressfunction: (){
                        if(cubit.editPasswordFormKey.currentState!.validate()) {
                          cubit.changePassword(context,cubit.oldPasswordController.text,cubit.newPasswordController.text);
                        }
                      }, text: 'Save Password',),
                    ],
                  ),
                ),
              ),
            ),
            fallback: (context) => const Center(child: CircularProgressIndicator(color: Colors.amber,)),
          ),
        );
      },
    );
  }
}
