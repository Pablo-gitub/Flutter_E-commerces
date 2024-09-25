import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BannerListWidget extends StatelessWidget {
  const BannerListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> bannersStream =
        FirebaseFirestore.instance.collection('banners').snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: bannersStream,
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
            return SizedBox(
              child: Image.network(
                categoryData['image'],
                height: 100,
                width: 200,
              ),
            );
          },
        );
      },
    );
  }
}
