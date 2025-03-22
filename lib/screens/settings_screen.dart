import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Settings state
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  double _textSize = 1.0;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Help section coming soon')),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),

          // Profile section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.blue[800],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Hello user',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'user@example.com',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Edit profile coming soon'),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Edit Profile'),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Section divider
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'APPLICATION SETTINGS',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
                letterSpacing: 1.2,
              ),
            ),
          ),

          // Notifications toggle
          _buildSettingTile(
            title: 'Notifications',
            subtitle: 'Receive push notifications',
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.notifications_outlined, color: Colors.red[400]),
            ),
            trailing: Switch(
              value: _notificationsEnabled,
              activeColor: Colors.blue,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),
          ),

          // Dark mode toggle
          _buildSettingTile(
            title: 'Dark Mode',
            subtitle: 'Toggle dark theme',
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.purple[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.dark_mode_outlined, color: Colors.purple[400]),
            ),
            trailing: Switch(
              value: _darkModeEnabled,
              activeColor: Colors.blue,
              onChanged: (value) {
                setState(() {
                  _darkModeEnabled = value;
                });
              },
            ),
          ),

          // Text size slider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.text_fields,
                            color: Colors.blue[400],
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          'Text Size',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text('A', style: TextStyle(fontSize: 14)),
                        Expanded(
                          child: Slider(
                            value: _textSize,
                            min: 0.5,
                            max: 1.5,
                            divisions: 4,
                            label: _textSize.toString(),
                            onChanged: (value) {
                              setState(() {
                                _textSize = value;
                              });
                            },
                          ),
                        ),
                        const Text('A', style: TextStyle(fontSize: 24)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Language selection
          _buildSettingTile(
            title: 'Language',
            subtitle: _selectedLanguage,
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.language, color: Colors.orange[400]),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              _showLanguageBottomSheet();
            },
          ),

          // Section divider
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'ABOUT',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
                letterSpacing: 1.2,
              ),
            ),
          ),

          // About options
          _buildSettingTile(
            title: 'Terms of Service',
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.description_outlined, color: Colors.blue[400]),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          ),

          _buildSettingTile(
            title: 'Privacy Policy',
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.privacy_tip_outlined, color: Colors.blue[400]),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          ),

          _buildSettingTile(
            title: 'App Version',
            subtitle: '1.0.0 (Build 1)',
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.info_outline, color: Colors.grey[700]),
            ),
          ),

          const SizedBox(height: 24),

          // Logout button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Logout functionality coming soon'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[400],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Log Out'),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required String title,
    String? subtitle,
    required Widget leading,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: leading,
          title: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          subtitle: subtitle != null ? Text(subtitle) : null,
          trailing: trailing,
          onTap: onTap,
        ),
      ),
    );
  }

  void _showLanguageBottomSheet() {
    final languages = [
      'English',
      'Spanish',
      'French',
      'German',
      'Japanese',
      'Chinese',
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Language',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: languages.length,
                    itemBuilder: (context, index) {
                      final language = languages[index];
                      return ListTile(
                        title: Text(language),
                        trailing:
                            _selectedLanguage == language
                                ? const Icon(Icons.check, color: Colors.blue)
                                : null,
                        onTap: () {
                          setState(() {
                            _selectedLanguage = language;
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
