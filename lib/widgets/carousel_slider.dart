import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CustomCarousel extends StatelessWidget {
  const CustomCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: List.generate(4, (index) {
        return Container(
          height: 150,
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blue,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Claim your rewards ${index + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Text(
                "Many wonderful rewards are waiting for you, don't forget to claim them.",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        );
      }),
      options: CarouselOptions(
        autoPlay: false,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        height: 150.0,
        enableInfiniteScroll: true,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
