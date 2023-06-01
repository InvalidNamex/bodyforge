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
        Neon(
          text: plan.planName,
          color: Colors.red,
          font: NeonFont.Membra,
          fontSize: 36,
        ),
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
        ElevatedButton(
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
            style: GoogleFonts.aclonica(color: Colors.black, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget container(context) {
    return Text(
      plan.planText!,
      style: GoogleFonts.aclonica(color: Colors.white, fontSize: 28),
      textAlign: TextAlign.start,
    );
  }
}
