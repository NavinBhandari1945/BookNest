import 'dart:convert';
import 'package:booknest/Views/Pages/Home/send_email.dart';
import 'package:booknest/Views/Pages/Home/user_not_login_home_screen.dart';
import 'package:booknest/Views/common%20widget/commonbutton.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';
import '../../../Models/OrderModel.dart';
import '../../../constant/constant.dart';
import '../../../constant/styles.dart';
import '../../common widget/common_method.dart';
import '../../common widget/toast.dart';
import 'cart_screen.dart';

class CartDetailsScreen extends StatefulWidget {
  final String email;
  final String usertype;
  final String jwttoken;
  final int? cartId;
  final String? addedAt;
  final int? quantity;
  final int? cartUserId;
  final int? cartBookId;
  final String? bookName;
  final double? price;
  final String? format;
  final String? title;
  final String? author;
  final String? publisher;
  final String? publicationDate;
  final String? language;
  final String? category;
  final String? listedAt;
  final int? availableQuantity;
  final double? discountPercent;
  final String? discountStart;
  final String? discountEnd;
  final String? photo;

  const CartDetailsScreen({
    super.key,
    required this.jwttoken,
    required this.usertype,
    required this.email,
    required this.cartId,
    required this.addedAt,
    required this.quantity,
    required this.cartUserId,
    required this.cartBookId,
    required this.bookName,
    required this.price,
    required this.format,
    required this.title,
    required this.author,
    required this.publisher,
    required this.publicationDate,
    required this.language,
    required this.category,
    required this.listedAt,
    required this.availableQuantity,
    required this.discountPercent,
    required this.discountStart,
    required this.discountEnd,
    required this.photo,
  });
  @override
  State<CartDetailsScreen> createState() => _CartDetailsScreenState();
}

class _CartDetailsScreenState extends State<CartDetailsScreen> {

  @override
  void initState() {
    super.initState();
    checkJWTExpiationmember();
  }

  Future<void> checkJWTExpiationmember() async {
    try {
      //check jwt called in admin home screen.
      print("check jwt called in book screen.");
      int result = await checkJwtToken_initistate_member(
          widget.email, widget.usertype, widget.jwttoken);
      if (result == 0)
      {
        await clearUserData();
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => UserNotLoginHomeScreen()));
        Toastget().Toastmsg("Session End. Relogin please.");
      }
    } catch (obj) {
      print("Exception caught while verifying jwt for admin home screen.");
      print(obj.toString());
      await clearUserData();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserNotLoginHomeScreen()));
      Toastget().Toastmsg("Error. Relogin please.");
    }
  }

  // Calculate total price (quantity * price)
  double? get totalPrice {
    if (widget.quantity != null && widget.price != null) {
      return widget.quantity! * widget.price!;
    }
    return null;
  }

  int? GetTotalPrice()
  {
    if (widget.quantity != null && widget.price != null)
    {
      int? IntPrice=int.tryParse(widget.price.toString());
      return widget.quantity! * IntPrice!;
    }
    return null;
  }

  Future<int> Delete_Cart_Item() async {
    try {
      final Map<String, dynamic> CartData = {"CartId": widget.cartId};
      const String url = Backend_Server_Url + "api/Member/deletecartitem";
      final headers = {
        'Authorization': 'Bearer ${widget.jwttoken}',
        'Content-Type': 'application/json',
      };
      final body_data = jsonEncode(CartData);

      final response = await http.delete(
        Uri.parse(url),
        headers: headers,
        body: body_data,
      );
      if (response.statusCode == 200) {
        Toastget().Toastmsg("Delete cart success.");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return CartScreen(
                jwttoken: widget.jwttoken,
                usertype: widget.usertype,
                email: widget.email,
              );
            },
          ),
        );
        return 1;
      } else if (response.statusCode == 502) {
        Toastget().Toastmsg("Invalid data format.");
        print("Invalid data format.");
        return 3;
      } else if (response.statusCode == 503) {
        Toastget().Toastmsg("Invalid cartid.");
        print("Invalid cartid.");
        return 4;
      } else {
        Toastget().Toastmsg("Other status code.Error.");
        print("Other status code.Error.");
        print("Status code = ${response.statusCode}");
        return 2;
      }
    } catch (Obj) {
      Toastget().Toastmsg(
        "Exception caught in lDelete cart method in http method.",
      );
      print("Exception caught in Delete cart method in http method.");
      print(Obj.toString());
      return 0;
    }
  }

  List<OrderModel> OrderInfoList = [];

  Future<int> GetOrderInfo() async {
    try {
      print("Get order info method called");
      const String url = Backend_Server_Url + "api/Member/get_order_details";
      final headers = {
        'Authorization': 'Bearer ${widget.jwttoken}',
        'Content-Type': 'application/json',
      };
      Map<String, dynamic> BodyData = {"UserId": widget.cartUserId};
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body:json.encode(BodyData),
      );
      if (response.statusCode == 200) {
        List<dynamic> responseData = await jsonDecode(response.body);
        OrderInfoList.clear();
        OrderInfoList.addAll(
          responseData.map((data) => OrderModel.fromJson(data)).toList(),
        );
        print("OrderInfoList  count value");
        print(OrderInfoList.length);
        return 1;
      } else {
        OrderInfoList.clear();
        Toastget().Toastmsg("Fail to load order details.Try again.");
        print("Data insert in OrderInfoList failed.");
        return 2;
      }
    } catch (obj) {
      OrderInfoList.clear();
      print(
        "Exception caught while fetching OrderInfoList data in http method",
      );
      print(obj.toString());
      return 0;
    }
  }

  Future<int> Buy_Item({
    required int Discountamount,
    required double TotalAmount,
    required String ClaimCode,
    required String OrderDate,
  }) async {
    try {
      final Map<String, dynamic> OrderData = {
        "OrderId": 0,
        "Status": "Pending",
        "BookQuantity": widget.quantity,
        "ClaimId": widget.email,
        "DiscountAmount": Discountamount,
        "TotalPrice": TotalAmount,
        "ClaimCode": ClaimCode,
        "OrderDate": OrderDate,
        "UserId": widget.cartUserId,
        "BookId": widget.cartBookId,
      };
      const String url = Backend_Server_Url + "api/Member/add_order";
      final headers = {
        'Authorization': 'Bearer ${widget.jwttoken}',
        'Content-Type': 'application/json',
      };
      final body_data = jsonEncode(OrderData);

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body_data,
      );
      if (response.statusCode == 200) {
        print("Adding order success.");
        Toastget().Toastmsg("Adding order success.");
        return 1;
      } else if (response.statusCode == 502) {
        Toastget().Toastmsg("Invalid data format.");
        print("Invalid data format.");
        return 3;
      } else {
        Toastget().Toastmsg("Other status code.Error.");
        print("Other status code.Error.");
        print("Status code = ${response.statusCode}");
        return 2;
      }
    } catch (Obj) {
      Toastget().Toastmsg(
        "Exception caught in Adding order method in http method.",
      );
      print("Exception caught in Adding order method in http method.");
      print(Obj.toString());
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    var shortestval = MediaQuery.of(context).size.shortestSide;
    var widthval = MediaQuery.of(context).size.width;
    var heightval = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar:

      AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Cart Details",
          style: TextStyle(
            fontFamily: bold,
            fontSize: 24,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Colors.green[700],
        elevation: 4,
        shadowColor: Colors.black45,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book Image
            Center(
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child:
                      widget.photo != null
                          ? Image.memory(
                            base64Decode(widget.photo!),
                            height: heightval * 0.3,
                            width: widthval * 0.6,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => Container(
                                  height: heightval * 0.3,
                                  width: widthval * 0.6,
                                  color: Colors.grey[300],
                                  child: const Icon(
                                    Icons.broken_image,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                ),
                          )
                          : Container(
                            height: heightval * 0.3,
                            width: widthval * 0.6,
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.image,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Book Details Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Book Name : ${widget.bookName}" ?? 'N/A',
                      style: const TextStyle(
                        fontFamily: bold,
                        fontSize: 22,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Book Tittle : ${widget.title}" ?? 'N/A',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow('Author', widget.author ?? 'N/A'),
                    _buildDetailRow('Publisher', widget.publisher ?? 'N/A'),
                    _buildDetailRow('Language', widget.language ?? 'N/A'),
                    _buildDetailRow('Category', widget.category ?? 'N/A'),
                    _buildDetailRow('Format', widget.format ?? 'N/A'),
                    _buildDetailRow(
                      'Publication Date',
                      widget.publicationDate ?? 'N/A',
                    ),
                    _buildDetailRow('Listed At', widget.listedAt ?? 'N/A'),
                    _buildDetailRow(
                      'Price',
                      widget.price != null
                          ? '${widget.price!.toStringAsFixed(2)}'
                          : 'N/A',
                    ),
                    _buildDetailRow(
                      'Discount',
                      widget.discountPercent != null
                          ? '${widget.discountPercent!.toStringAsFixed(0)}%'
                          : 'N/A',
                    ),
                    _buildDetailRow(
                      'Discount Period',
                      (widget.discountStart != null &&
                              widget.discountEnd != null)
                          ? '${widget.discountStart} to ${widget.discountEnd}'
                          : 'N/A',
                    ),
                    _buildDetailRow(
                      'Available Quantity',
                      widget.availableQuantity?.toString() ?? 'N/A',
                    ),
                    _buildDetailRow(
                      'Quantity',
                      widget.quantity?.toString() ?? 'N/A',
                    ),
                    _buildDetailRow(
                      'Total Price',
                      totalPrice != null
                          ? '${totalPrice!.toStringAsFixed(2)}'
                          : 'N/A',
                    ),
                    _buildDetailRow('Added At', widget.addedAt ?? 'N/A'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    try {
                      final Delete_Cart_Result = await Delete_Cart_Item();
                      print(Delete_Cart_Result);
                    } catch (obj) {
                      print(obj.toString());
                      Toastget().Toastmsg("Try again.fail.");
                      return;
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[600],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: widthval * 0.1,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 4,
                  ),
                  child: const Text(
                    'Delete',
                    style: TextStyle(fontFamily: bold, fontSize: 16),
                  ),
                ),

                ElevatedButton(
                  onPressed: () async {
                    try {

                      int TotalDiscountPercent = 0;

                      print("Discount percent from datbase = ${widget.discountPercent}");

                      if (widget.discountPercent != null &&
                          widget.discountPercent! > 0 &&
                          widget.discountStart != null &&
                          widget.discountEnd != null)
                      {
                        final currentDate = DateTime.now().toUtc();
                        final startDate = DateTime.tryParse(
                          widget.discountStart!,
                        );
                        final endDate = DateTime.tryParse(widget.discountEnd!);
                        print("start date = ${startDate}");
                        print("current date = ${currentDate}");
                        print("end date = ${endDate}");
                        if (startDate != null &&
                            endDate != null &&
                            currentDate.isAfter(startDate) &&
                            currentDate.isBefore(endDate)) {
                          print("Yes Book discount from databse discount percent added");

                          int? DiscountFromdatabse=int.tryParse(widget.discountPercent.toString());
                          print("Discountfromdatabse=${DiscountFromdatabse}");
                          TotalDiscountPercent =
                              TotalDiscountPercent + DiscountFromdatabse!;
                        }
                      }

                      if(TotalDiscountPercent==0)
                      {
                        print("No Book discount from databse discount percent added fail.Invalid discount status.");
                      }

                      print("Book order quantity = ${widget.quantity}");

                      if (widget.quantity! >= 5)
                      {
                        print("Order quantity=${widget.quantity}");
                        print("Yes Book discount aaded for more than or equal to 5 books order");
                        TotalDiscountPercent = TotalDiscountPercent + 5;
                      }

                      if(widget.quantity!<5)
                      {
                        print("Order quantity=${widget.quantity}");
                        print("No Book discount aaded for more than or equal to 5 books order");
                      }


                      final Order_History_Result = await GetOrderInfo();

                      print("Order_History_Result = ${Order_History_Result}");

                      if (Order_History_Result == 1)
                      {

                        if (OrderInfoList.length > 10)
                        {
                          print("Yes Book discount added for more than 10 successful book order.");
                          TotalDiscountPercent = TotalDiscountPercent + 10;
                        }

                        if(OrderInfoList.length < 10){
                          print("No Book discount added for more than 10 successful book order.");

                        }

                        int? IntTotal_Price=GetTotalPrice();
                        int IntTotalDiscountPercent=TotalDiscountPercent;

                        int discountAmount = ((IntTotal_Price! * IntTotalDiscountPercent) / 100).toInt();

                        double? DoubleTotalPrice=double.tryParse(IntTotal_Price.toString());
                        double? DoubleDiscountAmount=double.tryParse(discountAmount.toString());


                        double Total_Amount = DoubleTotalPrice! - DoubleDiscountAmount!;


                        print("Total Discount: $TotalDiscountPercent%");
                        print("Discount Amount: $discountAmount");
                        print("Final Payable Amount: $Total_Amount");

                        String ClaimCode =
                            DateTime.now().toUtc().toString() +
                            "${widget.cartUserId}";

                        String OrderDate = getCurrentDateFormatted();

                        final Add_Order_Result = await Buy_Item(
                          Discountamount: discountAmount,
                          TotalAmount: Total_Amount,
                          ClaimCode: ClaimCode,
                          OrderDate: OrderDate,
                        );

                        print("Add_Order_Result= ${Add_Order_Result}");
                        if (Add_Order_Result != 1)
                        {
                          print("Failed to save order data in databse");
                          Toastget().Toastmsg(
                            "Failed to save order data in databse",
                          );
                          return;
                        }

                        String message = '''
                                      Dear User,
                                      
                                      Your book purchase request has been recorded with the following details:
                                      
                                      - Status: Pending
                                      - Book Quantity: ${widget.quantity}
                                      - User Email: ${widget.email}
                                      - Discount Amount: ${discountAmount.toStringAsFixed(2)}
                                      - Total Price After Discount: ${Total_Amount.toStringAsFixed(2)}
                                      - Claim Code: $ClaimCode
                                      - Order Date: $OrderDate
                                      - User ID: ${widget.cartUserId}
                                      - Book ID: ${widget.cartBookId}
                                      - ClaimCodeId:${widget.email}
                                      
                                      Thank you for your order!
                                      
                                      Best regards,  
                                      Your Bookstore Team
                                      ''';

                        final SendEmailResult = await sendEmail(
                          name: "BookNest",
                          email: widget.email,
                          subject: "BookNest book order Bill and payment details.",
                          message: message,
                        );

                        print("Send Email Result: $SendEmailResult");

                        if(SendEmailResult!=1)
                        {
                          print("Failed to send email");
                          Toastget().Toastmsg("Failed to senfd email of order details");
                          return;
                        }
                        print("Success to send email");
                        Toastget().Toastmsg("Success to send email of order details");
                        return;
                      } else {
                        Toastget().Toastmsg(
                          "Order process fail.try again.server Error.",
                        );
                        return;
                      }
                    } catch (obj) {
                      print(obj.toString());
                      Toastget().Toastmsg("Try again.fail.");
                      return;
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: widthval * 0.1,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 4,
                  ),
                  child: const Text(
                    'Buy Now',
                    style: TextStyle(fontFamily: bold, fontSize: 16),
                  ),
                ),


              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build detail rows
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
          ),
        ],
      ),
    );
  }

  Future<int> sendEmail({
    required String name,
    required String email,
    required String subject,
    required String message,
  }) async {
    try {
      const serviceId = "service_wn7e1b7";
      const userId = "55pnpAt50ARjpcT9f";
      const templateId = "template_larap3m";
      const privateKey = "kNdcuy4zAUFmCzDYG9iZ2"; // Replace with your EmailJS private key
      final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");

      final headers = {
        'Content-Type': 'application/json',
      };

      final body = jsonEncode({
        "service_id": serviceId,
        "user_id": userId,
        "template_id": templateId,
        "accessToken": privateKey, // Include the private key
        "template_params": {
          "user_name": name,
          "user_email": email,
          "user_subject": subject,
          "user_message": message,
        },
      });

      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      print("EmailJS response: ${response.body}");
      print("Status code: ${response.statusCode}");
      return response.statusCode == 200 ? 1 : 0;
    } catch (e) {
      print("Error: ${e.toString()}");
      return 0;
    }
  }

}
