import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';

import '../../../constant/constant.dart';
import '../../../constant/styles.dart';
import '../../common widget/common_method.dart';
import '../../common widget/commonbutton.dart';
import '../../common widget/commontextfield_obs_false.dart';
import '../../common widget/toast.dart';
import '../Home/user_not_login_home_screen.dart';

class UpdateBook extends StatefulWidget {
  final String email;
  final String usertype;
  final String jwttoken;

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

  Future<void> checkJWTExpiationAdmin() async {
    try {
      //check jwt called in admin home screen.
      print("check jwt called in admin home screen.");
      int result = await checkJwtToken_initistate_admin(
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

  final TextEditingController bookIdController = TextEditingController();
  final TextEditingController bookNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController formatController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController languageController = TextEditingController();
  final TextEditingController availableQuantityController =
      TextEditingController();

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
          'Authorization': 'Bearer ${widget.jwttoken}',
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
        title: Text(
          "Update Book",
          style: TextStyle(fontFamily: bold, fontSize: 24, color: Colors.white),
        ),
        backgroundColor: Colors.green[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CommonTextField_obs_false(
              "Book ID",
              "",
              false,
              bookIdController,
              context,
            ),
            CommonTextField_obs_false(
              "Book Name",
              "",
              false,
              bookNameController,
              context,
            ),
            CommonTextField_obs_false(
              "Price",
              "",
              false,
              priceController,
              context,
            ),
            CommonTextField_obs_false(
              "Format",
              "",
              false,
              formatController,
              context,
            ),
            CommonTextField_obs_false(
              "Title",
              "",
              false,
              titleController,
              context,
            ),
            CommonTextField_obs_false(
              "Language",
              "",
              false,
              languageController,
              context,
            ),
            CommonTextField_obs_false(
              "Available Quantity",
              "",
              false,
              availableQuantityController,
              context,
            ),
            Commonbutton(
              "Update Book",
              () async {
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
                    Toastget().Toastmsg("Invalid Book ID.");
                    return;
                  }

                  final price = double.tryParse(priceController.text);
                  if (price == null || price <= 0) {
                    Toastget().Toastmsg("Price must be greater than 0.");
                    return;
                  }

                  final quantity = int.tryParse(
                    availableQuantityController.text,
                  );
                  if (quantity == null || quantity < 0) {
                    Toastget().Toastmsg("Quantity must be 0 or more.");
                    return;
                  }

                  if (bookNameController.text.length > 50 ||
                      formatController.text.length > 50 ||
                      titleController.text.length > 50 ||
                      languageController.text.length > 50) {
                    Toastget().Toastmsg("Fields cannot exceed 50 characters.");
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
              context,
              Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
