import 'package:flutter/material.dart';
import '../screens/owner_dashnoard.dart';
import '../screens/manager_screen.dart';
import '../screens/team_leaders_screen.dart';
import '../model/user/app_user.dart';
import '../model/notifications/toast.dart';

Future<void> navigateToRoleBasedScreen(BuildContext context, AppUser user) async {
  if (user.role == 'Owner') {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const OwnerDashboard()),
    );
  } else if (user.role == 'manager') {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ManagerScreen()),
    );
  } else if (user.role == 'Team Leader') {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => RoomBookingScreen(userId: user.uid)),
    );
  } else {
    showToast(message: 'Role not recognized. Please contact support.');
  }
}
