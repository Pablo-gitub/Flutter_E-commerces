import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductReviews extends StatelessWidget {
  const ProductReviews({
    super.key,
    required Stream<QuerySnapshot<Object?>> reviewsStream,
  }) : _reviewsStream = reviewsStream;

  final Stream<QuerySnapshot<Object?>> _reviewsStream;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 60),
      child: StreamBuilder<QuerySnapshot>(
        stream: _reviewsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong loading reviews');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Text('No reviews yet for this product');
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final reviewData = snapshot.data!.docs[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            reviewData['fullName'],
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Row(
                            children: List.generate(
                              5,
                              (starIndex) {
                                double rating = reviewData['rating'];
                                return starIndex < rating.floor()
                                    ?
                                    // Mostra la stella piena
                                    const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 16,
                                      )
                                    : starIndex < rating &&
                                            rating - starIndex >= 0.5
                                        ?
                                        // Mostra mezza stella
                                        const Icon(
                                            Icons.star_half,
                                            color: Colors.amber,
                                            size: 16,
                                          )
                                        :
                                        // Mostra la stella vuota
                                        const Icon(
                                            Icons.star_border,
                                            color: Colors.amber,
                                            size: 16,
                                          );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        reviewData['review'],
                        style: GoogleFonts.lato(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
