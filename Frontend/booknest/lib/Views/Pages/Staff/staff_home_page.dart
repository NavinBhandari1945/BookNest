import 'package:flutter/material.dart';

import '../../../constant/styles.dart';

class StaffHomePage extends StatefulWidget {
  final String email;
  final String usertype;
  final String jwttoken;
  const StaffHomePage({super.key,required this.jwttoken,required this.usertype,required this.email});


  @override
  State<StaffHomePage> createState() => _StaffHomePageState();
}

class _StaffHomePageState extends State<StaffHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "Staff",
            style: TextStyle(fontFamily: bold, fontSize: 24, color: Colors.white, letterSpacing: 1.2),
          ),
          backgroundColor: Colors.green[700],
          elevation: 4,
          shadowColor: Colors.black45,
        ),
        body:Container()
    );
  }
}
