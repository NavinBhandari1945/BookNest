import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';

import '../../../constant/constant.dart';
import '../../../constant/styles.dart';
import '../../common widget/common_method.dart';
import '../../common widget/toast.dart';
import '../Home/user_not_login_home_screen.dart';

// UpdateBook widget to allow admins to update book details
class UpdateBook extends StatefulWidget {
  final String email; // User's email for authentication
  final String usertype; // User type (e.g., admin)
  final String jwttoken; // JWT token for API authentication

  const UpdateBook({
    super.key,
    required this.jwttoken,
    required this.usertype,
    required this.email,
  });

  @override
  State<UpdateBook> createState() => _UpdateBookState();
}

class _UpdateBookState extends State<UpdateBook> {
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

  // Text controllers for book fields
  final TextEditingController bookIdController = TextEditingController();
  final TextEditingController bookNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController formatController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController languageController = TextEditingController();
  final TextEditingController availableQuantityController =
  TextEditingController();

  // Function to update book details via API
  Future<int> updateBook({
    required int bookId,
    required String bookName,
    required double price,
    required String format,
    required String title,
    required String language,
    required int quantity,
  }) async {
    try {
      Map<String, dynamic> bookData = {
        "BookId": bookId,
        "BookName": bookName,
        "Price": price,
        "Format": format,
        "Title": title,
        "Language": language,
        "AvailableQuantity": quantity,
      };

      const String url = Backend_Server_Url + "api/Admin/update_book";

      final response = await http.put(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${widget.jwttoken}'
        },
        body: json.encode(bookData),
      );

      if (response.statusCode == 200) {
        Toastget().Toastmsg("Book updated successfully.");
        return 1;
      } else if (response.statusCode == 501) {
        Toastget().Toastmsg("Invalid book data. Try again.");
        return 11;
      } else {
        print("Error. Status code: ${response.statusCode}");
        return 4;
      }
    } catch (e) {
      print("Exception during updateBook: $e");
      Toastget().Toastmsg("Update failed. Try again.");
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          "Update Book",
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
                  _buildSectionHeader("Select Book to Update"),
                  const SizedBox(height: 12),
                  // Distinct ISBN text field
                  _buildIsbnTextField(
                    controller: bookIdController,
                    hint: "Enter book ISBN",
                    icon: Icons.confirmation_number,
                  ),
                  const SizedBox(height: 24),
                  // Header for book details
                  _buildSectionHeader("Book Details"),
                  const SizedBox(height: 12),
                  // Text field for Book Name
                  _buildTextField(
                    controller: bookNameController,
                    hint: "Enter book name",
                    icon: Icons.book,
                  ),
                  const SizedBox(height: 16),
                  // Text field for Price
                  _buildTextField(
                    controller: priceController,
                    hint: "Enter price",
                    icon: Icons.attach_money,
                  ),
                  const SizedBox(height: 16),
                  // Text field for Format
                  _buildTextField(
                    controller: formatController,
                    hint: "Enter format (e.g., Hardcover, Paperback)",
                    icon: Icons.description,
                  ),
                  const SizedBox(height: 16),
                  // Text field for Title
                  _buildTextField(
                    controller: titleController,
                    hint: "Enter title",
                    icon: Icons.title,
                  ),
                  const SizedBox(height: 16),
                  // Text field for Language
                  _buildTextField(
                    controller: languageController,
                    hint: "Enter language",
                    icon: Icons.language,
                  ),
                  const SizedBox(height: 16),
                  // Text field for Available Quantity
                  _buildTextField(
                    controller: availableQuantityController,
                    hint: "Enter available quantity",
                    icon: Icons.inventory,
                  ),
                  const SizedBox(height: 24),
                  // Update Book button
                  _buildButton(
                    title: "Update Book",
                    icon: Icons.update,
                    onPressed: () async {
                      try {
                        if (bookIdController.text.isEmptyOrNull ||
                            bookNameController.text.isEmptyOrNull ||
                            priceController.text.isEmptyOrNull ||
                            formatController.text.isEmptyOrNull ||
                            titleController.text.isEmptyOrNull ||
                            languageController.text.isEmptyOrNull ||
                            availableQuantityController.text.isEmptyOrNull) {
                          Toastget().Toastmsg("All fields are required.");
                          return;
                        }

                        final bookId = int.tryParse(bookIdController.text);
                        if (bookId == null || bookId <= 0) {
                          Toastget().Toastmsg("Invalid Book ISBN.");
                          return;
                        }

                        final price = double.tryParse(priceController.text);
                        if (price == null || price <= 0) {
                          Toastget().Toastmsg("Price must be greater than 0.");
                          return;
                        }

                        final quantity =
                        int.tryParse(availableQuantityController.text);
                        if (quantity == null || quantity < 0) {
                          Toastget().Toastmsg("Quantity must be 0 or more.");
                          return;
                        }

                        if (bookNameController.text.length > 50 ||
                            formatController.text.length > 50 ||
                            titleController.text.length > 50 ||
                            languageController.text.length > 50) {
                          Toastget().Toastmsg(
                              "Fields cannot exceed 50 characters.");
                          return;
                        }

                        await updateBook(
                          bookId: bookId,
                          bookName: bookNameController.text.trim(),
                          price: price,
                          format: formatController.text.trim(),
                          title: titleController.text.trim(),
                          language: languageController.text.trim(),
                          quantity: quantity,
                        );
                      } catch (e) {
                        print("Error: $e");
                        Toastget().Toastmsg("Validation or update failed.");
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


// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:velocity_x/velocity_x.dart';
//
// import '../../../constant/constant.dart';
// import '../../../constant/styles.dart';
// import '../../common widget/common_method.dart';
// import '../../common widget/toast.dart';
// import '../Home/user_not_login_home_screen.dart';
//
// // UpdateBook widget to allow admins to update book details
// class UpdateBook extends StatefulWidget {
//   final String email; // User's email for authentication
//   final String usertype; // User type (e.g., admin)
//   final String jwttoken; // JWT token for API authentication
//
//   const UpdateBook({
//     super.key,
//     required this.jwttoken,
//     required this.usertype,
//     required this.email,
//   });
//
//   @override
//   State<UpdateBook> createState() => _UpdateBookState();
// }
//
// class _UpdateBookState extends State<UpdateBook> {
//   @override
//   void initState() {
//     super.initState();
//     checkJWTExpiationAdmin();
//   }
//
//   // Function to validate JWT token and handle session expiration
//   Future<void> checkJWTExpiationAdmin() async {
//     try {
//       print("check jwt called in admin home screen.");
//       int result = await checkJwtToken_initistate_admin(
//           widget.email, widget.usertype, widget.jwttoken);
//       if (result == 0) {
//         await clearUserData();
//         Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => UserNotLoginHomeScreen()));
//         Toastget().Toastmsg("Session End. Relogin please.");
//       }
//     } catch (obj) {
//       print("Exception caught while verifying jwt for admin home screen.");
//       print(obj.toString());
//       await clearUserData();
//       Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//               builder: (context) => UserNotLoginHomeScreen()));
//       Toastget().Toastmsg("Error. Relogin please.");
//     }
//   }
//
//   // Text controllers for book fields
//   final TextEditingController bookIdController = TextEditingController();
//   final TextEditingController bookNameController = TextEditingController();
//   final TextEditingController priceController = TextEditingController();
//   final TextEditingController formatController = TextEditingController();
//   final TextEditingController titleController = TextEditingController();
//   final TextEditingController languageController = TextEditingController();
//   final TextEditingController availableQuantityController =
//   TextEditingController();
//
//   // Function to update book details via API
//   Future<int> updateBook({
//     required int bookId,
//     required String bookName,
//     required double price,
//     required String format,
//     required String title,
//     required String language,
//     required int quantity,
//   }) async {
//     try {
//       Map<String, dynamic> bookData = {
//         "BookId": bookId,
//         "BookName": bookName,
//         "Price": price,
//         "Format": format,
//         "Title": title,
//         "Language": language,
//         "AvailableQuantity": quantity,
//       };
//
//       const String url = Backend_Server_Url + "api/Admin/update_book";
//
//       final response = await http.put(
//         Uri.parse(url),
//         headers: {
//           "Content-Type": "application/json",
//           'Authorization': 'Bearer ${widget.jwttoken}'
//         },
//         body: json.encode(bookData),
//       );
//
//       if (response.statusCode == 200) {
//         Toastget().Toastmsg("Book updated successfully.");
//         return 1;
//       } else if (response.statusCode == 501) {
//         Toastget().Toastmsg("Invalid book data. Try again.");
//         return 11;
//       } else {
//         print("Error. Status code: ${response.statusCode}");
//         return 4;
//       }
//     } catch (e) {
//       print("Exception during updateBook: $e");
//       Toastget().Toastmsg("Update failed. Try again.");
//       return 0;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: true,
//         title: const Text(
//           "Update Book",
//           style: TextStyle(
//             fontFamily: bold,
//             fontSize: 26,
//             fontWeight: FontWeight.w700,
//             color: Colors.white,
//             letterSpacing: 1.5,
//           ),
//         ),
//         backgroundColor: const Color(0xFF1A3C34),
//         elevation: 8,
//         shadowColor: Colors.black.withOpacity(0.3),
//         centerTitle: true,
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Color(0xFFF5F6F5),
//               Color(0xFFE8ECEF),
//             ],
//           ),
//         ),
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
//             child: SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   // Section header for book details
//                   _buildSectionHeader("Book Details"),
//                   const SizedBox(height: 12),
//                   // Text field for Book ID
//                   _buildTextField(
//                     controller: bookIdController,
//                     hint: "Enter book ID",
//                     icon: Icons.confirmation_number,
//                   ),
//                   const SizedBox(height: 16),
//                   // Text field for Book Name
//                   _buildTextField(
//                     controller: bookNameController,
//                     hint: "Enter book name",
//                     icon: Icons.book,
//                   ),
//                   const SizedBox(height: 16),
//                   // Text field for Price
//                   _buildTextField(
//                     controller: priceController,
//                     hint: "Enter price",
//                     icon: Icons.attach_money,
//                   ),
//                   const SizedBox(height: 16),
//                   // Text field for Format
//                   _buildTextField(
//                     controller: formatController,
//                     hint: "Enter format (e.g., Hardcover, Paperback)",
//                     icon: Icons.description,
//                   ),
//                   const SizedBox(height: 16),
//                   // Text field for Title
//                   _buildTextField(
//                     controller: titleController,
//                     hint: "Enter title",
//                     icon: Icons.title,
//                   ),
//                   const SizedBox(height: 16),
//                   // Text field for Language
//                   _buildTextField(
//                     controller: languageController,
//                     hint: "Enter language",
//                     icon: Icons.language,
//                   ),
//                   const SizedBox(height: 16),
//                   // Text field for Available Quantity
//                   _buildTextField(
//                     controller: availableQuantityController,
//                     hint: "Enter available quantity",
//                     icon: Icons.inventory,
//                   ),
//                   const SizedBox(height: 24),
//                   // Update Book button
//                   _buildButton(
//                     title: "Update Book",
//                     icon: Icons.update,
//                     onPressed: () async {
//                       try {
//                         if (bookIdController.text.isEmptyOrNull ||
//                             bookNameController.text.isEmptyOrNull ||
//                             priceController.text.isEmptyOrNull ||
//                             formatController.text.isEmptyOrNull ||
//                             titleController.text.isEmptyOrNull ||
//                             languageController.text.isEmptyOrNull ||
//                             availableQuantityController.text.isEmptyOrNull) {
//                           Toastget().Toastmsg("All fields are required.");
//                           return;
//                         }
//
//                         final bookId = int.tryParse(bookIdController.text);
//                         if (bookId == null || bookId <= 0) {
//                           Toastget().Toastmsg("Invalid Book ID.");
//                           return;
//                         }
//
//                         final price = double.tryParse(priceController.text);
//                         if (price == null || price <= 0) {
//                           Toastget().Toastmsg("Price must be greater than 0.");
//                           return;
//                         }
//
//                         final quantity =
//                         int.tryParse(availableQuantityController.text);
//                         if (quantity == null || quantity < 0) {
//                           Toastget().Toastmsg("Quantity must be 0 or more.");
//                           return;
//                         }
//
//                         if (bookNameController.text.length > 50 ||
//                             formatController.text.length > 50 ||
//                             titleController.text.length > 50 ||
//                             languageController.text.length > 50) {
//                           Toastget().Toastmsg(
//                               "Fields cannot exceed 50 characters.");
//                           return;
//                         }
//
//                         await updateBook(
//                           bookId: bookId,
//                           bookName: bookNameController.text.trim(),
//                           price: price,
//                           format: formatController.text.trim(),
//                           title: titleController.text.trim(),
//                           language: languageController.text.trim(),
//                           quantity: quantity,
//                         );
//                       } catch (e) {
//                         print("Error: $e");
//                         Toastget().Toastmsg("Validation or update failed.");
//                       }
//                     },
//                     color: const Color(0xFF2E7D32),
//                   ),
//                   const SizedBox(height: 24),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Widget for section headers
//   Widget _buildSectionHeader(String title) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12.0, top: 8.0),
//       child: Text(
//         title,
//         style: const TextStyle(
//           fontFamily: bold,
//           fontSize: 20,
//           fontWeight: FontWeight.w600,
//           color: Color(0xFF1A3C34),
//           letterSpacing: 1.2,
//         ),
//       ),
//     );
//   }
//
//   // Widget for styled text fields
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String hint,
//     required IconData icon,
//     int maxLines = 1,
//   }) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: TextField(
//         controller: controller,
//         maxLines: maxLines,
//         style: const TextStyle(
//           fontFamily: regular,
//           fontSize: 16,
//           color: Color(0xFF1A3C34),
//         ),
//         decoration: InputDecoration(
//           hintText: hint,
//           hintStyle: TextStyle(
//             color: Colors.grey[600],
//             fontFamily: regular,
//           ),
//           prefixIcon: Icon(icon, color: const Color(0xFF2E7D32)),
//           filled: true,
//           fillColor: Colors.white,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide.none,
//           ),
//           contentPadding:
//           const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
//         ),
//       ),
//     );
//   }
//
//   // Widget for styled buttons
//   Widget _buildButton({
//     required String title,
//     required IconData icon,
//     required VoidCallback onPressed,
//     required Color color,
//   }) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(12),
//         onTap: onPressed,
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
//           decoration: BoxDecoration(
//             color: color,
//             borderRadius: BorderRadius.circular(12),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 blurRadius: 8,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           child: Row(
//             children: [
//               Icon(icon, color: Colors.white, size: 28),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Text(
//                   title,
//                   style: const TextStyle(
//                     fontFamily: regular,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.white,
//                     letterSpacing: 0.8,
//                   ),
//                 ),
//               ),
//               Icon(Icons.arrow_forward_ios,
//                   color: Colors.white.withOpacity(0.7), size: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
//
//
//
//
// // import 'dart:convert';
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:velocity_x/velocity_x.dart';
// //
// // import '../../../constant/constant.dart';
// // import '../../../constant/styles.dart';
// // import '../../common widget/common_method.dart';
// // import '../../common widget/commonbutton.dart';
// // import '../../common widget/commontextfield_obs_false.dart';
// // import '../../common widget/toast.dart';
// // import '../Home/user_not_login_home_screen.dart';
// //
// //
// // class UpdateBook extends StatefulWidget {
// //   final String email;
// //   final String usertype;
// //   final String jwttoken;
// //
// //   const UpdateBook({
// //     super.key,
// //     required this.jwttoken,
// //     required this.usertype,
// //     required this.email,
// //   });
// //
// //   @override
// //   State<UpdateBook> createState() => _UpdateBookState();
// // }
// //
// // class _UpdateBookState extends State<UpdateBook> {
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     checkJWTExpiationAdmin();
// //   }
// //
// //   Future<void> checkJWTExpiationAdmin() async {
// //     try {
// //       //check jwt called in admin home screen.
// //       print("check jwt called in admin home screen.");
// //       int result = await checkJwtToken_initistate_admin(
// //           widget.email, widget.usertype, widget.jwttoken);
// //       if (result == 0)
// //       {
// //         await clearUserData();
// //         Navigator.pushReplacement(context,
// //             MaterialPageRoute(builder: (context) => UserNotLoginHomeScreen()));
// //         Toastget().Toastmsg("Session End. Relogin please.");
// //       }
// //     } catch (obj) {
// //       print("Exception caught while verifying jwt for admin home screen.");
// //       print(obj.toString());
// //       await clearUserData();
// //       Navigator.pushReplacement(context,
// //           MaterialPageRoute(builder: (context) => UserNotLoginHomeScreen()));
// //       Toastget().Toastmsg("Error. Relogin please.");
// //     }
// //   }
// //
// //   final TextEditingController bookIdController = TextEditingController();
// //   final TextEditingController bookNameController = TextEditingController();
// //   final TextEditingController priceController = TextEditingController();
// //   final TextEditingController formatController = TextEditingController();
// //   final TextEditingController titleController = TextEditingController();
// //   final TextEditingController languageController = TextEditingController();
// //   final TextEditingController availableQuantityController = TextEditingController();
// //
// //   Future<int> updateBook({
// //     required int bookId,
// //     required String bookName,
// //     required double price,
// //     required String format,
// //     required String title,
// //     required String language,
// //     required int quantity,
// //   }) async {
// //     try {
// //       Map<String, dynamic> bookData = {
// //         "BookId": bookId,
// //         "BookName": bookName,
// //         "Price": price,
// //         "Format": format,
// //         "Title": title,
// //         "Language": language,
// //         "AvailableQuantity": quantity,
// //       };
// //
// //       const String url = Backend_Server_Url + "api/Admin/update_book";
// //
// //       final response = await http.put(
// //         Uri.parse(url),
// //         headers: {
// //           "Content-Type": "application/json",
// //           'Authorization': 'Bearer ${widget.jwttoken}'
// //         },
// //         body: json.encode(bookData),
// //       );
// //
// //       if (response.statusCode == 200) {
// //         Toastget().Toastmsg("Book updated successfully.");
// //         return 1;
// //       } else if (response.statusCode == 501) {
// //         Toastget().Toastmsg("Invalid book data. Try again.");
// //         return 11;
// //       } else {
// //         print("Error. Status code: ${response.statusCode}");
// //         return 4;
// //       }
// //     } catch (e) {
// //       print("Exception during updateBook: $e");
// //       Toastget().Toastmsg("Update failed. Try again.");
// //       return 0;
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         automaticallyImplyLeading: true,
// //         title: Text("Update Book", style: TextStyle(fontFamily: bold, fontSize: 24, color: Colors.white)),
// //         backgroundColor: Colors.green[700],
// //       ),
// //       body: SingleChildScrollView(
// //         padding: const EdgeInsets.all(16),
// //         child: Column(
// //           children: [
// //             CommonTextField_obs_false("Book ID", "", false, bookIdController, context),
// //             CommonTextField_obs_false("Book Name", "", false, bookNameController, context),
// //             CommonTextField_obs_false("Price", "", false, priceController, context),
// //             CommonTextField_obs_false("Format", "", false, formatController, context),
// //             CommonTextField_obs_false("Title", "", false, titleController, context),
// //             CommonTextField_obs_false("Language", "", false, languageController, context),
// //             CommonTextField_obs_false("Available Quantity", "", false, availableQuantityController, context),
// //             Commonbutton("Update Book", () async {
// //               try {
// //                 if (bookIdController.text.isEmptyOrNull ||
// //                     bookNameController.text.isEmptyOrNull ||
// //                     priceController.text.isEmptyOrNull ||
// //                     formatController.text.isEmptyOrNull ||
// //                     titleController.text.isEmptyOrNull ||
// //                     languageController.text.isEmptyOrNull ||
// //                     availableQuantityController.text.isEmptyOrNull) {
// //                   Toastget().Toastmsg("All fields are required.");
// //                   return;
// //                 }
// //
// //                 final bookId = int.tryParse(bookIdController.text);
// //                 if (bookId == null || bookId <= 0) {
// //                   Toastget().Toastmsg("Invalid Book ID.");
// //                   return;
// //                 }
// //
// //                 final price = double.tryParse(priceController.text);
// //                 if (price == null || price <= 0) {
// //                   Toastget().Toastmsg("Price must be greater than 0.");
// //                   return;
// //                 }
// //
// //                 final quantity = int.tryParse(availableQuantityController.text);
// //                 if (quantity == null || quantity < 0) {
// //                   Toastget().Toastmsg("Quantity must be 0 or more.");
// //                   return;
// //                 }
// //
// //                 if (bookNameController.text.length > 50 ||
// //                     formatController.text.length > 50 ||
// //                     titleController.text.length > 50 ||
// //                     languageController.text.length > 50) {
// //                   Toastget().Toastmsg("Fields cannot exceed 50 characters.");
// //                   return;
// //                 }
// //
// //                 await updateBook(
// //                   bookId: bookId,
// //                   bookName: bookNameController.text.trim(),
// //                   price: price,
// //                   format: formatController.text.trim(),
// //                   title: titleController.text.trim(),
// //                   language: languageController.text.trim(),
// //                   quantity: quantity,
// //                 );
// //               } catch (e) {
// //                 print("Error: $e");
// //                 Toastget().Toastmsg("Validation or update failed.");
// //               }
// //             }, context, Colors.red)
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
