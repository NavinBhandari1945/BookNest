import 'package:booknest/Views/Pages/Home/book_screen.dart';
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
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: shortestval * 0.02),
              child: ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginHomePage())),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.symmetric(horizontal: shortestval * 0.04, vertical: shortestval * 0.02),
                ),
                child: Text(
                  "Login",
                  style: TextStyle(fontFamily: semibold, color: Colors.white, fontSize: shortestval * 0.04),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: shortestval * 0.04),
              child: ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen())),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.symmetric(horizontal: shortestval * 0.04, vertical: shortestval * 0.02),
                ),
                child: Text(
                  "Sign Up",
                  style: TextStyle(fontFamily: semibold, color: Colors.white, fontSize: shortestval * 0.04),
                ),
              ),
            ),
          ],
        ),
        body: Container(
          child: Column(
            children: [
              Container(child: Text("Book screen"),).onTap((){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                  return BookScreen(jwttoken: widget.jwttoken, usertype:widget.usertype, email: widget.email);
                },));
        }),
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
