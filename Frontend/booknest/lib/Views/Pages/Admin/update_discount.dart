import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';
import '../../../constant/constant.dart';
import '../../../constant/styles.dart';
import '../../common widget/common_method.dart';
import '../../common widget/toast.dart';
import '../Home/user_not_login_home_screen.dart';

// UpdateDiscount widget to allow admins to update discount details
class UpdateDiscount extends StatefulWidget {
  final String email; // User's email for authentication
  final String usertype; // User type (e.g., admin)
  final String jwttoken; // JWT token for API authentication

  const UpdateDiscount({
    super.key,
    required this.jwttoken,
    required this.usertype,
    required this.email,
  });

  @override
  State<UpdateDiscount> createState() => _UpdateDiscountState();
}

class _UpdateDiscountState extends State<UpdateDiscount> {
  @override
  void initState() {
    super.initState();
    checkJWTExpiationAdmin();
  }

  // Function to validate JWT token and handle session expiration
  Future<void> checkJWTExpiationAdmin() async {
    try {
      print("check jwt called in admin home screen.");
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

  // Text controllers for discount fields
  final TextEditingController BookIdController = TextEditingController();
  final TextEditingController CategoryController = TextEditingController();
  final TextEditingController discountPercentController =
  TextEditingController();
  final TextEditingController discountStartController = TextEditingController();
  final TextEditingController discountEndController = TextEditingController();

  // Function to update discount details via API
  Future<int> UpdateDiscount({
    required int BookId,
    required String Category,
    required double Discount_Percent,
    required String Discount_Start,
    required String Discount_End,
  }) async {
    try {
      Map<String, dynamic> bookData = {
        "BookId": BookId,
        "Category": Category,
        "DiscountPercent": Discount_Percent,
        "DiscountStart": Discount_Start,
        "DiscountEnd": Discount_End,
      };

      const String url = Backend_Server_Url + "api/Admin/update_discount";

      final response = await http.put(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${widget.jwttoken}'
        },
        body: json.encode(bookData),
      );

      if (response.statusCode == 200) {
        Toastget().Toastmsg("Update Discount success.");
        return 1;
      } else if (response.statusCode == 501) {
        Toastget().Toastmsg(
            "Updating book failed. Incorrect book data format. Try again.");
        return 11;
      } else {
        print("Error. Other status code.");
        print("Response body: ${response.statusCode}");
        return 4;
      }
    } catch (obj) {
      print("Exception caught while updating discount.");
      print(obj.toString());
      Toastget().Toastmsg("Updating book failed.");
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          "Update Discount",
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
                  // Header for selecting book by ISBN
                  _buildSectionHeader("Select Book to Update Discount"),
                  const SizedBox(height: 12),
                  // Distinct ISBN text field
                  _buildIsbnTextField(
                    controller: BookIdController,
                    hint: "Enter book ISBN",
                    icon: Icons.confirmation_number,
                  ),
                  const SizedBox(height: 24),
                  // Header for discount details
                  _buildSectionHeader("Discount Details"),
                  const SizedBox(height: 12),
                  // Text field for Category
                  _buildTextField(
                    controller: CategoryController,
                    hint: "Enter book category",
                    icon: Icons.category,
                  ),
                  const SizedBox(height: 16),
                  // Text field for Discount Percent
                  _buildTextField(
                    controller: discountPercentController,
                    hint: "Enter discount percent",
                    icon: Icons.discount,
                  ),
                  const SizedBox(height: 16),
                  // Text field for Discount Start Date
                  _buildTextField(
                    controller: discountStartController,
                    hint: "Enter discount start date (YYYY-MM-DD)",
                    icon: Icons.calendar_today,
                  ),
                  const SizedBox(height: 16),
                  // Text field for Discount End Date
                  _buildTextField(
                    controller: discountEndController,
                    hint: "Enter discount end date (YYYY-MM-DD)",
                    icon: Icons.calendar_today,
                  ),
                  const SizedBox(height: 24),
                  // Update Discount button
                  _buildButton(
                    title: "Update Discount",
                    icon: Icons.update,
                    onPressed: () async {
                      try {
                        if (BookIdController.text.isEmptyOrNull ||
                            CategoryController.text.isEmptyOrNull ||
                            discountPercentController.text.isEmptyOrNull ||
                            discountStartController.text.isEmptyOrNull ||
                            discountEndController.text.isEmptyOrNull) {
                          Toastget().Toastmsg("All fields are required");
                          return;
                        }

                        final bookId = int.tryParse(BookIdController.text);
                        if (bookId == null) {
                          Toastget().Toastmsg("Invalid Book ISBN");
                          return;
                        }

                        final bookDiscountPercent =
                        double.tryParse(discountPercentController.text);
                        if (bookDiscountPercent == null ||
                            bookDiscountPercent <= 0) {
                          Toastget().Toastmsg(
                              "Discount percent must be a number greater than 0");
                          return;
                        }

                        final discountStart =
                        DateTime.tryParse(discountStartController.text);
                        final discountEnd =
                        DateTime.tryParse(discountEndController.text);
                        final currentDate = DateTime.now().toUtc();

                        if (discountStart == null || discountEnd == null) {
                          Toastget().Toastmsg("Invalid date format");
                          return;
                        }

                        if (discountStart.isBefore(currentDate)) {
                          Toastget().Toastmsg(
                              "Start date cannot be before current date");
                          return;
                        }

                        if (discountEnd.isBefore(discountStart)) {
                          Toastget().Toastmsg(
                              "End date cannot be before start date");
                          return;
                        }

                        final result = await UpdateDiscount(
                          BookId: bookId,
                          Category: CategoryController.text,
                          Discount_Percent: bookDiscountPercent,
                          Discount_Start: discountStartController.text,
                          Discount_End: discountEndController.text,
                        );

                        print("Update result: $result");
                      } catch (e) {
                        print(e.toString());
                        Toastget().Toastmsg(
                            "Error occurred during validation or submission.");
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

  // Widget for styled text fields (used for all fields except ISBN)
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

  // Widget for distinct ISBN text field
  Widget _buildIsbnTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Card(
      elevation: 6, // Higher elevation for emphasis
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(
            color: Color(0xFF1A3C34), width: 2), // Distinct border
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(
          fontFamily: regular,
          fontSize: 16,
          color: Color(0xFF1A3C34),
          fontWeight: FontWeight.w600, // Bolder text for emphasis
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.grey[600],
            fontFamily: regular,
            fontWeight: FontWeight.w600,
          ),
          prefixIcon: Icon(icon, color: const Color(0xFF2E7D32), size: 28), // Larger icon
          filled: true,
          fillColor: Colors.white.withOpacity(0.95), // Slightly off-white
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding:
          const EdgeInsets.symmetric(vertical: 18, horizontal: 22), // Larger padding
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



