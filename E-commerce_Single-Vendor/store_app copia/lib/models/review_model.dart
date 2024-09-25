class ReviewModel{
  final String buyerId;
  final String email;
  final String fullName;
  final String productId;
  final double rating;
  final String review;
  final String reviewId;
  final String timeStamp;

  ReviewModel({
    required this.buyerId,
    required this.email,
    required this.fullName,
    required this.productId,
    required this.rating,
    required this.review,
    required this.reviewId,
    required this.timeStamp,
  });
}