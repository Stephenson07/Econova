import 'package:flutter/material.dart';

// Blog Model
class Blog {
  final String title;
  final String description;
  final String? imageUrl;
  int likes;

  Blog({
    required this.title,
    required this.description,
    this.imageUrl,
    this.likes = 0,
  });
}

// AddBlogScreen Widget
class AddBlogScreen extends StatefulWidget {
  final Function(Blog) onPost;

  const AddBlogScreen({super.key, required this.onPost});

  @override
  State<AddBlogScreen> createState() => _AddBlogScreenState();
}

class _AddBlogScreenState extends State<AddBlogScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();

  // Post Blog Function
  void _postBlog() {
    if (_formKey.currentState?.validate() ?? false) {
      final newBlog = Blog(
        title: _titleController.text,
        description: _descriptionController.text,
        imageUrl:
            _imageUrlController.text.isNotEmpty
                ? _imageUrlController.text
                : null,
      );

      widget.onPost(newBlog);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    // Dispose of controllers to prevent memory leaks
    _titleController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Blog")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Using a form key for validation
          child: Column(
            children: [
              _buildTextField(
                controller: _titleController,
                label: "Title",
                validator:
                    (value) =>
                        value?.isEmpty ?? true ? 'Title is required' : null,
              ),
              const SizedBox(height: 10),
              _buildTextField(
                controller: _descriptionController,
                label: "Blog Content",
                maxLines: 5,
                validator:
                    (value) =>
                        value?.isEmpty ?? true ? 'Content is required' : null,
              ),
              const SizedBox(height: 10),
              _buildTextField(
                controller: _imageUrlController,
                label: "Image URL (optional)",
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _postBlog, child: const Text("Post")),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method for TextField to avoid repetition
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      maxLines: maxLines,
      validator: validator,
    );
  }
}
