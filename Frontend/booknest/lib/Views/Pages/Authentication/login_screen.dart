import 'dart:convert';
import 'package:booknest/Views/Pages/Admin/admin_screen.dart';
import 'package:booknest/Views/Pages/Home/member_login_page.dart';
import 'package:booknest/Views/Pages/Staff/staff_home_page.dart';
import 'package:booknest/Views/common%20widget/commonbutton.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../constant/constant.dart';
import '../../../constant/styles.dart';
import '../../common widget/CommonTextfield_obs_val_true.dart';
import '../../common widget/common_method.dart';
import '../../common widget/commontextfield_obs_false.dart';
import 'package:http/http.dart' as http;
import '../../common widget/toast.dart';

class LoginHomePage extends StatefulWidget {
  const LoginHomePage({super.key});

  @override
  State<LoginHomePage> createState() => _LoginHomePageState();
}

class _LoginHomePageState extends State<LoginHomePage> with SingleTickerProviderStateMixin {
  var email_cont = TextEditingController();
  var passwoord_cont = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
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

  @override
  void dispose() {
    _animationController.dispose();
    email_cont.dispose();
    passwoord_cont.dispose();
    super.dispose();
  }

  Future<int> login_user({required String email, required String password}) async {
    try {
      final Map<String, dynamic> userData = {"Email": email, "Password": password};
      const String url = Backend_Server_Url + "api/Auth/login";
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(userData),
      );
      if (response.statusCode == 200) {
        Map<dynamic, dynamic> responseData = jsonDecode(response.body);
        await handleResponse(responseData);
        return 1;
      } else if (response.statusCode == 503) {
        print("Invalid password.");
        return 3;
      } else if (response.statusCode == 501) {
        print("Email don't found.");
        return 4;
      } else if (response.statusCode == 502) {
        print("Incorrect format of provided details.");
        return 5;
      } else if (response.statusCode == 400) {
        print("Incorrect provided details.");
        return 6;
      } else {
        print("Other status code.Error.");
        print("Status code = ${response.statusCode}");
        return 2;
      }
    } catch (Obj) {
      print("Exception caight in login user method in http method.");
      print(Obj.toString());
      return 0;
    }
  }

  Future<int> _login() async {
    try {
      if (email_cont.text.isEmptyOrNull || passwoord_cont.text.isEmptyOrNull) {
        Toastget().Toastmsg("All fields are mandatory. Fill first and try again.");
        return 0;
      }
      int login_rsult = await login_user(email: email_cont.text.toString(), password: passwoord_cont.text.toString());
      print("Login result from http method");
      print(login_rsult);
      if (login_rsult == 1) {
        final box = await Hive.openBox('userData');
        String? jwtToken = await box.get('jwt_token');
        Map<dynamic, dynamic> userData = await getUserCredentials();
        if (jwtToken.isEmptyOrNull && userData == null) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginHomePage()));
          Toastget().Toastmsg("Login Failed. Try again.");
          return 0;
        } else {
          if (userData["usertype"] == "Admin") {
            Toastget().Toastmsg("Login success");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AdminHomePage(jwttoken: jwtToken!, usertype: userData['usertype'], email: userData["email"]),
              ),
            );
            return 1;
          } else if (userData["usertype"] == "Staff") {
            Toastget().Toastmsg("Login success");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => StaffHomePage(jwttoken: jwtToken!, usertype: userData['usertype'], email: userData["email"]),
              ),
            );
            return 1;
          } else if (userData["usertype"] == "Member") {
            Toastget().Toastmsg("Login success");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MemberHomePage(jwttoken: jwtToken!, usertype: userData['usertype'], email: userData["email"]),
              ),
            );
            return 1;
          } else {
            Toastget().Toastmsg("Login fail.Server error.Try again.");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginHomePage(),
              ),
            );
            return 0;
          }
        }
      } else if (login_rsult == 5) {
        Toastget().Toastmsg("Enter details in wrong format.");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginHomePage(),
          ),
        );
        return 0;
      } else if (login_rsult == 4) {
        Toastget().Toastmsg("Email not found. Enter register email.");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginHomePage(),
          ),
        );
        return 0;
      } else if (login_rsult == 3) {
        Toastget().Toastmsg("Invalid password.Login failed.");
        return 0;
      } else if (login_rsult == 6) {
        Toastget().Toastmsg("Invalid entered details. Login failed.");
        return 0;
      } else {
        Toastget().Toastmsg("Login failed. Try again.");
        return 0;
      }
    } catch (obj) {
      print("${obj.toString()}");
      Toastget().Toastmsg("Server error. Try again.");
      return 0;
    }
  }

  Widget _Login_UI_Layout(double shortestval, double widthval, double heightval) {
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
                      Text(
                        "Welcome Back!",
                        style: TextStyle(
                          fontFamily: bold,
                          fontSize: shortestval * 0.07,
                          color: Colors.green[700],
                        ),
                      ),
                      SizedBox(height: shortestval * 0.04),
                      CommonTextField_obs_false(
                        "Enter your email",
                        "",
                        false,
                        email_cont,
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
                      CommonTextField_obs_val_true(
                        "Enter your Password",
                        "",
                        passwoord_cont,
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
                      SizedBox(height: shortestval * 0.06),
                      Center(
                        child: Commonbutton("Login", () async {
                          int Login_Result = await _login();
                          print("Login result from widget = ${Login_Result}");
                        }, context, Colors.red),
                      ),
                      SizedBox(height: shortestval * 0.04),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Container()),
                            ),
                            child: Text(
                              "Forgot Password?",
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

  @override
  Widget build(BuildContext context) {
    var shortestval = MediaQuery.of(context).size.shortestSide;
    var widthval = MediaQuery.of(context).size.width;
    var heightval = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Login",
          style: TextStyle(fontFamily: bold, fontSize: 24, color: Colors.white, letterSpacing: 1.2),
        ),
        backgroundColor: Colors.green[700],
        elevation: 4,
        shadowColor: Colors.black45,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[50]!, Colors.white],
          ),
        ),
        child: _Login_UI_Layout(shortestval, widthval, heightval),
      ),
    );
  }
}