import 'dart:convert';
import 'package:booknest/Views/Pages/Authentication/login_screen.dart';
import 'package:booknest/Views/common%20widget/commonbutton.dart';
import 'package:booknest/Views/common%20widget/commontextfield_obs_false.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../constant/constant.dart';
import '../../../constant/styles.dart';
import 'package:http/http.dart' as http;

import '../../common widget/toast.dart';
import 'getx cont/getx_accept_tems_cond_checkbox.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with SingleTickerProviderStateMixin {
  var first_name_cont = TextEditingController();
  var last_name_cont = TextEditingController();
  var email_cont = TextEditingController();
  var phone_number_cont = TextEditingController();
  var password_cont = TextEditingController();
  var checkbox_a_t_c_cont = Get.put(CheckBox_A_T_C());
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    checkbox_a_t_c_cont.ValueChange(false);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    first_name_cont.dispose();
    last_name_cont.dispose();
    email_cont.dispose();
    phone_number_cont.dispose();
    password_cont.dispose();
    super.dispose();
  }

  Future<int> SignInUser({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String password,
    required String usertype,
  }) async {

    try {
      final Map<String, dynamic> userData = {
        "FirstName": firstName,
        "LastName": lastName,
        "Email": email,
        "PhoneNumber": phoneNumber,
        "Password": password,
        "Role": usertype,
      };
      const String url = Backend_Server_Url + "api/Auth/register";
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(userData),
      );

      if (response.statusCode == 200) {
        print("Data insert in userinfo table successs.");
        return 1;
      } else if (response.statusCode == 502) {
        print("Email already exists.");
        return 3;
      }
      else if (response.statusCode == 503) {
        print("Phone number already exists.");
        return 6;
      }else if (response.statusCode == 501) {
        print("Provided data are not in correct format.");
        return 4;
      } else if (response.statusCode == 500) {
        print("Exception caught in backend.");
        return 5;
      }
      else
      {
        print(response.statusCode.toString());
        print("Data insert in userinfo table fail.Other status code.");
        return 2;
      }
    } catch (Obj) {
      print("Exception caught in sign in user http method.");
      print(Obj.toString());
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    var shortestval = MediaQuery.of(context).size.shortestSide;
    var widthval = MediaQuery.of(context).size.width;
    var heightval = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up", style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green[700],
        elevation: 4,
        shadowColor: Colors.black45,
        automaticallyImplyLeading: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[50]!, Colors.white],
          ),
        ),
        child: OrientationBuilder(
          builder: (context, orientation) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child:  _buildPortraitLayout(shortestval, widthval, heightval)
            );
          },
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(double shortestval, double widthval, double heightval) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.all(shortestval * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: shortestval * 0.03),
            _buildTextField("Enter your First Name", first_name_cont, shortestval, widthval),
            SizedBox(height: shortestval * 0.02),
            _buildTextField("Enter your Last Name", last_name_cont, shortestval, widthval),
            SizedBox(height: shortestval * 0.02),
            _buildTextField("Enter your Email", email_cont, shortestval, widthval),
            SizedBox(height: shortestval * 0.02),
            _buildTextField("Enter your Phone Number", phone_number_cont, shortestval, widthval),
            SizedBox(height: shortestval * 0.02),
            _buildTextField("Enter yourPassword", password_cont, shortestval, widthval),
            SizedBox(height: shortestval * 0.03),
            _buildCheckboxRow(shortestval),
            SizedBox(height: shortestval * 0.03),
            _buildSignInButton(shortestval, widthval),
            SizedBox(height: shortestval * 0.02),
            _buildLoginLink(shortestval),
          ],
        ),
      ),
    );
  }



  Widget _buildTextField(String hint, TextEditingController controller, double shortestval, double width) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: width,
      padding: EdgeInsets.all(shortestval * 0.02),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: CommonTextField_obs_false(hint, hint == "Enter Password" ? "xxxxx" : "", false, controller, context),
    );
  }



  Widget _buildCheckboxRow(double shortestval) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Obx(
              () => Checkbox(
            value: checkbox_a_t_c_cont.termns_cond.value,
            onChanged: (value) {
              checkbox_a_t_c_cont.ValueChange(value);
            },
          ),
        ),
        Flexible(
          child: Text(
            "I accept all terms and conditions.",
            style: TextStyle(fontSize: shortestval * 0.04, fontFamily: semibold, color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _buildSignInButton(double shortestval, double width) {
    return Commonbutton(
        "Sign In",
            () async {
          try {
            if (first_name_cont.text.isEmptyOrNull ||
                last_name_cont.text.isEmptyOrNull ||
                email_cont.text.isEmptyOrNull ||
                phone_number_cont.text.isEmptyOrNull ||
                password_cont.text.isEmptyOrNull) {
              Toastget().Toastmsg("All the field are mandatory.Try again.");
              return;
            }
            if (!RegExp(r"^\+?[0-9]+$").hasMatch(phone_number_cont.text)) {
              Toastget().Toastmsg("Invalid number format.");
              return;
            }

            if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(email_cont.text)) {
              Toastget().Toastmsg("Invalid email format.");
              return;
            }

            if (!RegExp(r"^[a-zA-Z]+$").hasMatch(first_name_cont.text) ||
                !RegExp(r"^[a-zA-Z]+$").hasMatch(last_name_cont.text)) {
              Toastget().Toastmsg("Only valid Aa-Zz letter for first and last name.");
              return;
            }

            if (checkbox_a_t_c_cont.termns_cond.value == false) {
              Toastget().Toastmsg("Accept terms and condition first and try again.");
              return;
            }

              int signinuser = await SignInUser(
                firstName: first_name_cont.text.toString(),
                lastName: last_name_cont.text.toString(),
                email: email_cont.text.toString(),
                phoneNumber: phone_number_cont.text.toString(),
                password: password_cont.text.toString(),
                usertype: 'Member',
              );
              if (signinuser == 1) {
                print("User register success");
                Toastget().Toastmsg("User register success");
                return;
              } else if (signinuser == 3) {
                print("User signin fail.Email already exist.");
                Toastget().Toastmsg("User signin fail.Email already used.Try different.");
                return;
              }
              else if (signinuser == 6) {
                print("User signin fail.Phone number already exist.");
                Toastget().Toastmsg("User signin fail.Phone number already used.Try different.");
                return;
              } else if (signinuser == 4) {
                print("User signin fail.Invalid provide details format.");
                Toastget().Toastmsg("User signin fail.Enter details are not according to format.");
                return;
              }
              else if (signinuser == 5) {
                print("Exception caught in backend.");
                Toastget().Toastmsg("User signin fail.Server busy.Try again.");
                return;
              }else {
                print("User signin fail");
                Toastget().Toastmsg("User signin fail.Try again.");
                return;
              }
          } catch (obj) {
            print("Exception caught while using post request for sign in.");
            print("Exception = ${obj.toString()}");
            Toastget().Toastmsg("Sign in fail.Refill form and try again.");
            return;
          }
        },
        context,
        Colors.red,
      );
  }

  Widget _buildLoginLink(double shortestval)
  {
    return TextButton(
      onPressed: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginHomePage()));
      },
      child: Text(
        "Go to login screen. Click me.",
        style: TextStyle(fontSize: shortestval * 0.04, fontFamily: bold, color: Colors.black),
      ),
    );
  }


  
}






