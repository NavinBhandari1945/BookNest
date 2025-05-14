import 'dart:convert';

import 'package:booknest/Views/common%20widget/commonbutton.dart';
import 'package:booknest/Views/common%20widget/commontextfield_obs_false.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';

import '../../../constant/constant.dart';
import '../../../constant/styles.dart';
import '../../common widget/common_method.dart';
import '../../common widget/toast.dart';
import '../Home/user_not_login_home_screen.dart';

class ClaimCodePage extends StatefulWidget {
  final String email;
  final String usertype;
  final String jwttoken;

  const ClaimCodePage({
    super.key,
    required this.jwttoken,
    required this.usertype,
    required this.email,
  });

  @override
  State<ClaimCodePage> createState() => _ClaimCodePageState();
}

class _ClaimCodePageState extends State<ClaimCodePage> {
  // Controllers to manage user input
  final Claimcode_Id_cont = TextEditingController();
  final ClaimCode_Cont = TextEditingController();
  final Order_Id_Cont = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Check for valid JWT session when screen is initialized
    checkJWTExpiationmember();
  }

  /// Validates the JWT token and redirects to login screen if session is expired
  Future<void> checkJWTExpiationmember() async {
    try {
      int result = await checkJwtToken_initistate_staff(
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
      print("JWT verification failed: $obj");
      await clearUserData();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserNotLoginHomeScreen()),
      );
      Toastget().Toastmsg("Error. Relogin please.");
    }
  }

  /// Sends HTTP POST request to claim an order using claim code
  Future<int> Claim_Order({
    required int OrderId,
    required String ClaimCode,
    required String ClaimId,
  }) async {
    try {
      Map<String, dynamic> BodyData = {
        "OrderId": OrderId,
        "ClaimCode": ClaimCode,
        "ClaimId": ClaimId,
      };

      const String url = Backend_Server_Url + "api/Staff/claim_code";
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${widget.jwttoken}',
        },
        body: json.encode(BodyData),
      );

      // Handle responses from the server
      if (response.statusCode == 200) {
        Toastget().Toastmsg("Order claim success.");
        return 1;
      } else if (response.statusCode == 501) {
        Toastget().Toastmsg("Session ended. Please re-login.");
        await clearUserData();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const UserNotLoginHomeScreen()),
        );
        return 2;
      } else if (response.statusCode == 502) {
        Toastget().Toastmsg("Incorrect claim data format. Try again.");
        return 3;
      } else if (response.statusCode == 503) {
        Toastget().Toastmsg("Invalid order status. Try again.");
        return 5;
      } else {
        Toastget().Toastmsg("Unexpected error occurred.");
        return 4;
      }
    } catch (obj) {
      print("Error during claim order: $obj");
      Toastget().Toastmsg("Claim process failed. Try again.");
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Custom styled AppBar
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          "Claim Order",
          style: TextStyle(
            fontFamily: bold,
            fontSize: 24,
            color: Colors.white,
            letterSpacing: 1.3,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF2C786C),
        elevation: 6,
        shadowColor: Colors.black38,
      ),
      // Page body with gradient background and padding
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF1F4F6), Color(0xFFE0E4E7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildSectionHeader("Enter Claim Details"),
                  const SizedBox(height: 20),

                  // Order ID input field
                  CommonTextField_obs_false("Enter Order ID", "", false, Order_Id_Cont, context),
                  const SizedBox(height: 16),

                  // Claim code ID input field
                  CommonTextField_obs_false("Enter Claim Code ID", "", false, Claimcode_Id_cont, context),
                  const SizedBox(height: 16),

                  // Claim code input field
                  CommonTextField_obs_false("Enter Claim Code", "", false, ClaimCode_Cont, context),
                  const SizedBox(height: 24),

                  // Submit button
                  Commonbutton("Confirm", () async {
                    try {
                      if (Claimcode_Id_cont.text.isEmptyOrNull ||
                          ClaimCode_Cont.text.isEmptyOrNull ||
                          Order_Id_Cont.text.isEmptyOrNull) {
                        Toastget().Toastmsg("Please fill all fields correctly.");
                        return;
                      }

                      int? orderId = int.tryParse(Order_Id_Cont.text.trim());
                      if (orderId == null) {
                        Toastget().Toastmsg("Order ID must be a number.");
                        return;
                      }

                      int result = await Claim_Order(
                        OrderId: orderId,
                        ClaimCode: ClaimCode_Cont.text.trim(),
                        ClaimId: Claimcode_Id_cont.text.trim(),
                      );

                      print("Claim result: $result");

                    } catch (e) {
                      print("Error: $e");
                      Toastget().Toastmsg("Order claim failed. Try again.");
                    }
                  }, context, const Color(0xFFD9534F)), // Red button color
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Widget to build section headers
  Widget _buildSectionHeader(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontFamily: bold,
          fontSize: 20,
          color: const Color(0xFF1A3C34),
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}




// import 'dart:convert';
//
// import 'package:booknest/Views/common%20widget/commonbutton.dart';
// import 'package:booknest/Views/common%20widget/commontextfield_obs_false.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:velocity_x/velocity_x.dart';
//
// import '../../../constant/constant.dart';
// import '../../../constant/styles.dart';
// import '../../common widget/common_method.dart';
// import '../../common widget/toast.dart';
// import '../Home/user_not_login_home_screen.dart';
//
// class ClaimCodePage extends StatefulWidget {
//   final String email;
//   final String usertype;
//   final String jwttoken;
//   const ClaimCodePage({super.key,required this.jwttoken,required this.usertype,required this.email});
//
//   @override
//   State<ClaimCodePage> createState() => _ClaimCodePageState();
// }
//
// class _ClaimCodePageState extends State<ClaimCodePage> {
//
//   final Claimcode_Id_cont=TextEditingController();
//   final ClaimCode_Cont=TextEditingController();
//   final Order_Id_Cont=TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     checkJWTExpiationmember();
//   }
//
//   Future<void> checkJWTExpiationmember() async {
//     try {
//       print("check jwt called in addreview screen.");
//       int result = await checkJwtToken_initistate_staff(
//           widget.email, widget.usertype, widget.jwttoken);
//       if (result == 0)
//       {
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
//
//   Future<int> Claim_Order({
//     required int OrderId,
//     required String ClaimCode,
//     required String ClaimId,
//   }) async {
//     try {
//       print("Order claim start");
//       // Construct the JSON payload
//       Map<String, dynamic> BodyData = {
//         "OrderId":OrderId,
//         "ClaimCode": ClaimCode,
//         "ClaimId": ClaimId,
//       };
//       const String url = Backend_Server_Url + "api/Staff/claim_code";
//       final response = await http.post(
//         Uri.parse(url),
//         headers: {
//           "Content-Type": "application/json",
//           'Authorization': 'Bearer ${widget.jwttoken}',
//         },
//         body: json.encode(BodyData),
//       );
//       if (response.statusCode == 200) {
//         Toastget().Toastmsg("Order claim success.");
//         return 1;
//       } else if (response.statusCode == 501) {
//         Toastget().Toastmsg("Session end.Relogin please.");
//         await clearUserData();
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => const UserNotLoginHomeScreen(),
//           ),
//         );
//         return 2; // jwt error
//       } else if (response.statusCode == 502) {
//         Toastget().Toastmsg(
//           "Claim process failed.Incorrect claim data format.Try again.",
//         );
//         return 3; // jwt error
//       }
//       else if (response.statusCode == 503) {
//         Toastget().Toastmsg(
//           "Order invalid status.Data don't match.Try again.",
//         );
//         return 5;
//       }
//       else if (response.statusCode == 500) {
//         print("Error.other status code = ${response.statusCode}");
//         // print("Response body: ${response.body}");
//         // final decoded = json.decode(response.body);
//         // print("Error message: ${decoded['message']}");
//         // print("Stack trace: ${decoded['stackTrace']}");
//         Toastget().Toastmsg(
//           "Exception caught in backend.Try again.",
//         );
//         return 5;
//       }
//       else {
//         print("Error.other status code= ${response.statusCode}");
//         Toastget().Toastmsg(" Claim process failed.");
//         return 4;
//       }
//     } catch (obj) {
//       print("Exception caught while Claim order in http method.");
//       print(obj.toString());
//       Toastget().Toastmsg("Checking Claim failed.");
//       return 0;
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           automaticallyImplyLeading: false,
//           title: Text(
//             "Staff",
//             style: TextStyle(fontFamily: bold, fontSize: 24, color: Colors.white, letterSpacing: 1.2),
//           ),
//           backgroundColor: Colors.green[700],
//           elevation: 4,
//           shadowColor: Colors.black45,
//         ),
//         body:Container(
//           child: Column(
//             children: [
//               CommonTextField_obs_false("Enter  order id.", "", false, Order_Id_Cont, context),
//               CommonTextField_obs_false("Enter claim code id.", "", false, Claimcode_Id_cont, context),
//               CommonTextField_obs_false("Enter claim code.", "", false, ClaimCode_Cont, context),
//               10.heightBox,
//               Commonbutton("Confirm", ()async{
//                 try {
//
//                   if(Claimcode_Id_cont.text.isEmptyOrNull ||
//                       ClaimCode_Cont.text.isEmptyOrNull ||
//                   Order_Id_Cont.text.isEmptyOrNull
//                   ){
//                     print("Incorrect enter data format.");
//                     Toastget().Toastmsg("Incorrect enter data format.");
//                     return;
//                   }
//
//                   int? OrderId_Int=int.tryParse(Order_Id_Cont.text.toString());
//
//                   final Claim_Code_Result=await Claim_Order(OrderId: OrderId_Int!, ClaimCode:ClaimCode_Cont.text.toString(), ClaimId:Claimcode_Id_cont.text.toString());
//                   print(Claim_Code_Result);
//
//
//                 }catch(obj){
//                   print(obj.toString());
//                   Toastget().Toastmsg("Order claim fail.Try again.");
//                 }
//               }, context, Colors.red)
//
//             ],
//           ),
//         )
//
//     );
//   }
// }
