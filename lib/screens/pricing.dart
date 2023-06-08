import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';
import '../controllers/home_controller.dart';

class PricingScreen extends GetView<HomeController> {
  const PricingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.7),
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
            const Text(
              'Pricing',
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
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

Widget buildContent(context, HomeController controller) {
  final screenWidth = MediaQuery.of(context).size.width;
  final crossAxisCount = screenWidth < pageWidth ? 1 : 2;

  return Container(
      padding: const EdgeInsets.all(5),
      alignment: Alignment.center,
      constraints: BoxConstraints(maxWidth: pageWidth),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/home-bg.png'),
          fit: BoxFit.fill,
        ),
      ),
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
      )));
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
    child: ListView(
      shrinkWrap: true,
      children: [
        Text(
          controller.webPriceList[index].planName,
          style: GoogleFonts.adamina(color: Colors.red, fontSize: 24),
          textAlign: TextAlign.center,
        ),
        Container(
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.all(5),
            color: Colors.red,
            child: Text(
              controller.webPriceList[index].planTitle,
              style: GoogleFonts.bebasNeue(color: Colors.white, fontSize: 28),
              textAlign: TextAlign.center,
            )),
        const SizedBox(
          height: 7,
        ),
        Text(
          controller.webPriceList[index].planText,
          style: GoogleFonts.cairoPlay(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.start,
          maxLines: 10,
        ),
        Text(
          controller.webPriceList[index].planPrice.toString(),
          style: GoogleFonts.cairo(
              color: Colors.red, fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
