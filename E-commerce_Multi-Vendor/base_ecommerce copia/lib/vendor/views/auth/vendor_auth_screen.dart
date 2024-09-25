//import 'package:base_ecommerce/vendor/views/screens/landing_screen.dart';
import 'package:base_ecommerce/vendor/views/screens/main_vendor_screen.dart';
import 'package:base_ecommerce/views/buyers/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

class VendorAuthScreen extends StatelessWidget {
  const VendorAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      initialData: FirebaseAuth.instance.currentUser,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Column(
            children: [
              Expanded(
                child: SignInScreen(
                  providers: [
                    EmailAuthProvider(),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Go to Buyers app'),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return LoginScreen();
                      }));
                    },
                    child: Text(
                      'Buyer Login',
                    ),
                  ),
                ],
              ),
            ],
          );
        }

        return const MainVendorScreen();
      },
    );
  }
}
