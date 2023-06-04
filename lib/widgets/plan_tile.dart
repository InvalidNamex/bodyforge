import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neon/neon.dart';
import '../models/pricing_model.dart';

class PlanTile extends GetView {
  final PricingModel plan;
  final String coachName;
  const PlanTile({super.key, required this.plan, required this.coachName});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        plan.planImage == null
            ? container(context)
            : Image.network(
                plan.planImage!,
                fit: BoxFit.fill,
              ),
        const SizedBox(
          height: 5,
        ),
        Center(
          child: Text(
            plan.planPrice.toString(),
            style: GoogleFonts.aclonica(color: Colors.white, fontSize: 28),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        FittedBox(
          fit: BoxFit.fitWidth,
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red)),
            onPressed: () {
              Get.defaultDialog(
                  backgroundColor: Colors.black.withOpacity(0.8),
                  title: 'whatsapp us with a screenshot of your transaction',
                  titleStyle: const TextStyle(color: Colors.white),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'images/vfcash.webp',
                        height: 80,
                        width: 100,
                      ),
                      Text(
                        'Coach: $coachName',
                        style: GoogleFonts.aclonica(color: Colors.red),
                      ),
                      Text(
                        'Price: ${plan.planPrice}',
                        style: GoogleFonts.aclonica(color: Colors.white),
                      ),
                      Text(
                        'Number: +201002777664',
                        style: GoogleFonts.aclonica(color: Colors.red),
                      ),
                    ],
                  ));
            },
            child: Text(
              'Subscribe Now',
              style: GoogleFonts.aclonica(color: Colors.black, fontSize: 24),
            ),
          ),
        ),
      ],
    );
  }

  Widget container(context) {
    return Container(
      height: 400,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
          image: DecorationImage(
              colorFilter:
                  ColorFilter.mode(Color(0x80000000), BlendMode.darken),
              image: AssetImage('images/plan-bg.png'),
              fit: BoxFit.fill)),
      child: Column(
        children: [
          Text(
            'BODY FORGE',
            style: GoogleFonts.adamina(color: Colors.red, fontSize: 24),
          ),
          Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.all(5),
              color: Colors.red,
              child: Text(
                plan.planName!,
                style: GoogleFonts.bebasNeue(color: Colors.white, fontSize: 28),
              )),
          const SizedBox(
            height: 7,
          ),
          Text(
            plan.planTitle!,
            style: GoogleFonts.cairo(
                color: Colors.red, fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              plan.planText!,
              style: GoogleFonts.cairoPlay(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}
