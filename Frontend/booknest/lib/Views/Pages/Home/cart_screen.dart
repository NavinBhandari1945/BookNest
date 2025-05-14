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
import '../../common widget/header_footer.dart';
import '../../common widget/toast.dart';
import 'member_login_page.dart';

// A StatefulWidget that displays a list of cart items for the current user.
class CartScreen extends StatefulWidget {
  final String email;
  final String usertype;
  final String jwttoken;
  const CartScreen({
    super.key,
    required this.jwttoken,
    required this.usertype,
    required this.email,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    // Check JWT token validity when the page initializes.
    checkJWTExpiationmember();
  }

  // Validates the JWT token and logs out the user if the session has expired.
  Future<void> checkJWTExpiationmember() async {
    try {
      print("check jwt called in book screen.");
      int result = await checkJwtToken_initistate_member(
          widget.email, widget.usertype, widget.jwttoken);
      if (result == 0) {
        // Clear user data and redirect to login screen if token is invalid.
        await clearUserData();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => UserNotLoginHomeScreen()));
        Toastget().Toastmsg("Session End. Relogin please.");
      }
    } catch (obj) {
      print("Exception caught while verifying jwt for admin home screen.");
      print(obj.toString());
      // Handle errors by clearing user data and redirecting to login screen.
      await clearUserData();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => UserNotLoginHomeScreen()));
      Toastget().Toastmsg("Error. Relogin please.");
    }
  }

  // Lists to store all cart items and the current user's cart items.
  List<CartUserBookModel> CartInfoList = [];
  List<CartUserBookModel> CurrentUserCartInfoList = [];

  // Fetches the cart items from the server for the current user.
  Future<int> Get_CartInfo() async {
    try {
      const String url = Backend_Server_Url + "api/Member/getcartuserbooks";
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${widget.jwttoken}'
        },
      );
      if (response.statusCode == 200) {
        // Parse the response data and populate the cart lists.
        List<dynamic> responseData = await jsonDecode(response.body);
        print("response body");
        print(responseData);
        CartInfoList.clear();
        CartInfoList.addAll(responseData.map((data) => CartUserBookModel.fromJson(data)).toList());
        print("Cart list count value");
        print(CartInfoList.length);
        print(CartInfoList[0].bookName);
        // Filter cart items for the current user based on their email.
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
    // Get screen dimensions for responsive design.
    var shortestval = MediaQuery.of(context).size.shortestSide;
    var widthval = MediaQuery.of(context).size.width;
    var heightval = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Cart Screen",
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
        // Apply a gradient background for a modern look.
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[700]!, Colors.green[100]!],
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              // Full-width header with user information.
              SizedBox(
                width: double.infinity,
                child: HeaderWidget(
                  email: widget.email,
                  usertype: widget.usertype,
                  jwttoken: widget.jwttoken,
                ),
              ),
              SizedBox(height: shortestval * 0.02),
              // Use FutureBuilder to handle asynchronous fetching of cart data.
              FutureBuilder<void>(
                future: Get_CartInfo(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Show a loading indicator while fetching data.
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    // Display an error message if fetching fails.
                    return Center(
                      child: Text(
                        "Error fetching cart data. Please reopen app.",
                        style: TextStyle(color: Colors.red, fontSize: shortestval * 0.04),
                      ),
                    );
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return CartInfoList.isEmpty
                        ? Center(
                      child: Text(
                        "No cart data available.",
                        style: TextStyle(
                          fontFamily: regular,
                          fontSize: shortestval * 0.045,
                          color: Colors.green[800],
                        ),
                      ),
                    )
                        : Container(
                      width: widthval,
                      child: Builder(
                        builder: (context) {
                          return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final cart = CurrentUserCartInfoList[index];
                              return Card(
                                elevation: 6,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                color: Colors.white.withOpacity(0.9),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: shortestval * 0.08,
                                    backgroundImage: cart.photo != null
                                        ? MemoryImage(base64Decode(cart.photo!))
                                        : null,
                                    child: cart.photo == null
                                        ? const Icon(
                                      Icons.broken_image,
                                      color: Colors.grey,
                                      size: 40,
                                    )
                                        : null,
                                  ),
                                  title: Text(
                                    cart.bookName ?? 'N/A',
                                    style: TextStyle(
                                      fontFamily: semibold,
                                      fontSize: shortestval * 0.045,
                                      color: Colors.green[900],
                                    ),
                                  ),
                                  subtitle: Text(
                                    "Qty: ${cart.quantity?.toString() ?? 'N/A'}",
                                    style: TextStyle(
                                      fontFamily: regular,
                                      fontSize: shortestval * 0.04,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  trailing: Text(
                                    cart.addedAt ?? 'N/A',
                                    style: TextStyle(
                                      fontFamily: regular,
                                      fontSize: shortestval * 0.04,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ).onTap(() {
                                // Navigate to the CartDetailsScreen when a cart item is tapped.
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return CartDetailsScreen(
                                        jwttoken: widget.jwttoken,
                                        usertype: widget.usertype,
                                        email: widget.email,
                                        cartId: cart.cartId,
                                        addedAt: cart.addedAt,
                                        quantity: cart.quantity,
                                        cartUserId: cart.cartUserId,
                                        cartBookId: cart.cartBookId,
                                        bookName: cart.bookName,
                                        price: cart.price,
                                        format: cart.format,
                                        title: cart.title,
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
                                        photo: cart.photo,
                                      );
                                    },
                                  ),
                                );
                              });
                            },
                            itemCount: CurrentUserCartInfoList.length,
                          );
                        },
                      ),
                    );
                  } else {
                    // Display a fallback message for unexpected states.
                    return Center(
                      child: Text(
                        "Please reopen app.",
                        style: TextStyle(color: Colors.red, fontSize: shortestval * 0.04),
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: shortestval * 0.02),
              // Full-width footer.
              SizedBox(
                width: double.infinity,
                child: FooterWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}