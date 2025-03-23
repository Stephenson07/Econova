import 'package:flutter/material.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // A method to handle validation
  String? _validateInput(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Enter a $fieldName';
    }
    return null;
  }

  void _createGroup() {
    if (_formKey.currentState!.validate()) {
      final newGroup = {
        'name': _nameController.text,
        'description': _descriptionController.text,
        'members': 0,
        'image': 'assets/default.png',
      };
      Navigator.pop(context, newGroup);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Group'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextFormField(
                controller: _nameController,
                label: 'Group Name',
                validator: (value) => _validateInput(value, 'group name'),
              ),
              const SizedBox(height: 12),
              _buildTextFormField(
                controller: _descriptionController,
                label: 'Description',
                validator: (value) => _validateInput(value, 'description'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _createGroup,
                child: const Text('Create Group'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Extracting the text form field into a separate method for reuse
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      validator: validator,
    );
  }
}
