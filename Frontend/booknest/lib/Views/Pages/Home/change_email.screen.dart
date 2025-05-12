import 'dart:convert';
import 'package:booknest/Views/Pages/Home/user_not_login_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';

import '../../../constant/constant.dart';
import '../../common widget/common_method.dart';
import '../../common widget/toast.dart';

class ChangeEmailScreen extends StatefulWidget {
  final String email;
  final String usertype;
  final String jwttoken;
  const ChangeEmailScreen({super.key,required this.jwttoken,required this.usertype,required this.email});
  @override
  State<ChangeEmailScreen> createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {

  @override
  void initState() {
    super.initState();
    checkJWTExpiationmember();
  }

  Future<void> checkJWTExpiationmember() async {
    try {
      //check jwt called in admin home screen.
      print("check jwt called in book screen.");
      int result = await checkJwtToken_initistate_member(
          widget.email, widget.usertype, widget.jwttoken);
      if (result == 0)
      {
        await clearUserData();
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => UserNotLoginHomeScreen()));
        Toastget().Toastmsg("Session End. Relogin please.");
      }
    } catch (obj) {
      print("Exception caught while verifying jwt for admin home screen.");
      print(obj.toString());
      await clearUserData();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserNotLoginHomeScreen()));
      Toastget().Toastmsg("Error. Relogin please.");
    }
  }
  final _newEmailController = TextEditingController();
  final _confirmEmailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
    return Scaffold(
      appBar: AppBar(
        title: "Change Email".text.xl2.white.make(),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              TextFormField(
                controller: _newEmailController,
                decoration: InputDecoration(
                  labelText: 'New Email',
                  hintText: 'Enter new email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    Toastget().Toastmsg("Enter new email.Try again.");
                    return 'Please enter new email';
                  } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    Toastget().Toastmsg("Enter new email format incorrect.Try again.");
                    return 'Enter valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _confirmEmailController,
                decoration: InputDecoration(
                  labelText: 'Confirm Email',
                  hintText: 'Confirm new email',
                  border: OutlineInputBorder(),
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
              SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    Toastget().Toastmsg('Passowrd is required.');
                    return 'Password is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                onPressed: () async {
                  try {
                    if (_formKey.currentState!.validate()) {
                      await updateEmail();
                    }
                  }catch(obj)
                  {
                    print(obj.toString());
                    Toastget().Toastmsg('Update email fial.Try again with correct data format.');
                  }
                },
                child: "Update Email".text.white.xl.make(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _newEmailController.dispose();
    _confirmEmailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
