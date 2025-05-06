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

class _OrderDetailsPageState extends State<OrderDetailsPage> {
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

  Future<int> Cancel_Order({required int OrderId}) async
  {

    try {
      print("Cancel order start");
      print("${OrderId}");
      // Construct the JSON payload
      Map<String, int> OrderData =
      {
        "OrderId": OrderId
      };

      final BodyData=json.encode(OrderData);
      const String url = Backend_Server_Url + "api/Member/deleteorder";
      final response = await http.delete(
        Uri.parse(url),
        headers: {"Content-Type": "application/json", 'Authorization': 'Bearer ${widget.jwttoken}'},
        body: BodyData,
      );

      if (response.statusCode == 200)
      {
        print("Cancel order success.");
        Toastget().Toastmsg("Cancel order success.");
        return 1;
      }
      else if (response.statusCode == 502)
      {
        Toastget().Toastmsg("Try again end.Fail.Server error.");
        return 11; // jwt error
      }
      else if (response.statusCode == 503) {
        Toastget().Toastmsg("Cancel order failed.Incorrect order data format.Try again.");
        return 11; // jwt error
      }
      else {
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

  @override
  Widget build(BuildContext context) {
    var shortestval = MediaQuery.of(context).size.shortestSide;
    var widthval = MediaQuery.of(context).size.width;
    var heightVal = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar:  AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Order full Details",
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

        body:Container(
          width: widthval,
          height: heightVal,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Column(
              children: [

                Center(
                  child:
                  ClipOval (
                      child:  Image.memory(
                        base64Decode(widget.OrderObject.photo!),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                        const Icon(
                          Icons.broken_image,
                          size: 100,
                          color: Colors.grey,
                        ),
                      )
                  ),
                ),

                SizedBox(height: heightVal * 0.03),

                Text("Order ID: ${widget.OrderObject.orderId ?? ''}"),
                Text("Status: ${widget.OrderObject.status ?? ''}"),
                Text("Book Quantity: ${widget.OrderObject.bookQuantity ?? ''}"),
                Text("Claim ID: ${widget.OrderObject.claimId ?? ''}"),
                Text("Discount Amount: ${widget.OrderObject.discountAmount ?? ''}"),
                Text("Total Price: ${widget.OrderObject.totalPrice?.toStringAsFixed(2) ?? ''}"),
                Text("Claim Code: ${widget.OrderObject.claimCode ?? ''}"),
                Text("Order Date: ${widget.OrderObject.orderDate ?? ''}"),
                Text("Order User ID: ${widget.OrderObject.orderUserId ?? ''}"),
                Text("Order Book ID: ${widget.OrderObject.orderBookId ?? ''}"),
                Text("First Name: ${widget.OrderObject.firstName ?? ''}"),
                Text("Last Name: ${widget.OrderObject.lastName ?? ''}"),
                Text("Email: ${widget.OrderObject.email ?? ''}"),
                Text("Phone Number: ${widget.OrderObject.phoneNumber ?? ''}"),
                Text("Role: ${widget.OrderObject.role ?? ''}"),
                Text("Book Name: ${widget.OrderObject.bookName ?? ''}"),
                Text("Price: ${widget.OrderObject.price?.toStringAsFixed(2) ?? ''}"),
                Text("Format: ${widget.OrderObject.format ?? ''}"),
                Text("Title: ${widget.OrderObject.title ?? ''}"),
                Text("Author: ${widget.OrderObject.author ?? ''}"),
                Text("Publisher: ${widget.OrderObject.publisher ?? ''}"),
                Text("Publication Date: ${widget.OrderObject.publicationDate ?? ''}"),
                Text("Language: ${widget.OrderObject.language ?? ''}"),
                Text("Category: ${widget.OrderObject.category ?? ''}"),
                Text("Listed At: ${widget.OrderObject.listedAt ?? ''}"),

                10.heightBox,
                Commonbutton("Cancel order", ()async{

                  if(widget.OrderObject.status=="Complete" )
                  {
                    print("Order already eceived.Cannot cancel.");
                    Toastget().Toastmsg("Order already eceived.Cannot cancel.");
                    return;
                  }
                  else{
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
                    }
                    catch(obj){
                      print(obj.toString());
                      Toastget().Toastmsg("Retry.Fail.");
                      return;
                    }
                  }
                }, context, Colors.red),
              ],
            ),
          ),
        )

    );
  }
}
