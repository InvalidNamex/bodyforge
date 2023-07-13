import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher_string.dart';
import 'dart:convert';
import 'dart:js' as js;
import 'package:flutter/foundation.dart' show kIsWeb;

class PaymentController extends GetxController {
  Future<void> payTabsRequest(
      {required double price,
      required String currency,
      required String coachName,
      required String planTitle}) async {
    var response = await http.post(
      Uri.https('bodyforge.site', '/redirect/api/payment'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'coach_name': coachName,
        'plan_title': planTitle,
        'cart_amount': price,
        'currency': currency
      }),
    );
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var redirectUrl = jsonResponse['redirect_url'];
      if (redirectUrl != null) {
        if (!kIsWeb) {
          if (await canLaunchUrlString(redirectUrl)) {
            await launchUrlString(redirectUrl);
          }
        } else {
          if (redirectUrl != null) {
            void openUrlInCurrentTab(String url) {
              js.context.callMethod('open', [url, '_self']);
            }

            openUrlInCurrentTab(redirectUrl);
          }
        }
      }
    } else {
      // handle non-200 response
      Get.snackbar(
          'error', 'Request failed with status: ${response.statusCode}.');
    }
  }

  Future<String> img2txt({required String image}) async {
    await dotenv.load(fileName: ".env");
    String _key = dotenv.env['IMAGE_TO_TEXT_API_KEY']!;
    final _x = await http.get(
      Uri.https('api.apilayer.com', '/image_to_text/url', {'url': image}),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'apikey': 'SRQ70Sm9PuiwNU3nfl7u4YHEKqbAhiWx',
      },
    );
    if (_x.statusCode == 200) {
      final _y = json.decode(_x.body);
      return _y['all_text'];
    } else {
      return _x.statusCode.toString();
    }
  }
}
