import 'dart:convert';
import 'package:booknest/Views/Pages/Home/user_not_login_home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';
import '../../../Models/AnnouncementModel.dart';
import '../../../Models/OrderModel.dart';
import '../../../constant/constant.dart';
import '../../../constant/styles.dart';
import '../../common widget/circular_progress_ind_yellow.dart';
import '../../common widget/common_method.dart';
import '../../common widget/header_footer.dart';
import '../../common widget/toast.dart';

// Widget definition section
class MemberHomePage extends StatefulWidget {
  final String email;
  final String usertype;
  final String jwttoken;
  const MemberHomePage({super.key, required this.jwttoken, required this.usertype, required this.email});

  @override
  State<MemberHomePage> createState() => _MemberHomePageState();
}

// State management and initialization section
class _MemberHomePageState extends State<MemberHomePage> {
  @override
  void initState() {
    super.initState();
    checkJWTExpiationmember();
  }

  Future<void> checkJWTExpiationmember() async {
    try {
      print("check jwt called in member home screen.");
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
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => UserNotLoginHomeScreen()));
      Toastget().Toastmsg("Error. Relogin please.");
    }
  }

  List<OrderModel> SuccessOrderList = [];

  Future<void> GetSuccessOrderInfo() async {
    try {
      print("Get success order info method called");
      const String url = Backend_Server_Url + "api/Member/get_success_order";
      final headers = {
        'Authorization': 'Bearer ${widget.jwttoken}',
        'Content-Type': 'application/json',
      };
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        List<dynamic> responseData = await jsonDecode(response.body);
        print("response statuscode = ${response.statusCode}");
        SuccessOrderList.clear();
        SuccessOrderList.addAll(responseData.map((data) => OrderModel.fromJson(data)).toList());
        print("SuccessOrderList count value");
        print(SuccessOrderList.length);
        return;
      } else {
        SuccessOrderList.clear();
        print("Data insert in SuccessOrderList info failed.");
        return;
      }
    } catch (obj) {
      SuccessOrderList.clear();
      print("Exception caught while fetching SuccessOrderList data in http method");
      print(obj.toString());
      return;
    }
  }

  List<AnnouncementModel> AnnouncementInfoList = [];
  Future<void> GetAnnouncementInfo() async {
    try {
      print("Get announcement info method called");
      const String url = Backend_Server_Url + "api/Member/get_announcement_info";
      final headers = {
        'Authorization': 'Bearer ${widget.jwttoken}',
        'Content-Type': 'application/json',
      };
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        List<dynamic> responseData = await jsonDecode(response.body);
        AnnouncementInfoList.clear();
        AnnouncementInfoList.addAll(responseData.map((data) => AnnouncementModel.fromJson(data)).toList());
        print("AnnouncementInfoList count value");
        print(AnnouncementInfoList.length);
        return;
      } else {
        AnnouncementInfoList.clear();
        print("Data insert in AnnouncementInfoList failed.");
        return;
      }
    } catch (obj) {
      AnnouncementInfoList.clear();
      print("Exception caught while fetching AnnouncementInfoList data in http method");
      print(obj.toString());
      return;
    }
  }

  // UI building section
  @override
  Widget build(BuildContext context) {
    var widthval = MediaQuery.of(context).size.width;
    var heightval = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "User Home",
          style: TextStyle(
            fontFamily: bold,
            fontSize: 20,
            color: Colors.white,
            letterSpacing: 1.0,
          ),
        ),
        backgroundColor: Colors.green[700],
        elevation: 4,
        shadowColor: Colors.black45,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
        child: Column(
          children: [
            // Header section
            SizedBox(
              width: double.infinity,
              child: HeaderWidget(
                email: widget.email,
                usertype: widget.usertype,
                jwttoken: widget.jwttoken,
              ),
            ),
            // Main content section
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 800,
                      minWidth: 300,
                    ),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Successful Order Details header
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: heightval * 0.02),
                            child: Text(
                              "Successful Order Details",
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: bold,
                                color: Colors.green[800],
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ).centered(),
                          ),
                          // Success Order Section
                          Container(
                            height: heightval * 0.85,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.green[200]!, width: 1),
                            ),
                            child: FutureBuilder(
                              future: GetSuccessOrderInfo(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: Circular_pro_indicator_Yellow(context));
                                } else if (snapshot.hasError) {
                                  return Center(
                                    child: Text(
                                      'Error: ${snapshot.error}',
                                      style: TextStyle(
                                        fontSize: widthval * 0.035,
                                        color: Colors.red[600],
                                        fontFamily: bold,
                                      ),
                                    ),
                                  );
                                } else if (snapshot.connectionState == ConnectionState.done) {
                                  if (SuccessOrderList.isNotEmpty) {
                                    return LayoutBuilder(
                                      builder: (context, constraints) {
                                        double fontScale = constraints.maxWidth < 360 ? 0.85 : constraints.maxWidth < 400 ? 0.9 : 1.0;
                                        return ListView.builder(
                                          shrinkWrap: true,
                                          physics: const BouncingScrollPhysics(),
                                          clipBehavior: Clip.hardEdge,
                                          itemCount: SuccessOrderList.length,
                                          itemBuilder: (context, index) {
                                            final order = SuccessOrderList[index];
                                            return Card(
                                              elevation: 4,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              margin: EdgeInsets.symmetric(
                                                horizontal: widthval * 0.02,
                                                vertical: heightval * 0.005,
                                              ),
                                              color: Colors.white,
                                              child: Padding(
                                                padding: EdgeInsets.all(widthval * 0.02),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    _buildInfoRow('Order ID', order.orderId?.toString() ?? 'N/A', widthval, heightval, fontScale, isBold: true),
                                                    _buildInfoRow('Status', order.status ?? 'N/A', widthval, heightval, fontScale, color: order.status == 'Success' ? Colors.green[600] : Colors.red[600]),
                                                    _buildInfoRow('Book Quantity', order.bookQuantity?.toString() ?? 'N/A', widthval, heightval, fontScale),
                                                    _buildInfoRow('Discount Amount', order.discountAmount?.toString() ?? 'N/A', widthval, heightval, fontScale),
                                                    _buildInfoRow('Total Price', order.totalPrice?.toStringAsFixed(2) ?? 'N/A', widthval, heightval, fontScale, color: Colors.green[700]),
                                                    _buildInfoRow('Order Date', order.orderDate ?? 'N/A', widthval, heightval, fontScale),
                                                    _buildInfoRow('User ID', order.userId?.toString() ?? 'N/A', widthval, heightval, fontScale),
                                                    _buildInfoRow('Book ID', order.bookId?.toString() ?? 'N/A', widthval, heightval, fontScale),
                                                    ExpansionTile(
                                                      title: Text(
                                                        'Message',
                                                        style: TextStyle(
                                                          fontSize: widthval * 0.03 * fontScale,
                                                          fontFamily: bold,
                                                          color: Colors.black87,
                                                        ),
                                                      ),
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.all(widthval * 0.02),
                                                          child: Text(
                                                            'Thank you for your order.Your purchase of ${order.bookQuantity ?? '-'} item totaling ${order.totalPrice?.toStringAsFixed(2) ?? '-'} has been successfully placed on ${order.orderDate ?? '-'}. We appreciate your trust in BookNest.',
                                                            style: TextStyle(
                                                              fontSize: widthval * 0.028 * fontScale,
                                                              color: Colors.grey[800],
                                                            ),
                                                            softWrap: true,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    );
                                  } else {
                                    return Center(
                                      child: Text(
                                        'No successful orders found.',
                                        style: TextStyle(
                                          fontSize: widthval * 0.035,
                                          color: Colors.grey[600],
                                          fontFamily: bold,
                                        ),
                                      ),
                                    );
                                  }
                                } else {
                                  return Center(
                                    child: Text(
                                      'Error. Please relogin.',
                                      style: TextStyle(
                                        fontSize: widthval * 0.035,
                                        color: Colors.red[600],
                                        fontFamily: bold,
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                          SizedBox(height: heightval * 0.03),
                          // Announcement Details header
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: heightval * 0.02),
                            child: Text(
                              "Announcement Details",
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: bold,
                                color: Colors.green[800],
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ).centered(),
                          ),
                          // Announcement Section
                          Container(
                            height: heightval * 0.80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.green[200]!, width: 1),
                            ),
                            child: FutureBuilder<void>(
                              future: GetAnnouncementInfo(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Circular_pro_indicator_Yellow(context);
                                } else if (snapshot.hasError) {
                                  return Center(
                                    child: Text(
                                      "Error fetching announcement info.Close and reopen app.. Please try again.",
                                      style: TextStyle(color: Colors.red, fontSize: 16),
                                    ),
                                  );
                                } else if (snapshot.connectionState == ConnectionState.done) {
                                  return AnnouncementInfoList.isEmpty
                                      ? const Center(
                                    child: Text("No announcement data available."),
                                  )
                                      : Container(
                                    height: heightval * 0.28,
                                    width: widthval,
                                    child: VxSwiper.builder(
                                      itemCount: AnnouncementInfoList.length,
                                      autoPlay: true,
                                      enlargeCenterPage: false,
                                      viewportFraction: 1.0,
                                      aspectRatio: 16 / 9,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final ad = AnnouncementInfoList[index];
                                        return Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Center(
                                              child: Text(
                                                "Title=${ad.title!}",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green[900],
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: heightval * 0.01),
                                            Text(
                                              "Message:${ad.message!}",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(height: heightval * 0.01),
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.green[50],
                                                  borderRadius: BorderRadius.circular(16),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black26,
                                                      blurRadius: 8,
                                                      offset: Offset(0, 4),
                                                    ),
                                                  ],
                                                ),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(16),
                                                  child: Image.memory(
                                                    base64Decode(ad.photo!),
                                                    height: heightval * 0.05,
                                                    width: widthval,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  );
                                } else {
                                  return Center(
                                    child: Text(
                                      "Please close and reopen app.",
                                      style: TextStyle(color: Colors.red, fontSize: 16),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: heightval * 0.01),
            // Footer section
            SizedBox(
              width: double.infinity,
              child: FooterWidget(),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method section
  Widget _buildInfoRow(
      String label,
      String value,
      double widthval,
      double heightval,
      double fontScale, {
        bool isBold = false,
        bool isItalic = false,
        Color? color,
      }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: heightval * 0.002),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: widthval * 0.03 * fontScale,
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
                fontSize: widthval * 0.03 * fontScale,
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
}