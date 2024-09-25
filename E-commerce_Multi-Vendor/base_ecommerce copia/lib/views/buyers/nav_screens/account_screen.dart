import 'package:base_ecommerce/views/buyers/auth/login_screen.dart';
import 'package:base_ecommerce/views/buyers/inner_screens/edit_profile.dart';
import 'package:base_ecommerce/views/buyers/inner_screens/order_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('buyers');
    return _auth.currentUser == null
        ? Scaffold(
            appBar: AppBar(
              elevation: 2,
              backgroundColor: Colors.yellow.shade900,
              title: Text(
                'Profile',
                style: TextStyle(letterSpacing: 4),
              ),
              centerTitle: true,
              // actions: [
              //   Padding(
              //     padding: const EdgeInsets.all(14.0),
              //     child: Icon(Icons.star),
              //   ),
              // ],
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: CircleAvatar(
                    radius: 64,
                    backgroundColor: Colors.yellow.shade900,
                    child: Icon(Icons.person, size: 60, color:  Colors.white,),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Login Account To Access Profile',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                      return LoginScreen();
                    }));
                  },
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width - 100,
                    decoration: BoxDecoration(
                      color: Colors.yellow.shade900,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'LOGIN ACCOUNT',
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 3,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : FutureBuilder<DocumentSnapshot>(
            future: users.doc(FirebaseAuth.instance.currentUser!.uid).get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text("Something went wrong");
              }

              if (snapshot.hasData && !snapshot.data!.exists) {
                return Text("Document does not exist");
              }

              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;
                return Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    elevation: 2,
                    backgroundColor: Colors.yellow.shade900,
                    title: Text(
                      'Profile',
                      style: TextStyle(letterSpacing: 4),
                    ),
                    centerTitle: true,
                    actions: [
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Icon(Icons.star),
                      ),
                    ],
                  ),
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: CircleAvatar(
                            radius: 64,
                            backgroundColor: Colors.yellow.shade900,
                            backgroundImage: NetworkImage(data['profileImage']),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            data['fullName'],
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            data['email'],
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return EditProfileScreen(
                                  userData: data,
                                );
                              }),
                            );
                          },
                          child: Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width - 200,
                            decoration: BoxDecoration(
                              color: Colors.yellow.shade900,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                'Edit Profile',
                                style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 3,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Divider(
                            thickness: 2,
                            color: Colors.grey,
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.settings),
                          title: Text('Settings'),
                        ),
                        ListTile(
                          leading: Icon(Icons.phone),
                          title: Text('Phone Number'),
                          subtitle: Text(
                            data['phoneNumber'],
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        ListTile(
                          leading: Icon(CupertinoIcons.cart),
                          title: Text('Cart'),
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return BuyerOrderScreen();
                            }));
                          },
                          leading: Icon(CupertinoIcons.cart_fill),
                          title: Text('Orders'),
                        ),
                        ListTile(
                          onTap: () async {
                            await _auth.signOut().whenComplete(() {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return LoginScreen();
                              }));
                            });
                          },
                          leading: Icon(Icons.logout),
                          title: Text('Logout'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Center(child: CircularProgressIndicator());
            },
          );
  }
}
