import 'dart:convert';

import 'package:booknest/Views/common%20widget/commonbutton.dart';
import 'package:booknest/Views/common%20widget/commontextfield_obs_false.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';

import '../../../constant/constant.dart';
import '../../../constant/styles.dart';
import '../../common widget/common_method.dart';
import '../../common widget/toast.dart';
import '../Home/user_not_login_home_screen.dart';

class ClaimCodePage extends StatefulWidget {
  final String email;
  final String usertype;
  final String jwttoken;
  const ClaimCodePage({super.key,required this.jwttoken,required this.usertype,required this.email});

  @override
  State<ClaimCodePage> createState() => _ClaimCodePageState();
}

class _ClaimCodePageState extends State<ClaimCodePage> {

  final Claimcode_Id_cont=TextEditingController();
  final ClaimCode_Cont=TextEditingController();
  final Order_Id_Cont=TextEditingController();

  @override
  void initState() {
    super.initState();
    checkJWTExpiationmember();
  }

  Future<void> checkJWTExpiationmember() async {
    try {
      print("check jwt called in addreview screen.");
      int result = await checkJwtToken_initistate_staff(
          widget.email, widget.usertype, widget.jwttoken);
      if (result == 0)
      {
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


  Future<int> Claim_Order({
    required int OrderId,
    required String ClaimCode,
    required String ClaimId,
  }) async {
    try {
      print("Order claim start");
      // Construct the JSON payload
      Map<String, dynamic> BodyData = {
        "OrderId":OrderId,
        "ClaimCode": ClaimCode,
        "ClaimId": ClaimId,
      };
      const String url = Backend_Server_Url + "api/Staff/claim_code";
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${widget.jwttoken}',
        },
        body: json.encode(BodyData),
      );
      if (response.statusCode == 200) {
        Toastget().Toastmsg("Order claim success.");
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
          "Claim process failed.Incorrect claim data format.Try again.",
        );
        return 3; // jwt error
      }
      else if (response.statusCode == 503) {
        Toastget().Toastmsg(
          "Order invalid status.Data don't match.Try again.",
        );
        return 5;
      }
      else if (response.statusCode == 500) {
        print("Error.other status code = ${response.statusCode}");
        // print("Response body: ${response.body}");
        // final decoded = json.decode(response.body);
        // print("Error message: ${decoded['message']}");
        // print("Stack trace: ${decoded['stackTrace']}");
        Toastget().Toastmsg(
          "Exception caught in backend.Try again.",
        );
        return 5;
      }
      else {
        print("Error.other status code= ${response.statusCode}");
        Toastget().Toastmsg(" Claim process failed.");
        return 4;
      }
    } catch (obj) {
      print("Exception caught while Claim order in http method.");
      print(obj.toString());
      Toastget().Toastmsg("Checking Claim failed.");
      return 0;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "Staff",
            style: TextStyle(fontFamily: bold, fontSize: 24, color: Colors.white, letterSpacing: 1.2),
          ),
          backgroundColor: Colors.green[700],
          elevation: 4,
          shadowColor: Colors.black45,
        ),
        body:Container(
          child: Column(
            children: [
              CommonTextField_obs_false("Enter  order id.", "", false, Order_Id_Cont, context),
              CommonTextField_obs_false("Enter claim code id.", "", false, Claimcode_Id_cont, context),
              CommonTextField_obs_false("Enter claim code.", "", false, ClaimCode_Cont, context),
              10.heightBox,
              Commonbutton("Confirm", ()async{
                try {

                  if(Claimcode_Id_cont.text.isEmptyOrNull ||
                      ClaimCode_Cont.text.isEmptyOrNull ||
                  Order_Id_Cont.text.isEmptyOrNull
                  ){
                    print("Incorrect enter data format.");
                    Toastget().Toastmsg("Incorrect enter data format.");
                    return;
                  }

                  int? OrderId_Int=int.tryParse(Order_Id_Cont.text.toString());

                  final Claim_Code_Result=await Claim_Order(OrderId: OrderId_Int!, ClaimCode:ClaimCode_Cont.text.toString(), ClaimId:Claimcode_Id_cont.text.toString());
                  print(Claim_Code_Result);


                }catch(obj){
                  print(obj.toString());
                  Toastget().Toastmsg("Order claim fail.Try again.");
                }
              }, context, Colors.red)

            ],
          ),
        )

    );
  }
}
