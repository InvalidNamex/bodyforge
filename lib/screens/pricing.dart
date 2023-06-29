import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '/widgets/scaffold_widget.dart';

import '../constants.dart';
import '../controllers/home_controller.dart';

class PricingScreen extends GetView<HomeController> {
  const PricingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        backgroundColor: darkColor.withOpacity(0.7),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'images/visa.png',
              height: 20,
              width: 55,
              fit: BoxFit.fill,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              'Pricing',
              style: TextStyle(color: lightColor),
            )
          ],
        ),
      ),
      buildContent: buildContent(context, controller),
    );
  }
}

Widget buildContent(context, HomeController controller) {
  final screenWidth = MediaQuery.of(context).size.width;
  final crossAxisCount = screenWidth < pageWidth ? 1 : 2;

  return RefreshIndicator(
    onRefresh: () async => await homeController.getWebPrices(),
    child: SafeArea(
        child: GridView.builder(
      padding: const EdgeInsets.all(10),
      shrinkWrap: true,
      itemCount: controller.webPriceList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return container(context, controller, index);
      },
    )),
  );
}

Widget container(context, HomeController controller, index) {
  return Container(
    alignment: Alignment.topCenter,
    padding: const EdgeInsets.all(20),
    margin: const EdgeInsets.all(20),
    decoration: const BoxDecoration(
        image: DecorationImage(
            colorFilter: ColorFilter.mode(Color(0x80000000), BlendMode.darken),
            image: AssetImage('images/plan-bg.png'),
            fit: BoxFit.fill)),
    child: Column(
      children: [
        Text(
          controller.webPriceList[index].planTitle,
          style: GoogleFonts.adamina(color: accentColor, fontSize: 24),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 5,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Text(
              controller.webPriceList[index].planText,
              style: GoogleFonts.cairoPlay(
                  color: lightColor, fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
              maxLines: 10,
            ),
          ),
        ),
        homeController.isLocal.value
            ? Text(
                '${controller.webPriceList[index].planPrice} L.E',
                style: GoogleFonts.cairo(
                    color: lightColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              )
            : Text(
                '${controller.webPriceList[index].planPriceUSD} \$',
                style: GoogleFonts.cairo(
                    color: lightColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
        ElevatedButton(
            onPressed: () {
              //TODO: add subscription
              homeController.isLocal.value
                  ? paymentController.makeRequest(
                      price:
                          controller.webPriceList[index].planPrice.toDouble(),
                      currency: 'EGP',
                      description: controller.webPriceList[index].planTitle)
                  : paymentController.makeRequest(
                      price:
                          controller.webPriceList[index].planPrice.toDouble(),
                      currency: 'USD',
                      description: controller.webPriceList[index].planTitle);
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(accentColor)),
            child: Text(
              'Subscribe',
              style: GoogleFonts.cairoPlay(
                  color: darkColor, fontWeight: FontWeight.bold, fontSize: 18),
            )),
      ],
    ),
  );
}
