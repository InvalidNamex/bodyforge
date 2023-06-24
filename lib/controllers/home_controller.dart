import 'dart:async';

import 'package:get/get.dart';
import 'package:ifit/models/ad_banner_model.dart';
import 'package:ifit/models/web_pricing_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/app_model.dart';
import '../models/book_model.dart';
import '../models/coach_model.dart';
import '../models/product_model.dart';

class HomeController extends GetxController {
  static HomeController instance = Get.find();
  RxString policiesString = ''.obs;
  final supabase = Supabase.instance.client;
  RxBool isButtonVisible = false.obs;
  RxList<CoachModel> coachList = RxList<CoachModel>([]);
  RxList<ProductModel> productList = RxList<ProductModel>([]);
  RxList<AdBannerModel> adBannersList = RxList<AdBannerModel>([]);
  RxList<BookModel> bookList = RxList<BookModel>([]);
  RxList<AppModel> appList = RxList<AppModel>([]);
  RxBool isLocal = true.obs;
  List<WebPricingModel> webPriceList = RxList<WebPricingModel>([]);
  Future getFeaturedCoaches() async {
    coachList.clear();
    final data =
        await supabase.from('coaches').select().eq('coach_isFeatured', true);
    for (var coach in data) {
      coachList.add(CoachModel.fromJson(coach));
    }
  }

  Future getProducts() async {
    productList.clear();
    final data = await supabase.from('products').select();
    for (var product in data) {
      productList.add(ProductModel.fromJson(product));
    }
  }

  Future getBooks() async {
    bookList.clear();
    final data = await supabase.from('books').select();
    for (var book in data) {
      bookList.add(BookModel.fromJson(book));
    }
  }

  Future getApps() async {
    appList.clear();
    final data = await supabase.from('apps').select();
    for (var app in data) {
      appList.add(AppModel.fromJson(app));
    }
  }

  Future getWebPrices() async {
    webPriceList.clear();
    final data = await supabase.from('bodyforge_plans').select();
    for (var plan in data) {
      webPriceList.add(WebPricingModel.fromJson(plan));
    }
  }

  Future getAdBanners() async {
    adBannersList.clear();
    final data = await supabase.from('ad_banners').select();
    for (var ad in data) {
      adBannersList.add(AdBannerModel.fromJson(ad));
    }
  }

  @override
  void onInit() async {
    await getAdBanners();
    await getFeaturedCoaches();
    await getBooks();
    await getApps();
    await getWebPrices();
    super.onInit();
  }

  @override
  void onClose() {
    // Dispose the controller when the controller is closed
    super.onClose();
  }
}
