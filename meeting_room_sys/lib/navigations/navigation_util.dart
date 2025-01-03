import 'package:flutter/material.dart';
import 'package:meeting_room_sys/firebase_services/auth_service.dart';
import 'package:meeting_room_sys/login/login_screen.dart';
import '../screens/owner_dashboard.dart';
import '../screens/manager_screen.dart';
import '../screens/team_leaders_screen.dart';
import '../model/user/app_user.dart';
import '../model/notifications/toast.dart';
import '../screens/user_booking_screen.dart';


late final AuthService authService;
late final AppUser user;

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
  } else if (user.role == 'User') {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => UserBookingScreen(user: user, )),
    );
  } else {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen(authService: authService,)),
    );

    showToast(message: 'Role not recognized. Please contact support.');
  }
}

