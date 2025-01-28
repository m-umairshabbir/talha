import 'package:flutter/material.dart';
import 'package:untitled/ManageUserAccounts/manage_app.dart';
import 'package:untitled/Screens/UserAccounManagement/user_account.dart';

class CaretakerProfileScreen extends StatefulWidget {
  const CaretakerProfileScreen({super.key});

  @override
  _CaretakerProfileScreenState createState() => _CaretakerProfileScreenState();
}

class _CaretakerProfileScreenState extends State<CaretakerProfileScreen> {
  List<Map<String, String>> reportedIssues = [
    {"title": "Login Issue", "status": "Pending", "description": "User unable to log in."},
    {"title": "App Crash", "status": "Resolved", "description": "App crashes on opening settings."},
  ];

  int resolvedCount = 1; // Example stats
  int pendingCount = 1;
  int activeUsers = 50;
  int notificationsCount = 3; // Example notification count

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        actions: [
          // Notification Icon
          Stack(
            children: [
              IconButton(
                icon: Icon(
                  Icons.notifications,
                  size: 35,
                  color: Colors.yellow.shade700,
                ),
                onPressed: _showNotifications, // Show notifications on tap
              ),
              if (notificationsCount > 0)
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$notificationsCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Statistics Section
              const Text(
                'Statistics',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff253244),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatCard('Resolved', '$resolvedCount', Colors.green),
                  _buildStatCard('Pending', '$pendingCount', Colors.orange),
                  _buildStatCard('Active', '$activeUsers', Colors.blue),
                ],
              ),
              const SizedBox(height: 20),

              // Reported Issues Section
              const Text(
                'Reported Issues',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff253244),
                ),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: reportedIssues.length,
                itemBuilder: (context, index) {
                  final issue = reportedIssues[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: issue["status"] == "Pending"
                            ? Colors.orange
                            : Colors.green,
                        child: Icon(
                          issue["status"] == "Pending"
                              ? Icons.warning
                              : Icons.check,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(issue["title"]!),
                      subtitle: Text(issue["status"]!),
                      trailing: ElevatedButton(
                        onPressed: issue["status"] == "Pending"
                            ? () {
                          setState(() {
                            issue["status"] = "Resolved";
                            resolvedCount++;
                            pendingCount--;
                          });
                        }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: issue["status"] == "Pending"
                              ? Colors.green
                              : Colors.grey,
                        ),
                        child: Text(
                          issue["status"] == "Pending" ? 'Resolve' : 'Resolved',
                        ),
                      ),
                      onTap: () {
                        _showIssueDetails(
                            issue["title"]!, issue["description"]!);
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              // User Management Section
              const Text(
                'User Account Management',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff253244),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 2,
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: const Text('Manage User Accounts'),
                  subtitle:
                  const Text('Reset passwords or update user details.'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ManageUserAccountsScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // App Settings Section
              const Text(
                'App Customizations',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff253244),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 2,
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.purple,
                    child: Icon(Icons.settings, color: Colors.white),
                  ),
                  title: const Text('Manage App Settings'),
                  subtitle: const Text('Customize app settings for users.'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ManageAppSettingsScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper to build stat cards
  Widget _buildStatCard(String label, String value, Color color) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.2),
                child: Icon(Icons.analytics, color: color),
              ),
              const SizedBox(height: 10),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Show details for an issue
  void _showIssueDetails(String title, String description) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(description),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // Show notifications
  void _showNotifications() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notifications'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            notificationsCount,
                (index) => ListTile(
              leading:
              const Icon(Icons.notification_important, color: Colors.blue),
              title: Text('Notification ${index + 1}'),
              subtitle: Text('Details of notification ${index + 1}...'),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
