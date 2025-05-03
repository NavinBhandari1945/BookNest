import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;


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
  const AddBook({super.key,required this.jwttoken,required this.usertype,required this.email});
  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  final Pick_Photo_Cont=Get.put(PickSinglePhotoGetxInt());
  @override
  void initState() {
    super.initState();
    checkJWTExpiationAdmin();
  }

  Future<void> checkJWTExpiationAdmin() async {
    try {
      //check jwt called in admin home screen.
      print("check jwt called in change user role screen.");
      int result = await checkJwtToken_initistate_admin(
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

  final TextEditingController bookNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController formatController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController publisherController = TextEditingController();
  final TextEditingController publicationDateController = TextEditingController();
  final TextEditingController languageController = TextEditingController();
  final TextEditingController listedAtController = TextEditingController();
  final TextEditingController CategoryController = TextEditingController();
  final TextEditingController availableQuantityController = TextEditingController();
  final TextEditingController discountPercentController = TextEditingController();
  final TextEditingController discountStartController = TextEditingController();
  final TextEditingController discountEndController = TextEditingController();

  // // Dispose controllers to prevent memory leaks
  // void dispose() {
  //   bookNameController.dispose();
  //   priceController.dispose();
  //   formatController.dispose();
  //   titleController.dispose();
  //   authorController.dispose();
  //   publisherController.dispose();
  //   publicationDateController.dispose();
  //   languageController.dispose();
  //   // listedAtController.dispose();
  //   availableQuantityController.dispose();
  //   discountPercentController.dispose();
  //   discountStartController.dispose();
  //   discountEndController.dispose();
  // }

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
    required imagebytes

  }) async {
    try {
      final String base64Image = base64Encode(imagebytes as List<int>);
      // Construct the JSON payload
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
        "Photo":base64Image
      };

      const String url = Backend_Server_Url + "api/Admin/add_book";

      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json", 'Authorization': 'Bearer ${widget.jwttoken}'},
        body: json.encode(bookData),
      );

      if (response.statusCode == 200) {
        Toastget().Toastmsg("Adding book success.");
        return 1;
      }  else if (response.statusCode == 501) {
        Toastget().Toastmsg("Adding book failed.Incorrect book data format.Try again.");
        return 11; // jwt error
      } else {
        print("Error.other status code.");
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
    var shortestval = MediaQuery.of(context).size.shortestSide;
    var widthval = MediaQuery.of(context).size.width;
    var heightval = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
        "Admin",
        style: TextStyle(fontFamily: bold, fontSize: 24, color: Colors.white, letterSpacing: 1.2),
    ),
    backgroundColor: Colors.green[700],
    elevation: 4,
    shadowColor: Colors.black45,
    ),
    body:Container(
      width: widthval,
      height: heightval,
      child:
      SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Column(
          children:
          [
            CommonTextField_obs_false("Enter book name.", "", false, bookNameController, context),
            CommonTextField_obs_false("Enter price.", "", false, priceController, context),
            CommonTextField_obs_false("Enter format.", "", false, formatController, context),
            CommonTextField_obs_false("Enter title.", "", false, titleController, context),
            CommonTextField_obs_false("Enter author.", "", false, authorController, context),
            CommonTextField_obs_false("Enter publisher.", "", false, publisherController, context),
            CommonTextField_obs_false("Enter publication date.", "", false, publicationDateController, context),
            CommonTextField_obs_false("Enter language.", "", false, languageController, context),
            CommonTextField_obs_false("Enter listed at date.", "", false, listedAtController, context),
            CommonTextField_obs_false("Enter available quantity.", "", false, availableQuantityController, context),
            CommonTextField_obs_false("Enter the book category.", "", false, CategoryController, context),
            CommonTextField_obs_false("Enter discount percent.", "", false, discountPercentController, context),
            CommonTextField_obs_false("Enter discount start date.", "", false, discountStartController, context),
            CommonTextField_obs_false("Enter discount end date.", "", false, discountEndController, context),
            Commonbutton("Pick photo", ()async{

              final Pick_Photo_Result=await Pick_Photo_Cont.pickImage();
              print(Pick_Photo_Result.toString());



            }, context, Colors.red),
            Commonbutton("Add book", ()async{
              try{
                final double_book_price=double.tryParse(priceController.text.toString());
                final book_quantity=int.tryParse(availableQuantityController.text.toString());
                final book_discount_percent=double.tryParse(discountPercentController.text.toString());
                final Result=await Add_Book(
                    BookName:bookNameController.text.toString(),
                    Price: double_book_price!,
                    Format: formatController.text.toString(),
                    Title: titleController.text.toString(),
                    Author: authorController.text.toString(),
                    Publisher: publisherController.text.toString(),
                    PublicationDate: publicationDateController.text,
                    Language: languageController.text.toString(),
                    Category: CategoryController.text.toString(),
                    AvailableQuantity:book_quantity!,
                    DiscountPercent:book_discount_percent!,
                    DiscountStart:discountStartController.text,
                    DiscountEnd: discountEndController.text,
                  ListedAt: listedAtController.text,
                  imagebytes: Pick_Photo_Cont.imageBytes.value
                );
                print(Result);
              }catch(Obj){
                print(Obj.toString());
                Toastget().Toastmsg("Incorrect data validation.");
                return;
              }
            }, context, Colors.red)
          ],
        ),
      ),


    ),

    );
  }
}
