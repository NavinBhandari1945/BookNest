import 'dart:convert';
import 'package:booknest/Views/Pages/Home/user_not_login_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';
import '../../../Models/ReviewModel.dart';
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

class _BookDetailsState extends State<BookDetails>
    with SingleTickerProviderStateMixin {
  final TextEditingController _quantityController = TextEditingController(
    text: '1',
  );
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
        widget.email,
        widget.usertype,
        widget.jwttoken,
      );
      if (result == 0) {
        await clearUserData();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const UserNotLoginHomeScreen(),
          ),
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
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${widget.jwttoken}',
        },
        body: json.encode(BookmarkData),
      );
      if (response.statusCode == 200) {
        Toastget().Toastmsg("Adding bookmark success.");
        return 1;
      } else if (response.statusCode == 503) {
        Toastget().Toastmsg("Session end.Relogin please.");
        await clearUserData();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const UserNotLoginHomeScreen(),
          ),
        );
        return 11; // jwt error
      } else if (response.statusCode == 502) {
        Toastget().Toastmsg(
          "Adding bookmark failed.Incorrect bookmark data format.Try again.",
        );
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

  Future<int> Add_Cart({
    required int Quantity,
    required String DateAdded,
  }) async {
    try {
      print("Adding cart start");
      // Construct the JSON payload
      Map<String, dynamic> CartData = {
        "CartId": 0,
        "AddedAt": DateAdded,
        "Quantity": Quantity,
        "Email": widget.email,
        "BookId": widget.BookId,
      };
      const String url = Backend_Server_Url + "api/Member/add_cart";
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${widget.jwttoken}',
        },
        body: json.encode(CartData),
      );
      if (response.statusCode == 200) {
        Toastget().Toastmsg("Adding cart success.");
        return 1;
      } else if (response.statusCode == 503) {
        Toastget().Toastmsg("Session end.Relogin please.");
        await clearUserData();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const UserNotLoginHomeScreen(),
          ),
        );
        return 11; // jwt error
      } else if (response.statusCode == 502) {
        Toastget().Toastmsg(
          "Adding cart failed.Incorrect cart data format.Try again.",
        );
        return 11; // jwt error
      } else if (response.statusCode == 500) {
        print("Error.other status code.");
        print("Response body: ${response.body}");
        final decoded = json.decode(response.body);
        print("Error message: ${decoded['message']}");
        print("Stack trace: ${decoded['stackTrace']}");
        Toastget().Toastmsg("Exception caught in backend.Try again.");
        return 5;
      } else {
        print("Error.other status code = ${response.statusCode}");
        Toastget().Toastmsg("Adding cart failed.");
        return 4;
      }
    } catch (obj) {
      print("Exception caught while inserting cart data in http method.");
      print(obj.toString());
      Toastget().Toastmsg("Adding cart failed.");
      return 0;
    }
  }

  List<ReviewModel> ReviewInfoList = [];
  Future<int> Get_Review_Info() async {
    try {
      print("Getting review start");
      // Construct the JSON payload
      Map<String, dynamic> BookData = {"BookId": widget.BookId};
      const String url = Backend_Server_Url + "api/Member/getreviewdata";
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${widget.jwttoken}',
        },
        body: json.encode(BookData),
      );
      if (response.statusCode == 200) {
        List<dynamic> responseData = await jsonDecode(response.body);
        print("response body");
        print(responseData);
        ReviewInfoList.clear();
        ReviewInfoList.addAll(
          responseData.map((data) => ReviewModel.fromJson(data)).toList(),
        );
        print("ReviewInfoList  count value");
        print(ReviewInfoList.length);
        print(ReviewInfoList[0].bookId);
        return 1;
      } else if (response.statusCode == 500)
      {
        Toastget().Toastmsg(
          "Adding ReviewInfoList failed.Incorrect ReviewInfoList data format.Try again.",
        );
        return 11; // jwt error
      } else {
        ReviewInfoList.clear();
        print("Error.other status code.");
        print("Response body: ${response.statusCode}");
        Toastget().Toastmsg("Get review failed.");
        return 2;
      }
    } catch (obj) {
      ReviewInfoList.clear();
      print(
        "Exception caught while fetching ReviewInfoList data in http method",
      );
      print(obj.toString());
      return 3;
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
            shadows: [
              Shadow(color: Colors.black26, offset: Offset(0, 2), blurRadius: 4),
            ],
          ),
        ),
        backgroundColor: Colors.teal[700],
        elevation: 6,
        shadowColor: Colors.black54,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.teal[700]!, Colors.teal[100]!],
          ),
        ),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(shortestVal * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: AnimatedOpacity(
                      opacity: _isImageLoaded ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 500),
                      child: AnimatedScale(
                        scale: _isImageLoaded ? 1.0 : 0.8,
                        duration: const Duration(milliseconds: 500),
                        child: Container(
                          width: shortestVal * 0.6,
                          height: shortestVal * 0.6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.teal[300]!, width: 4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.teal[400]!.withOpacity(0.5),
                                blurRadius: 15,
                                spreadRadius: 2,
                                offset: const Offset(0, 8),
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
                  SizedBox(height: heightVal * 0.04),
                  Text(
                    "Book Title: ${widget.Title}",
                    style: TextStyle(
                      fontFamily: bold,
                      fontSize: shortestVal * 0.09,
                      color: Colors.teal[900],
                      shadows: [
                        Shadow(color: Colors.black26, offset: Offset(0, 2), blurRadius: 4),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: heightVal * 0.02),
                  Text(
                    "Author: ${widget.Author}",
                    style: TextStyle(
                      fontFamily: semibold,
                      fontSize: shortestVal * 0.06,
                      color: Colors.teal[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: heightVal * 0.03),
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.white, Colors.teal[50]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(shortestVal * 0.05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow(
                            "Price",
                            "${widget.Price}",
                            shortestVal,
                          ),
                          _buildDetailRow("Format", widget.Format, shortestVal),
                          _buildDetailRow(
                            "Publisher",
                            widget.Publisher,
                            shortestVal,
                          ),
                          _buildDetailRow(
                            "ISBN Number",
                            widget.BookId,
                            shortestVal,
                          ),
                          _buildDetailRow(
                            "Publication Date",
                            widget.PublicationDate,
                            shortestVal,
                          ),
                          _buildDetailRow(
                            "Language",
                            widget.Language,
                            shortestVal,
                          ),
                          _buildDetailRow(
                            "Category",
                            widget.Category,
                            shortestVal,
                          ),
                          _buildDetailRow(
                            "Listed At",
                            widget.ListedAt,
                            shortestVal,
                          ),
                          _buildDetailRow(
                            "Available Quantity",
                            widget.AvailableQuantity,
                            shortestVal,
                          ),
                          if (widget.DiscountPercent != "0") ...[
                            _buildDetailRow(
                              "Discount",
                              "${widget.DiscountPercent}%",
                              shortestVal,
                            ),
                            _buildDetailRow(
                              "Discount Period",
                              "${widget.DiscountStart} to ${widget.DiscountEnd}",
                              shortestVal,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: heightVal * 0.04),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _quantityController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            labelText: "Quantity",
                            labelStyle: TextStyle(
                              fontFamily: semibold,
                              fontSize: shortestVal * 0.05,
                              color: Colors.teal[600],
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Colors.teal[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Colors.teal[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Colors.teal[700]!,
                                width: 2,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: shortestVal * 0.05,
                              vertical: shortestVal * 0.04,
                            ),
                          ),
                          style: TextStyle(
                            fontFamily: regular,
                            fontSize: shortestVal * 0.05,
                          ),
                        ),
                      ),
                      SizedBox(width: shortestVal * 0.04),
                      Text(
                        "Max: ${widget.AvailableQuantity}",
                        style: TextStyle(
                          fontFamily: semibold,
                          fontSize: shortestVal * 0.045,
                          color: Colors.teal[600],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: heightVal * 0.04),
                  Center(child: Text("Review Information")),
                  FutureBuilder<void>(
                    future: Get_Review_Info(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            "Error fetching campaigns data. Please reopen app.",
                            style: TextStyle(color: Colors.red, fontSize: 16),
                          ),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        return ReviewInfoList.isEmpty
                            ? const Center(
                          child: Text("No review data available."),
                        )
                            : Container(
                          width: widthVal,
                          height: 200,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.teal[50]!, Colors.white],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Builder(
                            builder: (context) {
                              return ListView.builder(
                                itemBuilder: (context, index) {
                                  final review = ReviewInfoList[index];
                                  return Card(
                                    elevation: 6,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(12),
                                    ),
                                    child: ListTile(
                                      leading: Text(
                                        "Comment: ${review.comment!}",
                                        style: TextStyle(
                                          fontFamily: semibold,
                                          fontSize: shortestVal * 0.055,
                                          color: Colors.teal[800],
                                        ),
                                      ),
                                      title: Text(
                                        "Rating: ${review.rating!}",
                                        style: TextStyle(
                                          fontFamily: semibold,
                                          fontSize: shortestVal * 0.055,
                                          color: Colors.teal[800],
                                        ),
                                      ),
                                      trailing: Text(
                                        "User Email: ${widget.email}",
                                        style: TextStyle(
                                          fontFamily: semibold,
                                          fontSize: shortestVal * 0.055,
                                          color: Colors.teal[800],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                itemCount: ReviewInfoList.length,
                              );
                            },
                          ),
                        );
                      } else {
                        return Center(
                          child: Text(
                            "Please reopen app.",
                            style: TextStyle(color: Colors.red, fontSize: 16),
                          ),
                        );
                      }
                    },
                  ),
                  10.heightBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(
                        label: "Add to Cart",
                        icon: Icons.shopping_cart,
                        onPressed: () async {
                          try {
                            final Quantity = int.tryParse(
                              _quantityController.text.toString(),
                            );
                            if (Quantity! <= 0) {
                              Toastget().Toastmsg(
                                "Add at least 1 quantity of book.",
                              );
                              return;
                            }
                            final Available_Quantity = int.tryParse(
                              widget.AvailableQuantity,
                            );
                            if (Available_Quantity! < Quantity!) {
                              Toastget().Toastmsg(
                                "Insufficient quantity of book.",
                              );
                              return;
                            }
                            final AddedDate = getCurrentDateFormatted();
                            print(AddedDate);
                            final Cart_Result = await Add_Cart(
                              Quantity: Quantity!,
                              DateAdded: AddedDate,
                            );
                          } catch (Obj) {
                            print(Obj.toString());
                            Toastget().Toastmsg("Add to cart failed try again.");
                          }
                        },
                        shortestVal: shortestVal,
                        animation: _scaleAnimation,
                      ),
                      _buildActionButton(
                        label: "Bookmark",
                        icon: Icons.bookmark,
                        onPressed: () async {
                          try {
                            final Add_BookMark_Result = await Add_Bookmark();
                            print(Add_BookMark_Result);
                          } catch (Obj) {
                            print(Obj.toString());
                            Toastget().Toastmsg(
                              "Add to bookmark failed try again.",
                            );
                          }
                        },
                        shortestVal: shortestVal,
                        animation: _scaleAnimation,
                      ),
                    ],
                  ),
                  SizedBox(height: heightVal * 0.05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, double shortestVal) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: shortestVal * 0.02),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: shortestVal * 0.35,
            child: Text(
              label,
              style: TextStyle(
                fontFamily: semibold,
                fontSize: shortestVal * 0.05,
                color: Colors.blueAccent[900],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontFamily: regular,
                fontSize: shortestVal * 0.05,
                color: Colors.blueAccent[500],
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
            icon: Icon(icon, size: shortestVal * 0.07, color: Colors.white),
            label: Text(
              label,
              style: TextStyle(
                fontFamily: semibold,
                fontSize: shortestVal * 0.05,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: shortestVal * 0.08,
                vertical: shortestVal * 0.05,
              ),
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 0,
              minimumSize: Size(shortestVal * 0.4, shortestVal * 0.14),
            ).copyWith(
              backgroundBuilder: (context, states, child) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green[700]!, Colors.green[300]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        blurRadius: 10,
                        offset: const Offset(0, 6),
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