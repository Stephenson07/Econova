import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CustomCarousel extends StatelessWidget {
  const CustomCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: _buildCarouselItems(),
      options: _carouselOptions(),
    );
  }

  // Generates a list of carousel items
  List<Widget> _buildCarouselItems() {
    return List.generate(4, (index) {
      return _buildCarouselItem(index + 1);
    });
  }

  // Builds individual carousel item
  Widget _buildCarouselItem(int index) {
    return Container(
      height: 150,
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: _carouselItemDecoration(),
      child: _carouselItemContent(index),
    );
  }

  // Defines the decoration for each carousel item
  BoxDecoration _carouselItemDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.blue,
    );
  }

  // Defines the content of each carousel item
  Column _carouselItemContent(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Claim your rewards $index',
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
    );
  }

  // Defines the options for the carousel
  CarouselOptions _carouselOptions() {
    return CarouselOptions(
      autoPlay: false,
      enlargeCenterPage: true,
      aspectRatio: 16 / 9,
      height: 150.0,
      enableInfiniteScroll: true,
      scrollDirection: Axis.horizontal,
    );
  }
}
