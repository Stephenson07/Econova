import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'product_detail_screen.dart';
import 'cart.dart';
import 'cart_screen.dart';
import 'add_product_screen.dart';

class Product {
  final String id;
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
    String? id,
  }) : id = id ?? UniqueKey().toString();
}

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final Cart _cart = Cart();
  final List<Product> _products = [];
  List<Product> _filteredProducts = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInitialProducts();
    _filteredProducts = List.from(_products);
    _searchController.addListener(_filterProducts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadInitialProducts() {
    _products.addAll([
      Product(
        name: 'Laptop Pro X1',
        price: 1299.99,
        durability: '4 years',
        imageUrl: 'assets/images/product_0.png',
        date: DateTime.now().subtract(const Duration(days: 1)),
        description: 'High-performance laptop with 16GB RAM and 512GB SSD',
      ),
      Product(
        name: 'Smartphone Galaxy S30',
        price: 899.99,
        durability: '3 years',
        imageUrl: 'assets/images/product_1.png',
        date: DateTime.now().subtract(const Duration(days: 5)),
        description:
            'Latest smartphone with 6.7" AMOLED display and 108MP camera',
      ),
      Product(
        name: 'Wireless Headphones',
        price: 249.99,
        durability: '2 years',
        imageUrl: 'assets/images/product_10.png',
        date: DateTime.now().subtract(const Duration(days: 10)),
        description:
            'Noise-cancelling wireless headphones with 30-hour battery life',
      ),
      Product(
        name: 'Smart Watch Pro',
        price: 349.99,
        durability: '3 years',
        imageUrl: 'assets/images/product_3.png',
        date: DateTime.now().subtract(const Duration(days: 3)),
        description: 'Fitness and health tracking smartwatch with GPS',
      ),
      Product(
        name: 'Tablet Air',
        price: 599.99,
        durability: '4 years',
        imageUrl: 'assets/images/product_4.png',
        date: DateTime.now().subtract(const Duration(days: 7)),
        description: '10.9-inch tablet with A14 chip and all-day battery life',
      ),
      Product(
        name: 'Wireless Earbuds',
        price: 149.99,
        durability: '2 years',
        imageUrl: 'assets/images/product_5.png',
        date: DateTime.now().subtract(const Duration(days: 15)),
        description: 'True wireless earbuds with active noise cancellation',
      ),
      Product(
        name: 'Gaming Console X',
        price: 499.99,
        durability: '5 years',
        imageUrl: 'assets/images/product_6.png',
        date: DateTime.now().subtract(const Duration(days: 20)),
        description: 'Next-gen gaming console with 4K gaming at 60fps',
      ),
    ]);
  }

  void _filterProducts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredProducts = List.from(_products);
      } else {
        _filteredProducts =
            _products
                .where(
                  (product) =>
                      product.name.toLowerCase().contains(query) ||
                      product.description.toLowerCase().contains(query),
                )
                .toList();
      }
    });
  }

  void _addProduct(Product newProduct) {
    setState(() {
      _products.add(newProduct);
      _filterProducts();
    });
  }

  void _addToCart(Product product) {
    _cart.addToCart(product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildProductGrid(),
      floatingActionButton: _buildAddProductButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ),
          ),
          Badge(
            label: Text(_cart.items.length.toString()),
            isLabelVisible: _cart.items.isNotEmpty,
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
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
          ),
        ],
      ),
      backgroundColor: Colors.white,
      elevation: 1,
    );
  }

  Widget _buildProductGrid() {
    return _filteredProducts.isEmpty
        ? const Center(
          child: Text(
            'No products found',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        )
        : Padding(
          padding: const EdgeInsets.all(12.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.55,
            ),
            itemCount: _filteredProducts.length,
            itemBuilder: (context, index) {
              final product = _filteredProducts[index];
              return _buildProductCard(context, product);
            },
          ),
        );
  }

  Widget _buildProductCard(BuildContext context, Product product) {
    final formattedDate = DateFormat('yyyy-MM-dd').format(product.date);
    final formattedPrice = NumberFormat.currency(
      symbol: '₹',
      decimalDigits: 2,
    ).format(product.price);

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
            Hero(
              tag: 'product-image-${product.id}',
              child: Container(
                height: 120,
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
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formattedPrice,
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
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
                    'Added on: $formattedDate',
                    style: TextStyle(fontSize: 11, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _addToCart(product),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(
                        Icons.add_shopping_cart,
                        size: 16,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Add to Cart',
                        style: TextStyle(color: Colors.white),
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

  FloatingActionButton _buildAddProductButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddProductScreen(onProductAdded: _addProduct),
          ),
        );
      },
      backgroundColor: Colors.blue,
      icon: const Icon(Icons.add_circle, color: Colors.white),
      label: const Text('Add Product', style: TextStyle(color: Colors.white)),
      tooltip: 'Add New Product',
    );
  }
}
