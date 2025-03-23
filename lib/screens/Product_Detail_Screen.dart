import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_project/screens/store_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  // Constants for styling and spacing
  static const double _padding = 16.0;
  static const double _imageHeight = 250.0;
  static const double _borderRadius = 15.0;
  static const double _largeSpacing = 16.0;
  static const double _smallSpacing = 8.0;

  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // Format the date using intl package
    String formattedDate = DateFormat('yyyy-MM-dd').format(product.date);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name, style: TextStyle(fontFamily: 'Poppins')),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(_padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProductImage(),
              const SizedBox(height: _largeSpacing),
              _buildProductName(),
              const SizedBox(height: _smallSpacing),
              _buildProductPrice(),
              const SizedBox(height: _smallSpacing),
              _buildProductDurability(),
              const SizedBox(height: _smallSpacing),
              _buildProductDate(formattedDate),
              const SizedBox(height: _largeSpacing),
              _buildAddToCartButton(context),
            ],
          ),
        ),
      ),
    );
  }

  // Build product image container
  Widget _buildProductImage() {
    return Container(
      height: _imageHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_borderRadius),
        image: DecorationImage(
          image: AssetImage(product.imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // Build product name text
  Widget _buildProductName() {
    return Text(
      product.name,
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  // Build product price text
  Widget _buildProductPrice() {
    return Text(
      '₹${product.price}',
      style: const TextStyle(
        color: Colors.green,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  // Build product durability text
  Widget _buildProductDurability() {
    return Text(
      'Durability: ${product.durability}',
      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
    );
  }

  // Build product date text
  Widget _buildProductDate(String formattedDate) {
    return Text(
      'Added on: $formattedDate',
      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
    );
  }

  // Build add to cart button
  Widget _buildAddToCartButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _addToCart(context),
      child: const Text('Add to Cart'),
    );
  }

  // Handle adding product to cart
  void _addToCart(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${product.name} added to cart')));
  }
}
