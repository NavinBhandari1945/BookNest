import 'package:booknest/Views/Pages/Admin/add_book.dart';
import 'package:booknest/Views/common%20widget/commonbutton.dart';
import 'package:flutter/material.dart';

import '../../../constant/styles.dart';
import '../../common widget/common_method.dart';
import '../../common widget/toast.dart';
import '../Home/user_not_login_home_screen.dart';
import 'change_user_role.dart';

class AdminHomePage extends StatefulWidget {
  final String email;
  final String usertype;
  final String jwttoken;
  const AdminHomePage({super.key,required this.jwttoken,required this.usertype,required this.email});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {

  @override
  void initState() {
    super.initState();
    checkJWTExpiationAdmin();
  }

  Future<void> checkJWTExpiationAdmin() async {
    try {
      //check jwt called in admin home screen.
      print("check jwt called in admin home screen.");
      int result = await checkJwtToken_initistate_admin(
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
            "Admin",
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

              Commonbutton("Change user role", ()
              {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ChangeUserRole(jwttoken: widget.jwttoken, usertype: widget.usertype, email:widget.email,);

                },));

              }, context, Colors.red),

              Commonbutton("Add book", ()
              {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return AddBook(jwttoken: widget.jwttoken, usertype: widget.usertype, email:widget.email,);

                },));

              }, context, Colors.red),

              Commonbutton("Logout", ()async
              {
                final Clear_User_Data=await clearUserData();
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return UserNotLoginHomeScreen();

                },));

              }, context, Colors.red),

            ],
          ),
        )
    );
  }
}
