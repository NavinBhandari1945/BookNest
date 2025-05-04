class BooksWithReviewModel {
  BooksWithReviewModel({
    this.bookId,
    this.bookName,
    this.price,
    this.format,
    this.title,
    this.author,
    this.publisher,
    this.publicationDate,
    this.language,
    this.category,
    this.listedAt,
    this.availableQuantity,
    this.discountPercent,
    this.discountStart,
    this.discountEnd,
    this.photo,
    this.reviewId,
    this.comment,
    this.rating,
    this.reviewDate,
    this.userId,
    this.reviewBookId,
  });

  int? bookId;
  String? bookName;
  double? price;
  String? format;
  String? title;
  String? author;
  String? publisher;
  String? publicationDate;
  String? language;
  String? category;
  String? listedAt;
  int? availableQuantity;
  double? discountPercent;
  String? discountStart;
  String? discountEnd;
  String? photo;

  int? reviewId;
  String? comment;
  int? rating;
  String? reviewDate;
  int? userId;
  int? reviewBookId;

  BooksWithReviewModel.fromJson(Map<String, dynamic> json) {
    bookId = json['bookId'];
    bookName = json['bookName'];
    price = (json['price'] as num?)?.toDouble();
    format = json['format'];
    title = json['title'];
    author = json['author'];
    publisher = json['publisher'];
    publicationDate = json['publicationDate'];
    language = json['language'];
    category = json['category'];
    listedAt = json['listedAt'];
    availableQuantity = json['availableQuantity'];
    discountPercent = (json['discountPercent'] as num?)?.toDouble();
    discountStart = json['discountStart'];
    discountEnd = json['discountEnd'];
    photo = json['photo'];

    reviewId = json['reviewId'];
    comment = json['comment'];
    rating = json['rating'];
    reviewDate = json['reviewDate'];
    userId = json['userId'];
    reviewBookId = json['reviewBookId'];
  }

  Map<String, dynamic> toJson() {
    return {
      'bookId': bookId,
      'bookName': bookName,
      'price': price,
      'format': format,
      'title': title,
      'author': author,
      'publisher': publisher,
      'publicationDate': publicationDate,
      'language': language,
      'category': category,
      'listedAt': listedAt,
      'availableQuantity': availableQuantity,
      'discountPercent': discountPercent,
      'discountStart': discountStart,
      'discountEnd': discountEnd,
      'photo': photo,
      'reviewId': reviewId,
      'comment': comment,
      'rating': rating,
      'reviewDate': reviewDate,
      'userId': userId,
      'reviewBookId': reviewBookId,
    };
  }
}
