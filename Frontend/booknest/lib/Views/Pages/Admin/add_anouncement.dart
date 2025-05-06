import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
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

class AddAnnouncementPage extends StatefulWidget {
  final String email;
  final String usertype;
  final String jwttoken;
  const AddAnnouncementPage({
    super.key,
    required this.jwttoken,
    required this.usertype,
    required this.email,
  });

  @override
  State<AddAnnouncementPage> createState() => _AddAnnouncementPageState();
}

class _AddAnnouncementPageState extends State<AddAnnouncementPage> {
  @override
  void initState() {
    super.initState();
    checkJWTExpiationAdmin();
  }

  Future<void> checkJWTExpiationAdmin() async {
    try {
      //check jwt called in admin home screen.
      print("check jwt called in add announcement user.");
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

  final Pick_Photo_Cont = Get.put(PickSinglePhotoGetxInt());
  final TextEditingController Message_Cont = TextEditingController();
  final TextEditingController Title_Cont = TextEditingController();
  final TextEditingController StartDate_Cont = TextEditingController();
  final TextEditingController EndDate_Cont = TextEditingController();

  Future<int> Add_Announcement({
    required String Message,
    required String Tittle,
    required String StartDate,
    required String EndDate,
    required Imagebytes,
  }) async {
    try {

      final String base64Image = base64Encode(Imagebytes as List<int>);

      // Construct the JSON payload
      Map<String, dynamic> Body_Data = {
        "AnnouncementId": 0,
        "Message": Message,
        "Title": Tittle,
        "Photo": base64Image,
        "StartDate": StartDate,
        "EndDate": EndDate,
      };

      const String url = Backend_Server_Url + "api/Admin/add_announcement";

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${widget.jwttoken}',
        },
        body: json.encode(Body_Data),
      );

      if (response.statusCode == 200) {
        print("Status code.");
        print("Response body: ${response.statusCode}");
        Toastget().Toastmsg("Adding announceemnt success.");
        return 1;
      } else if (response.statusCode == 501) {
        Toastget().Toastmsg(
          "Adding announceemnt failed.Incorrect announceemnt data format.Try again.",
        );
        return 11;
      } else if (response.statusCode == 502) {
        Toastget().Toastmsg(
          "Adding announceemnt failed.Incorrect start and end date.Try again.",
        );
        return 11;
      } else if (response.statusCode == 500) {
        print("Error.other status code.");
        print("Response body: ${response.statusCode}");
        final decoded = json.decode(response.body);
        print("Error message: ${decoded['message']}");
        print("Stack trace: ${decoded['stackTrace']}");
        Toastget().Toastmsg(
          "Adding announceemnt failed: ${decoded['message']}",
        );
        return 4;
      } else {
        print("Error.other status code.");
        print("Response statuscode: ${response.statusCode}");
        Toastget().Toastmsg("Adding announceemnt failed.");
        return 4;
      }
    } catch (obj) {
      print("Exception caught while inserting announceemnt in http method.");
      print(obj.toString());
      Toastget().Toastmsg("Adding announceemnt failed.");
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
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              CommonTextField_obs_false(
                "Enter message.",
                "",
                false,
                Message_Cont,
                context,
              ),
              CommonTextField_obs_false(
                "Enter title.",
                "",
                false,
                Title_Cont,
                context,
              ),
              CommonTextField_obs_false(
                "Enter start date.",
                "",
                false,
                StartDate_Cont,
                context,
              ),
              CommonTextField_obs_false(
                "Enter dend date.",
                "",
                false,
                EndDate_Cont,
                context,
              ),
              Commonbutton(
                "Pick photo",
                () async {
                  try {
                    final Pick_Photo_Result = await Pick_Photo_Cont.pickImage();
                    print(Pick_Photo_Result.toString());
                  } catch (obj) {
                    print(obj.toString());
                    Toastget().Toastmsg("Image pick failed.Try again.");
                  }
                },
                context,
                Colors.red,
              ),
              Commonbutton(
                "Add announcement",
                () async {
                  try {
                    if (Message_Cont.text.toString().isEmptyOrNull ||
                        Title_Cont.text.toString().isEmptyOrNull ||
                        StartDate_Cont.text.toString().isEmptyOrNull ||
                        EndDate_Cont.text.toString().isEmptyOrNull) {
                      print("Incorrect data format.");
                      Toastget().Toastmsg("Incorrect data format.");
                      return;
                    }

                    final Start_Date = DateTime.tryParse(
                      StartDate_Cont.text,
                    );
                    final End_Date = DateTime.tryParse(
                      EndDate_Cont.text,
                    );

                    if (Start_Date!.isAfter(End_Date!) == true ||
                        End_Date!.isBefore(Start_Date) == true) {
                      print(
                        "Incorrect start or end date date.",
                      );
                      Toastget().Toastmsg(
                        "Incorrect start or end date date.",
                      );
                      return;
                    }

                    final Result = await Add_Announcement(
                      Imagebytes: Pick_Photo_Cont.imageBytes.value,
                      Message: Message_Cont.text.toString(),
                      Tittle: Title_Cont.text.toString(),
                      StartDate: StartDate_Cont.text.toString(),
                      EndDate: EndDate_Cont.text.toString(),
                    );
                    print(Result);
                  } catch (Obj) {
                    print(Obj.toString());
                    Toastget().Toastmsg("Incorrect data validation.");
                    return;
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
