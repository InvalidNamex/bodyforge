import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '/controllers/home_controller.dart';

class AdBannerWidget extends GetView<HomeController> {
  const AdBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Obx(
        () => CarouselSlider.builder(
            itemCount: controller.adBannersList.length,
            itemBuilder: (context, index, pgIndex) => InkWell(
                  onTap: () async {
                    String? url = controller.adBannersList[index].bannerURL;
                    if (url != null) {
                      if (await canLaunchUrlString(url)) {
                        await launchUrlString(url);
                      } else {
                        Get.defaultDialog(
                          title: 'Sorry',
                          content: const Text('App is no longer available'),
                        );
                      }
                    }
                  },
                  child: Image.network(
                    controller.adBannersList[index].bannerImage!,
                    fit: BoxFit.fill,
                  ),
                ),
            options: CarouselOptions(
              height: 250,
              aspectRatio: 16 / 9,
              viewportFraction: 0.8,
              initialPage: 0,
              enableInfiniteScroll: true,
              scrollPhysics: const NeverScrollableScrollPhysics(),
              reverse: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 4),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.easeInOutCubicEmphasized,
              enlargeCenterPage: true,
              enlargeFactor: 0.3,
              scrollDirection: Axis.vertical,
            )),
      ),
    );
  }
}
