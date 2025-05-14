import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';

import '../../../constant/constant.dart';
import '../../../constant/styles.dart';
import '../../common widget/common_method.dart';
import '../../common widget/commonbutton.dart';
import '../../common widget/commontextfield_obs_false.dart';
import '../../common widget/getx_cont_pick_single_photo_int.dart';
import '../../common widget/toast.dart';
import '../Home/user_not_login_home_screen.dart';

class AddBook extends StatefulWidget {
  final String email;
  final String usertype;
  final String jwttoken;
  const AddBook({super.key, required this.jwttoken, required this.usertype, required this.email});
  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  final Pick_Photo_Cont = Get.put(PickSinglePhotoGetxInt());
  @override
  void initState() {
    super.initState();
    checkJWTExpiationAdmin();
  }

  Future<void> checkJWTExpiationAdmin() async {
    try {
      print("check jwt called in change user role screen.");
      int result = await checkJwtToken_initistate_admin(
          widget.email, widget.usertype, widget.jwttoken);
      if (result == 0) {
        await clearUserData();
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => UserNotLoginHomeScreen()));
        Toastget().Toastmsg("Session End. Relogin please.");
      }
    } catch (obj) {
      print("Exception caught while verifying jwt for admin home screen.");
      print(obj.toString());
      await clearUserData();
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => UserNotLoginHomeScreen()));
      Toastget().Toastmsg("Error. Relogin please.");
    }
  }

  final TextEditingController bookNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController formatController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController publisherController = TextEditingController();
  final TextEditingController publicationDateController = TextEditingController();
  final TextEditingController languageController = TextEditingController();
  final TextEditingController listedAtController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController availableQuantityController = TextEditingController();
  final TextEditingController discountPercentController = TextEditingController();
  final TextEditingController discountStartController = TextEditingController();
  final TextEditingController discountEndController = TextEditingController();

  Future<int> Add_Book({
    required String BookName,
    required double Price,
    required String Format,
    required String Title,
    required String Author,
    required String Publisher,
    required String PublicationDate,
    required String Language,
    required String Category,
    required int AvailableQuantity,
    required double DiscountPercent,
    required String DiscountStart,
    required String DiscountEnd,
    required String ListedAt,
    required imagebytes,
  }) async {
    try {
      final String base64Image = base64Encode(imagebytes as List<int>);
      Map<String, dynamic> bookData = {
        "BookId": 0,
        "BookName": BookName,
        "Price": Price,
        "Format": Format,
        "Title": Title,
        "Author": Author,
        "Publisher": Publisher,
        "PublicationDate": PublicationDate,
        "Language": Language,
        "Category": Category,
        "ListedAt": ListedAt,
        "AvailableQuantity": AvailableQuantity,
        "DiscountPercent": DiscountPercent,
        "DiscountStart": DiscountStart,
        "DiscountEnd": DiscountEnd,
        "Photo": base64Image,
      };

      const String url = Backend_Server_Url + "api/Admin/add_book";

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${widget.jwttoken}',
        },
        body: json.encode(bookData),
      );

      if (response.statusCode == 200) {
        Toastget().Toastmsg("Adding book success.");
        return 1;
      } else if (response.statusCode == 501) {
        Toastget().Toastmsg("Adding book failed. Incorrect book data format. Try again.");
        return 11;
      } else {
        print("Error: other status code.");
        print("Response body: ${response.body}");
        final decoded = json.decode(response.body);
        print("Error message: ${decoded['message']}");
        print("Stack trace: ${decoded['stackTrace']}");
        Toastget().Toastmsg("Adding book failed: ${decoded['message']}");
        return 4;
      }
    } catch (obj) {
      print("Exception caught while inserting post in http method.");
      print(obj.toString());
      Toastget().Toastmsg("Adding book failed.");
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          "Add Book",
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
                  _buildSectionHeader("Book Details"),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: bookNameController,
                    hint: "Enter book name",
                    icon: Icons.book,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: titleController,
                    hint: "Enter title",
                    icon: Icons.title,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: authorController,
                    hint: "Enter author",
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: publisherController,
                    hint: "Enter publisher",
                    icon: Icons.business,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: publicationDateController,
                    hint: "Enter publication date (YYYY-MM-DD)",
                    icon: Icons.calendar_today,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: languageController,
                    hint: "Enter language",
                    icon: Icons.language,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: categoryController,
                    hint: "Enter category",
                    icon: Icons.category,
                  ),
                  const SizedBox(height: 24),
                  _buildSectionHeader("Pricing & Availability"),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: priceController,
                    hint: "Enter price",
                    icon: Icons.attach_money,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: formatController,
                    hint: "Enter format (e.g., Hardcover, Paperback)",
                    icon: Icons.description,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: availableQuantityController,
                    hint: "Enter available quantity",
                    icon: Icons.inventory,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: listedAtController,
                    hint: "Enter listed date (YYYY-MM-DD)",
                    icon: Icons.event,
                  ),
                  const SizedBox(height: 24),
                  _buildSectionHeader("Discount Details"),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: discountPercentController,
                    hint: "Enter discount percent",
                    icon: Icons.discount,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: discountStartController,
                    hint: "Enter discount start date (YYYY-MM-DD)",
                    icon: Icons.calendar_today,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: discountEndController,
                    hint: "Enter discount end date (YYYY-MM-DD)",
                    icon: Icons.calendar_today,
                  ),
                  const SizedBox(height: 24),
                  _buildSectionHeader("Book Cover"),
                  const SizedBox(height: 12),
                  Obx(
                        () => _buildButton(
                      title: "Pick Photo",
                      icon: Icons.photo,
                      onPressed: () async {
                        try {
                          final Pick_Photo_Result = await Pick_Photo_Cont.pickImage();
                          print(Pick_Photo_Result.toString());
                        } catch (obj) {
                          print(obj.toString());
                          Toastget().Toastmsg("Review details adding failed. Try again.");
                        }
                      },
                      color: Pick_Photo_Cont.imageBytes.value == null ? Colors.red : Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildButton(
                    title: "Add Book",
                    icon: Icons.add_circle,
                    onPressed: () async {
                      try {
                        if (bookNameController.text.isEmptyOrNull ||
                            priceController.text.isEmptyOrNull ||
                            formatController.text.isEmptyOrNull ||
                            titleController.text.isEmptyOrNull ||
                            authorController.text.isEmptyOrNull ||
                            publisherController.text.isEmptyOrNull ||
                            publicationDateController.text.isEmptyOrNull ||
                            languageController.text.isEmptyOrNull ||
                            listedAtController.text.isEmptyOrNull ||
                            categoryController.text.isEmptyOrNull ||
                            availableQuantityController.text.isEmptyOrNull ||
                            discountPercentController.text.isEmptyOrNull ||
                            discountStartController.text.isEmptyOrNull ||
                            discountEndController.text.isEmptyOrNull) {
                          print("Incorrect data format.");
                          Toastget().Toastmsg("Incorrect data format.");
                          return;
                        }

                        final double_book_price = double.tryParse(priceController.text.toString());
                        final book_quantity = int.tryParse(availableQuantityController.text.toString());
                        final book_discount_percent = double.tryParse(discountPercentController.text.toString());

                        if (book_discount_percent! > 0) {
                          final Current_Date = DateTime.now().toUtc();
                          final Start_Date = DateTime.tryParse(discountStartController.text);
                          final End_Date = DateTime.tryParse(discountEndController.text);
                          print("start date = ${Start_Date}");
                          print("current date = ${Current_Date}");
                          print("end date = ${End_Date}");
                          if (Start_Date!.isBefore(End_Date!) == false ||
                              End_Date.isAfter(Current_Date) == false
                              ) {
                            print("Incorrect date format discount percent greater then 0.");
                            Toastget().Toastmsg("Incorrect  start date and end date format.Start date must be before end date and end date must be after current date..");
                            return;
                          }
                        }

                        final Current_Date = DateTime.now().toUtc();
                        final Listed_Date = DateTime.tryParse(listedAtController.text);
                        final Publication_Date = DateTime.tryParse(publicationDateController.text);

                        if (Listed_Date!.isAfter(Current_Date) == true ||
                            Publication_Date!.isBefore(Current_Date) == false) {
                          print("Incorrect listed or publication date format.");
                          Toastget().Toastmsg("Incorrect date format.");
                          return;
                        }

                        final Result = await Add_Book(
                          BookName: bookNameController.text.toString(),
                          Price: double_book_price!,
                          Format: formatController.text.toString(),
                          Title: titleController.text.toString(),
                          Author: authorController.text.toString(),
                          Publisher: publisherController.text.toString(),
                          PublicationDate: publicationDateController.text,
                          Language: languageController.text.toString(),
                          Category: categoryController.text.toString(),
                          AvailableQuantity: book_quantity!,
                          DiscountPercent: book_discount_percent!,
                          DiscountStart: discountStartController.text,
                          DiscountEnd: discountEndController.text,
                          ListedAt: listedAtController.text,
                          imagebytes: Pick_Photo_Cont.imageBytes.value,
                        );
                        print(Result);
                      } catch (obj) {
                        print(obj.toString());
                        Toastget().Toastmsg("Incorrect data validation.");
                        return;
                      }
                    },
                    color: const Color(0xFF2E7D32),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

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
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
      ),
    );
  }

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
              Icon(Icons.arrow_forward_ios, color: Colors.white.withOpacity(0.7), size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

