// add_product_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:intl/intl.dart';
import 'store_screen.dart'; // Import for Product model

class AddProductScreen extends StatefulWidget {
  final Function(Product) onProductAdded;

  const AddProductScreen({super.key, required this.onProductAdded});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  File? _imageFile;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _durabilityController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _takePicture(); // Open camera as soon as this screen opens
  }

  Future<void> _takePicture() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? photo = await picker.pickImage(source: ImageSource.camera);

      if (photo == null) {
        // User canceled the camera
        Navigator.pop(context);
        return;
      }

      // Save the image to a permanent location
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = path.basename(photo.path);
      final savedImage = await File(
        photo.path,
      ).copy('${appDir.path}/$fileName');

      setState(() {
        _imageFile = savedImage;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error capturing image: $e')));
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate() && _imageFile != null) {
      final String name = _nameController.text;
      final double price = double.parse(_priceController.text);
      final String durability = _durabilityController.text;
      final String description = _descriptionController.text;

      // Create new product with current date
      final Product newProduct = Product(
        name: name,
        price: price,
        durability: durability,
        imageUrl: _imageFile!.path, // Local file path
        date: DateTime.now(),
        description: description,
      );

      // Call the callback function to add the product
      widget.onProductAdded(newProduct);

      // Show success message and go back
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('$name added successfully!')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Product'),
        backgroundColor: Colors.blue,
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _imageFile == null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('No image captured'),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _takePicture,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: Text('Take Picture'),
                    ),
                  ],
                ),
              )
              : SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display captured image
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            _imageFile!,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Product Name
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Product Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter product name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),

                      // Price
                      TextFormField(
                        controller: _priceController,
                        decoration: InputDecoration(
                          labelText: 'Price (₹)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter price';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),

                      // Durability
                      TextFormField(
                        controller: _durabilityController,
                        decoration: InputDecoration(
                          labelText: 'Durability (e.g., 2 years)',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter durability';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),

                      // Description
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter description';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),

                      // Current Date (non-editable)
                      Text(
                        'Date: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30),

                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _saveProduct,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Save Product',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _durabilityController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
