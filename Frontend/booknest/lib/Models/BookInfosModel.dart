/// bookId : 6
/// bookName : "dgfdgd"
/// price : 34
/// format : "dfdfdf"
/// title : "dgfdfgdfg"
/// author : "gdffdgdf"
/// publisher : "dgdfdf"
/// publicationDate : "2023-09-08T18:15:00Z"
/// language : "dfwdsffds"
/// category : "sfddsfsd"
/// listedAt : "2023-09-08T18:15:00Z"
/// availableQuantity : 45
/// discountPercent : 45
/// discountStart : "2023-09-08T18:15:00Z"
/// discountEnd : "2024-09-08T18:15:00Z"
/// photo : "iVBORw0KGgoAAAANSUhEUgA"

class BooKInfos {
  BooKInfos({
    int? bookId,
    String? bookName,
    double? price,
    String? format,
    String? title,
    String? author,
    String? publisher,
    String? publicationDate,
    String? language,
    String? category,
    String? listedAt,
    int? availableQuantity,
    double? discountPercent,
    String? discountStart,
    String? discountEnd,
    String? photo,
  }) {
    _bookId = bookId;
    _bookName = bookName;
    _price = price;
    _format = format;
    _title = title;
    _author = author;
    _publisher = publisher;
    _publicationDate = publicationDate;
    _language = language;
    _category = category;
    _listedAt = listedAt;
    _availableQuantity = availableQuantity;
    _discountPercent = discountPercent;
    _discountStart = discountStart;
    _discountEnd = discountEnd;
    _photo = photo;
  }

  BooKInfos.fromJson(dynamic json) {
    _bookId = json['bookId'];
    _bookName = json['bookName'];
    _price = (json['price'] as num?)?.toDouble();
    _format = json['format'];
    _title = json['title'];
    _author = json['author'];
    _publisher = json['publisher'];
    _publicationDate = json['publicationDate'];
    _language = json['language'];
    _category = json['category'];
    _listedAt = json['listedAt'];
    _availableQuantity = json['availableQuantity'];
    _discountPercent = (json['discountPercent'] as num?)?.toDouble();
    _discountStart = json['discountStart'];
    _discountEnd = json['discountEnd'];
    _photo = json['photo'];
  }

  int? _bookId;
  String? _bookName;
  double? _price;
  String? _format;
  String? _title;
  String? _author;
  String? _publisher;
  String? _publicationDate;
  String? _language;
  String? _category;
  String? _listedAt;
  int? _availableQuantity;
  double? _discountPercent;
  String? _discountStart;
  String? _discountEnd;
  String? _photo;

  BooKInfos copyWith({
    int? bookId,
    String? bookName,
    double? price,
    String? format,
    String? title,
    String? author,
    String? publisher,
    String? publicationDate,
    String? language,
    String? category,
    String? listedAt,
    int? availableQuantity,
    double? discountPercent,
    String? discountStart,
    String? discountEnd,
    String? photo,
  }) =>
      BooKInfos(
        bookId: bookId ?? _bookId,
        bookName: bookName ?? _bookName,
        price: price ?? _price,
        format: format ?? _format,
        title: title ?? _title,
        author: author ?? _author,
        publisher: publisher ?? _publisher,
        publicationDate: publicationDate ?? _publicationDate,
        language: language ?? _language,
        category: category ?? _category,
        listedAt: listedAt ?? _listedAt,
        availableQuantity: availableQuantity ?? _availableQuantity,
        discountPercent: discountPercent ?? _discountPercent,
        discountStart: discountStart ?? _discountStart,
        discountEnd: discountEnd ?? _discountEnd,
        photo: photo ?? _photo,
      );

  int? get bookId => _bookId;
  String? get bookName => _bookName;
  double? get price => _price;
  String? get format => _format;
  String? get title => _title;
  String? get author => _author;
  String? get publisher => _publisher;
  String? get publicationDate => _publicationDate;
  String? get language => _language;
  String? get category => _category;
  String? get listedAt => _listedAt;
  int? get availableQuantity => _availableQuantity;
  double? get discountPercent => _discountPercent;
  String? get discountStart => _discountStart;
  String? get discountEnd => _discountEnd;
  String? get photo => _photo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['bookId'] = _bookId;
    map['bookName'] = _bookName;
    map['price'] = _price;
    map['format'] = _format;
    map['title'] = _title;
    map['author'] = _author;
    map['publisher'] = _publisher;
    map['publicationDate'] = _publicationDate;
    map['language'] = _language;
    map['category'] = _category;
    map['listedAt'] = _listedAt;
    map['availableQuantity'] = _availableQuantity;
    map['discountPercent'] = _discountPercent;
    map['discountStart'] = _discountStart;
    map['discountEnd'] = _discountEnd;
    map['photo'] = _photo;
    return map;
  }
}