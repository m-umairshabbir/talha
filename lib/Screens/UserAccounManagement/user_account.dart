import 'package:flutter/material.dart';

class ManageUserAccountsScreen extends StatefulWidget {
  const ManageUserAccountsScreen({super.key});

  @override
  _ManageUserAccountsScreenState createState() =>
      _ManageUserAccountsScreenState();
}

class _ManageUserAccountsScreenState extends State<ManageUserAccountsScreen> {
  List<Map<String, String>> users = [
    {"name": "Muhammad Talha", "email": "talha.muh@gmail.com", "status": "Active"},
    {"name": "Jahangir Haider", "email": "haider.haider@gmail.com", "status": "Inactive"},
    {"name": "Ahtisham Kabir", "email": "ahtisham.kabir@gmail.com", "status": "Active"},
  ];

  List<Map<String, String>> filteredUsers = [];

  @override
  void initState() {
    super.initState();
    filteredUsers = users; // Initialize filtered list with all users
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage User Accounts'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchDialog, // Opens search dialog
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: filteredUsers.length,
        itemBuilder: (context, index) {
          final user = filteredUsers[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 4,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: user['status'] == "Active"
                    ? Colors.green.withOpacity(0.2)
                    : Colors.orange.withOpacity(0.2),
                child: Icon(
                  user['status'] == "Active" ? Icons.check : Icons.warning,
                  color: user['status'] == "Active" ? Colors.green : Colors.orange,
                ),
              ),
              title: Text(user['name']!),
              subtitle: Text(user['email']!),
              trailing: PopupMenuButton(
                onSelected: (value) {
                  if (value == 'reset_password') {
                    _showResetPasswordDialog(user['name']!);
                  } else if (value == 'deactivate') {
                    _deactivateAccount(index);
                  } else if (value == 'view_details') {
                    _viewUserDetails(user);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'reset_password', child: Text('Reset Password')),
                  const PopupMenuItem(value: 'deactivate', child: Text('Deactivate Account')),
                  const PopupMenuItem(value: 'view_details', child: Text('View Details')),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // **🔍 Show Search Dialog**
  void _showSearchDialog() {
    TextEditingController searchController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Users'),
        content: TextField(
          controller: searchController,
          decoration: const InputDecoration(
            labelText: 'Enter Name or Email',
            border: OutlineInputBorder(),
          ),
          onChanged: (query) {
            setState(() {
              filteredUsers = users
                  .where((user) =>
              user['name']!.toLowerCase().contains(query.toLowerCase()) ||
                  user['email']!.toLowerCase().contains(query.toLowerCase()))
                  .toList();
            });
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                filteredUsers = users; // Reset search
              });
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  // **🔑 Show Reset Password Dialog with Eye Toggle**
  void _showResetPasswordDialog(String userName) {
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();

    bool _isNewPasswordVisible = false;
    bool _isConfirmPasswordVisible = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Reset Password for $userName'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: newPasswordController,
                    obscureText: !_isNewPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isNewPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isNewPasswordVisible = !_isNewPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: !_isConfirmPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final newPassword = newPasswordController.text;
                    final confirmPassword = confirmPasswordController.text;

                    if (newPassword.isEmpty || confirmPassword.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill in all fields')),
                      );
                      return;
                    }

                    if (newPassword != confirmPassword) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Passwords do not match')),
                      );
                      return;
                    }

                    // Handle successful password reset
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Password successfully reset for $userName')),
                    );
                  },
                  child: const Text('Reset'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deactivateAccount(int index) {
    setState(() {
      users[index]['status'] = "Inactive";
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account deactivated')),
    );
  }

  void _viewUserDetails(Map<String, String> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Details for ${user['name']}'),
        content: Text('Email: ${user['email']}\nStatus: ${user['status']}'),
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
