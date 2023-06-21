import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants.dart';
import '../models/pricing_model.dart';

class PlanTile extends GetView {
  final PricingModel plan;
  final String coachName;
  const PlanTile({super.key, required this.plan, required this.coachName});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
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
        FittedBox(
          fit: BoxFit.fitWidth,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(accentColor),
            ),
            onPressed: () {
              //TODO: payments
            },
            child: Text(
              'Subscribe Now',
              style: GoogleFonts.aclonica(color: darkColor, fontSize: 24),
            ),
          ),
        ),
      ],
    );
  }

  Widget container(context) {
    return Container(
      alignment: Alignment.topCenter,
      height: 400,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
          image: DecorationImage(
              colorFilter:
                  ColorFilter.mode(Color(0x80000000), BlendMode.darken),
              image: AssetImage('images/plan-bg.png'),
              fit: BoxFit.fill)),
      child: ListView(
        shrinkWrap: true,
        children: [
          Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.all(5),
              color: accentColor,
              child: Text(
                plan.planName!,
                textAlign: TextAlign.center,
                style: GoogleFonts.aclonica(
                    color: darkColor,
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              )),
          const SizedBox(
            height: 7,
          ),
          Text(
            plan.planTitle!,
            style: GoogleFonts.cairo(
                color: accentColor, fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              plan.planText!,
              style: GoogleFonts.cairoPlay(
                  color: lightColor, fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}
