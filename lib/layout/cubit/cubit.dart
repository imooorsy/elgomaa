import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:elgomaa/layout/cubit/states.dart';
import 'package:elgomaa/models/categories_model.dart';
import 'package:elgomaa/models/change_password_model.dart';
import 'package:elgomaa/models/favorite_model.dart';
import 'package:elgomaa/models/favorites_model.dart';
import 'package:elgomaa/models/fqa_model.dart';
import 'package:elgomaa/models/home_model.dart';
import 'package:elgomaa/models/product_model.dart';
import 'package:elgomaa/models/shop_search_model.dart';
import 'package:elgomaa/models/updateUserModel.dart';
import 'package:elgomaa/models/user_data_model.dart';
import 'package:elgomaa/modules/categories_screen/categories_screen.dart';
import 'package:elgomaa/modules/favourite_screen/favourite_screen.dart';
import 'package:elgomaa/modules/products_screen/products_screen.dart';
import 'package:elgomaa/modules/settings_screen/settings_screen.dart';
import 'package:elgomaa/shared/componants/componants.dart';
import 'package:elgomaa/shared/componants/constants.dart';
import 'package:elgomaa/shared/network/local/local_notification_service.dart';
import 'package:elgomaa/shared/network/remote/dio_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  // Bottom Nav Bar
  int currentIndex = 0;

  List<Widget> shopScreens = [
    const ProductsScreen(),
    const CategoriesScreen(),
    const FavouriteScreen(),
    const SettingsScreen(),
  ];

  void changeBottomNav(int index) {
    currentIndex = index;
    emit(ShopChangeBottomNavState());
    if(index == 2) getFavorites();
    if(index == 3) getUserData();
  }

  // Check Connection
  Future<ConnectivityResult> checkConnection() async {
    return await (Connectivity().checkConnectivity());
  }

  // Get Home Data

  HomeModel? homeModel;
  Map<int, bool> favorites = {};

  Future<void> getStartData() async {
    checkConnection().then((value) async {
      if (value != ConnectivityResult.none) {
        homeModel = null;
        emit(ShopLoadingHomeDataState());
        await DioHelper.getData(url: 'home', token: token).then((value) {
          homeModel = HomeModel.fromJson(value.data);
          for (var element in homeModel!.data!.products!) {
            favorites.addAll({
              element.id!: element.inFavorites!,
            });
          }
          emit(ShopSuccessHomeDataState());
        }).catchError((error) {
          emit(ShopConnectionErrorStartState());
        });
      } else {
        emit(ShopConnectionErrorStartState());
      }
    });
  }

  Future<void> getHomeData() async {
    checkConnection().then((value) async {
      if (value != ConnectivityResult.none) {
        homeModel = null;
        emit(ShopLoadingHomeDataState());
        await DioHelper.getData(url: 'home', token: token).then((value) {
          homeModel = HomeModel.fromJson(value.data);
          for (var element in homeModel!.data!.products!) {
            favorites.addAll({
              element.id!: element.inFavorites!,
            });
          }
          emit(ShopSuccessHomeDataState());
        }).catchError((error) {
          emit(ShopErrorHomeDataState());
        });
      } else {
        emit(ShopConnectionErrorState());
      }
    });
  }

  CategoriesModel? categoriesModel;
  Future<void> getCategories() async {
    checkConnection().then((value) async {
      if (value != ConnectivityResult.none) {
        categoriesModel = null;
        await DioHelper.getData(url: 'categories').then((value) {
          categoriesModel = CategoriesModel.fromJson(value.data);
          emit(ShopSuccessCategoriesState());
        }).catchError((error) {
          emit(ShopErrorCategoriesState());
        });
      } else {
        emit(ShopConnectionErrorState());
      }
    });
  }

  ChangeFavoriteModel? changeFavoriteModel;

  void changeFavorites(int productId, context) {
    favorites[productId] = !favorites[productId]!;
    emit(ShopSuccessChangeFavoritesState());

    DioHelper.postData(
      url: 'favorites',
      data: {
        'product_id': productId,
      },
      token: token,
    ).then((value) {
      changeFavoriteModel = ChangeFavoriteModel.fromJson(value.data);

      if (!changeFavoriteModel!.status!) {
        favorites[productId] = !favorites[productId]!;
        showSnackBar(context, changeFavoriteModel!.message, SnackState.ERROR);
      } else {
        getFavorites();
      }
      emit(ShopSuccessChangeFavoritesState());
    }).catchError((error) {
      favorites[productId] = !favorites[productId]!;
      emit(ShopErrorChangeFavoritesState());
    });
  }

  FavoritesModel? favoritesModel;

  Future<void> getFavorites() async {
    emit(ShopLoadingFavoritesState());
    checkConnection().then((value) async {
      if (value != ConnectivityResult.none) {
        favoritesModel = null;
        await DioHelper.getData(url: 'favorites',token: token).then((value) {
          favoritesModel = FavoritesModel.fromJson(value.data);
          emit(ShopSuccessFavoritesState());
        }).catchError((error) {
          emit(ShopErrorFavoritesState());
        });
      } else {
        emit(ShopConnectionErrorState());
      }
    });
  }

  UserDataModel? userDataModel;

  Future<void> getUserData() async {
    emit(ShopLoadingUserDataState());
    checkConnection().then((value) async {
      if (value != ConnectivityResult.none) {
        userDataModel = null;
        await DioHelper.getData(url: 'profile',token: token).then((value) {
          userDataModel = UserDataModel.fromJson(value.data);
          emit(ShopSuccessUserDataState());
        }).catchError((error) {
          emit(ShopErrorUserDataState());
        });
      } else {
        emit(ShopConnectionErrorState());
      }
    });
  }

  FQAModel? fqaModel;

  Future<void> getFQA() async {
    emit(ShopLoadingFQAState());
    checkConnection().then((value) async {
      if (value != ConnectivityResult.none) {
        fqaModel = null;
        await DioHelper.getData(url: 'faqs').then((value) {
          fqaModel = FQAModel.fromJson(value.data);
          emit(ShopSuccessFQAState());
        }).catchError((error) {
          emit(ShopErrorFQAState());
        });
      } else {
        emit(ShopConnectionErrorState());
      }
    });
  }

  var editFormKey = GlobalKey<FormState>();

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();

  UpdateUserModel? updateUserModel;

  Future<void> updateUserData(context) async {
    emit(ShopLoadingUpdateUserState());
    checkConnection().then((value) async {
      if (value != ConnectivityResult.none) {
        updateUserModel = null;
        await DioHelper.putData(url: 'update-profile',token: token,data: {
          'name':nameController.text,
          'phone':phoneController.text,
          'email':emailController.text
        }).then((value) {
          updateUserModel = UpdateUserModel.fromJson(value.data);
          if(updateUserModel!.status!) {
            emailController.text = updateUserModel!.data!.email!;
            phoneController.text = updateUserModel!.data!.phone!;
            nameController.text = updateUserModel!.data!.name!;
            userDataModel = UserDataModel.fromJson(value.data);
            showSnackBar(context, updateUserModel!.message, SnackState.SUCCESS);
          }else {
            showSnackBar(context, updateUserModel!.message, SnackState.ERROR);
          }
          emit(ShopSuccessUpdateUserState());
        }).catchError((error) {
          emit(ShopErrorUpdateUserState());
        });
      } else {
        emit(ShopConnectionErrorState());
      }
    });
  }

  var editPasswordFormKey = GlobalKey<FormState>();

  var oldPasswordController = TextEditingController();
  var newPasswordController = TextEditingController();
  var repeatNewPasswordController = TextEditingController();

  bool oldPasswordHide = true;
  bool newPasswordHide = true;
  bool repeatPasswordHide = true;

  void changePasswordShow(int passNum){
    if(passNum == 1) {
      oldPasswordHide = !oldPasswordHide;
    }else if(passNum == 2) {
      newPasswordHide = !newPasswordHide;
    }else if(passNum == 3) {
      repeatPasswordHide = !repeatPasswordHide;
    }
    emit(ShopChangePasswordShowState());
  }

  ChangePasswordModel? changePasswordModel;


  void changePassword(context, String oldPassword, String newPassword ) {
    emit(ShopLoadingChangePasswordState());

    DioHelper.postData(
      url: 'change-password',
      data: {
        'current_password': oldPassword,
        'new_password': newPassword,
      },
      token: token,
    ).then((value) {
      changePasswordModel = ChangePasswordModel.fromJson(value.data);

      if(changePasswordModel!.status!) {
        oldPasswordController.text = '';
        newPasswordController.text = '';
        repeatNewPasswordController.text = '';
        showSnackBar(context, changePasswordModel!.message, SnackState.SUCCESS);
      }else {
        showSnackBar(context, changePasswordModel!.message, SnackState.ERROR);
      }
      emit(ShopSuccessChangePasswordState());
    }).catchError((error) {
      emit(ShopErrorChangePasswordState());
    });
  }

  var searchController = TextEditingController();


  ShopSearchModel? shopSearchModel;


  void getSearch(String q) {
    emit(ShopLoadingGetSearchState());

    DioHelper.postData(
      url: 'products/search',
      data: {
        'text': q
      },
    ).then((value) {
      shopSearchModel = ShopSearchModel.fromJson(value.data);
      emit(ShopSuccessGetSearchState());
    }).catchError((error) {
      emit(ShopErrorGetSearchState());
    });

  }

  ProductModel? productModel;

  void getProduct(int productId) {

    emit(ShopLoadingGetProductState());

    DioHelper.getData(
      url: 'products/$productId',
    ).then((value) {
      productModel = ProductModel.fromJson(value.data);
      emit(ShopSuccessGetProductState());
    }).catchError((error) {
      favorites[productId] = !favorites[productId]!;
      emit(ShopErrorGetProductState());
    });
  }



  void getCarts(int productId) {

    emit(ShopLoadingGetProductState());

    DioHelper.postData(
      url: 'products/$productId',
      data: {
        'product_id' : productId
      },
      token: token,
    ).then((value) {
      productModel = ProductModel.fromJson(value.data);
      emit(ShopSuccessGetProductState());
    }).catchError((error) {
      favorites[productId] = !favorites[productId]!;
      emit(ShopErrorGetProductState());
    });
  }

  void addToCart(int productId) {

    emit(ShopLoadingGetProductState());

    DioHelper.postData(
      url: 'products/$productId',
      data: {
        'product_id' : productId
      },
      token: token,
    ).then((value) {
      productModel = ProductModel.fromJson(value.data);
      emit(ShopSuccessGetProductState());
    }).catchError((error) {
      favorites[productId] = !favorites[productId]!;
      emit(ShopErrorGetProductState());
    });
  }

  void updateCart(int productId) {

    emit(ShopLoadingGetProductState());

    DioHelper.postData(
      url: 'products/$productId',
      data: {
        'product_id' : productId
      },
      token: token,
    ).then((value) {
      productModel = ProductModel.fromJson(value.data);
      emit(ShopSuccessGetProductState());
    }).catchError((error) {
      favorites[productId] = !favorites[productId]!;
      emit(ShopErrorGetProductState());
    });
  }

  void deleteCart(int productId) {

    emit(ShopLoadingGetProductState());

    DioHelper.getData(
      url: 'products/$productId',
    ).then((value) {
      productModel = ProductModel.fromJson(value.data);
      emit(ShopSuccessGetProductState());
    }).catchError((error) {
      favorites[productId] = !favorites[productId]!;
      emit(ShopErrorGetProductState());
    });
  }

  LocalNotificationService notificationServices = LocalNotificationService();
}
