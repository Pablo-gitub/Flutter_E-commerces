import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:store_app/provider/cart_provider.dart';
import 'package:store_app/views/screens/inner_screens/shipping_adress_screen.dart';
import 'package:store_app/views/screens/main_screen.dart';
import 'package:uuid/uuid.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _selectedPaymentMethod = 'stripe';

  //get current user information
  String state = '';
  String city = '';
  String locality = '';
  String pinCode = '';

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  //get current user details
  void getUserData() {
    Stream<DocumentSnapshot> userDataStream =
        _firestore.collection('buyers').doc(_auth.currentUser!.uid).snapshots();
    //listen to the stream and update the data
    userDataStream.listen((DocumentSnapshot userData) {
      if (userData.exists) {
        setState(() {
          state = userData.get('state');
          city = userData.get('city');
          locality = userData.get('locality');
          pinCode = userData.get('pinCode');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProviderData = ref.read(cartProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const ShippingAdressScreen();
                  }));
                },
                child: SizedBox(
                  width: 335,
                  height: 74,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          width: 335,
                          height: 74,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: const Color(
                                0xFFEFF0F2,
                              ),
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 70,
                        top: 17,
                        child: SizedBox(
                          width: 215,
                          height: 41,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                left: -1,
                                top: -1,
                                child: SizedBox(
                                  width: 219,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Add Adress',
                                          style: GoogleFonts.lato(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            height: 1.3,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Enter City',
                                          style: GoogleFonts.lato(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            height: 1.3,
                                            color: const Color(0xFF7F808C),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 16,
                        top: 16,
                        child: SizedBox.square(
                          dimension: 42,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 43,
                                  height: 43,
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFFFBF7F5,
                                    ),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Stack(
                                    clipBehavior: Clip.hardEdge,
                                    children: [
                                      Positioned(
                                        left: 11,
                                        top: 11,
                                        child: Image.network(
                                          "https://storage.googleapis.com/codeless-dev.appspot.com/uploads%2Fimages%2Fnn2Ldqjoc2Xp89Y7Wfzf%2F2ee3a5ce3b02828d0e2806584a6baa88.png",
                                          width: 20,
                                          height: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 305,
                        top: 25,
                        child: Image.network(
                          'https://firebasestorage.googleapis.com/v0/b/codeless-app.appspot.com/o/projects%2Fnn2Ldqjoc2Xp89Y7Wfzf%2F6ce18a0efc6e889de2f2878027c689c9caa53feeedit%201.png?alt=media&token=a3a8a999-80d5-4a2e-a9b7-a43a7fa8789a',
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                'Your Items',
                style: GoogleFonts.lato(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 300,
                child: ListView.builder(
                    itemCount: cartProviderData.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final cartItem = cartProviderData.values.toList()[index];
                      return InkWell(
                        onTap: () {},
                        child: Container(
                          width: 336,
                          height: 91,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: const Color(0xFFEFF0F2),
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                left: 6,
                                top: 6,
                                child: SizedBox(
                                  width: 320,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 3),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 78,
                                          height: 78,
                                          clipBehavior: Clip.hardEdge,
                                          decoration: BoxDecoration(
                                            color: const Color(
                                              0xFFBCC5FF,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Image.network(
                                            cartItem.imageUrl[0],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 11,
                                        ),
                                        Expanded(
                                          child: Container(
                                            height: 78,
                                            alignment:
                                                const Alignment(0, -0.51),
                                            child: SizedBox(
                                              width: double.infinity,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SizedBox(
                                                    width: double.infinity,
                                                    child: Text(
                                                      cartItem.productName,
                                                      style: GoogleFonts.lato(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        height: 1.3,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 4,
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      cartItem.categoryName,
                                                      style: const TextStyle(
                                                        color: Colors.blueGrey,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Price',
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                                color: Colors.black,
                                                height: 1.3,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'discount',
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                                color: Colors.pink,
                                                height: 1.3,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'quantity',
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                                color: Colors.black,
                                                height: 1.3,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'total',
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                                color: Colors.green,
                                                height: 1.3,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 30,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              '${cartItem.productPrice} €',
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                                color: Colors.black,
                                                height: 1.3,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              '${cartItem.discount} €',
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                                color: Colors.pink,
                                                height: 1.3,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              '${cartItem.quantity} €',
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                                color: Colors.black,
                                                height: 1.3,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              '${((cartItem.productPrice - cartItem.discount) * cartItem.quantity).toStringAsFixed(2)} €',
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                                color: Colors.green,
                                                height: 1.3,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Choose Payment Method',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              RadioListTile(
                title: const Text('Stripe'),
                value: 'stripe',
                groupValue: _selectedPaymentMethod,
                onChanged: (String? value) {
                  setState(() {
                    _selectedPaymentMethod = value!;
                  });
                },
              ),
              RadioListTile(
                title: const Text('Cash On Delivery'),
                value: 'cashOnDelivery',
                groupValue: _selectedPaymentMethod,
                onChanged: (String? value) {
                  setState(() {
                    _selectedPaymentMethod = value!;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      bottomSheet: state == ""
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: const Color(
                      0xFF102DE1,
                    ),
                    foregroundColor: Colors.white),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const ShippingAdressScreen();
                  }));
                },
                child: const Text('Add Address'),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () async {
                  if (_selectedPaymentMethod == 'stripe') {
                    //pay with stripe
                  } else {
                    setState(() {
                      isLoading = true;
                    });
                    //pay on delivery
                    for (var item
                        in ref.read(cartProvider.notifier).getCartItem.values) {
                      DocumentSnapshot userDoc = await _firestore
                          .collection('buyers')
                          .doc(_auth.currentUser!.uid)
                          .get();
                      CollectionReference orderRef =
                          _firestore.collection('orders');
                      final orderId = const Uuid().v4();
                      await orderRef.doc(orderId).set({
                        'orderId': orderId,
                        'productName': item.productName,
                        'productId': item.productId,
                        'size': item.productSize,
                        'quantity': item.quantity,
                        'price':
                            item.quantity * (item.productPrice - item.discount),
                        'category': item.categoryName,
                        'productImage': item.imageUrl[0],
                        'state':
                            (userDoc.data() as Map<String, dynamic>)['state'],
                        'city':
                            (userDoc.data() as Map<String, dynamic>)['city'],
                        'country':
                            (userDoc.data() as Map<String, dynamic>)['country'],
                        'road':
                            (userDoc.data() as Map<String, dynamic>)['road'],
                        'phoneNumber': (userDoc.data()
                            as Map<String, dynamic>)['phoneNumber'],
                        'postCode': (userDoc.data()
                            as Map<String, dynamic>)['postCode'],
                        'postNumber': (userDoc.data()
                            as Map<String, dynamic>)['postNumber'],
                        'inside':
                            (userDoc.data() as Map<String, dynamic>)['inside'],
                        'email':
                            (userDoc.data() as Map<String, dynamic>)['email'],
                        'fullName': (userDoc.data()
                            as Map<String, dynamic>)['fullName'],
                        'buyerId': _auth.currentUser!.uid,
                        'deliveredCount': 0,
                        'delivered': false,
                        'processing': true,
                      });

                      // Aggiorna il campo totalSold del prodotto corrispondente
                      DocumentReference productRef =
                          _firestore.collection('products').doc(item.productId);
                      _firestore.runTransaction((transaction) async {
                        DocumentSnapshot productSnapshot =
                            await transaction.get(productRef);
                        if (productSnapshot.exists) {
                          int newTotalSold =
                              (productSnapshot.get('totalSold') ?? 0) +
                                  item.quantity;
                          transaction
                              .update(productRef, {'totalSold': newTotalSold});
                        }
                      });
                    }
                    cartProviderData.clear();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return MainScreen();
                    }));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.grey,
                        content: Text('order have been placed'),
                      ),
                    );
                    setState(() {
                      isLoading = false;
                    });
                  }
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width - 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color(
                      0xFF102DE1,
                    ),
                  ),
                  child: Center(
                    child: isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            'PLACE ORDER',
                            style: GoogleFonts.lato(
                              color: Colors.white,
                              fontSize: 17,
                              height: 1.4,
                            ),
                          ),
                  ),
                ),
              ),
            ),
    );
  }
}
