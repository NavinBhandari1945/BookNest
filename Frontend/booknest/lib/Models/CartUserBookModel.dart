class CartUserBookModel {
  CartUserBookModel({
    this.cartId,
    this.addedAt,
    this.quantity,
    this.cartUserId,
    this.cartBookId,
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

  int? cartId;
  String? addedAt;
  int? quantity;
  int? cartUserId;
  int? cartBookId;
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

  CartUserBookModel.fromJson(Map<String, dynamic> json) {
    cartId = json['cartId'];
    addedAt = json['addedAt'];
    quantity = json['quantity'];
    cartUserId = json['cartUserId'];
    cartBookId = json['cartBookId'];
    userId = json['userId'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    role = json['role'];
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
      'cartId': cartId,
      'addedAt': addedAt,
      'quantity': quantity,
      'cartUserId': cartUserId,
      'cartBookId': cartBookId,
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