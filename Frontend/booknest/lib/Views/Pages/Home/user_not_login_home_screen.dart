import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../constant/styles.dart';
import '../Authentication/login_screen.dart';
import '../Authentication/signin_screen.dart';

class UserNotLoginHomeScreen extends StatefulWidget {
  const UserNotLoginHomeScreen({super.key});

  @override
  State<UserNotLoginHomeScreen> createState() => _UserNotLoginHomeScreenState();
}

class _UserNotLoginHomeScreenState extends State<UserNotLoginHomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var shortestval = MediaQuery.of(context).size.shortestSide;
    var widthval = MediaQuery.of(context).size.width;
    var heightval = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.teal[700]!, Colors.lightGreen[100]!],
          ),
        ),
        child: Stack(
          children: [
            // Main content
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: shortestval * 0.05),
                  // Animated header
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Center(
                        child: Text(
                          "Welcome to BookNest",
                          style: TextStyle(
                            fontFamily: bold,
                            fontSize: shortestval * 0.12,
                            color: Colors.teal[200],
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: shortestval * 0.03),
                  // Call to action buttons at top
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: shortestval * 0.04),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          child: ElevatedButton(
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginHomePage())),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal[600],
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              padding: EdgeInsets.symmetric(horizontal: shortestval * 0.06, vertical: shortestval * 0.03),
                            ).copyWith(
                              backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                                    (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed)) return Colors.teal[800];
                                  return null;
                                },
                              ),
                            ),
                            child: Text(
                              "Login",
                              style: TextStyle(
                                fontFamily: semibold,
                                color: Colors.greenAccent,
                                fontSize: shortestval * 0.05,
                              ),
                            ),
                          ),
                          onEnd: () => setState(() {}),
                        ),
                        SizedBox(width: shortestval * 0.04),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          child: ElevatedButton(
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen())),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal[600],
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              padding: EdgeInsets.symmetric(horizontal: shortestval * 0.06, vertical: shortestval * 0.03),
                            ).copyWith(
                              backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                                    (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed)) return Colors.teal[800];
                                  return null;
                                },
                              ),
                            ),
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                fontFamily: semibold,
                                color: Colors.greenAccent,
                                fontSize: shortestval * 0.05,
                              ),
                            ),
                          ),
                          onEnd: () => setState(() {}),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: shortestval * 0.06),
                  // Hero section with glassmorphic card
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: Container(
                          width: widthval * 0.9,
                          padding: EdgeInsets.all(shortestval * 0.06),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.menu_book,
                                size: shortestval * 0.15,
                                color: Colors.teal[700],
                              ),
                              SizedBox(height: shortestval * 0.02),
                              Text(
                                "Discover Your Next Favorite Book!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: semibold,
                                  fontSize: shortestval * 0.05,
                                  color: Colors.lightGreen[400],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: shortestval * 0.06),
                  // Why Choose BookNest section
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        children: [
                          Text(
                            "Why Choose BookNest?",
                            style: TextStyle(
                              fontFamily: bold,
                              fontSize: shortestval * 0.06,
                              color: Colors.teal[700],
                            ),
                          ),
                          SizedBox(height: shortestval * 0.04),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildFeatureIcon(Icons.book, "Wide Selection", shortestval),
                              _buildFeatureIcon(Icons.shopping_cart, "Easy Ordering", shortestval),
                              _buildFeatureIcon(Icons.admin_panel_settings, "Admin Tools", shortestval),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: shortestval * 0.08),
                  // Footer with wave effect
                  Stack(
                    children: [
                      Container(
                        height: shortestval * 0.15,
                        color: Colors.teal[700],
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          width: widthval,
                          height: shortestval * 0.1,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(widthval * 0.2),
                              topRight: Radius.circular(widthval * 0.2),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: shortestval * 0.02,
                        width: widthval,
                        child: Text(
                          "Join BookNest Today and Start Reading!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: regular,
                            fontSize: shortestval * 0.04,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build feature icons
  Widget _buildFeatureIcon(IconData icon, String label, double shortestval) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          child: Icon(
            icon,
            size: shortestval * 0.1,
            color: Colors.teal[700],
          ),
        ),
        SizedBox(height: shortestval * 0.02),
        Text(
          label,
          style: TextStyle(
            fontFamily: regular,
            fontSize: shortestval * 0.04,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}