import 'package:booknest/Views/Pages/Admin/admin_screen.dart';
import 'package:booknest/Views/Pages/Home/user_not_login_home_screen.dart';
import 'package:booknest/Views/Pages/Staff/staff_home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import '../../constant/constant.dart';
import '../Pages/Home/member_login_page.dart';

Future<void> saveJwtToken(String token) async {
  final box = await Hive.openBox('userData');
  // Ensure that token is not null
  if (token != null) {
    // Save JWT token to Hive
    await box.put('jwt_token', token);
    print("JWT token saved.");
  } else {
    print("Error: Token is missing.");
  }
}

// Method to retrieve JWT token
Future<String?> getJwtToken() async {
  final box = await Hive.openBox('userData');
  // Retrieve JWT token from Hive
  String? token = await box.get('jwt_token');
  return token;
}

// Method to save username and password
Future<void> saveUserCredentials(
  String email,
  String usertype,
  String login_date,
) async {
  final box = await Hive.openBox('userData');

  // Ensure that username and password are not null
  if (email != null && usertype != null && login_date != null) {
    // Save username and password to Hive
    await box.put('email', email);
    await box.put('usertype', usertype);
    await box.put("loginDate", login_date);
    print("Email,usertype and login date saved.");
  } else {
    print("Error: Username,user login date or usertype is missing.");
  }
}

// Method to retrieve username and password
Future<Map<String, String?>> getUserCredentials() async {
  final box = await Hive.openBox('userData');
  // Retrieve email and password from Hive
  String? email = await box.get('email');
  String? usertype = await box.get('usertype');
  String? UserLoginDate = await box.get('loginDate');
  return {'email': email, 'usertype': usertype, 'UserLogindate': UserLoginDate};
}

// Method to clear JWT token, username, and password
Future<void> clearUserData() async {
  final box = await Hive.openBox('userData');
  // Clear JWT token, username, and password
  await box.delete('jwt_token');
  await box.delete('email');
  await box.delete('usertype');
  await box.delete('loginDate');
  print("User data cleared.");
}

// Method to handle API response and save data if status code is 200
Future<void> handleResponse(Map<dynamic, dynamic> responseData) async {
  String token = responseData['token']!;
  String email = responseData['email']!;
  String User_Type = responseData['role']!;
  String login_date = DateTime.now().toUtc().toIso8601String();
  await saveJwtToken(token);
  await saveUserCredentials(email, User_Type, login_date);
  print("Login sucecss");
  print("User data");
  print("jwt token");
  print(token);
  print("email");
  print(email);
  print("user type");
  print(User_Type);
  print("Login date");
  print(login_date);
  return;
}

Future<Widget> Check_Jwt_Token_Start_Screen() async {
  final box = await Hive.openBox('userData');
  final jwtToken = await box.get('jwt_token');
  if (jwtToken == null || jwtToken.isEmpty) {
    print("jwt token empty or null.Check jwt for main.dart.");
    await clearUserData();
    return const UserNotLoginHomeScreen();
  }

  const String url = Backend_Server_Url + "api/Auth/jwtverify";

  // verification
  final response = await http.get(
    Uri.parse(url),
    headers: {'Authorization': 'Bearer $jwtToken'},
  );

  if (response.statusCode == 200) {
    Map<String, String?> userData = await getUserCredentials();

    if (userData["usertype"] == "Admin") {
      return AdminHomePage(jwttoken: jwtToken!, usertype:userData['usertype']!, email: userData["email"]!,);
    }

    if (userData["usertype"] == "Member") {
      return MemberHomePage(jwttoken: jwtToken!, usertype:userData['usertype']!, email: userData["email"]!,);
    }

    if (userData["usertype"] == "Staff") {
      return StaffHomePage(jwttoken: jwtToken!, usertype:userData['usertype']!, email: userData["email"]!,);
    }
  } else {
    print("jwt token unverified in main.dart.");
    await clearUserData();
    return UserNotLoginHomeScreen();
  }
  await clearUserData();
  return const UserNotLoginHomeScreen();
}

Future<int> checkJwtToken_initistate_member(
  String email,
  String usertype,
  String jwttoken,
) async {
  print("jwt token");
  print(jwttoken);
  print("email");
  print(email);
  print("user type");
  print(usertype);
  if (jwttoken == null ||
      jwttoken.isEmpty ||
      usertype != "Member" ||
      usertype.isEmpty ||
      usertype == null ||
      email == null ||
      email.isEmpty) {
    print("User details miss match.");
    return 0;
  }

  const String url = Backend_Server_Url + 'api/Auth/jwtverify';

  final response2 = await http.get(
    Uri.parse(url),
    headers: {'Authorization': 'Bearer $jwttoken'},
  );
  if (response2.statusCode == 200) {
    if (usertype == "Member") {
      return 1;
    } else {
      print(
        "User type mismatch.jwt initistate user method present in common method .dart file.",
      );
      await clearUserData();
      return 0;
    }
  } else {
    print("jwt not verify for jwt initstate user");
    await clearUserData();
    return 0;
  }
}

Future<int> checkJwtToken_initistate_admin(
  String email,
  String usertype,
  String jwttoken,
) async {
  print("jwt token");
  print(jwttoken);
  print("email");
  print(email);
  print("user type");
  print(usertype);
  if (jwttoken == null ||
      jwttoken.isEmpty ||
      usertype != "Admin" ||
      usertype.isEmpty ||
      usertype == null ||
      email == null ||
      email.isEmpty) {
    print("User details miss match.");
    return 0;
  }

  const String url = Backend_Server_Url + 'api/Auth/jwtverify';

  final response2 = await http.get(
    Uri.parse(url),
    headers: {'Authorization': 'Bearer $jwttoken'},
  );
  if (response2.statusCode == 200) {
    if (usertype == "Admin") {
      return 1;
    } else {
      print(
        "User type mismatch.jwt initistate user method present in common method .dart file.",
      );
      await clearUserData();
      return 0;
    }
  } else {
    print("jwt not verify for jwt initstate user");
    await clearUserData();
    return 0;
  }
}

Future<int> checkJwtToken_initistate_staff(
  String email,
  String usertype,
  String jwttoken,
) async {
  print("jwt token");
  print(jwttoken);
  print("email");
  print(email);
  print("user type");
  print(usertype);
  if (jwttoken == null ||
      jwttoken.isEmpty ||
      usertype != "Staff" ||
      usertype.isEmpty ||
      usertype == null ||
      email == null ||
      email.isEmpty) {
    print("User details miss match.");
    return 0;
  }

  const String url = Backend_Server_Url + 'api/Auth/jwtverify';

  final response2 = await http.get(
    Uri.parse(url),
    headers: {'Authorization': 'Bearer $jwttoken'},
  );
  if (response2.statusCode == 200) {
    if (usertype == "Staff") {
      return 1;
    } else {
      print(
        "User type mismatch.jwt initistate user method present in common method .dart file.",
      );
      await clearUserData();
      return 0;
    }
  } else {
    print("jwt not verify for jwt initstate user");
    await clearUserData();
    return 0;
  }
}
