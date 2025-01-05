import 'package:flutter/material.dart';

import '../app_theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.white),),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: const Center(
        child: Text('Profile Screen'),
      ),
    );
  }
}