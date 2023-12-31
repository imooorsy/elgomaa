import 'package:buildcondition/buildcondition.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:elgomaa/layout/cubit/cubit.dart';
import 'package:elgomaa/layout/cubit/states.dart';
import 'package:elgomaa/modules/cart_screen/cart_screen.dart';
import 'package:elgomaa/shared/componants/componants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:badges/badges.dart' as bdg;

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is ShopConnectionErrorState) {
          showSnackBar(context, "لا يتوفر اتصال بالانترنت", SnackState.ERROR);
        }
      },
      builder: (context, state) {
        ShopCubit cubit = ShopCubit.get(context);
        return Scaffold(
          backgroundColor: Colors.amber,
          appBar: AppBar(
            leadingWidth: 70,
            title: const Text('رجوع',style: TextStyle(fontSize: 25,color: Colors.black45),),
            titleSpacing: 0,
            leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back_ios,size: 30,)),
            actions: [
              bdg.Badge(
                position: bdg.BadgePosition.topEnd(top: 0, end: -2),
                showBadge: true,
                ignorePointer: false,
                onTap: () {
                  navigatorGoto(context, const CartScreen());
                },
                badgeContent:const Text('2',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                badgeAnimation: const bdg.BadgeAnimation.rotation(
                  animationDuration: Duration(seconds: 1),
                  colorChangeAnimationDuration: Duration(seconds: 1),
                  loopAnimation: false,
                  curve: Curves.fastOutSlowIn,
                  colorChangeAnimationCurve: Curves.easeInCubic,
                ),
                badgeStyle: const bdg.BadgeStyle(
                  shape: bdg.BadgeShape.circle,
                  badgeColor: Colors.red,
                  padding: EdgeInsets.all(8),
                  borderSide: BorderSide(color: Colors.white, width: 1),
                  elevation: 0,
                ),
                child: IconButton(onPressed: (){}, icon: const Icon(Icons.shopping_cart,size: 40,)),
              ),
              const SizedBox(width: 10,)
            ],
          ),
          body:BuildCondition(
            condition: state is! ShopLoadingGetProductState,
            builder: (context) => SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(color: Colors.white,borderRadius: BorderRadius.only(bottomRight: Radius.circular(50),bottomLeft: Radius.circular(50))),
                    child:productPageBuilder(context,cubit),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    child: Text(cubit.productModel!.data!.description!,style: const TextStyle(fontSize: 25,color: Colors.white),textAlign: TextAlign.right,),
                  )
                ],
              ),
            ),
            fallback: (context) => const Center(child: CircularProgressIndicator(color: Colors.white,)),
          ),

        );
      },
    );
  }

  Widget productPageBuilder(context,ShopCubit cubit) =>
      SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              items: cubit.productModel!.data!.images!
                  .map((e) => CachedNetworkImage(
                imageUrl: e.toString(),
                errorWidget: (context, text, dynamic) => Image.asset(
                  "assets/image/PngItem_5585968.png",
                  width: double.infinity,
                ),
                progressIndicatorBuilder: (context, msg, progress) =>
                    const Center(
                        child: CircularProgressIndicator(
                          color: Colors.amber,
                        )),
                width: double.infinity,
              ))
                  .toList(),
              options: CarouselOptions(
                height: 300,
                viewportFraction: 1,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                enlargeFactor: 0.3,
                scrollDirection: Axis.horizontal,
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              child: Column(
                textDirection: TextDirection.rtl,
                children: [
                  Text(
                    cubit.productModel!.data!.name!,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${cubit.productModel!.data!.price!}\$',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 22.0, color: Colors.amber),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        if (cubit.productModel!.data!.discount! != 0)
                          Text(
                            '${cubit.productModel!.data!.oldPrice!}\$',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 20.0,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough),
                          ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            cubit.changeFavorites(cubit.productModel!.data!.id!, context);
                          },
                          icon: Icon(
                            Icons.favorite,
                            size: 40,
                            color: cubit.favorites[cubit.productModel!.data!.id!]!
                                ? Colors.red
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20,),
                  defultButton(pressfunction: (){}, text: 'add to cart',background: Colors.black)
                ],
              ),
            ),
          ],
        ),
      );
}
