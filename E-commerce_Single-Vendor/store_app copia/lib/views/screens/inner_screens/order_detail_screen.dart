import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderDetailScreen extends StatefulWidget {
  final dynamic orderData;

  OrderDetailScreen({super.key, required this.orderData});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final TextEditingController _reviwController = TextEditingController();
  double rating = 0;

  //check if the current logged user have gave a review or not
  Future<bool> hasUserReviewedProduct(String productId) async {
    final user = FirebaseAuth.instance.currentUser;
    final querySnapshot = await FirebaseFirestore.instance
        .collection('productReviews')
        .where('productId', isEqualTo: productId)
        .where('buyerId', isEqualTo: user!.uid)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  //update review and rating within the product collection
  Future<void> updateProductRating(String productId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('productReviews')
        .where('productId', isEqualTo: productId)
        .get();

    double totalRating = 0;
    int totalReviews = querySnapshot.docs.length;
    for (final doc in querySnapshot.docs) {
      totalRating += doc['rating'];
    }

    final double averageRating =
        totalReviews > 0 ? totalRating / totalReviews : 0;
    await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .update({
      'rating': averageRating,
      'totalReviews': totalReviews,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.orderData['productName'],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 25,
              ),
              child: Container(
                width: 335,
                height: 153,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(),
                child: SizedBox(
                  width: double.infinity,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 336,
                          height: 154,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: const Color(
                                0xFFEFF0F2,
                              ),
                            ),
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                left: 13,
                                top: 9,
                                child: Container(
                                  width: 78,
                                  height: 78,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFFBCC5FF,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      8,
                                    ),
                                  ),
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Positioned(
                                        left: 10,
                                        top: 5,
                                        child: Image.network(
                                          widget.orderData["productImage"],
                                          width: 58,
                                          height: 67,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 101,
                                top: 14,
                                child: SizedBox(
                                  width: 216,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(
                                                width: double.infinity,
                                                child: Text(
                                                  widget
                                                      .orderData['productName'],
                                                  style: GoogleFonts.lato(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  widget.orderData['category'],
                                                  style: const TextStyle(
                                                    color: Color(
                                                      0xFF7F808C,
                                                    ),
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 2,
                                              ),
                                              Text(
                                                "${widget.orderData['price']} €",
                                                style: const TextStyle(
                                                  color: Color(
                                                    0xFF0B0C1E,
                                                  ),
                                                  fontSize: 14,
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
                                left: 13,
                                top: 113,
                                child: Container(
                                  width: 77,
                                  height: 25,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    color: widget.orderData['delivered'] == true
                                        ? const Color(0xFF3C55EF)
                                        : widget.orderData['processing'] == true
                                            ? Colors.purple
                                            : Colors.red,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Positioned(
                                        left: 7,
                                        top: 5,
                                        child: Text(
                                          widget.orderData['delivered'] == true
                                              ? 'Delivered'
                                              : widget.orderData[
                                                          'processing'] ==
                                                      true
                                                  ? 'Processing'
                                                  : 'Cancelled',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            height: 1.3,
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
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Container(
                width: 336,
                height: 192,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  border: Border.all(
                    color: const Color(
                      0xFFEFF0F2,
                    ),
                  ),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Delivery Address',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            widget.orderData['country'] +
                                ", " +
                                widget.orderData['state'] +
                                ", " +
                                widget.orderData['city'] +
                                ", " +
                                widget.orderData['postCode'],
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            widget.orderData['road'] +
                                " " +
                                widget.orderData['postNumber'] +
                                " " +
                                widget.orderData['inside'],
                            style: const TextStyle(
                              fontSize: 16,
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            'To ${widget.orderData['fullName']}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: widget.orderData['delivered'] == true
                          ? ElevatedButton(
                              onPressed: () async {
                                final productId = widget.orderData['productId'];
                                final hasReviewed =
                                    await hasUserReviewedProduct(productId);
                                if (hasReviewed) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return FutureBuilder<DocumentSnapshot>(
                                        future: FirebaseFirestore.instance
                                            .collection('productReviews')
                                            .doc(widget.orderData['orderId'])
                                            .get(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator()); // Loading indicator while waiting
                                          }

                                          if (snapshot.hasError) {
                                            return const Center(
                                                child: Text(
                                                    'Error loading review data')); // Error message if the fetch fails
                                          }

                                          if (snapshot.hasData &&
                                              snapshot.data != null) {
                                            final reviewData = snapshot.data!
                                                .data() as Map<String, dynamic>;
                                            _reviwController.text = reviewData[
                                                'review']; // Populate the controller with the current review
                                            rating = reviewData[
                                                'rating']; // Set the current rating

                                            return AlertDialog(
                                              title:
                                                  const Text('Update Review'),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  TextFormField(
                                                    controller:
                                                        _reviwController,
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText:
                                                          'Update Your Review',
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: RatingBar.builder(
                                                      initialRating: rating,
                                                      direction:
                                                          Axis.horizontal,
                                                      minRating: 1,
                                                      maxRating: 5,
                                                      allowHalfRating: true,
                                                      itemSize: 25,
                                                      unratedColor: Colors.grey,
                                                      itemCount: 5,
                                                      itemPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              horizontal: 4),
                                                      itemBuilder:
                                                          (context, _) {
                                                        return const Icon(
                                                          Icons.star,
                                                          color: Colors.amber,
                                                        );
                                                      },
                                                      onRatingUpdate: (value) {
                                                        rating = value;
                                                      },
                                                    ),
                                                  )
                                                ],
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () async {
                                                    final review =
                                                        _reviwController.text;
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection(
                                                            'productReviews')
                                                        .doc(widget.orderData[
                                                            'orderId'])
                                                        .update({
                                                      'reviewId': widget
                                                          .orderData['orderId'],
                                                      'productId':
                                                          widget.orderData[
                                                              'productId'],
                                                      'fullName':
                                                          widget.orderData[
                                                              'fullName'],
                                                      'email': widget
                                                          .orderData['email'],
                                                      'buyerId': FirebaseAuth
                                                          .instance
                                                          .currentUser!
                                                          .uid,
                                                      'rating': rating,
                                                      'review': review,
                                                      'timeStamp':
                                                          Timestamp.now(),
                                                    }).whenComplete(() {
                                                      updateProductRating(
                                                          widget.orderData[
                                                              'productId']);
                                                      Navigator.of(context)
                                                          .pop();
                                                      _reviwController.clear();
                                                      rating = 0;
                                                    });
                                                  },
                                                  child: const Text('Submit'),
                                                ),
                                              ],
                                            );
                                          }

                                          return const Center(
                                              child: Text(
                                                  'No review found')); // In case no data is found
                                        },
                                      );
                                    },
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Leave a Review'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextFormField(
                                              controller: _reviwController,
                                              decoration: const InputDecoration(
                                                labelText: 'Your review',
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: RatingBar.builder(
                                                initialRating: rating,
                                                direction: Axis.horizontal,
                                                minRating: 1,
                                                maxRating: 5,
                                                allowHalfRating: true,
                                                itemSize: 25,
                                                unratedColor: Colors.grey,
                                                itemCount: 5,
                                                itemPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4),
                                                itemBuilder: (context, _) {
                                                  return const Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                  );
                                                },
                                                onRatingUpdate: (value) {
                                                  rating = value;
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () async {
                                              final review =
                                                  _reviwController.text;
                                              await FirebaseFirestore.instance
                                                  .collection('productReviews')
                                                  .doc(widget
                                                      .orderData['orderId'])
                                                  .set({
                                                'reviewId':
                                                    widget.orderData['orderId'],
                                                'productId': widget
                                                    .orderData['productId'],
                                                'fullName': widget
                                                    .orderData['fullName'],
                                                'email':
                                                    widget.orderData['email'],
                                                'buyerId': FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                'rating': rating,
                                                'review': review,
                                                'timeStamp': Timestamp.now(),
                                              }).whenComplete(() {
                                                updateProductRating(productId);
                                                Navigator.of(context).pop();
                                                _reviwController.clear();
                                                rating = 0;
                                              });
                                            },
                                            child: const Text('Submit'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                              child: FutureBuilder(
                                  future: hasUserReviewedProduct(
                                      widget.orderData['productId']),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    }

                                    final hasReviewed = snapshot.data ?? false;
                                    return Text(
                                        hasReviewed ? 'Update' : 'Review');
                                  }),
                            )
                          : const SizedBox(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
