import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';
import '../../../constant/constant.dart';
import '../../../constant/styles.dart';
import '../../common widget/common_method.dart';
import '../../common widget/toast.dart';
import '../Home/user_not_login_home_screen.dart';

// ChangeUserRole widget to allow admins to change user roles
class ChangeUserRole extends StatefulWidget {
  final String email; // User's email for authentication
  final String usertype; // User type (e.g., admin)
  final String jwttoken; // JWT token for API authentication
  const ChangeUserRole(
      {super.key,
        required this.jwttoken,
        required this.usertype,
        required this.email});

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

  // Function to validate JWT token and handle session expiration
  Future<void> checkJWTExpiationAdmin() async {
    try {
      print("check jwt called in change user role screen.");
      int result = await checkJwtToken_initistate_admin(
          widget.email, widget.usertype, widget.jwttoken);
      if (result == 0) {
        await clearUserData();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => UserNotLoginHomeScreen()));
        Toastget().Toastmsg("Session End. Relogin please.");
      }
    } catch (obj) {
      print("Exception caught while verifying jwt for admin home screen.");
      print(obj.toString());
      await clearUserData();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => UserNotLoginHomeScreen()));
      Toastget().Toastmsg("Error. Relogin please.");
    }
  }

  // Function to change user role via API
  Future<int> Change_User_Role(
      {required String User_Email, required String User_Role}) async {
    try {
      final Map<String, dynamic> userData = {
        "Email": User_Email,
        "Role": User_Role
      };
      const String url = Backend_Server_Url + "api/Admin/change_user_role";
      final headers = {
        'Authorization': 'Bearer ${widget.jwttoken}',
        'Content-Type': 'application/json',
      };
      final body_data = jsonEncode(userData);

      final response =
      await http.put(Uri.parse(url), headers: headers, body: body_data);
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
          "Exception caught in login user method in http method.");
      print("Exception caught in login user method in http method.");
      print(Obj.toString());
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          "Change User Role",
          style: TextStyle(
            fontFamily: bold,
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 1.5,
          ),
        ),
        backgroundColor: const Color(0xFF1A3C34),
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
              Color(0xFFF5F6F5),
              Color(0xFFE8ECEF),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header for changing user role
                  _buildSectionHeader("Change User Role"),
                  const SizedBox(height: 12),
                  // Text field for User Email
                  _buildTextField(
                    controller: User_Email_Cont,
                    hint: "Enter user email",
                    icon: Icons.email,
                  ),
                  const SizedBox(height: 16),
                  // Text field for User Role
                  _buildTextField(
                    controller: User_Role_Cont,
                    hint: "Enter user role (Staff,Member,Admin)",
                    icon: Icons.admin_panel_settings,
                  ),
                  const SizedBox(height: 24),
                  // Change Role button
                  _buildButton(
                    title: "Change Role",
                    icon: Icons.swap_horiz,
                    onPressed: () async {
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
                              User_Role: User_Role_Cont.text.toString());
                          print(Result);
                          return;
                        }
                      } catch (Obj) {
                        print(Obj.toString());
                        Toastget().Toastmsg("Incorrect data validation.");
                        return;
                      }
                    },
                    color: const Color(0xFF2E7D32),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget for section headers
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, top: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: bold,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1A3C34),
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  // Widget for styled text fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(
          fontFamily: regular,
          fontSize: 16,
          color: Color(0xFF1A3C34),
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.grey[600],
            fontFamily: regular,
          ),
          prefixIcon: Icon(icon, color: const Color(0xFF2E7D32)),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding:
          const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
      ),
    );
  }

  // Widget for styled buttons
  Widget _buildButton({
    required String title,
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
          decoration: BoxDecoration(
            color: color,
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
              Icon(Icons.arrow_forward_ios,
                  color: Colors.white.withOpacity(0.7), size: 20),
            ],
          ),
        ),
      ),
    );
  }
}





