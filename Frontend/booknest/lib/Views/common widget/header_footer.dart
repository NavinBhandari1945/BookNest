import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constant/styles.dart';
import '../Pages/Home/book_screen.dart';
import '../Pages/Home/cart_screen.dart';
import '../Pages/Home/member_login_page.dart';
import '../Pages/Home/pofile_page.dart';

class HeaderWidget extends StatelessWidget {
  final String email;
  final String usertype;
  final String jwttoken;

  const HeaderWidget({
    Key? key,
    required this.email,
    required this.usertype,
    required this.jwttoken,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.green[600],
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [

          _buildNavButton(context, 'Home', () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => MemberHomePage(
                  jwttoken: jwttoken,
                  usertype: usertype,
                  email: email,
                ),
              ),
            );
          }),

          _buildNavButton(context, 'Profile', () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => ProfilePage(
                  jwttoken: jwttoken,
                  usertype: usertype,
                  email: email,
                ),
              ),
            );
          }),
          _buildNavButton(context, 'Books', () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => BookScreen(
                  jwttoken: jwttoken,
                  usertype: usertype,
                  email: email,
                ),
              ),
            );
          }),
          _buildNavButton(context, 'Cart', () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => CartScreen(
                  jwttoken: jwttoken,
                  usertype: usertype,
                  email: email,
                ),
              ),
            );
          }),



        ],
      ),
    );
  }

  Widget _buildNavButton(BuildContext context, String label, VoidCallback onTap) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontFamily: bold,
          color: Colors.green[800],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}


class FooterWidget extends StatelessWidget {
  const FooterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.green[700],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'BookNest',
            style: TextStyle(
              fontSize: 14,
              fontFamily: bold,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            '© 2025 BookNest. All rights reserved.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
