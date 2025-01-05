import 'package:flutter/material.dart';

import '../app_theme/app_theme.dart';

class MyReservationsScreen extends StatelessWidget {
  const MyReservationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Reservations', style: TextStyle(color: Colors.white),),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: const Center(
        child: Text('My Reservations Screen'),
      ),
    );
  }
}