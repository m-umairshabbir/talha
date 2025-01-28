import 'package:flutter/material.dart';

class ManageAppSettingsScreen extends StatefulWidget {
  const ManageAppSettingsScreen({super.key});

  @override
  _ManageAppSettingsScreenState createState() =>
      _ManageAppSettingsScreenState();
}

class _ManageAppSettingsScreenState extends State<ManageAppSettingsScreen> {
  bool isNotificationsEnabled = true; // Example toggle for notifications
  String selectedTheme = "Light"; // Example theme selection

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: const Color(0xffd7e8fc),
        title: const Text('Manage App Settings'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff378acf), Color(0xff253244)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Theme Selection
            _buildSettingsCard(
              icon: Icons.color_lens,
              title: "Theme",
              subtitle: "Current: $selectedTheme",
              onTap: _openThemeSettings,
            ),
            const SizedBox(height: 16),

            // Notifications Preferences
            _buildSettingsCard(
              icon: Icons.notifications,
              title: "Notifications",
              subtitle: isNotificationsEnabled
                  ? "Notifications Enabled"
                  : "Notifications Disabled",
              onTap: () {
                setState(() {
                  isNotificationsEnabled = !isNotificationsEnabled;
                });
              },
            ),
            const SizedBox(height: 16),

            // Accessibility Options
            _buildSettingsCard(
              icon: Icons.accessibility,
              title: "Accessibility",
              subtitle: "Font size and High Contrast options",
              onTap: _openAccessibilitySettings,
            ),
            const SizedBox(height: 16),

            // Language Settings
            _buildSettingsCard(
              icon: Icons.language,
              title: "Language",
              subtitle: "Change app language",
              onTap: _openLanguageSettings,
            ),
            const SizedBox(height: 16),

            // Linked Accounts
            _buildSettingsCard(
              icon: Icons.account_circle,
              title: "Linked Accounts",
              subtitle: "Manage linked accounts",
              onTap: _openLinkedAccounts,
            ),
          ],
        ),
      ),
    );
  }

  // Helper to build a settings card
  Widget _buildSettingsCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.withOpacity(0.2),
          child: Icon(icon, color: Colors.blue),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  // Navigate to Theme Settings
  void _openThemeSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Select Theme"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile(
              title: const Text("Light"),
              value: "Light",
              groupValue: selectedTheme,
              onChanged: (value) {
                setState(() {
                  selectedTheme = value!;
                  Navigator.pop(context);
                });
              },
            ),
            RadioListTile(
              title: const Text("Dark"),
              value: "Dark",
              groupValue: selectedTheme,
              onChanged: (value) {
                setState(() {
                  selectedTheme = value!;
                  Navigator.pop(context);
                });
              },
            ),
            RadioListTile(
              title: const Text("Custom"),
              value: "Custom",
              groupValue: selectedTheme,
              onChanged: (value) {
                setState(() {
                  selectedTheme = value!;
                  Navigator.pop(context);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  // Navigate to Accessibility Settings
  void _openAccessibilitySettings() {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Accessibility Settings')));
  }

  // Navigate to Language Settings
  void _openLanguageSettings() {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Language Settings')));
  }

  // Navigate to Linked Accounts
  void _openLinkedAccounts() {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Linked Accounts')));
  }
}
