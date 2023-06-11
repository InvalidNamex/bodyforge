import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../widgets/video_banner_widget.dart';
import '/controllers/home_controller.dart';
import '/widgets/featured_coach_widget.dart';
import '../constants.dart';
import '../widgets/apps_widget.dart';
import '../widgets/books_widget.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/services.dart';
import 'package:neon/neon.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => HomeController());
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > pageWidth) {
            return Center(
              child: Container(
                width: pageWidth,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: buildContent(context, controller),
              ),
            );
          } else {
            return buildContent(context, controller);
          }
        },
      ),
    );
  }
}

Widget buildContent(context, HomeController controller) => Obx(
      () => controller.coachList.isEmpty
          ? const Center(
              child: SpinKitPumpingHeart(
                color: Colors.red,
              ),
            )
          : Container(
              alignment: Alignment.center,
              constraints: BoxConstraints(maxWidth: pageWidth),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/home-bg.png'),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      backgroundColor: Colors.black.withOpacity(0.7),
                      color: Colors.red,
                      onRefresh: () async {
                        await homeController.getFeaturedCoaches();
                        await homeController.getBooks();
                        await homeController.getApps();
                      },
                      child: ListView(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(bottom: 5),
                            color: Colors.black,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Get.toNamed('/pricing');
                                  },
                                  child: const Row(
                                    children: [
                                      Icon(
                                        Icons.monetization_on_outlined,
                                        color: Colors.red,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'Pricing',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    var bytes = await rootBundle.load(
                                        "images/policies.pdf"); // location of your asset file
                                    final blob =
                                        html.Blob([bytes], 'application/pdf');
                                    final url =
                                        html.Url.createObjectUrlFromBlob(blob);
                                    html.window.open(url, "_blank");
                                    html.Url.revokeObjectUrl(url);
                                  },
                                  child: const Row(
                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        color: Colors.red,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'policies',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                    onTap: () async {
                                      Uri url = Uri.parse(
                                          'https://linktr.ee/a7madhassan');
                                      if (!await launchUrl(url)) {
                                        Get.snackbar(
                                            'Error', 'Please contact support');
                                      }
                                    },
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.call,
                                          color: Colors.red,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'Contact Us',
                                          style: TextStyle(color: Colors.white),
                                        )
                                      ],
                                    ))
                              ],
                            ),
                          ),
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
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.black.withOpacity(0.8),
                                              Colors.black.withOpacity(0.6),
                                              Colors.black.withOpacity(0.3),
                                              Colors.black.withOpacity(0.0),
                                            ],
                                            stops: const [0.0, 0.4, 0.6, 1.0],
                                          ),
                                        ),
                                        padding: const EdgeInsets.only(top: 20),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset('images/icon.png'),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Neon(
                                              text: 'BodyForge',
                                              color: Colors.red,
                                              fontSize: 32,
                                              font: NeonFont.Membra,
                                              flickeringText: true,
                                              flickeringLetters: const [
                                                0,
                                                4,
                                                8
                                              ],
                                            ),
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
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Featured Coaches:',
                                  style: GoogleFonts.aclonica(
                                      fontSize: 24, color: Colors.white),
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
                                        fontSize: 14,
                                        color: Colors.red.shade700),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FeaturedCoachWidget(
                              coaches: controller.coachList,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Free Books:',
                              style: GoogleFonts.aclonica(
                                  fontSize: 24, color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: BookWidget(
                              books: controller.bookList,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Useful Applications:',
                              style: GoogleFonts.aclonica(
                                  fontSize: 24, color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: AppWidget(
                              apps: controller.appList,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
