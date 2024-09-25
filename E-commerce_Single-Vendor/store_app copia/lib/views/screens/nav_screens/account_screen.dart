import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:store_app/views/screens/authentication_screens/login_screen.dart';
import 'package:store_app/views/screens/inner_screens/edit_profile_screen.dart';
import 'package:store_app/views/screens/inner_screens/new_page.dart';
import 'package:store_app/views/screens/inner_screens/order_screen.dart';
import 'package:store_app/views/screens/inner_screens/setting_screen.dart';

class AccountScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    CollectionReference _buyersStream =
        FirebaseFirestore.instance.collection('buyers');

    return _auth.currentUser == null
        ? Scaffold(
            appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.20),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 100,
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/icons/cartb.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 71,
                      top: 41,
                      child: Text(
                        'Profile',
                        style: GoogleFonts.lato(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 20,
                      top: 42,
                      child: Stack(
                        children: [
                          Image.asset(
                            'assets/icons/profile.png',
                            width: 40,
                            height: 40,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Login Account To Access Profile',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return LoginScreen();
                      }));
                    },
                    child: const Text(
                      'Login Screen',
                      style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue
                    ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : FutureBuilder<DocumentSnapshot>(
            future:
                _buyersStream.doc(FirebaseAuth.instance.currentUser!.uid).get(),
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
                  appBar: PreferredSize(
                    preferredSize: Size.fromHeight(
                        MediaQuery.of(context).size.height * 0.20),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      clipBehavior: Clip.hardEdge,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/icons/cartb.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            left: 71,
                            top: 41,
                            child: Text(
                              data['fullName'],
                              style: GoogleFonts.lato(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 20,
                            top: 42,
                            child: Stack(
                              children: [
                                data['profileImage'] == ''
                                    ? Image.asset(
                                        'assets/icons/profile.png',
                                        width: 40,
                                        height: 40,
                                      )
                                    : Image.network(
                                        data['profileImage'],
                                        width: 40,
                                        height: 40,
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: CircleAvatar(
                            radius: 64,
                            backgroundColor: Colors.blue,
                            backgroundImage: data['profileImage'] != null &&
                                    data['profileImage'].isNotEmpty
                                ? NetworkImage(data['profileImage'])
                                : const AssetImage('assets/icons/profile.png')
                                    as ImageProvider,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            data['fullName'],
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            data['email'],
                            style: const TextStyle(
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
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
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
                        const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Divider(
                            thickness: 2,
                            color: Colors.grey,
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return const SettingScreen();
                            }));
                          },
                          leading: const Icon(Icons.settings),
                          title: Text(translate('Settings')),
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return OrderScreen();
                            }));
                          },
                          leading: const Icon(CupertinoIcons.cart_fill),
                          title: Text(translate('Orders')),
                        ),
                        ListTile(
                          onTap: () async {
                            await _auth.signOut().whenComplete(() {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return NewPage();
                              }));
                            });
                          },
                          leading: const Icon(Icons.door_back_door),
                          title: Text(translate('new page')),
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
                          leading: const Icon(Icons.logout),
                          title: Text(translate('Logout')),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          );
  }
}
