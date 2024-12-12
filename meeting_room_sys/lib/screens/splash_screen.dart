import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../firebase_services/auth_service.dart';
import '../login/login_screen.dart';
import '../model/user/app_user.dart';
import '../navigations/navigation_util.dart';

class SplashScreen extends StatelessWidget {
  final AuthService authService;
  const SplashScreen({Key? key, required this.authService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _hasNavigated = false;

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          final User? firebaseUser = snapshot.data;

          if (firebaseUser != null) {
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(firebaseUser.uid)
                  .get(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (userSnapshot.hasData && userSnapshot.data!.exists && !_hasNavigated) {
                  _hasNavigated = true; // Prevent multiple navigations
                  final AppUser user =
                  AppUser.fromFirestore(userSnapshot.data!);
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    navigateToRoleBasedScreen(context, user);
                  });
                  return const SizedBox.shrink(); // Placeholder
                } else {
                  return LoginScreen(authService: authService);
                }
              },
            );
          } else {
            return LoginScreen(authService: authService);
          }
        }

        return LoginScreen(authService: authService);
      },
    );
  }
}

