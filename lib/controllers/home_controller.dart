import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  RxList<BookModel> bookList = RxList<BookModel>([]);
  RxList<AppModel> appList = RxList<AppModel>([]);
  List<WebPricingModel> webPriceList = const [
    WebPricingModel(
        planName: 'Bronze',
        planTitle: 'Monthly Plan',
        planPrice: 250,
        planText:
            'With monthly plan feel free to create as many diet plans and work-out plans for your clients and share it with them'),
    WebPricingModel(
        planName: 'Silver',
        planTitle: '6 Months Plan',
        planPrice: 1200,
        planText:
            'With 6 months plan you are saving 300 \n Create unlimited diet plans and work-out plans and share it with your clients'),
    WebPricingModel(
        planName: 'Gold',
        planTitle: '12 Months Plan',
        planPrice: 2000,
        planText:
            'Starting from gold plan get featured among our coaches for more opportunities to get new clients'),
    WebPricingModel(
        planName: 'Diamond',
        planTitle: '24 Months Plan',
        planPrice: 4000,
        planText:
            'With Diamond plan you get a free add for 14 days of being featured on our Home Page and alse be featured in out sponsored ads'),
  ];
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

  @override
  void onInit() async {
    await getFeaturedCoaches();
    await getBooks();
    await getApps();
    super.onInit();
  }

  @override
  void onClose() {
    // Dispose the controller when the controller is closed
    super.onClose();
  }
}
