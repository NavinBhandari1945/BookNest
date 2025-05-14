import 'dart:convert';

import 'package:booknest/Views/Pages/Home/user_not_login_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';

import '../../../constant/constant.dart';
import '../../../constant/styles.dart'; // Ensure styles.dart is correctly imported
import '../../common widget/common_method.dart';
import '../../common widget/toast.dart';

// A StatefulWidget that allows the user to change their email address.
class ChangeEmailScreen extends StatefulWidget {
  final String email;
  final String usertype;
  final String jwttoken;
  const ChangeEmailScreen({
    super.key,
    required this.jwttoken,
    required this.usertype,
    required this.email,
  });

  @override
  State<ChangeEmailScreen> createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
  @override
  void initState() {
    super.initState();
    // Check JWT token validity when the page initializes.
    checkJWTExpiationmember();
  }

  // Validates the JWT token and logs out the user if the session has expired.
  Future<void> checkJWTExpiationmember() async {
    try {
      print("check jwt called in book screen.");
      int result = await checkJwtToken_initistate_member(
          widget.email, widget.usertype, widget.jwttoken);
      if (result == 0) {
        // Clear user data and redirect to login screen if token is invalid.
        await clearUserData();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => UserNotLoginHomeScreen()));
        Toastget().Toastmsg("Session End. Relogin please.");
      }
    } catch (obj) {
      print("Exception caught while verifying jwt for admin home screen.");
      print(obj.toString());
      // Handle errors by clearing user data and redirecting to login screen.
      await clearUserData();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => UserNotLoginHomeScreen()));
      Toastget().Toastmsg("Error. Relogin please.");
    }
  }

  // Controllers for form fields.
  final _newEmailController = TextEditingController();
  final _confirmEmailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Updates the user's email on the server.
  Future<int> updateEmail() async {
    try {
      if (_newEmailController.text != _confirmEmailController.text) {
        Toastget().Toastmsg("Emails do not match");
        return 0;
      }

      final Map<String, dynamic> requestData = {
        "oldEmail": widget.email,
        "newEmail": _newEmailController.text,
        "password": _passwordController.text,
      };

      final url = Uri.parse(Backend_Server_Url + 'api/Member/update_email');
      final headers = {
        'Authorization': 'Bearer ${widget.jwttoken}',
        'Content-Type': 'application/json',
      };

      final response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        Toastget().Toastmsg("Email updated successfully");
        Navigator.pop(context, true); // Return success
        return 1;
      } else if (response.statusCode == 401) {
        Toastget().Toastmsg("Invalid password");
      } else if (response.statusCode == 404) {
        Toastget().Toastmsg("User not found");
      } else {
        Toastget().Toastmsg("Error updating email");
      }
      return 0;
    } catch (e) {
      Toastget().Toastmsg("Connection error");
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive design.
    var shortestval = MediaQuery.of(context).size.shortestSide;
    var widthval = MediaQuery.of(context).size.width;
    var heightval = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Change Email",
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ).text.xl2.white.make(),
        backgroundColor: Colors.green[700],
        elevation: 4,
        shadowColor: Colors.black45,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: widthval,
        height: heightval,
        // Apply a gradient background for a modern look.
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[700]!, Colors.green[100]!],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(shortestval * 0.04),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: Colors.white.withOpacity(0.9),
            child: Padding(
              padding: EdgeInsets.all(shortestval * 0.04),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Form title.
                    Text(
                      "Update Your Email",
                      style: TextStyle(
                        fontFamily: bold, // Use bold from styles.dart
                        fontSize: shortestval * 0.06,
                        color: Colors.green[900],
                      ),
                    ),
                    SizedBox(height: shortestval * 0.03),
                    // New email input field.
                    TextFormField(
                      controller: _newEmailController,
                      decoration: InputDecoration(
                        labelText: 'New Email',
                        hintText: 'Enter new email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: Icon(Icons.email, color: Colors.green[600]),
                        filled: true,
                        fillColor: Colors.green[50],
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          Toastget().Toastmsg("Enter new email.Try again.");
                          return 'Please enter new email';
                        } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          Toastget().Toastmsg("Enter new email format incorrect.Try again.");
                          return 'Enter valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: shortestval * 0.03),
                    // Confirm email input field.
                    TextFormField(
                      controller: _confirmEmailController,
                      decoration: InputDecoration(
                        labelText: 'Confirm Email',
                        hintText: 'Confirm new email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: Icon(Icons.email, color: Colors.green[600]),
                        filled: true,
                        fillColor: Colors.green[50],
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value != _newEmailController.text) {
                          Toastget().Toastmsg('Emails do not match');
                          return 'Emails do not match';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: shortestval * 0.03),
                    // Password input field.
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: Icon(Icons.lock, color: Colors.green[600]),
                        filled: true,
                        fillColor: Colors.green[50],
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          Toastget().Toastmsg('Password is required.');
                          return 'Password is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: shortestval * 0.05),
                    // Update email button.
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: widthval * 0.2,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 4,
                        ),
                        onPressed: () async {
                          try {
                            if (_formKey.currentState!.validate()) {
                              await updateEmail();
                            }
                          } catch (obj) {
                            print(obj.toString());
                            Toastget().Toastmsg('Update email fail. Try again with correct data format.');
                          }
                        },
                        child: const Text(
                          "Update Email",
                          style: TextStyle(
                            fontFamily: bold, // Use bold from styles.dart
                            fontSize: 16,
                          ),
                        ).text.white.xl.make(),
                      ),
                    ),
                    SizedBox(height: shortestval * 0.03),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose of controllers to free up resources.
    _newEmailController.dispose();
    _confirmEmailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}