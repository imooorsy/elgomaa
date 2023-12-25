import 'package:elgomaa/modules/search_screen/search_screen.dart';
import 'package:elgomaa/shared/componants/componants.dart';
import 'package:elgomaa/shared/network/local/local_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elgomaa/layout/cubit/cubit.dart';
import 'package:elgomaa/layout/cubit/states.dart';

class ShopLayout extends StatelessWidget {
  late final LocalNotificationService service;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        ShopCubit cubit = ShopCubit.get(context);
        cubit.notificationServices.intialize();
        return Scaffold(
          appBar: AppBar(
            title: const Row(
              children: [
                Icon(
                  Icons.shopping_basket,
                  size: 40,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "El",
                  style: TextStyle(fontSize: 40, color: Colors.amber),
                ),
                Text(
                  "gomaa",
                  style: TextStyle(fontSize: 40, color: Colors.black),
                ),
              ],
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    navigatorGoto(context, const SearchScreen());
                  },
                  icon: const Icon(
                    Icons.search,
                    size: 40,
                  )),
              const SizedBox(
                width: 10,
              ),
              IconButton(
                  onPressed: () {
                    cubit.notificationServices.showNotification(id: 1, title: 'this is title', body: 'this is body');
                  },
                  icon: const Icon(
                    Icons.notifications,
                    size: 40,
                  )),
            ],
          ),
          body: cubit.shopScreens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_filled), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.category), label: 'Categories'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.favorite), label: 'Favorite'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: 'Profile'),
            ],
            onTap: (index) {
              cubit.changeBottomNav(index);
            },
          ),
        );
      },
    );

  }
}
