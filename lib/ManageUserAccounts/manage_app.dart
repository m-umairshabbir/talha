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
  String selectedLanguage = "English"; // Default language selection

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
            _buildSettingsCard(
              icon: Icons.color_lens,
              title: "Theme",
              subtitle: "Current: $selectedTheme",
              onTap: _openThemeSettings,
            ),
            const SizedBox(height: 16),

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

            _buildSettingsCard(
              icon: Icons.accessibility,
              title: "Accessibility",
              subtitle: "Font size and High Contrast options",
              onTap: _openAccessibilitySettings,
            ),
            const SizedBox(height: 16),

            _buildSettingsCard(
              icon: Icons.language,
              title: "Language",
              subtitle: "Current: $selectedLanguage",
              onTap: _openLanguageSettings,
            ),
            const SizedBox(height: 16),

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

  void _openThemeSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Select Theme"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildRadioTile("Light", selectedTheme, (value) {
              setState(() {
                selectedTheme = value;
                Navigator.pop(context);
              });
            }),
            _buildRadioTile("Dark", selectedTheme, (value) {
              setState(() {
                selectedTheme = value;
                Navigator.pop(context);
              });
            }),
            _buildRadioTile("Custom", selectedTheme, (value) {
              setState(() {
                selectedTheme = value;
                Navigator.pop(context);
              });
            }),
          ],
        ),
      ),
    );
  }

  void _openLanguageSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Select Language"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildRadioTile("English", selectedLanguage, (value) {
              setState(() {
                selectedLanguage = value;
                Navigator.pop(context);
              });
            }),
            _buildRadioTile("Urdu", selectedLanguage, (value) {
              setState(() {
                selectedLanguage = value;
                Navigator.pop(context);
              });
            }),
            _buildRadioTile("Chinese", selectedLanguage, (value) {
              setState(() {
                selectedLanguage = value;
                Navigator.pop(context);
              });
            }),
            _buildRadioTile("German", selectedLanguage, (value) {
              setState(() {
                selectedLanguage = value;
                Navigator.pop(context);
              });
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioTile(String title, String groupValue, ValueChanged<String> onChanged) {
    return RadioListTile(
      title: Text(title),
      value: title,
      groupValue: groupValue,
      onChanged: (value) {
        onChanged(value!);
      },
    );
  }

  void _openAccessibilitySettings() {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Accessibility Settings')));
  }

  void _openLinkedAccounts() {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Linked Accounts')));
  }
}
