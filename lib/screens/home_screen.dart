import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_project/screens/credits_screen.dart' show CreditsScreen;
import 'package:test_project/screens/events_screen.dart';
import 'package:test_project/screens/report_screen.dart';
// import 'package:test_project/screens/scan_screen.dart';
import '../widgets/feature_card.dart';
import '../widgets/activity_card.dart';
import 'groups_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  final TextEditingController _addressController = TextEditingController();
  String _wasteType = 'Electronics';

  // Create a separate method to reference the '/users' endpoint
  DatabaseReference get usersRef =>
      FirebaseDatabase.instance.ref().child('users');

  // Create a reference for recycling schedules
  DatabaseReference get scheduleRef =>
      FirebaseDatabase.instance.ref().child('schedules');

  // Waste type options
  final List<String> _wasteTypes = [
    'Electronics',
    'Batteries',
    'Appliances',
    'Computers',
    'Mobile Phones',
    'Cables & Wires',
  ];

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  // Navigation methods for each feature card
  void _navigateToCommunities() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GroupsScreen()),
    );
  }

  void _navigateToReport() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ReportScreen()),
    );
  }

  void _navigateToEvents() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EventsScreen()),
    );
  }

  void _navigateToCredits() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreditsScreen()),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _scheduleRecycle() async {
    if (_addressController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter an address')));
      return;
    }

    try {
      final scheduleData = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'date': DateFormat('yyyy-MM-dd').format(_selectedDate),
        'time':
            '${_selectedTime.hour}:${_selectedTime.minute.toString().padLeft(2, '0')}',
        'address': _addressController.text,
        'wasteType': _wasteType,
        'status': 'Pending',
        'timestamp': DateTime.now().toIso8601String(),
      };

      await scheduleRef.child(scheduleData['id']!).set(scheduleData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Recycling pickup scheduled successfully!'),
          backgroundColor: Colors.blue,
        ),
      );

      // Clear form
      _addressController.clear();
      setState(() {
        _selectedDate = DateTime.now();
        _selectedTime = TimeOfDay.now();
        _wasteType = 'Electronics';
      });

      // Close bottom sheet
      Navigator.pop(context);
    } catch (e) {
      String errorMessage = 'An unexpected error occurred';

      if (e is FirebaseException) {
        errorMessage = 'Firebase error: ${e.message}';
        print('Firebase Error: ${e.code} - ${e.message}');
      } else {
        print('Unexpected Error: $e');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error scheduling recycling: $errorMessage'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showScheduleBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Schedule E-Waste Recycling',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Date picker
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue.shade300),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Date: ${DateFormat('MMM dd, yyyy').format(_selectedDate)}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const Icon(Icons.calendar_today, color: Colors.blue),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Time picker
                  InkWell(
                    onTap: () => _selectTime(context),
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue.shade300),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Time: ${_selectedTime.format(context)}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const Icon(Icons.access_time, color: Colors.blue),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Address input
                  TextField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelText: 'Collection Address',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.blue,
                          width: 2,
                        ),
                      ),
                      prefixIcon: const Icon(
                        Icons.location_on,
                        color: Colors.blue,
                      ),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 15),
                  // Waste type dropdown
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue.shade300),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _wasteType,
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.blue,
                        ),
                        isExpanded: true,
                        items:
                            _wasteTypes.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _wasteType = newValue;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _scheduleRecycle,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Schedule Pickup',
                        style: TextStyle(fontSize: 18),
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
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.blue.shade50,

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome to EcoRecycle',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Manage your e-waste recycling in one place',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 25),
                  // Schedule button
                  InkWell(
                    onTap: _showScheduleBottomSheet,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Schedule Recycling',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Tap to schedule a pickup',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.recycling,
                              color: Colors.blue,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Main Sections
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Explore',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Grid of options using the separate FeatureCard component
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 1.1,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    children: [
                      FeatureCard(
                        title: 'Communities',
                        subtitle: 'Join recycling communities',
                        icon: Icons.group,
                        color: Colors.blue.shade700,
                        onPressed: _navigateToCommunities,
                      ),
                      FeatureCard(
                        title: 'Report',
                        subtitle: 'Report e-waste issues',
                        icon: Icons.report_outlined,
                        color: Colors.blue.shade600,
                        onPressed: _navigateToReport,
                      ),
                      FeatureCard(
                        title: 'Events',
                        subtitle: 'Upcoming recycling events',
                        icon: Icons.event,
                        color: Colors.blue.shade500,
                        onPressed: _navigateToEvents,
                      ),
                      FeatureCard(
                        title: 'Credits',
                        subtitle: 'Your recycling rewards',
                        icon: Icons.star,
                        color: Colors.blue.shade400,
                        onPressed: _navigateToCredits,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Recent Activity using the separate ActivityCard component
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recent Activity',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 15),
                  ActivityCard(
                    title: 'Recycling Scheduled',
                    date: 'Mar 15, 2025',
                    description: '2 laptops and 1 monitor',
                    icon: Icons.check_circle_outline,
                    color: Colors.blue,
                    onPressed: () {
                      // View details or navigate to details screen
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Viewing pickup details')),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  ActivityCard(
                    title: 'Pickup Completed',
                    date: 'Mar 10, 2025',
                    description: 'Recycled 5kg of e-waste',
                    icon: Icons.recycling,
                    color: Colors.blue,
                    onPressed: () {
                      // View details or navigate to details screen
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Viewing completed pickup details'),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  ActivityCard(
                    title: 'Credits Earned',
                    date: 'Mar 10, 2025',
                    description: '+50 Eco Credits',
                    icon: Icons.star,
                    color: Colors.amber,
                    onPressed: () {
                      // Navigate to credits screen
                      _navigateToCredits();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Tips section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.lightbulb_outline, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        'Eco Tip',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Always remove batteries from electronics before recycling. Batteries should be recycled separately as they can be harmful to the environment if not disposed of properly.',
                    style: TextStyle(fontSize: 14, color: Colors.blue.shade800),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
