class OrderUserBookModel {
  OrderUserBookModel({
    this.orderId,
    this.status,
    this.bookQuantity,
    this.claimId,
    this.discountAmount,
    this.totalPrice,
    this.claimCode,
    this.orderDate,
    this.orderUserId,
    this.orderBookId,
    this.userId,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.role,
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

  int? orderId;
  String? status;
  int? bookQuantity;
  String? claimId;
  int? discountAmount;
  double? totalPrice;
  String? claimCode;
  String? orderDate;
  int? orderUserId;
  int? orderBookId;
  int? userId;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? role;
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

  factory OrderUserBookModel.fromJson(Map<String, dynamic> json) {
    return OrderUserBookModel(
      orderId: json['orderId'] as int?,
      status: json['status'] as String?,
      bookQuantity: json['bookQuantity'] as int?,
      claimId: json['claimId'] as String?,
      discountAmount: json['discountAmount'] as int?,
      totalPrice: (json['totalPrice'] as num?)?.toDouble(),
      claimCode: json['claimCode'] as String?,
      orderDate: json['orderDate'] as String?,
      orderUserId: json['orderUserId'] as int?,
      orderBookId: json['orderBookId'] as int?,
      userId: json['userId'] as int?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      role: json['role'] as String? ?? 'Member',
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
      'orderId': orderId,
      'status': status,
      'bookQuantity': bookQuantity,
      'claimId': claimId,
      'discountAmount': discountAmount,
      'totalPrice': totalPrice,
      'claimCode': claimCode,
      'orderDate': orderDate,
      'orderUserId': orderUserId,
      'orderBookId': orderBookId,
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'role': role,
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