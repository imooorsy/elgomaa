import 'package:buildcondition/buildcondition.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:elgomaa/layout/cubit/cubit.dart';
import 'package:elgomaa/layout/cubit/states.dart';
import 'package:elgomaa/models/categories_model.dart';
import 'package:elgomaa/models/home_model.dart';
import 'package:elgomaa/modules/product_page/product_Screen.dart';
import 'package:elgomaa/shared/componants/componants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

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
          body: BuildCondition(
            condition: state is! ShopConnectionErrorStartState,
            builder: (context) => BuildCondition(
              condition:
                  cubit.homeModel != null && cubit.categoriesModel != null,
              builder: (context) => RefreshIndicator(
                  displacement: 100,
                  color: Colors.amber,
                  onRefresh: cubit.getHomeData,
                  child: productBuilder(
                      cubit.homeModel, cubit.categoriesModel, cubit, context)),
              fallback: (context) => const Center(
                  child: CircularProgressIndicator(
                color: Colors.amber,
              )),
            ),
            fallback: (context) => RefreshIndicator(
                displacement: 100,
                color: Colors.amber,
                onRefresh: cubit.getStartData,
                child: ListView(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.4,
                        ),
                        const Center(
                            child: Text(
                          "No Internet !\n pull to Refresh",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        )),
                      ],
                    ),
                  ],
                )),
          ),
        );
      },
    );
  }

  Widget productBuilder(HomeModel? model, CategoriesModel? categories,
          ShopCubit cubit, context) =>
      SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              items: model!.data!.banners!
                  .map((e) => CachedNetworkImage(
                        imageUrl: e.image.toString(),
                        fit: BoxFit.cover,
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
                height: 220,
                viewportFraction: 1,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 5),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                enlargeFactor: 0.3,
                scrollDirection: Axis.horizontal,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Categories",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 100.0,
                    child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) =>
                            buildCategoryItem(categories.data!.data![index]),
                        separatorBuilder: (context, index) => const SizedBox(
                              width: 5,
                            ),
                        itemCount: categories!.data!.data!.length),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "News Products",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.grey[300],
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 5.0,
                crossAxisSpacing: 5.0,
                childAspectRatio: 1 / 1.6,
                crossAxisCount: 2,
                children: List.generate(
                  model.data!.products!.length,
                  (index) => gridProductBuilder(
                      model.data!.products![index], cubit, context),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            CachedNetworkImage(
              imageUrl: model.data!.ad!,
              fit: BoxFit.cover,
              errorWidget: (context, text, dynamic) => Image.asset(
                "assets/image/PngItem_5585968.png",
                width: double.infinity,
                height: 10,
              ),
              progressIndicatorBuilder: (context, msg, progress) => const Center(
                  child: CircularProgressIndicator(
                color: Colors.amber,
              )),
              width: double.infinity,
              height: 100,
            ),
          ],
        ),
      );

  Widget buildCategoryItem(DataModel? model) => SizedBox(
        width: 100,
        height: 100,
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: model!.image!,
              fit: BoxFit.cover,
              errorWidget: (context, text, dynamic) => Image.asset(
                "assets/image/PngItem_5585968.png",
                width: 100.0,
                height: 100.0,
              ),
              progressIndicatorBuilder: (context, msg, progress) => const Center(
                  child: CircularProgressIndicator(
                color: Colors.amber,
              )),
              width: double.infinity,
              height: double.infinity,
            ),
            Container(
                color: Colors.black54,
                width: double.infinity,
                child: Text(
                  model.name.toString(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )),
          ],
        ),
      );
  Widget gridProductBuilder(Products product, ShopCubit cubit, context) =>
      InkWell(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            textDirection: TextDirection.rtl,
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CachedNetworkImage(
                    imageUrl: product.image.toString(),
                    errorWidget: (context, text, dynamic) => Image.asset(
                      "assets/image/PngItem_5585968.png",
                      width: double.infinity,
                    ),
                    progressIndicatorBuilder: (context, msg, progress) => const Center(
                        child: CircularProgressIndicator(
                      color: Colors.amber,
                    )),
                    width: double.infinity,
                    height: 200,
                  ),
                  if (product.discount != 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      color: Colors.red,
                      child: Text(
                        "خصم ${product.discount}%",
                        style: const TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
                    ),
                ],
              ),
              Expanded(
                child: Text(
                  product.name.toString(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 20.0, height: 1.3),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        '${product.price.toString()}\$',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 18.0, color: Colors.amber),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    if (product.discount != 0)
                      Text(
                        '${product.oldPrice.toString()}\$',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough),
                      ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        cubit.changeFavorites(product.id!, context);
                      },
                      icon: Icon(
                        Icons.favorite,
                        size: 40,
                        color: cubit.favorites[product.id]!
                            ? Colors.red
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        onTap: (){
          cubit.getProduct(product.id!);
          navigatorGoto(context, const ProductScreen());
        },
      );
}
