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

class ChangeUserRole extends StatefulWidget {
  final String email;
  final String usertype;
  final String jwttoken;
  const ChangeUserRole({
    super.key,
    required this.jwttoken,
    required this.usertype,
    required this.email,
  });

  @override
  State<ChangeUserRole> createState() => _ChangeUserRoleState();
}

class _ChangeUserRoleState extends State<ChangeUserRole> {
  final User_Email_Cont = TextEditingController();
  final User_Role_Cont = TextEditingController();
  @override
  void initState() {
    super.initState();
    checkJWTExpiationAdmin();
  }

  Future<void> checkJWTExpiationAdmin() async {
    try {
      //check jwt called in admin home screen.
      print("check jwt called in change user role screen.");
      int result = await checkJwtToken_initistate_admin(
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

  Future<int> Change_User_Role({
    required String User_Email,
    required String User_Role,
  }) async {
    try {
      final Map<String, dynamic> userData = {
        "Email": User_Email,
        "Role": User_Role,
      };
      const String url = Backend_Server_Url + "api/Admin/change_user_role";
      final headers = {
        'Authorization': 'Bearer ${widget.jwttoken}',
        'Content-Type': 'application/json',
      };
      final body_data = jsonEncode(userData);

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body_data,
      );
      if (response.statusCode == 200) {
        Toastget().Toastmsg("Change role success.");
        return 1;
      } else if (response.statusCode == 501) {
        Toastget().Toastmsg("Invalid email.");
        print("Invalid email.");
        return 3;
      } else {
        Toastget().Toastmsg("Other status code.Error.");
        print("Other status code.Error.");
        print("Status code = ${response.statusCode}");
        return 2;
      }
    } catch (Obj) {
      Toastget().Toastmsg(
        "Exception caught in login user method in http method.",
      );
      print("Exception caught in login user method in http method.");
      print(Obj.toString());
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Change user role.",
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
            CommonTextField_obs_false(
              "Enter user email.",
              "",
              false,
              User_Email_Cont,
              context,
            ),
            CommonTextField_obs_false(
              "Enter user role.",
              "",
              false,
              User_Role_Cont,
              context,
            ),
            Commonbutton(
              "Change",
              () async {
                try {
                  if (User_Email_Cont.text.isEmptyOrNull ||
                      User_Role_Cont.text.isEmptyOrNull ||
                      User_Role_Cont.text.toString() != "Staff") {
                    print("Incorrect data validation.");
                    Toastget().Toastmsg("Incorrect data validation.");
                    return;
                  } else {
                    final Result = await Change_User_Role(
                      User_Email: User_Email_Cont.text.toString(),
                      User_Role: User_Role_Cont.text.toString(),
                    );
                    print(Result);
                    return;
                  }
                } catch (Obj) {
                  print(Obj.toString());
                  Toastget().Toastmsg("Incorrect data validation.");
                  return;
                }
              },
              context,
              Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
