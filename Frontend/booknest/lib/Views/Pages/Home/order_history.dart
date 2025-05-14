import 'dart:convert';

import 'package:booknest/Views/Pages/Home/user_not_login_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';

import '../../../Models/UserOrderBookModel.dart';
import '../../../constant/constant.dart';
import '../../../constant/styles.dart';
import '../../common widget/circular_progress_ind_yellow.dart';
import '../../common widget/common_method.dart';
import '../../common widget/toast.dart';
import 'order_full_details.dart';

// Widget definition section
class OrderHistoryPage extends StatefulWidget {
  final String email;
  final String usertype;
  final String jwttoken;
  const OrderHistoryPage({
    super.key,
    required this.jwttoken,
    required this.usertype,
    required this.email,
  });

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

// State management and initialization section
class _OrderHistoryPageState extends State<OrderHistoryPage> {
  @override
  void initState() {
    super.initState();
    checkJWTExpiationmember();
  }

  Future<void> checkJWTExpiationmember() async {
    try {
      print("check jwt called in book screen.");
      int result = await checkJwtToken_initistate_member(
        widget.email,
        widget.usertype,
        widget.jwttoken,
      );
      if (result == 0) {
        await clearUserData();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserNotLoginHomeScreen()),
        );
        Toastget().Toastmsg("Session End. Relogin please.");
      }
    } catch (obj) {
      print("Exception caught while verifying jwt for admin home screen.");
      print(obj.toString());
      await clearUserData();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserNotLoginHomeScreen()),
      );
      Toastget().Toastmsg("Error. Relogin please.");
    }
  }

  List<OrderUserBookModel> OrdrInfoList = [];
  List<OrderUserBookModel> CurrentUserOrdrInfoList = [];
  Future<void> GetOrderInfos() async {
    try {
      print("Get order info method called");
      const String url = Backend_Server_Url + "api/Member/getorderuserbooks";
      final headers = {
        'Authorization': 'Bearer ${widget.jwttoken}',
        'Content-Type': 'application/json',
      };
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        List<dynamic> responseData = await jsonDecode(response.body);
        print("response statuscode");
        print("200");
        OrdrInfoList.clear();
        OrdrInfoList.addAll(
          responseData
              .map((data) => OrderUserBookModel.fromJson(data))
              .toList(),
        );
        print("OrdrInfoList count value");
        print(OrdrInfoList.length);
        CurrentUserOrdrInfoList.clear();
        CurrentUserOrdrInfoList.addAll(
          OrdrInfoList.where(
                (orderitem) => orderitem.email == widget.email,
          ).toList(),
        );
        print(
          "Current user CurrentUserOrdrInfoList count: ${CurrentUserOrdrInfoList.length}",
        );
        return;
      } else {
        OrdrInfoList.clear();
        print("Data insert in OrdrInfoList failed.");
        return;
      }
    } catch (obj) {
      OrdrInfoList.clear();
      print("Exception caught while fetching OrdrInfoList in http method");
      print(obj.toString());
      return;
    }
  }

  // UI building section
  @override
  Widget build(BuildContext context) {
    var shortestval = MediaQuery.of(context).size.shortestSide;
    var widthval = MediaQuery.of(context).size.width;
    var heightval = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Order History",
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
        height: heightval,
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
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              // Order history content section
              Container(
                margin: EdgeInsets.all(16.0),
                padding: EdgeInsets.all(16.0),
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
                child: FutureBuilder(
                  future: GetOrderInfos(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Circular_pro_indicator_Yellow(
                        context,
                      );
                    } else if (snapshot.hasError) {
                      return Text(
                        'Error: ${snapshot.error}',
                      );
                    } else if (snapshot.connectionState == ConnectionState.done) {
                      if (CurrentUserOrdrInfoList.isNotEmpty ||
                          CurrentUserOrdrInfoList.length >= 1) {
                        return Container(
                          width: widthval,
                          height: heightval * 0.85,
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              final order = CurrentUserOrdrInfoList[index];
                              return Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                margin: EdgeInsets.symmetric(vertical: heightval * 0.01),
                                color: Colors.white,
                                child: Container(
                                  padding: EdgeInsets.all(12.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${order.bookId}", style: TextStyle(fontSize: widthval * 0.04, fontFamily: bold)),
                                      Text("${order.author}", style: TextStyle(fontSize: widthval * 0.04)),
                                      Text("${order.publicationDate}", style: TextStyle(fontSize: widthval * 0.04)),
                                    ],
                                  ),
                                ),
                              ).onTap(() {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OrderDetailsPage(
                                      jwttoken: widget.jwttoken,
                                      usertype: widget.usertype,
                                      email: widget.email,
                                      OrderObject: order,
                                    ),
                                  ),
                                );
                              });
                            },
                            itemCount: CurrentUserOrdrInfoList.length,
                          ),
                        );
                      } else {
                        return Center(
                          child: Text(
                            'No order history. Please close and reopen app or place an order.',
                            style: TextStyle(
                              fontSize: widthval * 0.04,
                              color: Colors.grey[600],
                              fontFamily: bold,
                            ),
                          ),
                        );
                      }
                    } else {
                      return Center(
                        child: Text('Error. Relogin.'),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}