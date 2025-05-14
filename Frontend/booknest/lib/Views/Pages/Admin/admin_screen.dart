import 'package:booknest/Views/Pages/Admin/add_book.dart';
import 'package:booknest/Views/Pages/Admin/update_book.dart';
import 'package:booknest/Views/Pages/Admin/update_discount.dart';
import 'package:booknest/Views/common%20widget/commonbutton.dart';
import 'package:flutter/material.dart';

import '../../../constant/styles.dart';
import '../../common widget/common_method.dart';
import '../../common widget/toast.dart';
import '../Home/user_not_login_home_screen.dart';
import 'add_anouncement.dart';
import 'admin_book_details.dart';
import 'change_user_role.dart';

class AdminHomePage extends StatefulWidget {
  final String email;
  final String usertype;
  final String jwttoken;
  const AdminHomePage({super.key, required this.jwttoken, required this.usertype, required this.email});

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
      print("check jwt called in admin home screen.");
      int result = await checkJwtToken_initistate_admin(
          widget.email, widget.usertype, widget.jwttoken);
      if (result == 0) {
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
        title: const Text(
          "Admin Dashboard",
          style: TextStyle(
            fontFamily: bold,
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 1.5,
          ),
        ),
        backgroundColor: const Color(0xFF1A3C34), // Deep forest green
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.3),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF5F6F5), // Light gray-green
              Color(0xFFE8ECEF), // Soft white-blue
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSectionHeader("User Management"),
                  _buildButton(
                    context,
                    title: "Change User Role",
                    icon: Icons.person,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return ChangeUserRole(
                          jwttoken: widget.jwttoken,
                          usertype: widget.usertype,
                          email: widget.email,
                        );
                      }));
                    },
                    color: const Color(0xFF2E7D32), // Vibrant green
                  ),
                  const SizedBox(height: 16),
                  _buildSectionHeader("Book Management"),
                  _buildButton(
                    context,
                    title: "Add Book",
                    icon: Icons.book,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return AddBook(
                          jwttoken: widget.jwttoken,
                          usertype: widget.usertype,
                          email: widget.email,
                        );
                      }));
                    },
                    color: const Color(0xFF388E3C), // Forest green
                  ),
                  const SizedBox(height: 12),
                  _buildButton(
                    context,
                    title: "View Available Books",
                    icon: Icons.library_books,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return AdminBookDetails(
                          jwttoken: widget.jwttoken,
                          usertype: widget.usertype,
                          email: widget.email,
                        );
                      }));
                    },
                    color: const Color(0xFF4CAF50), // Bright green
                  ),
                  const SizedBox(height: 12),
                  _buildButton(
                    context,
                    title: "Update Book Details",
                    icon: Icons.edit,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return UpdateBook(
                          jwttoken: widget.jwttoken,
                          usertype: widget.usertype,
                          email: widget.email,
                        );
                      }));
                    },
                    color: const Color(0xFF66BB6A), // Light green
                  ),
                  const SizedBox(height: 12),
                  _buildButton(
                    context,
                    title: "Update Book Discount",
                    icon: Icons.discount,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return UpdateDiscount(
                          jwttoken: widget.jwttoken,
                          usertype: widget.usertype,
                          email: widget.email,
                        );
                      }));
                    },
                    color: const Color(0xFF81C784), // Soft green
                  ),
                  const SizedBox(height: 16),
                  _buildSectionHeader("Announcements"),
                  _buildButton(
                    context,
                    title: "Add Announcement",
                    icon: Icons.announcement,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return AddAnnouncementPage(
                          jwttoken: widget.jwttoken,
                          usertype: widget.usertype,
                          email: widget.email,
                        );
                      }));
                    },
                    color: const Color(0xFF0288D1), // Vibrant blue
                  ),
                  const SizedBox(height: 16),
                  _buildSectionHeader("Session"),
                  _buildButton(
                    context,
                    title: "Logout",
                    icon: Icons.logout,
                    onPressed: () async {
                      await clearUserData();
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return UserNotLoginHomeScreen();
                      }));
                    },
                    color: const Color(0xFFD32F2F), // Deep red
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, top: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: bold,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1A3C34), // Deep forest green
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, {required String title, required IconData icon, required VoidCallback onPressed, Color? color}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
          decoration: BoxDecoration(
            color: color ?? const Color(0xFF2E7D32), // Default vibrant green
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 28),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: regular,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.white.withOpacity(0.7), size: 20),
            ],
          ),
        ),
      ),
    );
  }
}






