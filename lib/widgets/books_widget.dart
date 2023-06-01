import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../constants.dart';
import '../models/book_model.dart';

class BookWidget extends StatelessWidget {
  final RxList<BookModel> books;
  const BookWidget({super.key, required this.books});
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Obx(
          () => books.isEmpty
              ? const SpinKitPumpingHeart(
                  color: Colors.red,
                )
              : CarouselSlider.builder(
                  options: CarouselOptions(
                    viewportFraction: screenWidth < pageWidth ? 1 / 2 : 1 / 3,
                    height: 250,
                    autoPlay: true,
                  ),
                  itemCount: books.length,
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
      onTap: () async {
        String url = books[index].url;
        if (await canLaunchUrlString(url)) {
          await launchUrlString(url);
        } else {
          Get.defaultDialog(
            title: 'Sorry',
            content: const Text('Book is no longer available'),
          );
        }
      },
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
                  image: NetworkImage(books[index].bookImage),
                  fit: BoxFit.fill,
                ),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 10),
            ),
            const SizedBox(height: 10),
            Text(
              books[index].bookName,
              style: GoogleFonts.aclonica(fontSize: 16, color: Colors.red),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
