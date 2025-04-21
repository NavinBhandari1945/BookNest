import 'package:booknest/Views/common%20widget/commonbutton.dart';
import 'package:flutter/material.dart';
import '../../../constant/styles.dart';
import '../../common widget/CommonTextfield_obs_val_true.dart';
import '../../common widget/commontextfield_obs_false.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
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

    // try {
    //   Check_Jwt_Token_Landing_Screen(context: context);
    // } catch (obj) {
    //   print("Exception caught while checking for landing screen");
    //   print(obj.toString());
    //   clearUserData();
    //   deleteTempDirectoryPostVideo();
    //   deleteTempDirectoryCampaignVideo();
    //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    // }
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    email_cont.dispose();
    passwoord_cont.dispose();
    super.dispose();
  }

  // Future<int> login_user({required String username, required String password}) async {
  //   try {
  //     final Map<String, dynamic> userData = {"Username": username, "Password": password};
  //     const String url = Backend_Server_Url + "api/Authentication/login";
  //     final response = await http.post(
  //       Uri.parse(url),
  //       headers: {"Content-Type": "application/json"},
  //       body: json.encode(userData),
  //     );
  //     if (response.statusCode == 200) {
  //       Map<String, dynamic> responseData = jsonDecode(response.body);
  //       await handleResponse(responseData);
  //       return 1;
  //     } else if (response.statusCode == 503) {
  //       print("Invalid password.");
  //       return 3;
  //     } else if (response.statusCode == 501) {
  //       print("Username don't found.");
  //       return 4;
  //     } else if (response.statusCode == 502) {
  //       print("Incorrect format of provided details.");
  //       return 5;
  //     } else if (response.statusCode == 400) {
  //       print("Incorrect provided details.");
  //       return 6;
  //     } else {
  //       print("Other status code.Error.");
  //       print("Status code = ${response.statusCode}");
  //       return 2;
  //     }
  //   } catch (Obj) {
  //     print("Exception caight in login user method in http method.");
  //     print(Obj.toString());
  //     return 0;
  //   }
  // }

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
      body: Container (
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[50]!, Colors.white],
          ),
        ),
        child:
        _Login_UI_Layout(shortestval, widthval, heightval),
      ),
    );
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
                        child: Commonbutton("Login", (){}, context, Colors.red),
                      ),
                      SizedBox(height: shortestval * 0.04),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>Container()),
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



  // void _login() async {
  //   try {
  //     isloading_getx_cont.change_isloadingval(true);
  //     if (username_cont.text.isEmptyOrNull || passwoord_cont.text.isEmptyOrNull) {
  //       Toastget().Toastmsg("All fields are mandatory. Fill first and try again.");
  //       isloading_getx_cont.change_isloadingval(false);
  //       return;
  //     }
  //     int login_rsult = await login_user(username: username_cont.text, password: passwoord_cont.text);
  //     print("Login result");
  //     print(login_rsult);
  //     if (login_rsult == 1) {
  //       final box = await Hive.openBox('userData');
  //       String? jwtToken = await box.get('jwt_token');
  //       Map<dynamic, dynamic> userData = await getUserCredentials();
  //       if (jwtToken == null && userData == null) {
  //         isloading_getx_cont.change_isloadingval(false);
  //         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthenticationHome()));
  //         Toastget().Toastmsg("Login Failed. Try again.");
  //       } else {
  //         if (userData["usertype"] == "user") {
  //           Toastget().Toastmsg("Login success");
  //           Navigator.pushReplacement(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => Index_Home_Screen(
  //                 username: userData["username"]!,
  //                 usertype: userData["usertype"]!,
  //                 jwttoken: jwtToken!,
  //               ),
  //             ),
  //           );
  //         } else if (userData["usertype"] == "admin") {
  //           Toastget().Toastmsg("Login success");
  //           Navigator.pushReplacement(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => AdminHome(
  //                 jwttoken: jwtToken!,
  //                 usertype: userData["usertype"]!,
  //                 username: userData["username"]!,
  //               ),
  //             ),
  //           );
  //         }
  //       }
  //     } else if (login_rsult == 5) {
  //       Toastget().Toastmsg("Enter details in correct format.");
  //     } else if (login_rsult == 4) {
  //       Toastget().Toastmsg("Username not found. Enter valid username.");
  //     } else if (login_rsult == 3) {
  //       Toastget().Toastmsg("Invalid password. Login failed.");
  //     } else if (login_rsult == 6) {
  //       Toastget().Toastmsg("Invalid entered details. Login failed.");
  //     } else {
  //       Toastget().Toastmsg("Login failed. Try again.");
  //     }
  //   } catch (obj) {
  //     print("${obj.toString()}");
  //     Toastget().Toastmsg("Server error. Try again.");
  //   } finally {
  //     isloading_getx_cont.change_isloadingval(false);
  //   }
  // }



}










