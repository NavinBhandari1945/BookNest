class ReviewModel {
  ReviewModel({
    this.reviewId,
    this.comment,
    this.rating,
    this.reviewDate,
    this.userId,
    this.bookId,
  });

  int? reviewId;
  String? comment;
  int? rating;
  String? reviewDate;
  int? userId;
  int? bookId;

  ReviewModel.fromJson(Map<String, dynamic> json) {
    reviewId = json['reviewId'];
    comment = json['comment'];
    rating = json['rating'];
    reviewDate = json['reviewDate'];
    userId = json['userId'];
    bookId = json['bookId'];
  }

  Map<String, dynamic> toJson() {
    return {
      'reviewId': reviewId,
      'comment': comment,
      'rating': rating,
      'reviewDate': reviewDate,
      'userId': userId,
      'bookId': bookId,
    };
  }
}