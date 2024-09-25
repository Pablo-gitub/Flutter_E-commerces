import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:store_app/provider/cart_provider.dart';
import 'package:store_app/views/screens/inner_screens/checkout_screen.dart';
import 'package:store_app/views/screens/main_screen.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cartData = ref.watch(cartProvider);
    final _cartProvider = ref.read(cartProvider.notifier);
    final totalAmount = ref.read(cartProvider.notifier).calculateTotalAmount();
    return Scaffold(
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
                left: 310,
                top: 42,
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/icons/cart.png',
                      width: 40,
                      height: 40,
                      color: Colors.white,
                    ),
                    Positioned(
                      top: -6,
                      right: 0,
                      child: badges.Badge(
                        badgeStyle: badges.BadgeStyle(
                          badgeColor: Colors.yellow.shade800,
                        ),
                        badgeContent: Text(
                          cartData.length.toString(),
                          style: GoogleFonts.lato(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                  left: 31,
                  top: 41,
                  child: Text(
                    'My Cart',
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ))
            ],
          ),
        ),
      ),
      body: cartData.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Your shopping cart is empty\n you can add product to your cart from the button below',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize: 17,
                      letterSpacing: 1.7,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return MainScreen();
                          },
                        ),
                      );
                    },
                    child: Text(
                      'Shopp Now',
                      style: GoogleFonts.lato(
                        fontSize: 17,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 49,
                    clipBehavior: Clip.hardEdge,
                    decoration: const BoxDecoration(),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 48,
                            clipBehavior: Clip.hardEdge,
                            decoration: const BoxDecoration(
                              color: Color(
                                0xFFD7DDFF,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 44,
                          top: 19,
                          child: Container(
                            width: 10,
                            height: 10,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 69,
                          top: 11,
                          child: Text(
                            'You have ${cartData.length} items',
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.7,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                    itemCount: cartData.length,
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemBuilder: (context, index) {
                      final cartItem = cartData.values.toList()[index];
                      return Padding(
                        padding: const EdgeInsets.all(8),
                        child: Card(
                          child: SizedBox(
                            height: 200,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: Image.network(
                                      cartItem.imageUrl[0],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cartItem.productName,
                                          style: GoogleFonts.lato(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          cartItem.categoryName,
                                          style: GoogleFonts.lato(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.blueGrey,
                                          ),
                                        ),
                                        Text(
                                          (cartItem.productPrice -
                                                  cartItem.discount)
                                              .toStringAsFixed(
                                            2,
                                          ),
                                          style: GoogleFonts.lato(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFF102DE1),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              height: 40,
                                              width: 120,
                                              decoration: BoxDecoration(
                                                  color: const Color(
                                                    0xFF102DE1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  IconButton(
                                                    onPressed: () {
                                                      _cartProvider
                                                          .decrementItem(
                                                              cartItem
                                                                  .productId);
                                                    },
                                                    icon: const Icon(
                                                      CupertinoIcons.minus,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Text(
                                                    cartItem.quantity
                                                        .toString(),
                                                    style: GoogleFonts.lato(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      _cartProvider
                                                          .incrementItem(
                                                              cartItem
                                                                  .productId);
                                                    },
                                                    icon: const Icon(
                                                      CupertinoIcons.plus,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                _cartProvider.removeItem(
                                                    cartItem.productId);
                                              },
                                              icon: const Icon(
                                                CupertinoIcons.delete,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
      bottomNavigationBar: Container(
        width: 416,
        height: 89,
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 416,
                height: 89,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: const Color(
                        0xFFC4C4C4,
                      ),
                    )),
              ),
            ),
            Align(
              alignment: const Alignment(
                -0.90,
                -0.26,
              ),
              child: Text(
                'Subtotal',
                style: GoogleFonts.roboto(
                  color: const Color(
                    0xFFA1A1A1,
                  ),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Align(
              alignment: const Alignment(
                -0.39,
                -0.31,
              ),
              child: Text(
                totalAmount.toStringAsFixed(2),
                style: GoogleFonts.roboto(
                  color: const Color(
                    0xFFFF6464,
                  ),
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Align(
              alignment: const Alignment(0.83, 0),
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return CheckoutScreen();
                  }));
                },
                child: Container(
                  width: 160,
                  height: 41,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: totalAmount == 0
                        ? Colors.grey
                        : const Color(
                            0xFF102DE1,
                          ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Checkout',
                            style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
