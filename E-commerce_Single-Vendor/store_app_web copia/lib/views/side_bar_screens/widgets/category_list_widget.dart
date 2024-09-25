import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryListWidget extends StatelessWidget {
  const CategoryListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> categoriesStream =
        FirebaseFirestore.instance.collection('categories').snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: categoriesStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(),);
        }

        return GridView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data!.docs.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            final categoryData = snapshot.data!.docs[index];
            return Column(
              children: [
                Expanded(
                  child: Image.network(
                    categoryData['categoryImage'],
                    height: 80,
                    width: 80,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  categoryData['categoryName'],
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
