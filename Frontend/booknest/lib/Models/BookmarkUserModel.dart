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

  UserBookmarkBookModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    role = json['role'];
    bookmarkId = json['bookmarkId'];
    bookmarkUserId = json['bookmarkUserId'];
    bookmarkBookId = json['bookmarkBookId'];
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