import 'package:base_ecommerce/vendor/models/vendor_user_models.dart';
import 'package:base_ecommerce/vendor/views/screens/main_vendor_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth/vendor_register_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final CollectionReference _vendorsStream =
        FirebaseFirestore.instance.collection('vendors');
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: _vendorsStream.doc(_auth.currentUser!.uid).snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          if(!snapshot.data!.exists){
            return VendorRegisterScreen();
          }

          VendorUserModel vendorUserModel = VendorUserModel.fromJson(
              snapshot.data!.data()! as Map<String, dynamic>);

          if(vendorUserModel.approved == true){
            return MainVendorScreen();
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    vendorUserModel.storeImage.toString(),
                    width: 90,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  vendorUserModel.bussinessName.toString(),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Your application has been sent to shop admin\n Admin will get back to you soon',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () async {
                    await _auth.signOut();
                  },
                  child: const Text('Signout'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
