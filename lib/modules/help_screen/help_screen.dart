import 'package:buildcondition/buildcondition.dart';
import 'package:elgomaa/models/fqa_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elgomaa/layout/cubit/cubit.dart';
import 'package:elgomaa/layout/cubit/states.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        ShopCubit cubit = ShopCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back_ios,size: 30,)),
            leadingWidth: 80,
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: const Text("Help & Support",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
          ),
          body: BuildCondition(
            condition: cubit.fqaModel != null,
            builder: (context) => ListView.separated(
              itemBuilder: (context, index) =>
                  buildQuestion(cubit.fqaModel!.data!.data![index], index),
              separatorBuilder: (context, index) => const SizedBox(
                height: 20,
              ),
              itemCount: cubit.fqaModel!.data!.data!.length,
            ),
            fallback: (context) => const Center(
                child: CircularProgressIndicator(
              color: Colors.amber,
            )),
          ),
        );
      },
    );
  }

  Widget buildQuestion(QData question, index) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          textDirection: TextDirection.rtl,
          children: [
            Text(
              question.question!,
              textAlign: TextAlign.start,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            Text(
              question.answer!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22),
            ),
          ],
        ),
      );
}
