import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/state.dart';
import '../screens/groups_screen.dart';
import '../screens/events_screen.dart';
import '../screens/credits_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/contact_screen.dart';
import '../screens/report_screen.dart';
import '../screens/dashboard_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // Get username from global state
    final userProvider = Provider.of<UserProvider>(context);
    final username = userProvider.username;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(context, username),
          _buildDrawerItem(
            context,
            Icons.event,
            'Events',
            const EventsScreen(),
          ),
          _buildDrawerItem(
            context,
            Icons.group,
            'Groups & Communities',
            const GroupsScreen(),
          ),
          _buildDrawerItem(context, Icons.paid, 'Credits', CreditsScreen()),
          _buildDrawerItem(
            context,
            Icons.dashboard,
            'Dashboard',
            const EWasteDashboard(),
          ),
          _buildDrawerItem(
            context,
            Icons.contact_support,
            'Contact Us',
            const ContactScreen(),
          ),
          _buildDrawerItem(
            context,
            Icons.report,
            'Report Incident',
            const ReportScreen(),
          ),
          _buildDrawerItem(
            context,
            Icons.settings,
            'Settings',
            const SettingsScreen(),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context, String username) {
    return DrawerHeader(
      decoration: BoxDecoration(color: Colors.blue),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            icon: ColorFiltered(
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
              child: Image.network(
                'https://cdn0.iconfinder.com/data/icons/cryptocurrency-137/128/1_profile_user_avatar_account_person-132-1024.png',
                height: 70,
                width: 70,
              ),
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          const SizedBox(height: 10),
          Text(
            'Hello, ${username.isNotEmpty ? username : "User"}!',
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String title,
    Widget screen,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      onTap: () {
        Navigator.pop(context); // Close the drawer
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
    );
  }
}
