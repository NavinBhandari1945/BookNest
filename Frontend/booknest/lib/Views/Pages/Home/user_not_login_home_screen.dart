import 'package:flutter/material.dart';
import '../../../constant/styles.dart';
import '../Authentication/login_screen.dart';
import '../Authentication/signin_screen.dart';

class UserNotLoginHomeScreen extends StatefulWidget {
  const UserNotLoginHomeScreen({super.key});

  @override
  State<UserNotLoginHomeScreen> createState() => _UserNotLoginHomeScreenState();
}

class _UserNotLoginHomeScreenState extends State<UserNotLoginHomeScreen> {
  @override
  Widget build(BuildContext context) {
    var shortestval = MediaQuery.of(context).size.shortestSide;
    var widthval = MediaQuery.of(context).size.width;
    var heightval = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "User not login Home Screen",
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
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: shortestval * 0.02),
            child: ElevatedButton(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginHomePage()),
                  ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: shortestval * 0.04,
                  vertical: shortestval * 0.02,
                ),
              ),
              child: Text(
                "Login",
                style: TextStyle(
                  fontFamily: semibold,
                  color: Colors.white,
                  fontSize: shortestval * 0.04,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: shortestval * 0.04),
            child: ElevatedButton(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()),
                  ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: shortestval * 0.04,
                  vertical: shortestval * 0.02,
                ),
              ),
              child: Text(
                "Sign Up",
                style: TextStyle(
                  fontFamily: semibold,
                  color: Colors.white,
                  fontSize: shortestval * 0.04,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(child: Center(child: Text("First login and try again."))),
    );
  }
}
