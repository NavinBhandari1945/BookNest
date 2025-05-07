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

class UpdateDiscount extends StatefulWidget {
  final String email;
  final String usertype;
  final String jwttoken;

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

  // TextEditingControllers
  final TextEditingController BookIdController = TextEditingController();
  final TextEditingController CategoryController = TextEditingController();
  final TextEditingController discountPercentController =
      TextEditingController();
  final TextEditingController discountStartController = TextEditingController();
  final TextEditingController discountEndController = TextEditingController();

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
          'Authorization': 'Bearer ${widget.jwttoken}',
        },
        body: json.encode(bookData),
      );

      if (response.statusCode == 200) {
        Toastget().Toastmsg("Update Discount success.");
        return 1;
      } else if (response.statusCode == 501) {
        Toastget().Toastmsg(
          "Updating book failed. Incorrect book data format. Try again.",
        );
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
    var widthval = MediaQuery.of(context).size.width;
    var heightval = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Admin",
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
      ),
      body: Container(
        width: widthval,
        height: heightval,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              CommonTextField_obs_false(
                "Enter Book ID",
                "",
                false,
                BookIdController,
                context,
              ),
              CommonTextField_obs_false(
                "Enter the book category",
                "",
                false,
                CategoryController,
                context,
              ),
              CommonTextField_obs_false(
                "Enter discount percent",
                "",
                false,
                discountPercentController,
                context,
              ),
              CommonTextField_obs_false(
                "Enter discount start date",
                "",
                false,
                discountStartController,
                context,
              ),
              CommonTextField_obs_false(
                "Enter discount end date",
                "",
                false,
                discountEndController,
                context,
              ),

              Commonbutton(
                "Update Discount",
                () async {
                  try {
                    if (BookIdController.text.toString().isEmptyOrNull ||
                        CategoryController.text.toString().isEmptyOrNull ||
                        discountPercentController.text
                            .toString()
                            .isEmptyOrNull ||
                        discountStartController.text.toString().isEmptyOrNull ||
                        discountEndController.text.toString().isEmptyOrNull) {
                      Toastget().Toastmsg("All fields are required");
                      return;
                    }

                    final bookId = int.tryParse(BookIdController.text);
                    if (bookId == null) {
                      Toastget().Toastmsg("Invalid Book ID format");
                      return;
                    }

                    final bookDiscountPercent = double.tryParse(
                      discountPercentController.text,
                    );
                    if (bookDiscountPercent == null ||
                        bookDiscountPercent <= 0) {
                      Toastget().Toastmsg(
                        "Discount percent must be a number greater than 0",
                      );
                      return;
                    }

                    final discountStart = DateTime.tryParse(
                      discountStartController.text,
                    );
                    final discountEnd = DateTime.tryParse(
                      discountEndController.text,
                    );
                    final currentDate = DateTime.now().toUtc();

                    if (discountStart == null || discountEnd == null) {
                      Toastget().Toastmsg("Invalid date format");
                      return;
                    }

                    if (discountStart.isBefore(currentDate) == true) {
                      Toastget().Toastmsg(
                        "Start date cannot be before current date",
                      );
                      return;
                    }

                    if (discountEnd.isBefore(discountStart)) {
                      Toastget().Toastmsg(
                        "End date cannot be before start date",
                      );
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
                      "Error occurred during validation or submission.",
                    );
                  }
                },
                context,
                Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
