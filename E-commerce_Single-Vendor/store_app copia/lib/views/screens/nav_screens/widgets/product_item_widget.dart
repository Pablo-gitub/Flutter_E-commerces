import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:store_app/provider/favorites_providers.dart';
import 'package:store_app/views/screens/inner_screens/product_detail_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductItemWidget extends ConsumerStatefulWidget {
  final dynamic productData;

  const ProductItemWidget({super.key, required this.productData});

  @override
  _ProductItemWidgetState createState() => _ProductItemWidgetState();
}

class _ProductItemWidgetState extends ConsumerState<ProductItemWidget> {
  @override
  Widget build(BuildContext context) {
    final favoriteProviderData = ref.read(favoriteProvider.notifier);
    final isFavorite = ref
        .watch(favoriteProvider)
        .containsKey(widget.productData['productId']);
    ref.watch(favoriteProvider);
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProductDetailScreen(
            productData: widget.productData,
          );
        }));
      },
      child: Container(
        width: 146,
        height: 245,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Container(
                width: 146,
                height: 245,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0f040828),
                      spreadRadius: 0,
                      offset: Offset(
                        0,
                        18,
                      ),
                      blurRadius: 30,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 7, top: 130),
              child: Text(
                widget.productData['productName'],
                style: GoogleFonts.lato(
                  color: const Color(0xFF1E3354),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 7, top: 177),
              child: Text(
                widget.productData['category'],
                style: GoogleFonts.lato(
                  color: const Color(0xFF7F8E9D),
                  fontSize: 12,
                  letterSpacing: 0.2,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 7, top: 207),
              child: Text(
                '€${widget.productData['productPrice'] - widget.productData['discount']}',
                style: GoogleFonts.lato(
                  color: const Color(0xFF1E3354),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.4,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 51, top: 205),
              child: Text(
                '€${widget.productData['productPrice']}',
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 11,
                  letterSpacing: 0.3,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 9, top: 9),
              child: Container(
                width: 128,
                height: 108,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    3,
                  ),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: -1,
                      top: -1,
                      child: Container(
                        width: 130,
                        height: 110,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 64, 183, 234),
                          border: Border.all(
                            width: 0.8,
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 2,
                      top: -10,
                      child: Opacity(
                        opacity: 0.5,
                        child: Container(
                          width: 125,
                          height: 125,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 27, 134, 188),
                            borderRadius: BorderRadius.circular(
                              100,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 0),
                      child: CachedNetworkImage(
                        imageUrl: widget.productData['productImage'][0],
                        width: 108,
                        height: 107,
                        //fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 90, top: 155),
              child: Text(
                widget.productData['rating'] == 0
                    ? ''
                    : 'reviews ${widget.productData['totalReviews'].toString()}',
                style: GoogleFonts.lato(
                  color: const Color(
                    0xFF7F8E9D,
                  ),
                  fontSize: 10,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50, top: 155),
              child: Text(
                widget.productData['totalSold'] == 0
                    ? ''
                    : 'sales ${widget.productData['totalSold'].toString()}',
                style: GoogleFonts.lato(
                  color: const Color(
                    0xFF7F8E9D,
                  ),
                  fontSize: 10,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 23, top: 155),
              child: Text(
                widget.productData['rating'] == 0
                    ? ''
                    : widget.productData['rating'].toString(),
                style: GoogleFonts.lato(
                  color: const Color(
                    0xFF7F8E9D,
                  ),
                  fontSize: 12,
                ),
              ),
            ),
            widget.productData['rating'] == 0
                ? const SizedBox()
                : const Padding(
                    padding: EdgeInsets.only(left: 8, top: 158),
                    child: Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 12,
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.only(left: 104, top: 15),
              child: Container(
                width: 27,
                height: 27,
                decoration: BoxDecoration(
                  color: const Color(0xFFFA634D),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33FF2000),
                      spreadRadius: 0,
                      offset: Offset(0, 7),
                      blurRadius: 15,
                    )
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 5, top: 5),
                child: IconButton(
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
                          color: Colors.white,
                          size: 16,
                        )
                      : const Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                          size: 16,
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
