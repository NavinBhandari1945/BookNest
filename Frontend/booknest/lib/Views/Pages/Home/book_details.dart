import 'dart:convert';
import 'package:booknest/Views/Pages/Home/user_not_login_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';
import '../../../constant/constant.dart';
import '../../../constant/styles.dart';
import '../../common widget/common_method.dart';
import '../../common widget/toast.dart';

class BookDetails extends StatefulWidget {
  final String email;
  final String usertype;
  final String jwttoken;
  final String BookId;
  final String BookName;
  final String Price;
  final String Format;
  final String Title;
  final String Author;
  final String Publisher;
  final String PublicationDate;
  final String Language;
  final String Category;
  final String ListedAt;
  final String AvailableQuantity;
  final String DiscountPercent;
  final String DiscountStart;
  final String DiscountEnd;
  final String Photo;

  const BookDetails({
    super.key,
    required this.jwttoken,
    required this.usertype,
    required this.email,
    required this.BookId,
    required this.BookName,
    required this.Price,
    required this.Format,
    required this.Title,
    required this.Author,
    required this.Publisher,
    required this.PublicationDate,
    required this.Language,
    required this.Category,
    required this.ListedAt,
    required this.AvailableQuantity,
    required this.DiscountPercent,
    required this.DiscountStart,
    required this.DiscountEnd,
    required this.Photo,
  });

  @override
  State<BookDetails> createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> with SingleTickerProviderStateMixin {
  final TextEditingController _quantityController = TextEditingController(text: '1');
  bool _isImageLoaded = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    checkJWTExpirationMember();
    // Initialize animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    _animationController.forward();
    // Simulate image load
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _isImageLoaded = true;
      });
    });
  }

  Future<void> checkJWTExpirationMember() async {
    try {
      print("Checking JWT in book details screen.");
      int result = await checkJwtToken_initistate_member(
          widget.email, widget.usertype, widget.jwttoken);
      if (result == 0) {
        await clearUserData();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const UserNotLoginHomeScreen()),
        );
        Toastget().Toastmsg("Session ended. Please relogin.");
      }
    } catch (e) {
      print("Exception caught while verifying JWT: $e");
      await clearUserData();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const UserNotLoginHomeScreen()),
      );
      Toastget().Toastmsg("Error. Please relogin.");
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<int> Add_Bookmark() async {
    try {
      // Construct the JSON payload
      Map<String, dynamic> BookmarkData = {
        "BookmarkId": 0,
        "Email": widget.email,
        "BookId": widget.BookId,
      };
      const String url = Backend_Server_Url + "api/Member/add_bookmark";
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json", 'Authorization': 'Bearer ${widget.jwttoken}'},
        body: json.encode(BookmarkData),
      );
      if (response.statusCode == 200)
      {
        Toastget().Toastmsg("Adding bookmark success.");
        return 1;
      }
      else if (response.statusCode == 503)
      {
        Toastget().Toastmsg("Session end.Relogin please.");
        await clearUserData();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const UserNotLoginHomeScreen()),
        );
        return 11; // jwt error
      }
      else if (response.statusCode == 502) {
        Toastget().Toastmsg("Adding bookmark failed.Incorrect bookmark data format.Try again.");
        return 11; // jwt error
      } else {
        print("Error.other status code.");
        Toastget().Toastmsg("Adding bookmark failed.");
        return 4;
      }
    } catch (obj) {
      print("Exception caught while inserting bookmark data in http method.");
      print(obj.toString());
      Toastget().Toastmsg("Adding bookmark failed.");
      return 0;
    }
  }


  @override
  Widget build(BuildContext context) {
    final shortestVal = MediaQuery.of(context).size.shortestSide;
    final widthVal = MediaQuery.of(context).size.width;
    final heightVal = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Book Details",
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(shortestVal * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Book Image
                Center(
                  child: AnimatedOpacity(
                    opacity: _isImageLoaded ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    child: AnimatedScale(
                      scale: _isImageLoaded ? 1.0 : 0.8,
                      duration: const Duration(milliseconds: 500),
                      child: Container(
                        width: shortestVal * 0.5,
                        height: shortestVal * 0.5,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: widget.Photo.isNotEmpty
                              ? Image.memory(
                            base64Decode(widget.Photo),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.broken_image,
                              size: 100,
                              color: Colors.grey,
                            ),
                          )
                              : const Icon(
                            Icons.book,
                            size: 100,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: heightVal * 0.03),

                // Book Title
                Text("Book tittle:${widget.Title}",
                  style: TextStyle(
                    fontFamily: bold,
                    fontSize: shortestVal * 0.08,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: heightVal * 0.01),

                // Author
                Text(
                  "Author name: ${widget.Author}",
                  style: TextStyle(
                    fontFamily: semibold,
                    fontSize: shortestVal * 0.05,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: heightVal * 0.02),

                // Book Details Card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(shortestVal * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow(
                          "Price",
                          widget.DiscountPercent != "0"
                              ? "${(double.parse(widget.Price) * (1 - double.parse(widget.DiscountPercent) / 100)).toStringAsFixed(2)} (Original: ${widget.Price})"
                              : "${widget.Price}",
                          shortestVal,
                        ),
                        _buildDetailRow("Format", widget.Format, shortestVal),
                        _buildDetailRow("Publisher", widget.Publisher, shortestVal),
                        _buildDetailRow("Publication Date", widget.PublicationDate, shortestVal),
                        _buildDetailRow("Language", widget.Language, shortestVal),
                        _buildDetailRow("Category", widget.Category, shortestVal),
                        _buildDetailRow("Listed At", widget.ListedAt, shortestVal),
                        _buildDetailRow("Available Quantity", widget.AvailableQuantity, shortestVal),
                        if (widget.DiscountPercent != "0") ...[
                          _buildDetailRow("Discount", "${widget.DiscountPercent}%", shortestVal),
                          _buildDetailRow("Discount Period", "${widget.DiscountStart} to ${widget.DiscountEnd}", shortestVal),
                        ],
                      ],
                    ),
                  ),
                ),
                SizedBox(height: heightVal * 0.03),

                // Quantity Input
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _quantityController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: InputDecoration(
                          labelText: "Quantity",
                          labelStyle: TextStyle(
                            fontFamily: semibold,
                            fontSize: shortestVal * 0.045,
                            color: Colors.grey[600],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.green[700]!, width: 2),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: shortestVal * 0.04,
                            vertical: shortestVal * 0.03,
                          ),
                        ),
                        style: TextStyle(
                          fontFamily: regular,
                          fontSize: shortestVal * 0.045,
                        ),
                      ),
                    ),
                    SizedBox(width: shortestVal * 0.03),
                    Text(
                      "Max: ${widget.AvailableQuantity}",
                      style: TextStyle(
                        fontFamily: semibold,
                        fontSize: shortestVal * 0.04,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: heightVal * 0.03),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton(
                      label: "Add to Cart",
                      icon: Icons.shopping_cart,
                      onPressed: ()async{


                      },
                      shortestVal: shortestVal,
                      animation: _scaleAnimation,
                    ),

                    _buildActionButton(
                      label: "Bookmark",
                      icon: Icons.bookmark,
                      onPressed: ()async{
                        final Add_BookMark_Result=await Add_Bookmark();
                        print(Add_BookMark_Result);
                      },
                      shortestVal: shortestVal,
                      animation: _scaleAnimation,
                    )

                  ],
                ),
                SizedBox(height: heightVal * 0.04),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, double shortestVal) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: shortestVal * 0.015),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: shortestVal * 0.3,
            child: Text(
              label,
              style: TextStyle(
                fontFamily: semibold,
                fontSize: shortestVal * 0.045,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontFamily: regular,
                fontSize: shortestVal * 0.045,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    required double shortestVal,
    required Animation<double> animation,
  }) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.scale(
          scale: animation.value,
          child: ElevatedButton.icon(
            onPressed: onPressed,
            icon: Icon(icon, size: shortestVal * 0.06, color: Colors.white),
            label: Text(
              label,
              style: TextStyle(
                fontFamily: semibold,
                fontSize: shortestVal * 0.045,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: shortestVal * 0.06,
                vertical: shortestVal * 0.04,
              ),
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              minimumSize: Size(shortestVal * 0.35, shortestVal * 0.12),
            ).copyWith(
              backgroundBuilder: (context, states, child) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green[700]!, Colors.green[400]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: child,
                );
              },
            ),
          ),
        );
      },
    );
  }
}






// import 'dart:convert';
//
// import 'package:booknest/Views/Pages/Home/user_not_login_home_screen.dart';
// import 'package:flutter/material.dart';
//
// import '../../../constant/styles.dart';
// import '../../common widget/common_method.dart';
// import '../../common widget/toast.dart';
//
// class BookDetails extends StatefulWidget {
//   final String email;
//   final String usertype;
//   final String jwttoken;
//
//   // Book properties
//   final String BookId;
//   final String BookName;
//   final String Price;
//   final String Format;
//   final String Title;
//   final String Author;
//   final String Publisher;
//   final String PublicationDate;
//   final String Language;
//   final String Category;
//   final String ListedAt;
//   final String AvailableQuantity;
//   final String DiscountPercent;
//   final String DiscountStart;
//   final String DiscountEnd;
//   final String Photo;
//
//   const BookDetails({
//     super.key,
//     required this.jwttoken,
//     required this.usertype,
//     required this.email,
//     required this.BookId,
//     required this.BookName,
//     required this.Price,
//     required this.Format,
//     required this.Title,
//     required this.Author,
//     required this.Publisher,
//     required this.PublicationDate,
//     required this.Language,
//     required this.Category,
//     required this.ListedAt,
//     required this.AvailableQuantity,
//     required this.DiscountPercent,
//     required this.DiscountStart,
//     required this.DiscountEnd,
//     required this.Photo,
//   });
//   @override
//   State<BookDetails> createState() => _BookDetailsState();
// }
//
// class _BookDetailsState extends State<BookDetails> {
//   @override
//   void initState() {
//     super.initState();
//     checkJWTExpiationmember();
//   }
//
//   Future<void> checkJWTExpiationmember() async {
//     try {
//       //check jwt called in admin home screen.
//       print("check jwt called in book screen.");
//       int result = await checkJwtToken_initistate_member(
//           widget.email, widget.usertype, widget.jwttoken);
//       if (result == 0)
//       {
//         await clearUserData();
//         Navigator.pushReplacement(context,
//             MaterialPageRoute(builder: (context) => UserNotLoginHomeScreen()));
//         Toastget().Toastmsg("Session End. Relogin please.");
//       }
//     } catch (obj) {
//       print("Exception caught while verifying jwt for admin home screen.");
//       print(obj.toString());
//       await clearUserData();
//       Navigator.pushReplacement(context,
//           MaterialPageRoute(builder: (context) => UserNotLoginHomeScreen()));
//       Toastget().Toastmsg("Error. Relogin please.");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var shortestval = MediaQuery.of(context).size.shortestSide;
//     var widthval = MediaQuery.of(context).size.width;
//     var heightval = MediaQuery.of(context).size.height;
//     return Scaffold(
//         appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: const Text(
//         "Book Details Screen",
//         style: TextStyle(
//         fontFamily: bold,
//         fontSize: 24,
//         color: Colors.white,
//         letterSpacing: 1.2,
//     ),
//     ),
//     backgroundColor: Colors.green[700],
//     elevation: 4,
//     shadowColor: Colors.black45
//         ),
//             body: Container(
//               child: Column(
//                 children: [
//                   Container (
//                     width: shortestval * 0.4,
//                     height: shortestval * 0.4,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       boxShadow: [
//                         BoxShadow(
//                             color: Colors.black26,
//                             blurRadius: 8,
//                             offset: Offset(0, 4))
//                       ],
//                     ),
//                     child: ClipOval(
//                       child: Image.memory(
//                           base64Decode(widget.Photo),
//                           fit: BoxFit.cover),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//
//
//     );
//   }
// }
