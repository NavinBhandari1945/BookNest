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

class MemberHomePage extends StatefulWidget {
  final String email;
  final String usertype;
  final String jwttoken;
  const MemberHomePage({
    super.key,
    required this.jwttoken,
    required this.usertype,
    required this.email,
  });

  @override
  State<MemberHomePage> createState() => _MemberHomePageState();
}

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
        SuccessOrderList.addAll(
          responseData.map((data) => OrderModel.fromJson(data)).toList(),
        );
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
      print(
        "Exception caught while fetching SuccessOrderList data in http method",
      );
      print(obj.toString());
      return;
    }
  }

  List<AnnouncementModel> AnnouncementInfoList = [];
  Future<void> GetAnnouncementInfo() async {
    try {
      print("Get announcement info method called");
      const String url =
          Backend_Server_Url + "api/Member/get_announcement_info";
      final headers = {
        'Authorization': 'Bearer ${widget.jwttoken}',
        'Content-Type': 'application/json',
      };
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        List<dynamic> responseData = await jsonDecode(response.body);
        AnnouncementInfoList.clear();
        AnnouncementInfoList.addAll(
          responseData.map((data) => AnnouncementModel.fromJson(data)).toList(),
        );
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
      print(
        "Exception caught while fetching AnnouncementInfoList data in http method",
      );
      print(obj.toString());
      return;
    }
  }

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
            colors: [Colors.green[50]!.withOpacity(0.7), Colors.white],
          ),
        ),
        child: Column(
          children: [
            // Header (Full Width)
            SizedBox(
              width: double.infinity,
              child: HeaderWidget(
                email: widget.email,
                usertype: widget.usertype,
                jwttoken: widget.jwttoken,
              ),
            ),

            // Constrained Content
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 800,
                    minWidth: 300,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: heightval * 0.01,
                        ),
                        child: Text(
                          "Successful Order Details",
                          style: TextStyle(
                            fontSize: 15,

                            color: Colors.green[800],
                          ),
                        ),
                      ),

                      // Success Order Section (30% height)
                      SizedBox(
                        height: heightval * 0.3,
                        child: FutureBuilder(
                          future: GetSuccessOrderInfo(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: Circular_pro_indicator_Yellow(context),
                              );
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
                            } else if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (SuccessOrderList.isNotEmpty) {
                                return LayoutBuilder(
                                  builder: (context, constraints) {
                                    double fontScale =
                                        constraints.maxWidth < 360
                                            ? 0.85
                                            : constraints.maxWidth < 400
                                            ? 0.9
                                            : 1.0;
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
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          margin: EdgeInsets.symmetric(
                                            horizontal: widthval * 0.02,
                                            vertical: heightval * 0.005,
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(
                                              widthval * 0.02,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                _buildInfoRow(
                                                  'Order ID',
                                                  order.orderId?.toString() ??
                                                      'N/A',
                                                  widthval,
                                                  heightval,
                                                  fontScale,
                                                  isBold: true,
                                                ),
                                                _buildInfoRow(
                                                  'Status',
                                                  order.status ?? 'N/A',
                                                  widthval,
                                                  heightval,
                                                  fontScale,
                                                  color:
                                                      order.status == 'Success'
                                                          ? Colors.green[600]
                                                          : Colors.red[600],
                                                ),
                                                _buildInfoRow(
                                                  'Book Quantity',
                                                  order.bookQuantity
                                                          ?.toString() ??
                                                      'N/A',
                                                  widthval,
                                                  heightval,
                                                  fontScale,
                                                ),
                                                _buildInfoRow(
                                                  'Claim ID',
                                                  order.claimId ?? 'N/A',
                                                  widthval,
                                                  heightval,
                                                  fontScale,
                                                ),
                                                _buildInfoRow(
                                                  'Discount Amount',
                                                  order.discountAmount
                                                          ?.toString() ??
                                                      'N/A',
                                                  widthval,
                                                  heightval,
                                                  fontScale,
                                                ),
                                                _buildInfoRow(
                                                  'Total Price',
                                                  order.totalPrice
                                                          ?.toStringAsFixed(
                                                            2,
                                                          ) ??
                                                      'N/A',
                                                  widthval,
                                                  heightval,
                                                  fontScale,
                                                  color: Colors.green[700],
                                                ),
                                                _buildInfoRow(
                                                  'Claim Code',
                                                  order.claimCode ?? 'N/A',
                                                  widthval,
                                                  heightval,
                                                  fontScale,
                                                ),
                                                _buildInfoRow(
                                                  'Order Date',
                                                  order.orderDate ?? 'N/A',
                                                  widthval,
                                                  heightval,
                                                  fontScale,
                                                ),
                                                _buildInfoRow(
                                                  'User ID',
                                                  order.userId?.toString() ??
                                                      'N/A',
                                                  widthval,
                                                  heightval,
                                                  fontScale,
                                                ),
                                                _buildInfoRow(
                                                  'Book ID',
                                                  order.bookId?.toString() ??
                                                      'N/A',
                                                  widthval,
                                                  heightval,
                                                  fontScale,
                                                ),
                                                ExpansionTile(
                                                  title: Text(
                                                    'Message',
                                                    style: TextStyle(
                                                      fontSize:
                                                          widthval *
                                                          0.03 *
                                                          fontScale,
                                                      fontFamily: bold,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.all(
                                                        widthval * 0.02,
                                                      ),
                                                      child: Text(
                                                        'Thank you for your order.Your purchase of ${order.bookQuantity ?? '-'} item totaling ${order.totalPrice?.toStringAsFixed(2) ?? '-'} has been successfully placed on ${order.orderDate ?? '-'}. We appreciate your trust in BookNest.',
                                                        style: TextStyle(
                                                          fontSize:
                                                              widthval *
                                                              0.028 *
                                                              fontScale,
                                                          color:
                                                              Colors.grey[800],
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
                    ],
                  ),
                ),
              ),
            ),

            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: heightval * 0.01),
                  child: Text(
                    "Announceemnt Details",
                    style: TextStyle(fontSize: 15, color: Colors.green[800]),
                  ),
                ),

                FutureBuilder<void>(
                  future: GetAnnouncementInfo(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Circular_pro_indicator_Yellow(context);
                    } else if (snapshot.hasError) {
                      // Handle any error from the future
                      return Center(
                        child: Text(
                          "Error fetching announceemnt info.Close and reopen app.. Please try again.",
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      return AnnouncementInfoList.isEmpty
                          ? const Center(
                            child: Text("No announcement data available."),
                          )
                          : Container(
                            // color: Colors.green,
                            height: heightval * 0.28,
                            width: widthval,
                            child: VxSwiper.builder(
                              itemCount: AnnouncementInfoList.length,
                              autoPlay: true,
                              enlargeCenterPage:
                                  false, // Disable enlargement effect
                              viewportFraction:
                                  1.0, // Each item occupies full width
                              aspectRatio: 16 / 9,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                final ad = AnnouncementInfoList[index];
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // messsage Text
                                    Center(
                                      child: Text(
                                        "Tittle=${ad.title!}",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: heightval * 0.01),

                                    // messsage Text
                                    Text(
                                      "Message;${ad.message!}",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: heightval * 0.01),

                                    // Image converted from Base64 String
                                    Expanded(
                                      child: Container(
                                        height: heightval * 0.5,
                                        width: widthval,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 8,
                                              offset: Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
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
              ],
            ),

            SizedBox(height: heightval * 0.01),

            // Footer (Full Width)
            SizedBox(width: double.infinity, child: FooterWidget()),
          ],
        ),
      ),
    );
  }

  // Helper method to build info rows
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

// import 'dart:convert';
// import 'package:booknest/Views/Pages/Home/user_not_login_home_screen.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import '../../../Models/OrderModel.dart';
// import '../../../constant/constant.dart';
// import '../../../constant/styles.dart';
// import '../../common widget/circular_progress_ind_yellow.dart';
// import '../../common widget/common_method.dart';
// import '../../common widget/header_footer.dart';
// import '../../common widget/toast.dart';
//
// class MemberHomePage extends StatefulWidget {
//   final String email;
//   final String usertype;
//   final String jwttoken;
//   const MemberHomePage({super.key, required this.jwttoken, required this.usertype, required this.email});
//
//   @override
//   State<MemberHomePage> createState() => _MemberHomePageState();
// }
//
// class _MemberHomePageState extends State<MemberHomePage> {
//   @override
//   void initState() {
//     super.initState();
//     checkJWTExpiationmember();
//   }
//
//   Future<void> checkJWTExpiationmember() async {
//     try {
//       print("check jwt called in member home screen.");
//       int result = await checkJwtToken_initistate_member(
//           widget.email, widget.usertype, widget.jwttoken);
//       if (result == 0) {
//         await clearUserData();
//         Navigator.pushReplacement(context,
//             MaterialPageRoute(builder: (context) => UserNotLoginHomeScreen()));
//         Toastget().Toastmsg("Session End. Relogin please.");
//       }
//     } catch (obj) {
//       print("Exception caught while verifying jwt for admin home screen.");
//       print(obj.toString());
//       await clearUserData();
//       Navigator.pushReplacement(context,
//           MaterialPageRoute(builder: (context) => UserNotLoginHomeScreen()));
//       Toastget().Toastmsg("Error. Relogin please.");
//     }
//   }
//
//   List<OrderModel> SuccessOrderList = [];
//
//   Future<void> GetSuccessOrderInfo() async {
//     try {
//       print("Get success order info method called");
//       const String url = Backend_Server_Url + "api/Member/get_success_order";
//       final headers = {
//         'Authorization': 'Bearer ${widget.jwttoken}',
//         'Content-Type': 'application/json',
//       };
//       final response = await http.get(Uri.parse(url), headers: headers);
//       if (response.statusCode == 200) {
//         List<dynamic> responseData = await jsonDecode(response.body);
//         print("response statuscode = ${response.statusCode}");
//         SuccessOrderList.clear();
//         SuccessOrderList.addAll(responseData.map((data) => OrderModel.fromJson(data)).toList());
//         print("SuccessOrderList count value");
//         print(SuccessOrderList.length);
//         return;
//       } else {
//         SuccessOrderList.clear();
//         print("Data insert in SuccessOrderList info failed.");
//         return;
//       }
//     } catch (obj) {
//       SuccessOrderList.clear();
//       print("Exception caught while fetching SuccessOrderList data in http method");
//       print(obj.toString());
//       return;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var widthval = MediaQuery.of(context).size.width;
//     var heightval = MediaQuery.of(context).size.height;
//
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: const Text(
//           "User Home",
//           style: TextStyle(
//             fontFamily: bold,
//             fontSize: 20,
//             color: Colors.white,
//             letterSpacing: 1.0,
//           ),
//         ),
//         backgroundColor: Colors.green[700],
//         elevation: 4,
//         shadowColor: Colors.black45,
//       ),
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Colors.green[50]!.withOpacity(0.7), Colors.white],
//           ),
//         ),
//         child: Column(
//           children: [
//             // Header (Full Width)
//             SizedBox(
//               width: double.infinity,
//               child: HeaderWidget(
//                 email: widget.email,
//                 usertype: widget.usertype,
//                 jwttoken: widget.jwttoken,
//               ),
//             ),
//             // Constrained Content
//             Expanded(
//               child: Center(
//                 child: ConstrainedBox(
//                   constraints: const BoxConstraints(
//                     maxWidth: 800,
//                     minWidth: 300,
//                   ),
//                   child: Column(
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.symmetric(vertical: heightval * 0.01),
//                         child: Text(
//                           "Successful Order Details",
//                           style: TextStyle(
//                             fontSize: 10,
//                             color: Colors.green[800],
//                           ),
//                         ),
//                       ),
//                       // Success Order Section
//                       Flexible(
//                         child: Container(
//                           constraints: BoxConstraints(minHeight: heightval * 0.3),
//                           child: FutureBuilder(
//                             future: GetSuccessOrderInfo(),
//                             builder: (context, snapshot) {
//                               if (snapshot.connectionState == ConnectionState.waiting) {
//                                 return Center(child: Circular_pro_indicator_Yellow(context));
//                               } else if (snapshot.hasError) {
//                                 return Center(
//                                   child: Text(
//                                     'Error: ${snapshot.error}',
//                                     style: TextStyle(
//                                       fontSize: widthval * 0.035,
//                                       color: Colors.red[600],
//                                       fontFamily: bold,
//                                     ),
//                                   ),
//                                 );
//                               } else if (snapshot.connectionState == ConnectionState.done) {
//                                 if (SuccessOrderList.isNotEmpty) {
//                                   return LayoutBuilder(
//                                     builder: (context, constraints) {
//                                       double fontScale = constraints.maxWidth < 360 ? 0.85 : constraints.maxWidth < 400 ? 0.9 : 1.0;
//                                       return ListView.builder(
//                                         shrinkWrap: true,
//                                         physics: const BouncingScrollPhysics(),
//                                         itemCount: SuccessOrderList.length,
//                                         itemBuilder: (context, index) {
//                                           final order = SuccessOrderList[index];
//                                           return Card(
//                                             elevation: 4,
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius: BorderRadius.circular(12),
//                                             ),
//                                             margin: EdgeInsets.symmetric(
//                                               horizontal: widthval * 0.02,
//                                               vertical: heightval * 0.005,
//                                             ),
//                                             child: Padding(
//                                               padding: EdgeInsets.all(widthval * 0.02),
//                                               child: Column(
//                                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                                 children: [
//                                                   _buildInfoRow('Order ID', order.orderId?.toString() ?? 'N/A', widthval, heightval, fontScale, isBold: true),
//                                                   _buildInfoRow('Status', order.status ?? 'N/A', widthval, heightval, fontScale, color: order.status == 'Success' ? Colors.green[600] : Colors.red[600]),
//                                                   _buildInfoRow('Book Quantity', order.bookQuantity?.toString() ?? 'N/A', widthval, heightval, fontScale),
//                                                   _buildInfoRow('Claim ID', order.claimId ?? 'N/A', widthval, heightval, fontScale),
//                                                   _buildInfoRow('Discount Amount', order.discountAmount?.toString() ?? 'N/A', widthval, heightval, fontScale),
//                                                   _buildInfoRow('Total Price', order.totalPrice?.toStringAsFixed(2) ?? 'N/A', widthval, heightval, fontScale, color: Colors.green[700]),
//                                                   _buildInfoRow('Claim Code', order.claimCode ?? 'N/A', widthval, heightval, fontScale),
//                                                   _buildInfoRow('Order Date', order.orderDate ?? 'N/A', widthval, heightval, fontScale),
//                                                   _buildInfoRow('User ID', order.userId?.toString() ?? 'N/A', widthval, heightval, fontScale),
//                                                   _buildInfoRow('Book ID', order.bookId?.toString() ?? 'N/A', widthval, heightval, fontScale),
//                                                   _buildInfoRow(
//                                                     'Message', 'Thank you for your order! Your purchase of ${order.bookQuantity ?? '-'} item(s) totaling ₹${order.totalPrice?.toStringAsFixed(2) ?? '-'} has been successfully placed on ${order.orderDate ?? '-'}. We appreciate your trust in BookNest!',
//                                                     widthval,
//                                                     heightval,
//                                                     fontScale,
//                                                     isMessage: true,
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           );
//                                         },
//                                       );
//                                     },
//                                   );
//                                 } else {
//                                   return Center(
//                                     child: Text(
//                                       'No successful orders found.',
//                                       style: TextStyle(
//                                         fontSize: widthval * 0.035,
//                                         color: Colors.grey[600],
//                                         fontFamily: bold,
//                                       ),
//                                     ),
//                                   );
//                                 }
//                               } else {
//                                 return Center(
//                                   child: Text(
//                                     'Error. Please relogin.',
//                                     style: TextStyle(
//                                       fontSize: widthval * 0.035,
//                                       color: Colors.red[600],
//                                       fontFamily: bold,
//                                     ),
//                                   ),
//                                 );
//                               }
//                             },
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             // Footer (Full Width)
//             SizedBox(
//               width: double.infinity,
//               child: FooterWidget(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Helper method to build info rows
//   Widget _buildInfoRow(
//       String label,
//       String value,
//       double widthval,
//       double heightval,
//       double fontScale, {
//         bool isBold = false,
//         bool isItalic = false,
//         Color? color,
//         bool isMessage = false,
//       }) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: isMessage ? heightval * 0.004 : heightval * 0.002),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             '$label: ',
//             style: TextStyle(
//               fontSize: widthval * 0.03 * fontScale,
//               fontFamily: bold,
//               fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
//               color: Colors.black87,
//             ),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: TextStyle(
//                 fontSize: isMessage ? widthval * 0.028 * fontScale : widthval * 0.03 * fontScale,
//                 color: color ?? Colors.grey[800],
//                 fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
//                 fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
//               ),
//               maxLines: isMessage ? null : 2,
//               softWrap: isMessage ? true : null,
//               overflow: isMessage ? null : TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
//
//
// // import 'dart:convert';
// //
// // import 'package:booknest/Views/Pages/Home/user_not_login_home_screen.dart';
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// //
// // import '../../../Models/OrderModel.dart';
// // import '../../../constant/constant.dart';
// // import '../../../constant/styles.dart';
// // import '../../common widget/circular_progress_ind_yellow.dart';
// // import '../../common widget/common_method.dart';
// // import '../../common widget/header_footer.dart';
// // import '../../common widget/toast.dart';
// //
// // class MemberHomePage extends StatefulWidget {
// //   final String email;
// //   final String usertype;
// //   final String jwttoken;
// //   const MemberHomePage({super.key, required this.jwttoken, required this.usertype, required this.email});
// //
// //   @override
// //   State<MemberHomePage> createState() => _MemberHomePageState();
// // }
// //
// // class _MemberHomePageState extends State<MemberHomePage> {
// //   @override
// //   void initState() {
// //     super.initState();
// //     checkJWTExpiationmember();
// //   }
// //
// //   Future<void> checkJWTExpiationmember() async {
// //     try {
// //       print("check jwt called in member home screen.");
// //       int result = await checkJwtToken_initistate_member(
// //           widget.email, widget.usertype, widget.jwttoken);
// //       if (result == 0) {
// //         await clearUserData();
// //         Navigator.pushReplacement(context,
// //             MaterialPageRoute(builder: (context) => UserNotLoginHomeScreen()));
// //         Toastget().Toastmsg("Session End. Relogin please.");
// //       }
// //     } catch (obj) {
// //       print("Exception caught while verifying jwt for admin home screen.");
// //       print(obj.toString());
// //       await clearUserData();
// //       Navigator.pushReplacement(context,
// //           MaterialPageRoute(builder: (context) => UserNotLoginHomeScreen()));
// //       Toastget().Toastmsg("Error. Relogin please.");
// //     }
// //   }
// //
// //   List<OrderModel> SuccessOrderList = [];
// //
// //   Future<void> GetSuccessOrderInfo() async {
// //     try {
// //       print("Get success order info method called");
// //       const String url = Backend_Server_Url + "api/Member/get_success_order";
// //       final headers = {
// //         'Authorization': 'Bearer ${widget.jwttoken}',
// //         'Content-Type': 'application/json',
// //       };
// //       final response = await http.get(Uri.parse(url), headers: headers);
// //       if (response.statusCode == 200) {
// //         List<dynamic> responseData = await jsonDecode(response.body);
// //         print("response statuscode = ${response.statusCode}");
// //         SuccessOrderList.clear();
// //         SuccessOrderList.addAll(responseData.map((data) => OrderModel.fromJson(data)).toList());
// //         print("SuccessOrderList count value");
// //         print(SuccessOrderList.length);
// //         return;
// //       } else {
// //         SuccessOrderList.clear();
// //         print("Data insert in SuccessOrderList info failed.");
// //         return;
// //       }
// //     } catch (obj) {
// //       SuccessOrderList.clear();
// //       print("Exception caught while fetching SuccessOrderList data in http method");
// //       print(obj.toString());
// //       return;
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final message="";
// //     var shortestval = MediaQuery.of(context).size.shortestSide;
// //     var widthval = MediaQuery.of(context).size.width;
// //     var heightval = MediaQuery.of(context).size.height;
// //
// //     return Scaffold(
// //       appBar: AppBar(
// //         automaticallyImplyLeading: false,
// //         title: const Text(
// //           "User Home",
// //           style: TextStyle(
// //             fontFamily: bold,
// //             fontSize: 20,
// //             color: Colors.white,
// //             letterSpacing: 1.0,
// //           ),
// //         ),
// //         backgroundColor: Colors.green[700],
// //         elevation: 4,
// //         shadowColor: Colors.black45,
// //       ),
// //       body: Container(
// //         decoration: BoxDecoration(
// //           gradient: LinearGradient(
// //             begin: Alignment.topCenter,
// //             end: Alignment.bottomCenter,
// //             colors: [Colors.green[50]!.withOpacity(0.7), Colors.white],
// //           ),
// //         ),
// //         child: Center(
// //           child: ConstrainedBox(
// //             constraints: const BoxConstraints(
// //               maxWidth: 800,
// //               minWidth: 300,
// //             ),
// //             child: Column(
// //               children: [
// //
// //
// //                 // Header
// //                 HeaderWidget(
// //                   email: widget.email,
// //                   usertype: widget.usertype,
// //                   jwttoken: widget.jwttoken,
// //                 ),
// //
// //                 Center(child: Text("Successful order details")),
// //
// //                 // Success Order Section
// //                 SizedBox(
// //                   height: heightval * 0.3,
// //                   child: FutureBuilder(
// //                     future: GetSuccessOrderInfo(),
// //                     builder: (context, snapshot) {
// //                       if (snapshot.connectionState == ConnectionState.waiting) {
// //                         return Center(child: Circular_pro_indicator_Yellow(context));
// //                       } else if (snapshot.hasError) {
// //                         return Center(
// //                           child: Text(
// //                             'Error: ${snapshot.error}',
// //                             style: TextStyle(
// //                               fontSize: widthval * 0.035,
// //                               color: Colors.red[600],
// //                               fontFamily: bold,
// //                             ),
// //                           ),
// //                         );
// //                       } else if (snapshot.connectionState == ConnectionState.done) {
// //                         if (SuccessOrderList.isNotEmpty) {
// //                           return LayoutBuilder(
// //                             builder: (context, constraints) {
// //                               double fontScale = constraints.maxWidth < 400 ? 0.9 : 1.0;
// //                               return ListView.builder(
// //                                 shrinkWrap: true,
// //                                 physics: const BouncingScrollPhysics(),
// //                                 itemCount: SuccessOrderList.length,
// //                                 itemBuilder: (context, index) {
// //                                   final order = SuccessOrderList[index];
// //                                   return Card(
// //                                     elevation: 4,
// //                                     shape: RoundedRectangleBorder(
// //                                       borderRadius: BorderRadius.circular(12),
// //                                     ),
// //                                     margin: EdgeInsets.symmetric(
// //                                       horizontal: widthval * 0.02,
// //                                       vertical: heightval * 0.005,
// //                                     ),
// //                                     child: Padding(
// //                                       padding: EdgeInsets.all(widthval * 0.02),
// //                                       child:
// //                                       SingleChildScrollView(
// //                                         scrollDirection: Axis.vertical,
// //                                         physics: BouncingScrollPhysics(),
// //                                         child: Column(
// //                                           crossAxisAlignment: CrossAxisAlignment.start,
// //                                           children: [
// //                                             _buildInfoRow('Order ID', order.orderId?.toString() ?? 'N/A', widthval, heightval, fontScale, isBold: true),
// //                                             _buildInfoRow('Status', order.status ?? 'N/A', widthval, heightval, fontScale, color: order.status == 'Success' ? Colors.green[600] : Colors.red[600]),
// //                                             _buildInfoRow('Book Quantity', order.bookQuantity?.toString() ?? 'N/A', widthval, heightval, fontScale),
// //                                             _buildInfoRow('Claim ID', order.claimId ?? 'N/A', widthval, heightval, fontScale),
// //                                             _buildInfoRow('Discount Amount', order.discountAmount?.toString() ?? 'N/A', widthval, heightval, fontScale),
// //                                             _buildInfoRow('Total Price', order.totalPrice?.toStringAsFixed(2) ?? 'N/A', widthval, heightval, fontScale, color: Colors.green[700]),
// //                                             _buildInfoRow('Claim Code', order.claimCode ?? 'N/A', widthval, heightval, fontScale),
// //                                             _buildInfoRow('Order Date', order.orderDate ?? 'N/A', widthval, heightval, fontScale),
// //                                             _buildInfoRow('User ID', order.userId?.toString() ?? 'N/A', widthval, heightval, fontScale),
// //                                             _buildInfoRow('Book ID', order.bookId?.toString() ?? 'N/A', widthval, heightval, fontScale),
// //                                             _buildInfoRow(
// //                                               'Message',
// //                                               order.status == 'Success'
// //                                                   ? 'Thank you for your order! Your purchase of ${order.bookQuantity ?? '-'} item(s) totaling ₹${order.totalPrice?.toStringAsFixed(2) ?? '-'} has been successfully placed on ${order.orderDate ?? '-'}. We appreciate your trust in BookNest!'
// //                                                   : 'We encountered an issue processing your order. Please check your order details or contact support.',
// //                                               widthval,
// //                                               heightval,
// //                                               fontScale,
// //                                             ),
// //
// //                                           ],
// //                                         ),
// //                                       ),
// //                                     ),
// //                                   );
// //                                 },
// //                               );
// //                             },
// //                           );
// //                         } else {
// //                           return Center(
// //                             child: Text(
// //                               'No successful orders found.',
// //                               style: TextStyle(
// //                                 fontSize: widthval * 0.035,
// //                                 color: Colors.grey[600],
// //                                 fontFamily: bold,
// //                               ),
// //                             ),
// //                           );
// //                         }
// //                       } else {
// //                         return Center(
// //                           child: Text(
// //                             'Error. Please relogin.',
// //                             style: TextStyle(
// //                               fontSize: widthval * 0.035,
// //                               color: Colors.red[600],
// //                               fontFamily: bold,
// //                             ),
// //                           ),
// //                         );
// //                       }
// //                     },
// //                   ),
// //                 ),
// //                 // Spacer to push footer to bottom
// //                 const Spacer(),
// //                 // Footer
// //                 FooterWidget(),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   // Helper method to build info rows
// //   Widget _buildInfoRow(
// //       String label,
// //       String value,
// //       double widthval,
// //       double heightval,
// //       double fontScale, {
// //         bool isBold = false,
// //         bool isItalic = false,
// //         Color? color,
// //       }) {
// //     return Padding(
// //       padding: EdgeInsets.symmetric(vertical: heightval * 0.002),
// //       child: Row(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Text(
// //             '$label: ',
// //             style: TextStyle(
// //               fontSize: widthval * 0.03 * fontScale,
// //               fontFamily: bold,
// //               fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
// //               color: Colors.black87,
// //             ),
// //             maxLines: 1,
// //             overflow: TextOverflow.ellipsis,
// //           ),
// //           Expanded(
// //             child: Text(
// //               value,
// //               style: TextStyle(
// //                 fontSize: widthval * 0.03 * fontScale,
// //                 color: color ?? Colors.grey[800],
// //                 fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
// //                 fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
// //               ),
// //               maxLines: 2,
// //               overflow: TextOverflow.ellipsis,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
//
//
//
//
//
//
//
//
//
//
// // import 'dart:convert';
// //
// // import 'package:booknest/Views/Pages/Home/book_screen.dart';
// // import 'package:booknest/Views/Pages/Home/cart_screen.dart';
// // import 'package:booknest/Views/Pages/Home/pofile_page.dart';
// // import 'package:booknest/Views/Pages/Home/send_email.dart';
// // import 'package:booknest/Views/Pages/Home/user_not_login_home_screen.dart';
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:velocity_x/velocity_x.dart';
// // import '../../../Models/OrderModel.dart';
// // import '../../../constant/constant.dart';
// // import '../../../constant/styles.dart';
// // import '../../common widget/circular_progress_ind_yellow.dart';
// // import '../../common widget/common_method.dart';
// // import '../../common widget/commonbutton.dart';
// // import '../../common widget/toast.dart';
// // import '../Authentication/login_screen.dart';
// // import '../Authentication/signin_screen.dart';
// //
// // class MemberHomePage extends StatefulWidget {
// //   final String email;
// //   final String usertype;
// //   final String jwttoken;
// //   const MemberHomePage({super.key,required this.jwttoken,required this.usertype,required this.email});
// //
// //
// //   @override
// //   State<MemberHomePage> createState() => _MemberHomePageState();
// // }
// //
// // class _MemberHomePageState extends State<MemberHomePage> {
// //   @override
// //   void initState() {
// //     super.initState();
// //     checkJWTExpiationmember();
// //   }
// //
// //   Future<void> checkJWTExpiationmember() async {
// //     try {
// //       //check jwt called in admin home screen.
// //       print("check jwt called in member home screen.");
// //       int result = await checkJwtToken_initistate_member(
// //           widget.email, widget.usertype, widget.jwttoken);
// //       if (result == 0)
// //       {
// //         await clearUserData();
// //         Navigator.pushReplacement(context,
// //             MaterialPageRoute(builder: (context) => UserNotLoginHomeScreen()));
// //         Toastget().Toastmsg("Session End. Relogin please.");
// //       }
// //     } catch (obj) {
// //       print("Exception caught while verifying jwt for admin home screen.");
// //       print(obj.toString());
// //       await clearUserData();
// //       Navigator.pushReplacement(context,
// //           MaterialPageRoute(builder: (context) => UserNotLoginHomeScreen()));
// //       Toastget().Toastmsg("Error. Relogin please.");
// //     }
// //   }
// //
// //
// //   List<OrderModel> SuccessOrderList=[];
// //
// //   Future<void> GetSuccessOrderInfo() async {
// //     try {
// //       print("Get success order info method called");
// //       const String url = Backend_Server_Url + "api/Member/get_success_order";
// //       final headers = {
// //         'Authorization': 'Bearer ${widget.jwttoken}',
// //         'Content-Type': 'application/json',
// //       };
// //       final response = await http.get(Uri.parse(url), headers: headers);
// //       if (response.statusCode == 200) {
// //         List<dynamic> responseData = await jsonDecode(response.body);
// //         print("response statuscode = ${response.statusCode}");
// //         SuccessOrderList.clear();
// //         SuccessOrderList.addAll(responseData.map((data) => OrderModel.fromJson(data)).toList());
// //         print("SuccessOrderList  count value");
// //         print(SuccessOrderList.length);
// //         return;
// //       } else {
// //         SuccessOrderList.clear();
// //         print("Data insert in SuccessOrderList info  failed.");
// //         return;
// //       }
// //     } catch (obj) {
// //       SuccessOrderList.clear();
// //       print("Exception caught while fetching SuccessOrderList data in http method");
// //       print(obj.toString());
// //       return;
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     var shortestval = MediaQuery.of(context).size.shortestSide;
// //     var widthval = MediaQuery.of(context).size.width;
// //     var heightval = MediaQuery.of(context).size.height;
// //     return Scaffold(
// //         appBar: AppBar(
// //           automaticallyImplyLeading: false,
// //           title: const Text(
// //             "User Home Screen",
// //             style: TextStyle(
// //               fontFamily: bold,
// //               fontSize: 24,
// //               color: Colors.white,
// //               letterSpacing: 1.2,
// //             ),
// //           ),
// //           backgroundColor: Colors.green[700],
// //           elevation: 4,
// //           shadowColor: Colors.black45,
// //         ),
// //         body: Container(
// //           child: Column(
// //             children: [
// //
// //
// //
// //               FutureBuilder  (
// //                 future: GetSuccessOrderInfo(),
// //                 builder: (context, snapshot) {
// //                   if (snapshot.connectionState == ConnectionState.waiting)
// //                   {
// //                     return Circular_pro_indicator_Yellow(context); // While waiting for response
// //                   }
// //                   else if (snapshot.hasError)
// //                   {
// //                     return Text('Error: ${snapshot.error}'); // If there's an error
// //                   }
// //                   else if (snapshot.connectionState == ConnectionState.done)
// //                   {
// //                     if (SuccessOrderList.isNotEmpty || SuccessOrderList.length>=1)
// //                     {
// //                       return ListView.builder(
// //                           itemBuilder: (context, index) {
// //                             final order=SuccessOrderList[index];
// //                             return
// //                               Card (
// //                                 child:
// //                                 Column(
// //                                   children: [
// //
// //                                     Text("${order.orderId}")
// //
// //                                   ],
// //                                 ),
// //                               ) ;
// //
// //                           },
// //                           itemCount: SuccessOrderList.length
// //                       );
// //
// //                     }
// //                     else
// //                     {
// //                       return Center(child: Text('No Success Order info.')); // If no user data
// //                     }
// //                   }
// //                   else
// //                   {
// //                     return Center(child: Text('Error.Relogin.')); // Default loading state
// //                   }
// //                 },
// //
// //               ),
// //
// //
// //
// //             ],
// //           )
// //         )
// //     );
// //   }
// //
// // }
