import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../models/coach_model.dart';
import '../models/product_model.dart';

class FeaturedProductWidget extends StatelessWidget {
  final RxList<ProductModel> products;
  const FeaturedProductWidget({super.key, required this.products});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => products.isEmpty
              ? const SpinKitPumpingHeart(
                  color: Colors.red,
                )
              : CarouselSlider.builder(
                  options: CarouselOptions(
                    viewportFraction: 1 / 3,
                    height: 400,
                    autoPlay: true,
                    reverse: true,
                  ),
                  itemCount: products.length,
                  itemBuilder:
                      (BuildContext context, int index, int realIndex) =>
                          _buildCoachContainer(index),
                ),
        ),
      ],
    );
  }

  Widget _buildCoachContainer(int index) {
    return GestureDetector(
      onTap: () {},
      child: SizedBox(
        width: 160,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              height: 200,
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
                image: DecorationImage(
                  image: NetworkImage(products[index].productImage),
                  fit: BoxFit.fill,
                ),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 10),
            ),
            const SizedBox(height: 10),
            Text(
              products[index].productName,
              style: GoogleFonts.aclonica(fontSize: 16, color: Colors.white),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            Text(
              '${products[index].productPrice.toString()} L.E',
              style: GoogleFonts.aclonica(
                  fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
