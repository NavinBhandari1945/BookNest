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
import '../../common widget/CommonTextfield_obs_val_true.dart';
import '../../common widget/toast.dart';
import 'getx cont/getx_accept_tems_cond_checkbox.dart';

// Main widget class for the signup screen
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

// State class for managing the signup screen
class _SignUpScreenState extends State<SignUpScreen> with SingleTickerProviderStateMixin {
  var first_name_cont = TextEditingController();
  var last_name_cont = TextEditingController();
  var email_cont = TextEditingController();
  var phone_number_cont = TextEditingController();
  var password_cont = TextEditingController();
  var checkbox_a_t_c_cont = Get.put(CheckBox_A_T_C());
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Initialize state and animations
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
    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  // Dispose of resources
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

  // API call to register a new user
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

      if (response.statusCode == 200)
      {
        print("Data insert in userinfo table successs.");
        return 1;
      } else if (response.statusCode == 502) {
        print("Email already exists.");
        return 3;
      } else if (response.statusCode == 503) {
        print("Phone number already exists.");
        return 6;
      } else if (response.statusCode == 501) {
        print("Provided data are not in correct format.");
        return 4;
      } else if (response.statusCode == 500) {
        print("Exception caught in backend.");
        return 5;
      } else {
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

  // Build the main scaffold and layout
  @override
  Widget build(BuildContext context) {
    var shortestval = MediaQuery.of(context).size.shortestSide;
    var widthval = MediaQuery.of(context).size.width;
    var heightval = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Sign Up",
          style: TextStyle(fontFamily: bold, fontSize: 24, color: Colors.white, letterSpacing: 1.2),
        ),
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
        child: _SignUp_UI_Layout(shortestval, widthval, heightval),
      ),
    );
  }

  // Build the signup UI layout with animations
  Widget _SignUp_UI_Layout(double shortestval, double widthval, double heightval) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(shortestval * 0.05),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Container(
                  width: widthval * 0.9,
                  padding: EdgeInsets.all(shortestval * 0.06),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Application name as logo
                      Center(
                        child: Text(
                          "BookNest",
                          style: TextStyle(
                            fontFamily: bold,
                            fontSize: shortestval * 0.08,
                            color: Colors.green[700],
                            shadows: [
                              Shadow(
                                color: Colors.green[900]!.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: shortestval * 0.02),
                      // Header text
                      Text(
                        "Create Your Account",
                        style: TextStyle(
                          fontFamily: bold,
                          fontSize: shortestval * 0.07,
                          color: Colors.green[700],
                        ),
                      ),
                      SizedBox(height: shortestval * 0.04),
                      // First Name input field
                      CommonTextField_obs_false(
                        "Enter your First Name",
                        "",
                        false,
                        first_name_cont,
                        context,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person, color: Colors.green[700]),
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          hintStyle: TextStyle(color: Colors.grey[500], fontFamily: regular),
                        ),
                      ),
                      SizedBox(height: shortestval * 0.04),
                      // Last Name input field
                      CommonTextField_obs_false(
                        "Enter your Last Name",
                        "",
                        false,
                        last_name_cont,
                        context,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person, color: Colors.green[700]),
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          hintStyle: TextStyle(color: Colors.grey[500], fontFamily: regular),
                        ),
                      ),
                      SizedBox(height: shortestval * 0.04),
                      // Email input field
                      CommonTextField_obs_false(
                        "Enter your Email",
                        "",
                        false,
                        email_cont,
                        context,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email, color: Colors.green[700]),
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          hintStyle: TextStyle(color: Colors.grey[500], fontFamily: regular),
                        ),
                      ),
                      SizedBox(height: shortestval * 0.04),
                      // Phone Number input field
                      CommonTextField_obs_false(
                        "Enter your Phone Number",
                        "",
                        false,
                        phone_number_cont,
                        context,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.phone, color: Colors.green[700]),
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          hintStyle: TextStyle(color: Colors.grey[500], fontFamily: regular),
                        ),
                      ),
                      SizedBox(height: shortestval * 0.04),
                      // Password input field
                      CommonTextField_obs_val_true(
                        "Enter your Password",
                        "",
                        password_cont,
                        context,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock, color: Colors.green[700]),
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          hintStyle: TextStyle(color: Colors.grey[500], fontFamily: regular),
                        ),
                      ),
                      SizedBox(height: shortestval * 0.04),
                      // Terms and conditions checkbox
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
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
                              style: TextStyle(
                                fontSize: shortestval * 0.04,
                                fontFamily: semibold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: shortestval * 0.06),
                      // Sign Up button
                      Center(
                        child: Commonbutton(
                          "Sign Up",
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
                              } else if (signinuser == 6) {
                                print("User signin fail.Phone number already exist.");
                                Toastget().Toastmsg("User signin fail.Phone number already used.Try different.");
                                return;
                              } else if (signinuser == 4) {
                                print("User signin fail.Invalid provide details format.");
                                Toastget().Toastmsg("User signin fail.Enter details are not according to format.");
                                return;
                              } else if (signinuser == 5) {
                                print("Exception caught in backend.");
                                Toastget().Toastmsg("User signin fail.Server busy.Try again.");
                                return;
                              } else {
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
                        ),
                      ),
                      SizedBox(height: shortestval * 0.04),
                      // Login link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginHomePage()));
                            },
                            child: Text(
                              "Go to login screen. Click me.",
                              style: TextStyle(
                                fontFamily: semibold,
                                color: Colors.green[700],
                                fontSize: shortestval * 0.04,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}