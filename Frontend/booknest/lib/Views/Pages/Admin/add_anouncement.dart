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
        print("Response body: ${response.statusCode}");
        Toastget().Toastmsg("Adding announcement success.");
        return 1;
      } else if (response.statusCode == 501) {
        Toastget().Toastmsg(
          "Adding announcement failed. Incorrect announcement data format. Try again.",
        );
        return 11;
      } else if (response.statusCode == 502) {
        Toastget().Toastmsg(
          "Adding announcement failed. Incorrect start and end date. Try again.",
        );
        return 11;
      } else if (response.statusCode == 500) {
        print("Response body: ${response.statusCode}");
        final decoded = json.decode(response.body);
        print("Error message: ${decoded['message']}");
        print("Stack trace: ${decoded['stackTrace']}");
        Toastget().Toastmsg(
          "Adding announcement failed: ${decoded['message']}",
        );
        return 4;
      } else {
        print("Response statuscode: ${response.statusCode}");
        Toastget().Toastmsg("Adding announcement failed.");
        return 4;
      }
    } catch (obj) {
      print("Exception caught while inserting announcement in http method.");
      print(obj.toString());
      Toastget().Toastmsg("Adding announcement failed.");
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          "Add Announcement",
          style: TextStyle(
            fontFamily: bold,
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 1.5,
          ),
        ),
        backgroundColor: const Color(0xFF1A3C34), // Deep forest green
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
              Color(0xFFF5F6F5), // Light gray-green
              Color(0xFFE8ECEF), // Soft white-blue
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
                  _buildSectionHeader("Announcement Details"),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: Title_Cont,
                    hint: "Enter title",
                    icon: Icons.title,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: Message_Cont,
                    hint: "Enter message",
                    icon: Icons.message,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: StartDate_Cont,
                    hint: "Enter start date (YYYY-MM-DD)",
                    icon: Icons.calendar_today,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: EndDate_Cont,
                    hint: "Enter end date (YYYY-MM-DD)",
                    icon: Icons.calendar_today,
                  ),
                  const SizedBox(height: 24),
                  _buildSectionHeader("Photo"),
                  const SizedBox(height: 12),

                  Obx(
                    ()=> _buildButton(
                      title: "Pick Photo",
                      icon: Icons.photo,
                      onPressed: () async {
                        try {
                          final Pick_Photo_Result = await Pick_Photo_Cont.pickImage();
                          print(Pick_Photo_Result.toString());
                        } catch (obj) {
                          print(obj.toString());
                          Toastget().Toastmsg("Image pick failed. Try again.");
                        }
                      },
                      color: Pick_Photo_Cont.imageBytes.value==null?Colors.red:Colors.blue, // Vibrant blue
                    ),
                  ),


                  const SizedBox(height: 24),
                  _buildButton(
                    title: "Add Announcement",
                    icon: Icons.send,
                    onPressed: () async {
                      try {
                        if (Message_Cont.text.isEmptyOrNull ||
                            Title_Cont.text.isEmptyOrNull ||
                            StartDate_Cont.text.isEmptyOrNull ||
                            EndDate_Cont.text.isEmptyOrNull) {
                          print("Incorrect data format.");
                          Toastget().Toastmsg("Incorrect data format.");
                          return;
                        }
                        //
                        // final Current_Date = DateTime.now().toUtc();

                        final Start_Date = DateTime.tryParse(StartDate_Cont.text);
                        final End_Date = DateTime.tryParse(EndDate_Cont.text);


                        // if (Start_Date!.isBefore(Current_Date!)) {
                        //   print("Incorrect start date.Date must be today.");
                        //   Toastget().Toastmsg("Incorrect start date.Date must be today.");
                        //   return;
                        // }


                        if (Start_Date!.isAfter(End_Date!) ||
                            End_Date.isBefore(Start_Date)) {
                          print("Incorrect start or end date.");
                          Toastget().Toastmsg("Incorrect start or end date.");
                          return;
                        }

                        final Result = await Add_Announcement(
                          Imagebytes: Pick_Photo_Cont.imageBytes.value,
                          Message: Message_Cont.text,
                          Tittle: Title_Cont.text,
                          StartDate: StartDate_Cont.text,
                          EndDate: EndDate_Cont.text,
                        );
                        print(Result);
                      } catch (obj) {
                        print(obj.toString());

                        Toastget().Toastmsg("Incorrect data validation.");
                      }
                    },
                    color: const Color(0xFF2E7D32), // Vibrant green
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
          color: Color(0xFF1A3C34), // Deep forest green
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

