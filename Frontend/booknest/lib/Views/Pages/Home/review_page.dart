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

class RreviewPage extends StatefulWidget {
  final String email;
  final String usertype;
  final String jwttoken;
  const RreviewPage({
    super.key,
    required this.jwttoken,
    required this.usertype,
    required this.email,
  });
  @override
  State<RreviewPage> createState() => _RreviewPageState();
}

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

  Future<int> Add_Review({
    required int BookId,
    required String Email,
    required String Comment,
    required int Rating,
    required String ReviewDate,
  }) async {
    try {
      print("Adding review start");
      // Construct the JSON payload
      Map<String, dynamic> BodyData = {
        "ReviewId": 0,
        "Comment": Comment,
        "Rating": Rating,
        "ReviewDate": ReviewDate,
        "Email": widget.email,
        "BookId": BookId,
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
        return 2; // jwt error
      } else if (response.statusCode == 502) {
        Toastget().Toastmsg(
          "Adding review failed.Incorrect review data format.Try again.",
        );
        return 3; // jwt error
      } else if (response.statusCode == 505) {
        Toastget().Toastmsg("Order invalid status.Try again.");
        return 5;
      } else if (response.statusCode == 500) {
        print("Error.other status code.");
        print("Response body: ${response.body}");
        final decoded = json.decode(response.body);
        print("Error message: ${decoded['message']}");
        print("Stack trace: ${decoded['stackTrace']}");
        Toastget().Toastmsg("Exception caught in backend.Try again.");
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
        child: Column(
          children: [
            CommonTextField_obs_false(
              "Enter Book Id",
              "",
              false,
              book_id,
              context,
            ),
            CommonTextField_obs_false(
              "Enter comment",
              "",
              false,
              comment_cont,
              context,
            ),

            CommonTextField_obs_false(
              "Enter rating",
              "1-5",
              false,
              rating_cont,
              context,
            ),

            CommonTextField_obs_false(
              "Enter review date",
              "2023-02-03",
              false,
              review_date,
              context,
            ),
            10.heightBox,
            Commonbutton(
              "Update",
              () async {
                try {
                  if (book_id.text.toString().isEmptyOrNull ||
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
                  Toastget().Toastmsg(
                    "Review details adding failed.Try again.",
                  );
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
