import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:store_app/models/category_model.dart';
import 'package:store_app/views/screens/nav_screens/widgets/popular_Item.dart';

class CategoryProductScreen extends StatelessWidget {
  final CategoryModel categoryModel;

  const CategoryProductScreen({super.key, required this.categoryModel});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productStream = FirebaseFirestore.instance
        .collection('products')
        .where('category', isEqualTo: categoryModel.categoryName)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          categoryModel.categoryName,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.8,
          ),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _productStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No products for this category\n please, check in the future',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.7,
                    ),
                  ),
                ],
              ),
            );
          }

          return GridView.count(
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 3,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            childAspectRatio: 300 / 500,
            children: List.generate(snapshot.data!.size, (index) {
              final productData = snapshot.data!.docs[index];
              return Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: PopularItem(productData: productData),
              );
            }),
          );
        },
      ),
    );
  }
}

