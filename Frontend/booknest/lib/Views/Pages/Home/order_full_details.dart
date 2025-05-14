import 'dart:convert';

import 'package:booknest/Views/Pages/Home/user_not_login_home_screen.dart';
import 'package:booknest/Views/common%20widget/commonbutton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';

import '../../../Models/UserOrderBookModel.dart';
import '../../../constant/constant.dart';
import '../../../constant/styles.dart';
import '../../common widget/common_method.dart';
import '../../common widget/toast.dart';
import 'order_history.dart';

// Widget definition section
class OrderDetailsPage extends StatefulWidget {
  final String email;
  final String usertype;
  final String jwttoken;
  final OrderUserBookModel OrderObject;
  const OrderDetailsPage({
    super.key,
    required this.jwttoken,
    required this.usertype,
    required this.email,
    required this.OrderObject
  });

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

// State management and initialization section
class _OrderDetailsPageState extends State<OrderDetailsPage> {
  @override
  void initState() {
    super.initState();
    checkJWTExpiationmember();
  }

  Future<void> checkJWTExpiationmember() async {
    try {
      print("check jwt called in book screen.");
      int result = await checkJwtToken_initistate_member(
          widget.email, widget.usertype, widget.jwttoken);
      if (result == 0) {
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

  Future<int> Cancel_Order({required int OrderId}) async {
    try {
      print("Cancel order start");
      print("${OrderId}");
      Map<String, int> OrderData = {
        "OrderId": OrderId
      };

      final BodyData = json.encode(OrderData);
      const String url = Backend_Server_Url + "api/Member/deleteorder";
      final response = await http.delete(
        Uri.parse(url),
        headers: {"Content-Type": "application/json", 'Authorization': 'Bearer ${widget.jwttoken}'},
        body: BodyData,
      );

      if (response.statusCode == 200) {
        print("Cancel order success.");
        Toastget().Toastmsg("Cancel order success.");
        return 1;
      } else if (response.statusCode == 502) {
        Toastget().Toastmsg("Try again end.Fail.Server error.");
        return 11;
      } else if (response.statusCode == 503) {
        Toastget().Toastmsg("Cancel order failed.Incorrect order data format.Try again.");
        return 11;
      } else {
        print("Error.other status code= ${response.statusCode}");
        print("Response body: ${response.body}");
        Toastget().Toastmsg("Cancel order failed.");
        return 4;
      }
    } catch (obj) {
      print("Exception caught while canceling order in http method.");
      print(obj.toString());
      Toastget().Toastmsg("Cancel order failed.");
      return 0;
    }
  }

  // UI building section
  @override
  Widget build(BuildContext context) {
    var shortestval = MediaQuery.of(context).size.shortestSide;
    var widthval = MediaQuery.of(context).size.width;
    var heightVal = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Order Full Details",
          style: TextStyle(
            fontFamily: bold,
            fontSize: 22,
            color: Colors.white,
            letterSpacing: 1.0,
          ),
        ),
        backgroundColor: Colors.green[800],
        elevation: 5,
        shadowColor: Colors.black54,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: widthval,
        height: heightVal,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green[50]!.withOpacity(0.9),
              Colors.white.withOpacity(0.95)
            ],
          ),
        ),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              // Image section
              Container(
                margin: EdgeInsets.only(top: heightVal * 0.03),
                width: widthval * 0.5,
                height: widthval * 0.5,
                child: ClipOval(
                  child: Image.memory(
                    base64Decode(widget.OrderObject.photo!),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(
                      Icons.broken_image,
                      size: 100,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              SizedBox(height: heightVal * 0.03),
              // Order details section
              Container(
                margin: EdgeInsets.symmetric(horizontal: widthval * 0.04),
                padding: EdgeInsets.all(widthval * 0.04),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow("Order ID", widget.OrderObject.orderId?.toString() ?? '', widthval, heightVal, isBold: true),
                    _buildInfoRow("Status", widget.OrderObject.status ?? '', widthval, heightVal, color: widget.OrderObject.status == 'Complete' ? Colors.green[600] : Colors.red[600]),
                    _buildInfoRow("Book Quantity", widget.OrderObject.bookQuantity?.toString() ?? '', widthval, heightVal),
                    _buildInfoRow("Claim ID", widget.OrderObject.claimId ?? '', widthval, heightVal),
                    _buildInfoRow("Discount Amount", widget.OrderObject.discountAmount?.toString() ?? '', widthval, heightVal),
                    _buildInfoRow("Total Price", widget.OrderObject.totalPrice?.toStringAsFixed(2) ?? '', widthval, heightVal, color: Colors.green[700]),
                    _buildInfoRow("Claim Code", widget.OrderObject.claimCode ?? '', widthval, heightVal),
                    _buildInfoRow("Order Date", widget.OrderObject.orderDate ?? '', widthval, heightVal),
                    _buildInfoRow("Order User ID", widget.OrderObject.orderUserId?.toString() ?? '', widthval, heightVal),
                    _buildInfoRow("Order Book ID", widget.OrderObject.orderBookId?.toString() ?? '', widthval, heightVal),
                    _buildDivider(),
                    _buildInfoRow("First Name", widget.OrderObject.firstName ?? '', widthval, heightVal),
                    _buildInfoRow("Last Name", widget.OrderObject.lastName ?? '', widthval, heightVal),
                    _buildInfoRow("Email", widget.OrderObject.email ?? '', widthval, heightVal),
                    _buildInfoRow("Phone Number", widget.OrderObject.phoneNumber ?? '', widthval, heightVal),
                    _buildInfoRow("Role", widget.OrderObject.role ?? '', widthval, heightVal),
                    _buildDivider(),
                    _buildInfoRow("Book Name", widget.OrderObject.bookName ?? '', widthval, heightVal, isBold: true),
                    _buildInfoRow("Price", widget.OrderObject.price?.toStringAsFixed(2) ?? '', widthval, heightVal, color: Colors.green[700]),
                    _buildInfoRow("Format", widget.OrderObject.format ?? '', widthval, heightVal),
                    _buildInfoRow("Title", widget.OrderObject.title ?? '', widthval, heightVal),
                    _buildInfoRow("Author", widget.OrderObject.author ?? '', widthval, heightVal, isItalic: true),
                    _buildInfoRow("Publisher", widget.OrderObject.publisher ?? '', widthval, heightVal),
                    _buildInfoRow("Publication Date", widget.OrderObject.publicationDate ?? '', widthval, heightVal),
                    _buildInfoRow("Language", widget.OrderObject.language ?? '', widthval, heightVal),
                    _buildInfoRow("Category", widget.OrderObject.category ?? '', widthval, heightVal),
                    _buildInfoRow("Listed At", widget.OrderObject.listedAt ?? '', widthval, heightVal),
                  ],
                ),
              ),
              SizedBox(height: heightVal * 0.03),
              // Action button section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: widthval * 0.04),
                child: Commonbutton("Cancel Order", () async {
                  if (widget.OrderObject.status == "Complete") {
                    print("Order already received.Cannot cancel.");
                    Toastget().Toastmsg("Order already received.Cannot cancel.");
                    return;
                  } else {
                    try {
                      final Order_Cancel_Result = await Cancel_Order(OrderId: widget.OrderObject.orderId!);
                      print(Order_Cancel_Result);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
                          OrderHistoryPage(
                            jwttoken: widget.jwttoken,
                            usertype: widget.usertype,
                            email: widget.email,
                          )
                        ,));
                      return;
                    } catch(obj) {
                      print(obj.toString());
                      Toastget().Toastmsg("Retry.Fail.");
                      return;
                    }
                  }
                }, context, Colors.red[600]!),
              ),
              SizedBox(height: heightVal * 0.03),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method section
  Widget _buildInfoRow(String label, String value, double widthval, double heightVal, {bool isBold = false, bool isItalic = false, Color? color}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: heightVal * 0.005),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: widthval * 0.035,
              fontFamily: bold,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: widthval * 0.035,
                color: color ?? Colors.grey[800],
                fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Divider(
        color: Colors.green[200],
        thickness: 1,
      ),
    );
  }
}