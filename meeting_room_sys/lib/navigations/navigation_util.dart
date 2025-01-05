import 'package:flutter/material.dart';
import 'package:meeting_room_sys/firebase_services/auth_service.dart';
import 'package:meeting_room_sys/login/login_screen.dart';
import '../screens/owner_dashboard.dart';
import '../screens/manager_screen.dart';
import '../screens/team_leaders_screen.dart';
import '../model/user/app_user.dart';
import '../model/notifications/toast.dart';
import '../screens/user_booking_screen.dart';

Future<void> navigateToRoleBasedScreen({
  required BuildContext context,
  required AppUser user,
  required AuthService authService,
}) async {
  if (user.role == 'Owner') {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => OwnerDashboard(user: user),
      ),
    );
  } else if (user.role == 'Manager') {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ManagerScreen(user: user),
      ),
    );
  } else if (user.role == 'Team Leader') {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => RoomBookingScreen(user: user),
      ),
    );
  } else if (user.role == 'User') {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => UserBookingScreen(user: user),
      ),
    );
  } else {
    // Handle unrecognized role
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(authService: authService),
      ),
    );

    showToast(message: 'Role not recognized. Please contact support.');
  }
}
