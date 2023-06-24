import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:neon/neon.dart';
import '../widgets/ad_banner_widget.dart';
import '/widgets/scaffold_widget.dart';
import '../helpers/loader_helper.dart';
import '../widgets/pdf_viewer.dart';
import '../widgets/video_banner_widget.dart';
import '/controllers/home_controller.dart';
import '/widgets/featured_coach_widget.dart';
import '../constants.dart';
import '../widgets/apps_widget.dart';
import '../widgets/books_widget.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => HomeController());
    return MyScaffold(buildContent: buildContent(context, controller));
  }
}

Widget buildContent(context, HomeController controller) {
  return Obx(
    () => controller.coachList.isEmpty
        ? Center(
            child: loader(),
          )
        : SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      const VideoBannerWidget(),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.only(top: 20),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'images/favicon.png',
                                    fit: BoxFit.fitHeight,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'BODY FORGE',
                                    style: GoogleFonts.aclonica(
                                        fontWeight: FontWeight.bold,
                                        color: accentColor,
                                        fontSize: 32),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 30.0, horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Featured Coaches',
                        style: GoogleFonts.aclonica(
                            fontSize: 24, color: lightColor),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      InkWell(
                        onTap: () {
                          Get.toNamed('/coaches');
                        },
                        child: Text(
                          'all coaches',
                          style: GoogleFonts.aclonica(
                              fontSize: 14, color: accentColor),
                        ),
                      )
                    ],
                  ),
                ),
                FeaturedCoachWidget(
                  coaches: controller.coachList,
                ),
                controller.adBannersList.isEmpty
                    ? Container()
                    : const SizedBox(height: 250, child: AdBannerWidget()),
                Container(
                  height: MediaQuery.of(context).size.height,
                  alignment: Alignment.bottomCenter,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('images/bg-banner2.png'),
                        fit: BoxFit.fill),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 30.0, horizontal: 5),
                        child: Neon(
                          text: 'Educational Books',
                          color: Colors.yellow,
                          font: NeonFont.Monoton,
                        ),
                      ),
                      BookWidget(
                        books: controller.bookList,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height,
                  alignment: Alignment.bottomCenter,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('images/bg-banner3.png'),
                        fit: BoxFit.fill),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 30.0, horizontal: 5),
                          child: Neon(
                            text: 'Useful Applications',
                            color: Colors.yellow,
                            font: NeonFont.Monoton,
                          ),
                        ),
                        AppWidget(
                          apps: controller.appList,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 5),
                  color: darkColor.withOpacity(0.7),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.toNamed('/pricing');
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.monetization_on_outlined,
                              color: accentColor,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Pricing',
                              style: TextStyle(color: lightColor),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          Get.to(() => const MyPdfViewer());
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: accentColor,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              'policies',
                              style: TextStyle(color: lightColor),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                          onTap: () async {
                            Get.defaultDialog(
                                backgroundColor: darkColor,
                                title: 'Contact us',
                                titleStyle: GoogleFonts.aclonica(
                                  color: accentColor,
                                ),
                                content: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.email_outlined,
                                          color: accentColor,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        SelectableText(
                                          'support@bodyforge.site',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: lightColor),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                      child: Divider(
                                        thickness: 2,
                                        color: lightColor,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.phone,
                                          color: accentColor,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        SelectableText(
                                          '+201144960133',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: lightColor),
                                        )
                                      ],
                                    ),
                                  ],
                                ));
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.call,
                                color: accentColor,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Contact Us',
                                style: TextStyle(color: lightColor),
                              )
                            ],
                          )),
                      Image.asset(
                        'images/visa.png',
                        fit: BoxFit.contain,
                        height: 40,
                        width: 80,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
  );
}
