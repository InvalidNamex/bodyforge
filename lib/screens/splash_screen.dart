import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import '../constants.dart';
import '../controllers/home_controller.dart';

class SplashScreen extends GetView<HomeController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future<String> getCountry() async {
      final response = await http.get(Uri.parse("http://ip-api.com/json"));
      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        final country = decodedResponse['country'];
        return country;
      } else {
        throw Exception('Failed to fetch country');
      }
    }

    Future.delayed(Duration.zero, () async {
      print(await getCountry());
      await precacheImage(
        const AssetImage('images/bg-banner3.png'),
        Get.context!,
      );
      await precacheImage(
        const AssetImage('images/bg-banner2.png'),
        Get.context!,
      );
      Get.offNamed('/index');
    });
    return Scaffold(
      backgroundColor: darkColor,
      body: Center(
        child: SpinKitPumpingHeart(
          color: accentColor,
        ),
      ),
    );
  }
}
