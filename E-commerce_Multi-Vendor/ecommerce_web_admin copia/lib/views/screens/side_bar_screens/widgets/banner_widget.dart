import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BannerWidget extends StatelessWidget {
  const BannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _bannersStream = 
      FirebaseFirestore.instance.collection('banners').snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: _bannersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: Colors.cyan),
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data!.size,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6, mainAxisSpacing: 8, crossAxisSpacing: 8), 
          itemBuilder: (context, Index){
            final bannerData = snapshot.data!.docs[Index];
            return Column(
              children: [
                SizedBox(
                  height: 100, 
                  width: 100, 
                  child: Image.network(
                    bannerData['image'],
                    //fit: BoxFit.cover,
                  ),
                ),
              ],
            );
          }
        );
      },
    );
  }
}