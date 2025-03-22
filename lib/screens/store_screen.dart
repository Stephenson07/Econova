import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'product_detail_screen.dart';
import 'cart.dart';
import 'cart_screen.dart';
import 'add_product_screen.dart';

class Product {
  final String name;
  final double price;
  final String durability;
  final String imageUrl;
  final DateTime date;
  final String description;

  Product({
    required this.name,
    required this.price,
    required this.durability,
    required this.imageUrl,
    required this.date,
    required this.description,
  });
}

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final Cart _cart = Cart();
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    // Add some initial products
    products = [
      Product(
        name: 'Product 1',
        price: 300.0,
        durability: '2 years',
        imageUrl: 'assets/images/product_0.png',
        date: DateTime.now().subtract(Duration(days: 1)),
        description: 'something laptop',
      ),
      Product(
        name: 'Product 2',
        price: 150.0,
        durability: '1 year',
        imageUrl: 'assets/images/product_1.png',
        date: DateTime.now().subtract(Duration(days: 5)),
        description: 'something laptop',
      ),
      Product(
        name: 'Product 10',
        price: 450.0,
        durability: '3 years',
        imageUrl: 'assets/images/product_10.png',
        date: DateTime.now().subtract(Duration(days: 10)),
        description: 'something laptop',
      ),
      Product(
        name: 'Product 4',
        price: 600.0,
        durability: '5 years',
        imageUrl: 'assets/images/product_3.png',
        date: DateTime.now().subtract(Duration(days: 3)),
        description: 'something laptop',
      ),
      Product(
        name: 'Product 4',
        price: 600.0,
        durability: '5 years',
        imageUrl: 'assets/images/product_4.png',
        date: DateTime.now().subtract(Duration(days: 3)),
        description: 'something laptop',
      ),
      Product(
        name: 'Product 4',
        price: 600.0,
        durability: '5 years',
        imageUrl: 'assets/images/product_5.png',
        date: DateTime.now().subtract(Duration(days: 3)),
        description: 'something laptop',
      ),
      Product(
        name: 'Product 4',
        price: 600.0,
        durability: '5 years',
        imageUrl: 'assets/images/product_6.png',
        date: DateTime.now().subtract(Duration(days: 3)),
        description: 'something laptop',
      ),
      Product(
        name: 'Product 4',
        price: 600.0,
        durability: '5 years',
        imageUrl: 'assets/images/product_10.png',
        date: DateTime.now().subtract(Duration(days: 3)),
        description: 'something laptop',
      ),
      Product(
        name: 'Product 4',
        price: 600.0,
        durability: '5 years',
        imageUrl: 'assets/images/product_0.png',
        date: DateTime.now().subtract(Duration(days: 3)),
        description: 'something laptop',
      ),
      Product(
        name: 'Product 4',
        price: 600.0,
        durability: '5 years',
        imageUrl: 'assets/images/product_3.png',
        date: DateTime.now().subtract(Duration(days: 3)),
        description: 'something laptop',
      ),
      Product(
        name: 'Product 4',
        price: 600.0,
        durability: '5 years',
        imageUrl: 'assets/images/product_1.png',
        date: DateTime.now().subtract(Duration(days: 3)),
        description: 'something laptop',
      ),
      Product(
        name: 'Product 4',
        price: 600.0,
        durability: '5 years',
        imageUrl: 'assets/images/product_2.png',
        date: DateTime.now().subtract(Duration(days: 3)),
        description: 'something laptop',
      ),
      Product(
        name: 'Product 4',
        price: 600.0,
        durability: '5 years',
        imageUrl: 'assets/images/product_3.png',
        date: DateTime.now().subtract(Duration(days: 3)),
        description: 'something laptop',
      ),
      Product(
        name: 'Product 4',
        price: 600.0,
        durability: '5 years',
        imageUrl: 'assets/images/product_0.png',
        date: DateTime.now().subtract(Duration(days: 3)),
        description: 'something laptop',
      ),
    ];
  }

  // Add a method to add new products
  void _addProduct(Product newProduct) {
    setState(() {
      products.add(newProduct);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Search Bar - now takes less space to make room for cart button
            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: 8),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
              ),
            ),
            // Cart Button - now located in the AppBar
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartScreen(cart: _cart),
                  ),
                );
              },
              tooltip: 'View Cart',
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.53, // Reduces item height for better scaling
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return _buildProductCard(context, product);
          },
        ),
      ),
      // Add Product as a Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => AddProductScreen(onProductAdded: _addProduct),
            ),
          );
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add_circle, size: 30),
        tooltip: 'Add Product',
      ),
      // Set the position to bottom left
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildProductCard(BuildContext context, Product product) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(product.date);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120, // Fixed height for testing
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
                image: DecorationImage(
                  image: AssetImage(product.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹${product.price}',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Durability: ${product.durability}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Added on:$formattedDate',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  // Add to cart button for each product
                  SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _cart.addToCart(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product.name} added to cart'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(vertical: 4),
                        textStyle: TextStyle(fontSize: 12),
                        minimumSize: Size(double.infinity, 30),
                      ),
                      child: Text(
                        'Add to Cart',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
