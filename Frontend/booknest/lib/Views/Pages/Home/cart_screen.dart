import 'dart:convert';

import 'package:booknest/Views/Pages/Home/cart_details_screen.dart';
import 'package:booknest/Views/Pages/Home/user_not_login_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';

import '../../../Models/CartUserBookModel.dart';
import '../../../constant/constant.dart';
import '../../../constant/styles.dart';
import '../../common widget/common_method.dart';
import '../../common widget/toast.dart';
import 'member_login_page.dart';

class CartScreen extends StatefulWidget {
  final String email;
  final String usertype;
  final String jwttoken;
  const CartScreen({super.key,required this.jwttoken,required this.usertype,required this.email});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  @override
  void initState() {
    super.initState();
    checkJWTExpiationmember();
  }

  Future<void> checkJWTExpiationmember() async {
    try {
      //check jwt called in admin home screen.
      print("check jwt called in book screen.");
      int result = await checkJwtToken_initistate_member(
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
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserNotLoginHomeScreen()));
      Toastget().Toastmsg("Error. Relogin please.");
    }
  }


  List<CartUserBookModel> CartInfoList=[];
  List<CartUserBookModel> CurrentUserCartInfoList=[];


  Future<int> Get_CartInfo() async {
    try {
      const String url = Backend_Server_Url + "api/Member/getcartuserbooks";
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json", 'Authorization': 'Bearer ${widget.jwttoken}'},
      );
      if (response.statusCode == 200) {
        List<dynamic> responseData = await jsonDecode(response.body);
        print("response body");
        print(responseData);
        CartInfoList.clear();
        CartInfoList.addAll(responseData.map((data) => CartUserBookModel.fromJson(data)).toList());
        print("Cart list count value");
        print(CartInfoList.length);
        print(CartInfoList[0].bookName);
        // Populate CurrentUserCartInfoList based on widget.email
        CurrentUserCartInfoList.clear();
        CurrentUserCartInfoList.addAll(
          CartInfoList.where((cartItem) => cartItem.email == widget.email).toList(),
        );
        print("Current user cart list count: ${CurrentUserCartInfoList.length}");
        return 1;
      } else {
        CartInfoList.clear();
        print("Data insert in cart info list failed.");
        return 2;
      }
    } catch (obj) {
      CartInfoList.clear();
      print("Exception caught while fetching cart data in http method");
      print(obj.toString());
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
        title: const Text(
        "Book Screen",
        style: TextStyle(
        fontFamily: bold,
        fontSize: 24,
        color: Colors.white,
        letterSpacing: 1.2,
    ),
    ),
    backgroundColor: Colors.green[700],
    elevation: 4,
    shadowColor: Colors.black45
        ),
      body: Container(
        width: widthval,
        height: heightval,
        child:
      SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(child: Text("Book screen"),).onTap((){
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => MemberHomePage(jwttoken:widget.jwttoken!, usertype:widget.usertype, email: widget.email,)
                ),
              );
            }),


            FutureBuilder<void> (
                future: Get_CartInfo(),
                builder: (context, snapshot)
                {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Show a loading indicator while the future is executing
                    return Center(child: CircularProgressIndicator());
                  }
                  else if (snapshot.hasError) {
                    // Handle any error from the future
                    return Center(
                      child: Text(
                        "Error fetching campaigns data. Please reopen app.",
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    );
                  }
                  else if (snapshot.connectionState == ConnectionState.done)
                  {
                    return CartInfoList.isEmpty
                        ? const Center(child: Text("No cart data available."))
                        :
                    Container(
                      color: Colors.grey,
                      width: widthval,
                      height: heightval,
                      child:
                      Builder(builder: (context)
                      {
                          return
                            ListView.builder(
                                itemBuilder: (context, index)
                                {
                                  final cart = CurrentUserCartInfoList[index];
                                  return Card(
                                    child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundImage: MemoryImage(
                                            base64Decode(cart.photo!),
                                          ),
                                        ),
                                        title: Text(cart.bookName!,style: TextStyle(fontFamily: semibold,fontSize: shortestval*0.05)),
                                        subtitle: Text("${cart.quantity!}",style: TextStyle(fontFamily: semibold,fontSize: shortestval*0.05)),
                                        trailing: Text("${cart.addedAt!}",style: TextStyle(fontFamily: semibold,fontSize: shortestval*0.05))
                                    ),
                                  )
                                      .onTap (()
                                  {
                                    Navigator.push(context,MaterialPageRoute(builder: (context) {
                                      return CartDetailsScreen(
                                          jwttoken:widget.jwttoken,
                                          usertype: widget.usertype,
                                          email: widget.email,
                                          cartId:cart.cartId,
                                          addedAt: cart.addedAt,
                                          quantity: cart.quantity,
                                          cartUserId: cart.cartUserId,
                                          cartBookId: cart.cartBookId,
                                          bookName: cart.bookName,
                                          price: cart.price,
                                          format: cart.format,
                                          title:cart.title,
                                          author: cart.author,
                                          publisher: cart.publisher,
                                          publicationDate: cart.publicationDate,
                                          language: cart.language,
                                          category: cart.category,
                                          listedAt: cart.listedAt,
                                          availableQuantity: cart.availableQuantity,
                                          discountPercent: cart.discountPercent,
                                          discountStart: cart.discountStart,
                                          discountEnd: cart.discountEnd,
                                          photo: cart.photo
                                      );
                                    },
                                    )
                                    );
                                  }
                                  );
                                },
                                itemCount: CurrentUserCartInfoList.length
                            );
                      },
                      ),
                    );

                  }//connection sattae wdone
                  else
                  {
                    return
                      Center(
                        child: Text(
                          "Please reopen app.",
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      );
                  }
                }
            ),




          ],
        ),
      ),),

    );
  }
}
