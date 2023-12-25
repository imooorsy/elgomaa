import 'package:buildcondition/buildcondition.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:elgomaa/modules/edit_password_screen/edit_password_screen.dart';
import 'package:elgomaa/shared/componants/componants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elgomaa/layout/cubit/cubit.dart';
import 'package:elgomaa/layout/cubit/states.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

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
            actions: [
              IconButton(
                  onPressed: () async {
                    if(cubit.editFormKey.currentState!.validate()) {
                      await cubit.updateUserData(context);
                    }
                  },
                  icon: const Icon(
                    Icons.save,
                    color: Colors.amber,
                    size: 40,
                  )),
              const SizedBox(
                width: 10,
              )
            ],
          ),
          body: BuildCondition(
            condition: state is! ShopLoadingUpdateUserState,
            builder: (context) => SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: cubit.editFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      const Text('Edit Your Profile.',
                          style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                      const SizedBox(
                        height: 20,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(150),
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            CachedNetworkImage(
                              imageUrl: 'https://picsum.photos/150',
                              errorWidget: (context, text, dynamic) => Image.asset(
                                "assets/image/PngItem_5585968.png",
                                width: 150,
                                height: 150,
                              ),
                              progressIndicatorBuilder: (context, msg, progress) =>
                                  const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.grey,
                                      )),
                              fit: BoxFit.cover,
                              width: 150,
                              height: 150,
                            ),
                            Container(
                              width: 150,
                              height: 40,
                              color: Colors.black45,
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 30,
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      defaultTextFormField(context,
                          controller: cubit.nameController,
                          keyboardtype: TextInputType.text, validator: (value) {
                            if (value.isEmpty) {
                              return 'Name Can\'t be empty';
                            } else {
                              return null;
                            }
                          },
                          prefix: Icons.person,
                          labelText: 'name'),
                      const SizedBox(
                        height: 30,
                      ),
                      defaultTextFormField(context,
                          controller: cubit.emailController,
                          keyboardtype: TextInputType.emailAddress,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your email';
                            } else if (!RegExp(
                                r'^[\w-\.]+@([\w-\.]+\.)+[\w]{2,4}')
                                .hasMatch(value!)) {
                              return 'Email Should be like salla@example.com \n Email can\'t contain * / - + % # \$ !';
                            }
                            return null;
                          },
                          prefix: Icons.email,
                          labelText: 'email'),
                      const SizedBox(
                        height: 30,
                      ),
                      defaultTextFormField(
                        context,
                        controller: cubit.phoneController,
                        keyboardtype: TextInputType.phone,
                        validator: (value) {
                          if(value.isEmpty) {
                            return 'phone can\'t be empty';
                          }else if (value.toString().length < 11 || value.toString().length > 11) {
                            return 'phone should be 11 number';
                          }else {
                            return null;
                          }
                        },
                        prefix: Icons.phone,
                        labelText: 'phone',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextButton(
                          onPressed: () {
                            navigatorGoto(context, const EditPasswordScreen());
                          },
                          child: const Text(
                            'edit password',
                            style: TextStyle(color: Colors.blue, fontSize: 20),
                          )),
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
