import 'package:booknest/Views/Pages/Home/book_screen.dart';
import 'package:booknest/Views/Pages/Home/cart_screen.dart';
import 'package:booknest/Views/Pages/Home/send_email.dart';
import 'package:booknest/Views/Pages/Home/user_not_login_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../constant/styles.dart';
import '../../common widget/common_method.dart';
import '../../common widget/commonbutton.dart';
import '../../common widget/toast.dart';
import '../Authentication/login_screen.dart';
import '../Authentication/signin_screen.dart';

class MemberHomePage extends StatefulWidget {
  final String email;
  final String usertype;
  final String jwttoken;
  const MemberHomePage({super.key,required this.jwttoken,required this.usertype,required this.email});


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
      //check jwt called in admin home screen.
      print("check jwt called in member home screen.");
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
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => UserNotLoginHomeScreen()));
      Toastget().Toastmsg("Error. Relogin please.");
    }
  }
  @override
  Widget build(BuildContext context) {
    var shortestval = MediaQuery.of(context).size.shortestSide;
    var widthval = MediaQuery.of(context).size.width;
    var heightval = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "User Home Screen",
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
        ),
        body: Container(
          child: Column(
            children: [

              // Container(child: Text("email screen"),).onTap((){
              //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
              //     return SendEmail();
              //   },));
              // }),

              Container(child: Text("Book screen"),).onTap((){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                  return BookScreen(jwttoken: widget.jwttoken, usertype:widget.usertype, email: widget.email);
                },));
        }),
              Container(child: Text("Cart screen"),).onTap((){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                  return CartScreen(jwttoken: widget.jwttoken, usertype:widget.usertype, email: widget.email);
                },));
              }),
              10.heightBox,
              Commonbutton("Logout", ()async
              {
                final Clear_User_Data=await clearUserData();
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return UserNotLoginHomeScreen();

                },));

              }, context, Colors.red),
            ],
          )
        )
    );
  }

}
