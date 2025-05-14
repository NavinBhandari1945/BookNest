import 'dart:convert';

import 'package:booknest/Views/Pages/Home/user_not_login_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';

import '../../../Models/BookmarkUserModel.dart';
import '../../../constant/constant.dart';
import '../../../constant/styles.dart';
import '../../common widget/circular_progress_ind_yellow.dart';
import '../../common widget/common_method.dart';
import '../../common widget/toast.dart';
import 'bookmark_full_details.dart';

// A StatefulWidget that displays a list of bookmarks for the current user.
class BookmarkPage extends StatefulWidget {
  final String email;
  final String usertype;
  final String jwttoken;
  const BookmarkPage({
    super.key,
    required this.jwttoken,
    required this.usertype,
    required this.email,
  });

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  @override
  void initState() {
    super.initState();
    // Check JWT token validity when the page initializes.
    checkJWTExpiationmember();
  }

  // Validates the JWT token and logs out the user if the session has expired.
  Future<void> checkJWTExpiationmember() async {
    try {
      print("check jwt called in bookmark screen.");
      int result = await checkJwtToken_initistate_member(
        widget.email,
        widget.usertype,
        widget.jwttoken,
      );
      if (result == 0) {
        // Clear user data and redirect to login screen if token is invalid.
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
      // Handle errors by clearing user data and redirecting to login screen.
      await clearUserData();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserNotLoginHomeScreen()),
      );
      Toastget().Toastmsg("Error. Relogin please.");
    }
  }

  // Lists to store all bookmarks and the current user's bookmarks.
  List<UserBookmarkBookModel> BookmarkInfoList = [];
  List<UserBookmarkBookModel> CurrentUserBookmarkInfoList = [];

  // Fetches the user's bookmarks from the backend server.
  Future<void> GetBookMarkInfos() async {
    try {
      print("Get bookmark info method called");
      const String url = Backend_Server_Url + "api/Member/getuserbookmarks";
      final headers = {
        'Authorization': 'Bearer ${widget.jwttoken}',
        'Content-Type': 'application/json',
      };
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        // Parse the response data and populate the bookmark lists.
        List<dynamic> responseData = await jsonDecode(response.body);
        print("response statuscode");
        print("200");
        BookmarkInfoList.clear();
        BookmarkInfoList.addAll(
          responseData
              .map((data) => UserBookmarkBookModel.fromJson(data))
              .toList(),
        );
        print("bookmarklist count value");
        print(BookmarkInfoList.length);
        // Filter bookmarks for the current user based on their email.
        CurrentUserBookmarkInfoList.clear();
        CurrentUserBookmarkInfoList.addAll(
          BookmarkInfoList.where(
                (bookmarkitem) => bookmarkitem.email == widget.email,
          ).toList(),
        );
        print(
          "Current user bookmarklist count: ${CurrentUserBookmarkInfoList.length}",
        );
        return;
      } else {
        // Clear the list if the request fails.
        BookmarkInfoList.clear();
        print("Data insert in bookmarklist failed.");
        return;
      }
    } catch (obj) {
      // Handle errors by clearing the list and logging the exception.
      BookmarkInfoList.clear();
      print("Exception caught while fetching bookmarklist in http method");
      print(obj.toString());
      return;
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
          "Bookmark Details",
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
        // Apply a gradient background for visual appeal.
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[700]!, Colors.green[100]!],
          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: shortestval * 0.03,
              vertical: shortestval * 0.02,
            ),
            child: Column(
              children: [
                // Use FutureBuilder to handle asynchronous fetching of bookmarks.
                FutureBuilder(
                  future: GetBookMarkInfos(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Show a loading indicator while fetching data.
                      return Circular_pro_indicator_Yellow(context);
                    } else if (snapshot.hasError) {
                      // Display error message if fetching fails.
                      return Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: TextStyle(
                            fontFamily: regular,
                            fontSize: shortestval * 0.05,
                            color: Colors.red[700],
                          ),
                        ),
                      );
                    } else if (snapshot.connectionState == ConnectionState.done) {
                      if (CurrentUserBookmarkInfoList.isNotEmpty ||
                          CurrentUserBookmarkInfoList.length >= 1) {
                        // Display the list of bookmarks if data is available.
                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final bookmark = CurrentUserBookmarkInfoList[index];
                            return Card(
                              elevation: 6,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: Colors.white.withOpacity(0.9),
                              child: Container(
                                padding: EdgeInsets.all(shortestval * 0.03),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [Colors.white, Colors.green[50]!],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Book ID: ${bookmark.bookId}",
                                            style: TextStyle(
                                              fontFamily: semibold,
                                              fontSize: shortestval * 0.045,
                                              color: Colors.green[900],
                                            ),
                                          ),
                                          SizedBox(height: shortestval * 0.01),
                                          Text(
                                            "Author: ${bookmark.author}",
                                            style: TextStyle(
                                              fontFamily: regular,
                                              fontSize: shortestval * 0.04,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          SizedBox(height: shortestval * 0.01),
                                          Text(
                                            "Published: ${bookmark.publicationDate}",
                                            style: TextStyle(
                                              fontFamily: regular,
                                              fontSize: shortestval * 0.04,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Add a bookmark icon for visual indication.
                                    Icon(
                                      Icons.bookmark,
                                      color: Colors.green[600],
                                      size: shortestval * 0.07,
                                    ),
                                  ],
                                ),
                              ),
                            ).onTap(() {
                              print("test1");
                              // Navigate to the BookmarkDetails page when a bookmark is tapped.
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookmarkDetails(
                                    jwttoken: widget.jwttoken,
                                    usertype: widget.usertype,
                                    email: widget.email,
                                    BookmarkInfoList: bookmark,
                                  ),
                                ),
                              );
                            });
                          },
                          itemCount: CurrentUserBookmarkInfoList.length,
                        );
                      } else {
                        // Display a message if no bookmarks are available.
                        return Center(
                          child: Text(
                            'No bookmarks available. Please close and reopen app or add a bookmark.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: regular,
                              fontSize: shortestval * 0.05,
                              color: Colors.green[800],
                            ),
                          ),
                        );
                      }
                    } else {
                      // Display a fallback error message if an unexpected state occurs.
                      return Center(
                        child: Text(
                          'Error. Please relogin.',
                          style: TextStyle(
                            fontFamily: regular,
                            fontSize: shortestval * 0.05,
                            color: Colors.red[700],
                          ),
                        ),
                      );
                    }
                  },
                ),
                // Add spacing at the bottom to prevent content cutoff.
                SizedBox(height: heightval * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }
}