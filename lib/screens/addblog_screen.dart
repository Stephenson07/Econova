import 'package:flutter/material.dart';

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

class AddBlogScreen extends StatefulWidget {
  final Function(Blog) onPost;

  const AddBlogScreen({super.key, required this.onPost});

  @override
  State<AddBlogScreen> createState() => _AddBlogScreenState();
}

class _AddBlogScreenState extends State<AddBlogScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();

  void _postBlog() {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Title and Blog content are required!")),
      );
      return;
    }

    final newBlog = Blog(
      title: _titleController.text,
      description: _descriptionController.text,
      imageUrl:
          _imageUrlController.text.isNotEmpty ? _imageUrlController.text : null,
    );

    widget.onPost(newBlog);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Blog")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: "Blog Content"),
              maxLines: 5,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _imageUrlController,
              decoration: const InputDecoration(
                labelText: "Image URL (optional)",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _postBlog, child: const Text("Post")),
          ],
        ),
      ),
    );
  }
}
