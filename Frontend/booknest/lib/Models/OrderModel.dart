class OrderModel {
  OrderModel({
    this.orderId,
    this.status,
    this.bookQuantity,
    this.claimId,
    this.discountAmount,
    this.totalPrice,
    this.claimCode,
    this.orderDate,
    this.userId,
    this.bookId,
  });

  int? orderId;
  String? status;
  int? bookQuantity;
  String? claimId;
  int? discountAmount;
  double? totalPrice;
  String? claimCode;
  String? orderDate;
  int? userId;
  int? bookId;

  OrderModel.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    status = json['status'];
    bookQuantity = json['bookQuantity'];
    claimId = json['claimId'];
    discountAmount = json['discountAmount'];
    totalPrice = (json['totalPrice'] as num?)?.toDouble();
    claimCode = json['claimCode'];
    orderDate = json['orderDate'];
    userId = json['userId'];
    bookId = json['bookId'];
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
      'userId': userId,
      'bookId': bookId,
    };
  }
}