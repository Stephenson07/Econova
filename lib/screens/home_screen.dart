import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Econova/screens/credits_screen.dart';
import 'package:Econova/screens/events_screen.dart';
import 'package:Econova/screens/report_screen.dart';
import '../widgets/feature_card.dart';
import '../widgets/activity_card.dart';
import 'groups_screen.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Database references
  DatabaseReference get _scheduleRef =>
      FirebaseDatabase.instance.ref().child('schedules');

  // Form state
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  final TextEditingController _addressController = TextEditingController();
  String _wasteType = 'Electronics';

  // Waste type options
  final List<String> _wasteTypes = [
    'Electronics',
    'Batteries',
    'Appliances',
    'Computers',
    'Mobile Phones',
    'Cables & Wires',
  ];

  // Recent activities (could be fetched from Firebase in a real app)
  final List<Map<String, dynamic>> _recentActivities = [
    {
      'title': 'Recycling Scheduled',
      'date': 'Mar 15, 2025',
      'description': '2 laptops and 1 monitor',
      'icon': Icons.check_circle_outline,
      'color': Colors.blue,
    },
    {
      'title': 'Pickup Completed',
      'date': 'Mar 10, 2025',
      'description': 'Recycled 5kg of e-waste',
      'icon': Icons.recycling,
      'color': Colors.blue,
    },
    {
      'title': 'Credits Earned',
      'date': 'Mar 10, 2025',
      'description': '+50 Eco Credits',
      'icon': Icons.star,
      'color': Colors.amber,
    },
  ];

  // Eco tips to show randomly
  final List<String> _ecoTips = [
    'Always remove batteries from electronics before recycling. Batteries should be recycled separately as they can be harmful to the environment if not disposed of properly.',
    'Consider donating working electronics to schools or charities instead of recycling them.',
    'Data security is important - make sure to wipe all personal data from devices before recycling.',
    'Many manufacturers offer take-back programs for their products. Check with the brand before scheduling a pickup.',
    'Old cables and chargers can be recycled too! Don\'t throw them in regular trash.',
  ];

  late String _currentTip;

  @override
  void initState() {
    super.initState();
    // Select a random tip to display
    _currentTip = _ecoTips[DateTime.now().microsecond % _ecoTips.length];
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  // Navigation methods
  void _navigateTo(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
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
      _showSnackBar('Please enter an address', isError: true);
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

      await _scheduleRef.child(scheduleData['id']!).set(scheduleData);

      _showSnackBar('Recycling pickup scheduled successfully!');

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
        errorMessage = e.message ?? 'Firebase error occurred';
        debugPrint('Firebase Error: ${e.code} - ${e.message}');
      } else {
        debugPrint('Unexpected Error: $e');
      }

      _showSnackBar('Error scheduling recycling: $errorMessage', isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.blue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showScheduleBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildScheduleForm(context),
    );
  }

  Widget _buildScheduleForm(BuildContext context) {
    return Container(
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
        child: SingleChildScrollView(
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
              _buildDateSelector(),
              const SizedBox(height: 15),
              _buildTimeSelector(),
              const SizedBox(height: 15),
              _buildAddressField(),
              const SizedBox(height: 15),
              _buildWasteTypeDropdown(),
              const SizedBox(height: 30),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return InkWell(
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
    );
  }

  Widget _buildTimeSelector() {
    return InkWell(
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
    );
  }

  Widget _buildAddressField() {
    return TextField(
      controller: _addressController,
      decoration: InputDecoration(
        labelText: 'Collection Address',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        prefixIcon: const Icon(Icons.location_on, color: Colors.blue),
      ),
      maxLines: 2,
    );
  }

  Widget _buildWasteTypeDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _wasteType,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.blue),
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
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
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
        child: const Text('Schedule Pickup', style: TextStyle(fontSize: 18)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // In a real app, refresh data from Firebase
            setState(() {
              _currentTip =
                  _ecoTips[DateTime.now().microsecond % _ecoTips.length];
            });
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                _buildExploreSection(),
                const SizedBox(height: 20),
                _buildRecentActivitySection(),
                const SizedBox(height: 20),
                _buildEcoTipSection(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
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
          _buildScheduleButton(),
        ],
      ),
    );
  }

  Widget _buildScheduleButton() {
    return InkWell(
      onTap: _showScheduleBottomSheet,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
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
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.recycling, color: Colors.blue, size: 28),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExploreSection() {
    final features = [
      {
        'title': 'Communities',
        'subtitle': 'Join recycling communities',
        'icon': Icons.group,
        'color': Colors.blue.shade700,
        'onPressed': () => _navigateTo(const GroupsScreen()),
      },
      {
        'title': 'Report',
        'subtitle': 'Report e-waste issues',
        'icon': Icons.report_outlined,
        'color': Colors.blue.shade600,
        'onPressed': () => _navigateTo(const ReportScreen()),
      },
      {
        'title': 'Events',
        'subtitle': 'Upcoming recycling events',
        'icon': Icons.event,
        'color': Colors.blue.shade500,
        'onPressed': () => _navigateTo(const EventsScreen()),
      },
      {
        'title': 'Credits',
        'subtitle': 'Your recycling rewards',
        'icon': Icons.star,
        'color': Colors.blue.shade400,
        'onPressed': () => _navigateTo(CreditsScreen()),
      },
    ];

    return Padding(
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
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.1,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
            ),
            itemCount: features.length,
            itemBuilder: (context, index) {
              final feature = features[index];
              return FeatureCard(
                title: feature['title'] as String,
                subtitle: feature['subtitle'] as String,
                icon: feature['icon'] as IconData,
                color: feature['color'] as Color,
                onPressed: feature['onPressed'] as VoidCallback,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivitySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to full activity history
                  _showSnackBar('Viewing all activities');
                },
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _recentActivities.length,
            itemBuilder: (context, index) {
              final activity = _recentActivities[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ActivityCard(
                  title: activity['title'] as String,
                  date: activity['date'] as String,
                  description: activity['description'] as String,
                  icon: activity['icon'] as IconData,
                  color: activity['color'] as Color,
                  onPressed: () {
                    // View details or navigate to details screen
                    _showSnackBar('Viewing details for ${activity['title']}');
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEcoTipSection() {
    return Container(
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
            _currentTip,
            style: TextStyle(fontSize: 14, color: Colors.blue.shade800),
          ),
          Align(
            alignment: Alignment.centerRight,

            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  // Get a random tip
                  String newTip;
                  Random random = Random();
                  do {
                    newTip = _ecoTips[random.nextInt(_ecoTips.length)];
                  } while (newTip == _currentTip && _ecoTips.length > 1);
                  _currentTip = newTip;
                });
              },
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('New Tip'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
                visualDensity: VisualDensity.compact,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
