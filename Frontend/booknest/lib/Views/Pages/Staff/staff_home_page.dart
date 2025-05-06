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
  const StaffHomePage({super.key,required this.jwttoken,required this.usertype,required this.email});
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
      int result = await checkJwtToken_initistate_staff(
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
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => UserNotLoginHomeScreen()));
      Toastget().Toastmsg("Error. Relogin please.");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "Staff",
            style: TextStyle(fontFamily: bold, fontSize: 24, color: Colors.white, letterSpacing: 1.2),
          ),
          backgroundColor: Colors.green[700],
          elevation: 4,
          shadowColor: Colors.black45,
        ),
        body:Container(
          child: Column(
            children:
            [


              Commonbutton("Claim orders", ()async{

          Navigator.push(context, MaterialPageRoute(builder: (context) {

            return ClaimCodePage(jwttoken: widget.jwttoken, usertype:widget.usertype, email: widget.email);

          },
          )
          );
              }, context, Colors.red),

            ],
          ),
        )
    );
  }
}
