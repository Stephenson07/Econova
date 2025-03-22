import 'package:flutter/material.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

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
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Group Name'),
                validator:
                    (value) => value!.isEmpty ? 'Enter a group name' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator:
                    (value) => value!.isEmpty ? 'Enter a description' : null,
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
}
