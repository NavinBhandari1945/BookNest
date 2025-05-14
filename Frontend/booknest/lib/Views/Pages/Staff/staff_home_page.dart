import 'dart:convert';

import 'package:booknest/Views/common%20widget/common_method.dart';
import 'package:booknest/Views/common%20widget/commonbutton.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../constant/constant.dart';
import '../../../constant/styles.dart';
import '../../common widget/toast.dart';
import '../Home/user_not_login_home_screen.dart';
import 'claim_code.dart';

class StaffHomePage extends StatefulWidget {
  final String email;
  final String usertype;
  final String jwttoken;
  const StaffHomePage({super.key, required this.jwttoken, required this.usertype, required this.email});

  @override
  State<StaffHomePage> createState() => _StaffHomePageState();
}

class _StaffHomePageState extends State<StaffHomePage> {
  @override
  void initState() {
    super.initState();
    checkJWTExpiationmember();
  }

  Future<void> checkJWTExpiationmember() async {
    try {
      print("check jwt called in addreview screen.");
      int result = await checkJwtToken_initistate_staff(widget.email, widget.usertype, widget.jwttoken);
      if (result == 0) {
        await clearUserData();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserNotLoginHomeScreen()));
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

  Future<void> logout() async {
    await clearUserData();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserNotLoginHomeScreen()));
    Toastget().Toastmsg("Logged out successfully.");
  }

  @override
  Widget build(BuildContext context) {
    var shortestval = MediaQuery.of(context).size.shortestSide;
    var widthval = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Staff",
          style: TextStyle(fontFamily: bold, fontSize: 24, color: Colors.white, letterSpacing: 1.2),
        ),
        backgroundColor: Colors.teal[700],
        elevation: 4,
        shadowColor: Colors.black45,
        actions: [
          TextButton(
            onPressed: logout,
            style: TextButton.styleFrom(
              backgroundColor: Colors.teal[600]!,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: shortestval * 0.03, vertical: shortestval * 0.01),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              "Logout",
              style: TextStyle(fontFamily: semibold, fontSize: shortestval * 0.04),
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity, // Ensure container fills the full width
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.teal[700]!, Colors.lightGreen[100]!],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: shortestval * 0.04), // Consistent horizontal padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch, // Ensure content stretches to fill width
            children: [
              Text(
                "Welcome, Staff!",
                style: TextStyle(
                  fontFamily: bold,
                  fontSize: shortestval * 0.08,
                  color: Colors.teal[200],
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: shortestval * 0.06),
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Container(
                  padding: EdgeInsets.all(shortestval * 0.06),
                  width: double.infinity, // Ensure card fills the available width
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: shortestval * 0.03),
                      Text(
                        "Claim Codes for orders",
                        style: TextStyle(
                          fontFamily: semibold,
                          fontSize: shortestval * 0.06,
                          color: Colors.teal[700],
                        ),
                      ),
                      SizedBox(height: shortestval * 0.03),
                      SizedBox(
                        width: double.infinity, // Ensure button fills the card width
                        child: Commonbutton(
                          "Claim",
                              () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ClaimCodePage(
                                  jwttoken: widget.jwttoken,
                                  usertype: widget.usertype,
                                  email: widget.email,
                                ),
                              ),
                            );
                          },
                          context,
                          Colors.teal[600]!, // Assert non-null color
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: shortestval * 0.06),
              Text(
                "Manage and claim codes for orders efficiently.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: regular,
                  fontSize: shortestval * 0.04,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}