class UserBookmarkBookModel {
  UserBookmarkBookModel({
    this.userId,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.role,
    this.bookmarkId,
    this.bookmarkUserId,
    this.bookmarkBookId,
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
  });

  int? userId;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? role;
  int? bookmarkId;
  int? bookmarkUserId;
  int? bookmarkBookId;
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

  factory UserBookmarkBookModel.fromJson(Map<String, dynamic> json) {
    return UserBookmarkBookModel(
      userId: json['userId'] as int?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      role: json['role'] as String? ?? 'Member',
      bookmarkId: json['bookmarkId'] as int?,
      bookmarkUserId: json['bookmarkUserId'] as int?,
      bookmarkBookId: json['bookmarkBookId'] as int?,
      bookId: json['bookId'] as int?,
      bookName: json['bookName'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      format: json['format'] as String?,
      title: json['title'] as String?,
      author: json['author'] as String?,
      publisher: json['publisher'] as String?,
      publicationDate: json['publicationDate'] as String?,
      language: json['language'] as String?,
      category: json['category'] as String?,
      listedAt: json['listedAt'] as String?,
      availableQuantity: json['availableQuantity'] as int?,
      discountPercent: (json['discountPercent'] as num?)?.toDouble(),
      discountStart: json['discountStart'] as String?,
      discountEnd: json['discountEnd'] as String?,
      photo: json['photo'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'role': role,
      'bookmarkId': bookmarkId,
      'bookmarkUserId': bookmarkUserId,
      'bookmarkBookId': bookmarkBookId,
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
    };
  }
}