import 'dart:convert';

import 'package:booknest/Views/Pages/Home/user_not_login_home_screen.dart';
import 'package:flutter/material.dart';

import '../../../Models/BookmarkUserModel.dart';
import '../../../constant/styles.dart';
import '../../common widget/common_method.dart';
import '../../common widget/toast.dart';

class BookmarkDetails extends StatefulWidget {
  final String email;
  final String usertype;
  final String jwttoken;
  final UserBookmarkBookModel BookmarkInfoList;
  const BookmarkDetails({
    super.key,
    required this.jwttoken,
    required this.usertype,
    required this.email,
    required this.BookmarkInfoList,
  });

  @override
  State<BookmarkDetails> createState() => _BookmarkDetailsState();
}

class _BookmarkDetailsState extends State<BookmarkDetails> {
  @override
  void initState() {
    super.initState();
    checkJWTExpiationmember();
  }

  Future<void> checkJWTExpiationmember() async {
    try {
      //check jwt called in admin home screen.
      print("check jwt called in bookmark full details screen.");
      int result = await checkJwtToken_initistate_member(
        widget.email,
        widget.usertype,
        widget.jwttoken,
      );
      if (result == 0) {
        await clearUserData();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserNotLoginHomeScreen()),
        );
        Toastget().Toastmsg("Session End. Relogin please.");
      }
    } catch (obj) {
      print("Exception caught while verifying jwt for admin home screen.");
      print(obj.toString());
      await clearUserData();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserNotLoginHomeScreen()),
      );
      Toastget().Toastmsg("Error. Relogin please.");
    }
  }

  @override
  Widget build(BuildContext context) {
    var shortestval = MediaQuery.of(context).size.shortestSide;
    var widthval = MediaQuery.of(context).size.width;
    var heightVal = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Bookmark full Details",
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Container(
        width: widthval,
        height: heightVal,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Center(
                child: ClipOval(
                  child: Image.memory(
                    base64Decode(widget.BookmarkInfoList.photo!),
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => const Icon(
                          Icons.broken_image,
                          size: 100,
                          color: Colors.grey,
                        ),
                  ),
                ),
              ),

              SizedBox(height: heightVal * 0.03),

              Text("User ID: ${widget.BookmarkInfoList.userId ?? ''}"),
              Text("First Name: ${widget.BookmarkInfoList.firstName ?? ''}"),
              Text("Last Name: ${widget.BookmarkInfoList.lastName ?? ''}"),
              Text("Email: ${widget.BookmarkInfoList.email ?? ''}"),
              Text(
                "Phone Number: ${widget.BookmarkInfoList.phoneNumber ?? ''}",
              ),
              Text("Bookmark ID: ${widget.BookmarkInfoList.bookmarkId ?? ''}"),
              Text("Book ID: ${widget.BookmarkInfoList.bookId ?? ''}"),
              Text("Book Name: ${widget.BookmarkInfoList.bookName ?? ''}"),
              Text(
                "Price: ${widget.BookmarkInfoList.price?.toStringAsFixed(2) ?? ''}",
              ),
              Text("Format: ${widget.BookmarkInfoList.format ?? ''}"),
              Text("Title: ${widget.BookmarkInfoList.title ?? ''}"),
              Text("Author: ${widget.BookmarkInfoList.author ?? ''}"),
              Text("Publisher: ${widget.BookmarkInfoList.publisher ?? ''}"),
              Text(
                "Publication Date: ${widget.BookmarkInfoList.publicationDate ?? ''}",
              ),
              Text("Language: ${widget.BookmarkInfoList.language ?? ''}"),
              Text("Category: ${widget.BookmarkInfoList.category ?? ''}"),
              Text("Listed At: ${widget.BookmarkInfoList.listedAt ?? ''}"),
              Text(
                "Available Quantity: ${widget.BookmarkInfoList.availableQuantity ?? ''}",
              ),
              Text(
                "Discount Percent: ${widget.BookmarkInfoList.discountPercent?.toStringAsFixed(2) ?? ''}",
              ),
              Text(
                "Discount Start: ${widget.BookmarkInfoList.discountStart ?? ''}",
              ),
              Text(
                "Discount End: ${widget.BookmarkInfoList.discountEnd ?? ''}",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
