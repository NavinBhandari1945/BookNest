import 'dart:convert';

import 'package:booknest/Views/Pages/Home/user_not_login_home_screen.dart';
import 'package:flutter/material.dart';

import '../../../Models/BookmarkUserModel.dart';
import '../../../constant/styles.dart';
import '../../common widget/common_method.dart';
import '../../common widget/toast.dart';

// A StatefulWidget that displays detailed information about a specific bookmark.
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
    // Check JWT token validity when the page initializes.
    checkJWTExpiationmember();
  }

  // Validates the JWT token and logs out the user if the session has expired.
  Future<void> checkJWTExpiationmember() async {
    try {
      print("check jwt called in bookmark full details screen.");
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

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive design.
    var shortestval = MediaQuery.of(context).size.shortestSide;
    var widthval = MediaQuery.of(context).size.width;
    var heightVal = MediaQuery.of(context).size.height;

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
        // Apply a gradient background for a modern look.
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[700]!, Colors.green[100]!],
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: EdgeInsets.all(shortestval * 0.03),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display the book cover image in a circular frame.
                Center(
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                    child: ClipOval(
                      child: Image.memory(
                        base64Decode(widget.BookmarkInfoList.photo!),
                        fit: BoxFit.cover,
                        width: shortestval * 0.35,
                        height: shortestval * 0.35,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.broken_image,
                          size: 80,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: shortestval * 0.04),
                // Section for user-related details.
                _buildDetailSection("User Information", [
                  _buildDetailRow("User ID", widget.BookmarkInfoList.userId?.toString() ?? '', Icons.person),
                  _buildDetailRow("First Name", widget.BookmarkInfoList.firstName?.toString() ?? '', Icons.account_circle),
                  _buildDetailRow("Last Name", widget.BookmarkInfoList.lastName?.toString() ?? '', Icons.account_circle),
                  _buildDetailRow("Email", widget.BookmarkInfoList.email?.toString() ?? '', Icons.email),
                  _buildDetailRow("Phone Number", widget.BookmarkInfoList.phoneNumber?.toString() ?? '', Icons.phone),
                ]),
                SizedBox(height: shortestval * 0.03),
                // Section for book-related details.
                _buildDetailSection("Book Information", [
                  _buildDetailRow("Bookmark ID", widget.BookmarkInfoList.bookmarkId?.toString() ?? '', Icons.bookmark),
                  _buildDetailRow("Book ID", widget.BookmarkInfoList.bookId?.toString() ?? '', Icons.book),
                  _buildDetailRow("Book Name", widget.BookmarkInfoList.bookName?.toString() ?? '', Icons.title),
                  _buildDetailRow("Price", widget.BookmarkInfoList.price?.toStringAsFixed(2) ?? '', Icons.attach_money),
                  _buildDetailRow("Format", widget.BookmarkInfoList.format?.toString() ?? '', Icons.description),
                  _buildDetailRow("Title", widget.BookmarkInfoList.title?.toString() ?? '', Icons.title),
                  _buildDetailRow("Author", widget.BookmarkInfoList.author?.toString() ?? '', Icons.person),
                  _buildDetailRow("Publisher", widget.BookmarkInfoList.publisher?.toString() ?? '', Icons.business),
                  _buildDetailRow("Publication Date", widget.BookmarkInfoList.publicationDate?.toString() ?? '', Icons.calendar_today),
                  _buildDetailRow("Language", widget.BookmarkInfoList.language?.toString() ?? '', Icons.language),
                  _buildDetailRow("Category", widget.BookmarkInfoList.category?.toString() ?? '', Icons.category),
                  _buildDetailRow("Listed At", widget.BookmarkInfoList.listedAt?.toString() ?? '', Icons.access_time),
                  _buildDetailRow("Available Quantity", widget.BookmarkInfoList.availableQuantity?.toString() ?? '', Icons.inventory),
                  _buildDetailRow("Discount Percent", widget.BookmarkInfoList.discountPercent?.toStringAsFixed(2) ?? '', Icons.discount),
                  _buildDetailRow("Discount Start", widget.BookmarkInfoList.discountStart?.toString() ?? '', Icons.date_range),
                  _buildDetailRow("Discount End", widget.BookmarkInfoList.discountEnd?.toString() ?? '', Icons.date_range),
                ]),
                // Add spacing at the bottom to prevent content cutoff.
                SizedBox(height: heightVal * 0.06),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Builds a section with a title and a list of detail rows, displayed in a card.
  Widget _buildDetailSection(String title, List<Widget> details) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white.withOpacity(0.9),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section title with bold styling.
            Text(
              title,
              style: TextStyle(
                fontFamily: bold,
                fontSize: 18,
                color: Colors.green[900],
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            // List of detail rows.
            ...details,
          ],
        ),
      ),
    );
  }

  // Builds a row to display a label-value pair with an icon for visual indication.
  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon for the detail row.
          Icon(
            icon,
            color: Colors.green[600],
            size: 20,
          ),
          SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "$label: ",
                    style: TextStyle(
                      fontFamily: semibold,
                      fontSize: 16,
                      color: Colors.green[800],
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: TextStyle(
                      fontFamily: regular,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}