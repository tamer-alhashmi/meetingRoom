import 'package:flutter/material.dart';
import '../model/user/app_user.dart';

class CustomDrawer extends StatelessWidget {
  final AppUser user; // Pass the AppUser instance
  final VoidCallback onSignOut;

  const CustomDrawer({
    required this.user,
    required this.onSignOut,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: user.photoURL.isNotEmpty
                  ? NetworkImage(user.photoURL)
                  : null,
              backgroundColor: Colors.grey,
              child: user.photoURL.isEmpty
                  ? Text(
                user.firstName.isNotEmpty
                    ? user.firstName[0].toUpperCase()
                    : '?', // Show the first letter of the first name or '?' if empty
                style: const TextStyle(fontSize: 24, color: Colors.white),
              )
                  : null,
            ),
            accountName: Text("${user.firstName} ${user.lastName}"),
            accountEmail: Text(user.email),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('My Reservations'),
            onTap: () {
              Navigator.pushNamed(context, '/reservations');
            },
          ),
          ListTile(
            leading: const Icon(Icons.update),
            title: const Text('Update Personal Info'),
            onTap: () {
              Navigator.pushNamed(context, '/updateInfo');
            },
          ),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Sign Out', style: TextStyle(color: Colors.red)),
            onTap: () => _showSignOutConfirmation(context),
          ),
        ],
      ),
    );
  }

  void _showSignOutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Sign Out"),
          content: const Text("Are you sure you want to sign out?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text("Sign Out"),
              onPressed: () {
                Navigator.pop(context); // Close dialog
                onSignOut(); // Call the provided sign-out logic
              },
            ),
          ],
        );
      },
    );
  }
}
