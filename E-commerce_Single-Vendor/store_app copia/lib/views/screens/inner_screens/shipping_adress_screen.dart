import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_state_city_picker_2/country_state_city_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShippingAdressScreen extends StatefulWidget {
  const ShippingAdressScreen({super.key});

  @override
  State<ShippingAdressScreen> createState() => _ShippingAdressScreenState();
}

class _ShippingAdressScreenState extends State<ShippingAdressScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String state;
  late String city;
  late String country;
  late String postCode;
  late String road;
  late String number;
  String inside = "";
  late String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.96),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white.withOpacity(0.96),
        title: Text(
          'Delivery',
          style: GoogleFonts.lato(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Center(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'where will your order\nbe shipped ',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    onChanged: (value) {
                      phoneNumber = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'enter field';
                      } else {
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SelectState(
                    spacing: 30,
                    dropdownColor: Colors.black,
                    onCountryChanged: (value) {
                      setState(() {
                        country = value;
                      });
                    },
                    onStateChanged: (value) {
                      setState(() {
                        state = value;
                      });
                    },
                    onCityChanged: (value) {
                      setState(() {
                        city = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    onChanged: (value) {
                      road = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'enter field';
                      } else {
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: 'Road',
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 130,
                        child: TextFormField(
                          onChanged: (value) {
                            number = value;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'enter field';
                            } else {
                              return null;
                            }
                          },
                          decoration: const InputDecoration(
                            labelText: 'Post Number',
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 130,
                        child: TextFormField(
                          onChanged: (value) {
                            inside = value;
                          },
                          decoration: const InputDecoration(
                            labelText: 'Inside',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    onChanged: (value) {
                      postCode = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'enter field';
                      } else {
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: 'Post Code',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () async {
            if (_formKey.currentState!.validate()) {
              //upload the user locality, city, state, pincode
              _showDialog(context);
              try {
                await _firestore
                    .collection('buyers')
                    .doc(_auth.currentUser!.uid)
                    .update({
                  'state': state,
                  'city': city,
                  'country': country,
                  'road': road,
                  'postNumber': number,
                  'inside': inside,
                  'postCode': postCode,
                  'phoneNumber': phoneNumber,
                }).whenComplete(() {
                  Navigator.of(context).pop();
                  setState(() {
                    _formKey.currentState!.validate();
                  });
                });
              } catch (e) {
                Navigator.of(context)
                    .pop(); // Chiudi il dialogo se c'è un errore
                // Mostra un messaggio di errore
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Errore nell\'aggiornamento: $e')),
                );
              }
            } else {
              //we can show a snackbar
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(
                0xFF1532E7,
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Center(
              child: Text(
                'Add Adress',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false, //use must tab button
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text('Update Dialog'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  height: 10,
                ),
                Text('Please Wait...')
              ],
            ),
          );
        });
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pop();
    });
  }
}
