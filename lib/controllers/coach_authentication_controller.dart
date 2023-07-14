import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifit/models/web_pricing_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/constants.dart';
import '/models/coach_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CoachAuthController extends GetxController {
  final supabase = Supabase.instance.client;
  final coachSignupForm = GlobalKey<FormState>();
  TextEditingController coachName = TextEditingController();
  TextEditingController coachPassword = TextEditingController();
  TextEditingController coachEmail = TextEditingController();
  TextEditingController coachPhone = TextEditingController();
  Future coachSignup({
    required coachName,
    required coachPassword,
    required coachEmail,
    required coachPhone,
    required planId,
  }) async {
    final List _check =
        await supabase.from('coaches').select().eq('coach_email', coachEmail);
    if (_check.isEmpty) {
      final _response = await supabase
          .from('coaches')
          .insert(CoachModel(
            coachID: 0,
            coachName: coachName,
            coachPassword: coachPassword,
            coachJoinDate: DateTime.now().day.toString(),
            coachMail: coachEmail,
            coachPhone: coachPhone,
            coachImage:
                'https://tcvlpuijzxidegumjimv.supabase.co/storage/v1/object/public/coach_image/test%20coach.png',
            isVisible: false,
            isVerified: false,
          ).toJson())
          .whenComplete(() async {
        await homeController.getWebPrices();
        // TODO: get all data and proceed to payment page
        WebPricingModel _x = homeController.webPriceList
            .where((item) => item.planID == int.parse(planId))
            .toList()[0];
        await paymentController.payTabsRequest(
            price: _x.planPrice.toDouble(),
            currency: "EGP",
            coachName: coachName,
            planTitle: _x.planTitle);
      });
    } else {
      Get.defaultDialog(
          title: '',
          content: const Text(
              'this user already exists \n forgot password? contact admin.'));
    }
  }

  Future<void> loginCoach(String coachName, String coachPassword) async {
    // Check if coach name exists in the coaches table.
    final users = await supabase
        .from('coaches')
        .select('id, coach_name, coach_password, coach_isVerified')
        .eq('coach_name', coachName);

    // If the coach name exists, check if the password matches.
    if (users.isNotEmpty) {
      final user = users.first;

      // If the password matches, check if the user is verified.
      if (user['coach_password'] == coachPassword &&
          user['coach_isVerified'] == true) {
        // If the user is verified, return the coach ID and navigate to the coach zone.
        int _coachId = user['id'];
        await coachController.getCoachByID(_coachId);
        final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
        final SharedPreferences pref = await prefs;
        await pref.setInt('id', _coachId);
        await coachController.populateCoach();
        Get.toNamed('/coach-zone');
      }
    }
    // If the user is not verified, show an error dialog.
    Get.defaultDialog(
      title: 'Could not login',
      content: const Text('Username or password is incorrect'),
    );
  }
}
