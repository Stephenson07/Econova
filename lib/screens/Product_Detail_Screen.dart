import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_project/screens/store_screen.dart'; // For date formatting

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  // Constructor to receive the product
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // Format the date using intl package
    String formattedDate = DateFormat('yyyy-MM-dd').format(product.date);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            Container(
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: AssetImage(product.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Product details
            Text(
              product.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '₹${product.price}',
              style: TextStyle(
                color: Colors.green,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Durability: ${product.durability}',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Added on:$formattedDate',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
            const SizedBox(height: 16),
            // Add to Cart button (you can add cart functionality later)
            ElevatedButton(
              onPressed: () {
                // Add functionality for adding to cart if needed
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${product.name} added to cart')),
                );
              },
              child: Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}
