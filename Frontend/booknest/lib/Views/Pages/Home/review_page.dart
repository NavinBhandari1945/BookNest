import 'dart:convert';

import 'package:booknest/Views/Pages/Home/user_not_login_home_screen.dart';
import 'package:booknest/Views/common%20widget/commonbutton.dart';
import 'package:booknest/Views/common%20widget/commontextfield_obs_false.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';
import '../../../constant/constant.dart';
import '../../../constant/styles.dart';
import '../../common widget/common_method.dart';
import '../../common widget/toast.dart';

// Widget definition section
class RreviewPage extends StatefulWidget {
  final String email;
  final String usertype;
  final String jwttoken;
  const RreviewPage({super.key, required this.jwttoken, required this.usertype, required this.email});
  @override
  State<RreviewPage> createState() => _RreviewPageState();
}

// State management and initialization section
class _RreviewPageState extends State<RreviewPage> {
  final comment_cont = TextEditingController();
  final rating_cont = TextEditingController();
  final review_date = TextEditingController();
  final book_id = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkJWTExpiationmember();
  }

  Future<void> checkJWTExpiationmember() async {
    try {
      print("check jwt called in addreview screen.");
      int result = await checkJwtToken_initistate_member(
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

  Future<int> Add_Review({
    required int BookId,
    required String Email,
    required String Comment,
    required int Rating,
    required String ReviewDate,
  }) async {
    try {
      print("Adding review start");
      Map<String, dynamic> BodyData = {
        "ReviewId": 0,
        "Comment": Comment,
        "Rating": Rating,
        "ReviewDate": ReviewDate,
        "Email": widget.email,
        "BookId": BookId
      };
      const String url = Backend_Server_Url + "api/Member/add_reviews";
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${widget.jwttoken}',
        },
        body: json.encode(BodyData),
      );
      if (response.statusCode == 200) {
        Toastget().Toastmsg("Adding review success.");
        return 1;
      } else if (response.statusCode == 501) {
        Toastget().Toastmsg("Session end.Relogin please.");
        await clearUserData();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const UserNotLoginHomeScreen(),
          ),
        );
        return 2;
      } else if (response.statusCode == 502) {
        Toastget().Toastmsg(
          "Adding review failed.Incorrect review data format.Try again.",
        );
        return 3;
      } else if (response.statusCode == 505) {
        Toastget().Toastmsg(
          "User haven't order items or the order status pending.First successfully order  and then try again.",
        );
        return 5;
      } else if (response.statusCode == 500) {
        print("Error.other status code.");
        print("Response body: ${response.body}");
        final decoded = json.decode(response.body);
        print("Error message: ${decoded['message']}");
        print("Stack trace: ${decoded['stackTrace']}");
        Toastget().Toastmsg(
          "Exception caught in backend.Try again.",
        );
        return 5;
      } else {
        print("Error.other status code= ${response.statusCode}");
        Toastget().Toastmsg("Adding review failed.");
        return 4;
      }
    } catch (obj) {
      print("Exception caught while inserting review data in http method.");
      print(obj.toString());
      Toastget().Toastmsg("Adding review failed.");
      return 0;
    }
  }

  // UI building section
  @override
  Widget build(BuildContext context) {
    var shortestval = MediaQuery.of(context).size.shortestSide;
    var widthval = MediaQuery.of(context).size.width;
    var heightval = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          "Review Screen",
          style: TextStyle(
            fontFamily: bold,
            fontSize: 22,
            color: Colors.white,
            letterSpacing: 1.0,
          ),
        ),
        backgroundColor: Colors.green[800],
        elevation: 5,
        shadowColor: Colors.black54,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green[50]!.withOpacity(0.9),
              Colors.white.withOpacity(0.95)
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Form header
              Padding(
                padding: EdgeInsets.symmetric(vertical: heightval * 0.02),
                child: Text(
                  'Add Your Review',
                  style: TextStyle(
                    fontSize: widthval * 0.045,
                    fontFamily: bold,
                    color: Colors.green[900],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Form fields section
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: EdgeInsets.symmetric(vertical: heightval * 0.01),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonTextField_obs_false(
                        "Enter Book ID",
                        "",
                        false,
                        book_id,
                        context,
                      ),
                      SizedBox(height: heightval * 0.02),
                      // Wrapping Comment field in a custom TextField for multi-line support
                      TextField(
                        controller: comment_cont,
                        maxLines: 3,
                        style: TextStyle(fontSize: widthval * 0.04),
                        decoration: InputDecoration(
                          labelText: "Enter Comment",
                          labelStyle: TextStyle(
                            fontSize: widthval * 0.04,
                            color: Colors.green[800],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Colors.green[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Colors.green[800]!),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 16.0,
                          ),
                        ),
                      ),
                      SizedBox(height: heightval * 0.02),
                      CommonTextField_obs_false(
                        "Enter Rating (1-5)",
                        "1-5",
                        false,
                        rating_cont,
                        context,
                      ),
                      SizedBox(height: heightval * 0.02),
                      CommonTextField_obs_false(
                        "Enter Review Date",
                        "YYYY-MM-DD",
                        false,
                        review_date,
                        context,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: heightval * 0.03),
              // Submit button section
              Commonbutton(
                "Submit Review",
                    () async {
                  try {
                    if (
                    book_id.text.toString().isEmptyOrNull ||
                        comment_cont.text.toString().isEmptyOrNull ||
                        rating_cont.text.toString().isEmptyOrNull ||
                        review_date.text.toString().isEmptyOrNull) {
                      print("Incorrect enter data format.");
                      Toastget().Toastmsg("Incorrect enter data format.");
                      return;
                    }
                    int? Rating_Id = int.tryParse(rating_cont.text.toString());
                    if (Rating_Id! <= 0 && Rating_Id! >= 6) {
                      print("Incorrect rating data format.");
                      Toastget().Toastmsg("Incorrect rating data format.");
                      return;
                    }

                    int? IntBook_Id = int.tryParse(book_id.text.toString());

                    final Review_Result = await Add_Review(
                      BookId: IntBook_Id!,
                      Email: widget.email,
                      Comment: comment_cont.text.toString(),
                      Rating: Rating_Id!,
                      ReviewDate: review_date.text.toString(),
                    );
                    print(Review_Result);
                  } catch (obj) {
                    print(obj.toString());
                    Toastget().Toastmsg("Review details adding failed.Try again.");
                  }
                },
                context,
                Colors.green[800]!,
              ),
              SizedBox(height: heightval * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}