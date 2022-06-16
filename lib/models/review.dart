class Review {
  Review({required this.score, this.review});
  final double score;
  // nullable - assuming the review may be missing
  final String? review;

  factory Review.fromMap(Map<String, dynamic> data) {
    final score = data['score'] as double;
    final review = data['review'] as String?;
    return Review(score: score, review: review);
  }

  Map<String, dynamic> toMap() {
    return {
      'score': score,
      if (review != null) 'review': review,
    };
  }
}