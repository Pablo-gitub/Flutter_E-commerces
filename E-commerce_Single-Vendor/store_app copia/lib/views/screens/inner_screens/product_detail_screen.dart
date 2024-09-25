import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:store_app/provider/cart_provider.dart';
import 'package:store_app/provider/favorites_providers.dart';
import 'package:store_app/views/screens/inner_screens/inner_widgets/product_reviews.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final dynamic productData;

  const ProductDetailScreen({super.key, required this.productData});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final cartProviderData = ref.read(cartProvider.notifier);
    final favoriteProviderData = ref.read(favoriteProvider.notifier);
    final isFavorite = ref
        .watch(favoriteProvider)
        .containsKey(widget.productData['productId']);
    ref.watch(favoriteProvider);

    // Stream per ottenere le recensioni dalla raccolta 'productReviews'
    final Stream<QuerySnapshot> _reviewsStream = FirebaseFirestore.instance
        .collection('productReviews')
        .where('productId', isEqualTo: widget.productData['productId'])
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.productData['productName'],
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF363330),
              ),
            ),
            IconButton(
              onPressed: () {
                if (isFavorite) {
                  favoriteProviderData
                      .removeItem(widget.productData['productId']);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      margin: const EdgeInsets.all(5),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.grey,
                      content: Text(
                          '${widget.productData['productName']} Removed from favorite'),
                    ),
                  );
                } else {
                  favoriteProviderData.addProductToFavorite(
                    productName: widget.productData['productName'],
                    productId: widget.productData['productId'],
                    imageUrl: widget.productData['productImage'],
                    productPrice: widget.productData['productPrice'],
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      margin: const EdgeInsets.all(5),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.grey,
                      content: Text(
                          '${widget.productData['productName']} added to favorite'),
                    ),
                  );
                }
              },
              icon: favoriteProviderData.getFavoriteItem
                      .containsKey(widget.productData['productId'])
                  ? const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    )
                  : const Icon(
                      Icons.favorite_border,
                      color: Colors.red,
                    ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 260,
                height: 274,
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        width: 260,
                        height: 260,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFFD8DDFF,
                          ),
                          borderRadius: BorderRadius.circular(
                            130,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 22,
                      top: 0,
                      child: Container(
                        width: 216,
                        height: 274,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF9CA8FF,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: SizedBox(
                          height: 300,
                          child: PageView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  widget.productData['productImage'].length,
                              itemBuilder: (context, index) {
                                return Image.network(
                                  widget.productData['productImage'][index],
                                  width: 198,
                                  height: 225,
                                  fit: BoxFit.cover,
                                );
                              }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 12,
                left: 8,
              ),
              child: Row(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8,
                        ),
                        child: Text(
                          '${widget.productData['productPrice'] - widget.productData['discount']} €',
                          style: GoogleFonts.roboto(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8,
                        ),
                        child: Text(
                          '${widget.productData['productPrice']} €',
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            letterSpacing: 1,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
              ),
              child: Text(
                widget.productData['category'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            widget.productData['rating'] == 0
                ? const Text('')
                : Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      children: [
                        for (int i = 1; i <= 5; i++)
                          Icon(
                            i <= widget.productData['rating']
                                ? Icons.star
                                : i - widget.productData['rating'] < 1 &&
                                        i - widget.productData['rating'] > 0
                                    ? Icons.star_half
                                    : Icons.star_border,
                            color: Colors.amber,
                          ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.productData['rating'].toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          '(${widget.productData['totalReviews']})',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 2,
                          ),
                        )
                      ],
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Size',
                    style: GoogleFonts.lato(
                      color: const Color(0xFF343434),
                      fontSize: 16,
                      letterSpacing: 1.6,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.productData['productSize'].length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {},
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF126881),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  widget.productData['productSize'][index],
                                  style: GoogleFonts.lato(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description',
                    style: GoogleFonts.lato(
                      color: const Color(0xFF363330),
                      fontSize: 16,
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    widget.productData['description'],
                  ),
                ],
              ),
            ),
            // Recensioni
            ProductReviews(reviewsStream: _reviewsStream),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8),
        child: InkWell(
          onTap: () {
            cartProviderData.addProductToCart(
                productName: widget.productData['productName'],
                productPrice: widget.productData['productPrice'],
                categoryName: widget.productData['category'],
                imageUrl: widget.productData['productImage'],
                quantity: 1,
                instock: widget.productData['quantity'],
                productId: widget.productData['productId'],
                productSize: '',
                discount: widget.productData['discount'].toDouble(),
                description: widget.productData['description']);

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                margin: const EdgeInsets.all(5),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.grey,
                content: Text(
                    '${widget.productData['productName']} added to cart')));
          },
          child: Container(
            width: 386,
            height: 48,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: const Color(0xFF3B54EE),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: Text(
                'Add to Cart',
                style: GoogleFonts.lato(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
