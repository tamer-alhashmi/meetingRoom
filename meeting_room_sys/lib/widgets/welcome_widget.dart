import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/user/app_user.dart';

class WelcomeWidget extends StatelessWidget {
  final AppUser user;

  const WelcomeWidget({
    Key? key,
    required this.user,
  }) : super(key: key);

  String _getGreeting() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else if (hour < 20) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  String _getFormattedDate() {
    return DateFormat.yMMMMEEEEd().format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final greeting = _getGreeting();
    final currentDate = _getFormattedDate();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade300, Colors.blue.shade600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$greeting, ${user.firstName}!',
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                currentDate,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
