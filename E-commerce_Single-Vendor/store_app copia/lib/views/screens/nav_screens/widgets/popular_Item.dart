import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:store_app/views/screens/inner_screens/product_detail_screen.dart';

class PopularItem extends StatelessWidget {
  const PopularItem({
    super.key,
    required this.productData,
  });

  final QueryDocumentSnapshot<Object?> productData;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ProductDetailScreen(productData: productData);
            },
          ),
        );
      },
      child: SizedBox(
        width: 110,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Container(
                width: 87,
                height: 81,
                decoration: BoxDecoration(
                  color: const Color(
                    0xFFB0CCFF,
                  ),
                  borderRadius: BorderRadius.circular(
                    5,
                  ),
                ),
                child: Image.network(
                  productData['productImage'][0],
                  width: 71,
                  height: 71,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              '€ ${productData['productPrice'] - productData['discount']}',
              style: const TextStyle(
                color: Color(
                  0xFF1E3354,
                ),
                fontSize: 17,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4,
              ),
            ),
            Text(
              productData['productName'],
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
