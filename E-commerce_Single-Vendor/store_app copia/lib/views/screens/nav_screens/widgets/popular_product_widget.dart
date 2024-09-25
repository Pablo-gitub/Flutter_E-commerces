import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:store_app/views/screens/nav_screens/widgets/product_item_widget.dart';

class PopularProductWidget extends StatelessWidget {
  const PopularProductWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productsStream =
        FirebaseFirestore.instance.collection('products').orderBy('totalSold', descending: true).snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: _productsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            double itemWidth = constraints.maxWidth / 2 - 15; // Adjust spacing
            return GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.size,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: itemWidth / 250, // Adjust height ratio
              ),
              itemBuilder: (context, index) {
                final productData = snapshot.data!.docs[index];
                return ProductItemWidget(
                  productData: productData,
                );
              },
            );
          },
        );
      },
    );
  }
}
