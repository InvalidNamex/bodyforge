import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uuid/uuid.dart';

class PaymentController extends GetxController {
  void makeRequest(
      {required double price,
      required String currency,
      required String description}) async {
    await dotenv.load(fileName: ".env");
    String serverKey = dotenv.env['SERVER_KEY']!;
    int profileID = int.parse(dotenv.env['PROFILE_ID']!);
    String generateUniqueId() {
      var uuid = const Uuid();
      String uniqueId = uuid.v4();
      return uniqueId;
    }

    var url = 'https://secure-egypt.paytabs.com/payment/request';
    var headers = {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Authorization': serverKey,
      'Accept': '*/*'
    };
    var body = {
      "profile_id": profileID,
      "tran_type": "sale",
      "tran_class": "ecom",
      "cart_id": generateUniqueId(),
      "cart_description": "$description ${generateUniqueId()}",
      "cart_currency": currency,
      "cart_amount": price,
      "callback": "https://bodyforge.site/",
      "return": "https://bodyforge.site/404"
    };
    var encodedBody = json.encode(body);
    try {
      var response =
          await http.post(Uri.parse(url), headers: headers, body: encodedBody);
      print('status code: ${response.statusCode}');
      print('response body: ${response.body}');
    } catch (e) {
      print(e.toString());
    }
  }
}
