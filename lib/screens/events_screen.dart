import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:Econova/main.dart'; // For JSON encoding

class Event {
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final String imageUrl;
  bool register;

  Event({
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    this.imageUrl = '',
    this.register = false,
  });
}

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final List<Event> _events = [
    Event(
      title: 'E-Waste Recycling 101',
      description:
          ' A hands-on session where participants can learn how to properly recycle their old electronics and the importance of responsible e-waste disposal.',
      date: DateTime.now().add(const Duration(days: 2)),
      location: 'Tech Hub Downtown',
      imageUrl: 'https://picsum.photos/id/1/300/200',
      register: false,
    ),
    Event(
      title: 'Old Electronics, New Life: E-Waste Collection Drive',
      description:
          'Drop off your old, unused electronics for safe disposal and recycling. Help reduce landfill waste!',
      date: DateTime.now().add(const Duration(days: 5)),
      location: 'Grand Hotel',
      imageUrl: 'https://picsum.photos/id/26/300/200',
      register: false,
    ),
    Event(
      title: 'The Future of E-Waste: Challenges and Solutions',
      description:
          ' A panel with experts discussing the environmental impact of e-waste and government policies to regulate the disposal of electronics.',
      date: DateTime.now().add(const Duration(days: 10)),
      location: 'Design Center',
      imageUrl: 'https://picsum.photos/id/48/300/200',
      register: false,
    ),
  ];

  bool _isFilterMenuOpen = false;
  String _selectedFilter = 'All';

  void _addNewEvent() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => CreateEventScreen(
              onEventCreated: (event) async {
                // Print a message for debugging
                print('Event Created: ${event.title}');

                // Send the event to the Flask API
                final response = await http.post(
                  Uri.parse(
                    'http:///192.168.31.180:5000/create_event',
                  ), // Use the correct URL for your Flask server
                  headers: {'Content-Type': 'application/json'},
                  body: json.encode({
                    'title': event.title,
                    'description': event.description,
                    'date':
                        event.date
                            .toIso8601String(), // Convert DateTime to string
                    'location': event.location,
                    'imageUrl': event.imageUrl,
                    'register': event.register,
                  }),
                );

                if (response.statusCode == 200) {
                  // If the server returns a successful response
                  // print('Event successfully sent to the server');

                  // Add the event to the local list of events
                  setState(() {
                    _events.add(event);
                  });
                } else {
                  // If the server returns an error
                  print('Failed to send event to server');
                  // Optionally, show an error message
                }
              },
            ),
      ),
    );
  }

  void _showEventDetails(Event event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(20),
            height: 600, // Increased height to 80%
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    event.imageUrl.isNotEmpty
                        ? event.imageUrl
                        : 'https://picsum.photos/300/200',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          height: 200,
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.image,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      DateFormat('EEEE, MMM d, yyyy').format(event.date),
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.red),
                    const SizedBox(width: 6),
                    Text(
                      event.location,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Description',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                // Make the description scrollable
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      event.description,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      event.register = true; // Change register status to true
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Registration confirmed!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    event.register
                        ? 'Registration Confirmed!'
                        : 'Register for Event',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Upcoming Events",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const MainAppScreen()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.filter_list, color: Colors.white),
                if (_selectedFilter != 'All')
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              setState(() {
                _isFilterMenuOpen = !_isFilterMenuOpen;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (_isFilterMenuOpen)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filter Events',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      FilterChip(
                        label: const Text('All'),
                        selected: _selectedFilter == 'All',
                        onSelected: (selected) {
                          setState(() {
                            _selectedFilter = 'All';
                          });
                        },
                      ),
                      FilterChip(
                        label: const Text('This Week'),
                        selected: _selectedFilter == 'This Week',
                        onSelected: (selected) {
                          setState(() {
                            _selectedFilter = 'This Week';
                          });
                        },
                      ),
                      FilterChip(
                        label: const Text('Next Week'),
                        selected: _selectedFilter == 'Next Week',
                        onSelected: (selected) {
                          setState(() {
                            _selectedFilter = 'Next Week';
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          Expanded(
            child:
                _events.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.event_busy,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No events available',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: _addNewEvent,
                            child: const Text('Add Your First Event'),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _events.length,
                      itemBuilder: (context, index) {
                        final event = _events[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: InkWell(
                            onTap: () => _showEventDetails(event),
                            borderRadius: BorderRadius.circular(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  ),
                                  child: Image.network(
                                    event.imageUrl.isNotEmpty
                                        ? event.imageUrl
                                        : 'https://picsum.photos/300/200',
                                    height: 150,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                              height: 150,
                                              width: double.infinity,
                                              color: Colors.grey[300],
                                              child: const Icon(
                                                Icons.image,
                                                size: 50,
                                                color: Colors.grey,
                                              ),
                                            ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.blue.withOpacity(
                                                0.1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              DateFormat(
                                                'MMM d',
                                              ).format(event.date),
                                              style: const TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const Spacer(),
                                          Icon(
                                            Icons.bookmark_border,
                                            color: Colors.grey[600],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        event.title,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            size: 16,
                                            color: Colors.grey[600],
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            event.location,
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed:
                                                  () =>
                                                      _showEventDetails(event),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.blue,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                    ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: const Text(
                                                'View Details',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Poppins',
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewEvent,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class CreateEventScreen extends StatefulWidget {
  final Function(Event) onEventCreated;

  const CreateEventScreen({super.key, required this.onEventCreated});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _imageUrlController = TextEditingController();

  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveEvent() {
    if (_formKey.currentState!.validate()) {
      final newEvent = Event(
        title: _titleController.text,
        description: _descriptionController.text,
        date: _selectedDate,
        location: _locationController.text,
        imageUrl: _imageUrlController.text,
      );

      widget.onEventCreated(newEvent);
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event created successfully!')),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Event',
          style: TextStyle(fontFamily: 'Poppins'),
        ),
        elevation: 0,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Event Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an event title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Event Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.description),
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an event description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Event Location',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an event location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_today),
                        const SizedBox(width: 8),
                        const Text(
                          'Event Date',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          DateFormat('EEEE, MMM d, yyyy').format(_selectedDate),
                          style: const TextStyle(fontSize: 16),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () => _selectDate(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Change',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(
                  labelText: 'Image URL (Optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.image),
                  hintText: 'https://example.com/image.jpg',
                ),
              ),
              const SizedBox(height: 24),
              if (_imageUrlController.text.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Image Preview:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        _imageUrlController.text,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => Container(
                              height: 200,
                              width: double.infinity,
                              color: Colors.grey[300],
                              child: const Center(
                                child: Text('Invalid image URL'),
                              ),
                            ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ElevatedButton(
                onPressed: _saveEvent,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Create Event',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
