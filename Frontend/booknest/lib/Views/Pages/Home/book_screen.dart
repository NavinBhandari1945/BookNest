// Imports section
import 'dart:convert';
import 'package:booknest/Views/Pages/Home/book_details.dart';
import 'package:booknest/Views/Pages/Home/user_not_login_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';
import '../../../Models/BookInfosModel.dart';
import '../../../Models/BookReviewModel.dart';
import '../../../constant/constant.dart';
import '../../../constant/styles.dart';
import '../../common widget/circular_progress_ind_yellow.dart';
import '../../common widget/common_method.dart';
import '../../common widget/header_footer.dart';
import '../../common widget/toast.dart';
import 'category_book_screen.dart';
import 'member_login_page.dart';

// Widget definition section
class BookScreen extends StatefulWidget {
  final String email;
  final String usertype;
  final String jwttoken;
  const BookScreen({
    super.key,
    required this.jwttoken,
    required this.usertype,
    required this.email,
  });

  @override
  State<BookScreen> createState() => _BookScreenState();
}

// State management section
class _BookScreenState extends State<BookScreen> {


  @override
  void initState() {
    super.initState();
    checkJWTExpiationmember();
  }

  // JWT and authentication section
  Future<void> checkJWTExpiationmember() async {
    try {
      print("check jwt called in book screen.");
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

  String? Filter_Sort_Value = "";
  final Search_Box_Cont = TextEditingController();
  List<BooKInfos> BookInfoList = [];
  List<BooKInfos> FilteredBookListIdOrTittleOrAuthor = [];
  List<BooKInfos> FilteredBookListDateAesc = [];
  List<BooKInfos> FilteredBookListDateDesc = [];
  List<BooKInfos> FilteredBookListPriceDesc = [];
  List<BooKInfos> FilteredBookListPriceAesc = [];

  List<BooksWithReviewModel> BookReviewInfoList = [];
  List<BooksWithReviewModel> FilteredBookListRatingsAesc = [];
  List<BooksWithReviewModel> FilteredBookListRatingsDesc = [];

  // API data fetching section
  Future<void> GetBookReviewInfos() async {
    try {
      print("Get books with review info method called");
      const String url = Backend_Server_Url + "api/Member/getbookswithreviews";
      final headers = {
        'Authorization': 'Bearer ${widget.jwttoken}',
        'Content-Type': 'application/json',
      };
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        List<dynamic> responseData = await jsonDecode(response.body);
        print("response body");
        print(responseData);
        BookReviewInfoList.clear();
        BookReviewInfoList.addAll(
          responseData
              .map((data) => BooksWithReviewModel.fromJson(data))
              .toList(),
        );
        print("Book Review list count value");
        print(BookReviewInfoList.length);

        print(BookReviewInfoList[0].bookId);
        print(BookReviewInfoList[0].reviewId);

        print(BookReviewInfoList[0].reviewBookId);
        print(BookReviewInfoList[0].bookName);

        return;
      } else {
        BookReviewInfoList.clear();
        print("Data insert in book review info list failed.");
        return;
      }
    } catch (obj) {
      BookReviewInfoList.clear();
      print("Exception caught while fetching book review data in http method");
      print(obj.toString());
      return;
    }
  }

  Future<void> GetBookInfo() async {
    try {
      print("Get books info method called");
      const String url = Backend_Server_Url + "api/Member/getbooksinfo";
      final headers = {
        'Authorization': 'Bearer ${widget.jwttoken}',
        'Content-Type': 'application/json',
      };
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200)
      {
        List<dynamic> responseData = await jsonDecode(response.body);
        print("response body");
        print(responseData);
        BookInfoList.clear();
        BookInfoList.addAll(
          responseData.map((data) => BooKInfos.fromJson(data)).toList(),
        );
        print("Book list count value");
        print(BookInfoList.length);
        print(BookInfoList[0].bookName);
        return;
      } else {
        BookInfoList.clear();
        print("Data insert in book info list failed.");
        return;
      }
    } catch (obj) {
      BookInfoList.clear();
      print("Exception caught while fetching book data in http method");
      print(obj.toString());
      return;
    }
  }


  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // UI building section
  @override
  Widget build(BuildContext context) {
    var shortestval = MediaQuery.of(context).size.shortestSide;
    var widthval = MediaQuery.of(context).size.width;
    var heightval = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          "Book Screen",
          style: TextStyle(
            fontFamily: bold,
            fontSize: 24,
            color: Colors.white,
            letterSpacing: 1.2,
            shadows: [
              Shadow(
                color: Colors.black26,
                offset: Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        backgroundColor: Colors.teal[700],
        elevation: 6,
        shadowColor: Colors.black54,
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  _scaffoldKey.currentState!.openDrawer();
                },
                icon: Icon(
                  Icons.book_online_sharp,
                  color: Colors.white,
                  size: shortestval * 0.07,
                ),
                tooltip: "Categories",
              ),
              Text(
                "Sort/Filters",
                style: TextStyle(
                  fontFamily: semibold,
                  color: Colors.white,
                  fontSize: shortestval * 0.045,
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == 'Date aescending') {
                    setState(() {
                      Filter_Sort_Value = "Date aescending";
                    });
                  } else if (value == 'Date descending') {
                    setState(() {
                      Filter_Sort_Value = "Date descending";
                    });
                  } else if (value == 'Price descending') {
                    setState(() {
                      Filter_Sort_Value = "Price descending";
                    });
                  } else if (value == 'Price aescending') {
                    setState(() {
                      Filter_Sort_Value = "Price aescending";
                    });
                  } else if (value == 'Ratings aescending') {
                    setState(() {
                      Filter_Sort_Value = "Ratings aescending";
                    });
                  } else if (value == 'Ratings descending') {
                    setState(() {
                      Filter_Sort_Value = "Ratings descending";
                    });
                  } else {
                    setState(() {
                      Filter_Sort_Value = "";
                    });
                  }
                },
                itemBuilder:
                    (context) => [
                      PopupMenuItem(
                        value: '',
                        child: Text(
                          'No filter/sort',
                          style: TextStyle(
                            fontFamily: semibold,
                            color: Colors.teal[800],
                            fontSize: shortestval * 0.05,
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        value: 'Date aescending',
                        child: Text(
                          'Date ascending',
                          style: TextStyle(
                            fontFamily: semibold,
                            color: Colors.teal[800],
                            fontSize: shortestval * 0.05,
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        value: 'Date descending',
                        child: Text(
                          'Date descending',
                          style: TextStyle(
                            fontFamily: semibold,
                            color: Colors.teal[800],
                            fontSize: shortestval * 0.05,
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        value: 'Price aescending',
                        child: Text(
                          'Price ascending',
                          style: TextStyle(
                            fontFamily: semibold,
                            color: Colors.teal[800],
                            fontSize: shortestval * 0.05,
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        value: 'Price descending',
                        child: Text(
                          'Price descending',
                          style: TextStyle(
                            fontFamily: semibold,
                            color: Colors.teal[800],
                            fontSize: shortestval * 0.05,
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        value: 'Ratings aescending',
                        child: Text(
                          'Ratings ascending',
                          style: TextStyle(
                            fontFamily: semibold,
                            color: Colors.teal[800],
                            fontSize: shortestval * 0.05,
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        value: 'Ratings descending',
                        child: Text(
                          'Ratings descending',
                          style: TextStyle(
                            fontFamily: semibold,
                            color: Colors.teal[800],
                            fontSize: shortestval * 0.05,
                          ),
                        ),
                      ),
                    ],
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.teal[300]!, width: 1),
                ),
              ),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.teal[700]!, Colors.teal[100]!],
            ),
          ),
          child: FutureBuilder(
            future: GetBookInfo(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Circular_pro_indicator_Yellow(context);
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(
                      fontFamily: regular,
                      color: Colors.red[700],
                      fontSize: shortestval * 0.05,
                    ),
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (BookInfoList.isNotEmpty || BookInfoList.length >= 1) {
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: shortestval * 0.03),
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 6,
                        margin: EdgeInsets.symmetric(
                          horizontal: shortestval * 0.04,
                          vertical: shortestval * 0.02,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.white, Colors.teal[50]!],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                        shortestval * 0.03,
                                      ),
                                      child: Text(
                                        "Category: ${BookInfoList[index].category}",
                                        style: TextStyle(
                                          fontFamily: semibold,
                                          fontSize:
                                              shortestval *
                                              0.04, // Reduced from 0.055
                                          color: Colors.teal[900],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      right: shortestval * 0.03,
                                    ),
                                    child: Icon(
                                      Icons.category,
                                      color: Colors.teal[600],
                                      size: shortestval * 0.07,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                height: heightval * 0.006,
                                color: Colors.teal[400],
                                width: widthval,
                              ),
                            ],
                          ),
                        ),
                      ).onTap(() {
                        String selectedCategory =
                            BookInfoList[index].category ?? "";
                        List<BooKInfos> Category_Book_Set =
                            BookInfoList.where(
                              (book) => book.category == selectedCategory,
                            ).toList();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return CategoryBookPage(
                                jwttoken: widget.jwttoken!,
                                usertype: widget.usertype,
                                email: widget.email,
                                BookInfo: Category_Book_Set,
                              );
                            },
                          ),
                        );
                      });
                    },
                    itemCount: BookInfoList.length,
                  );
                } else {
                  return Center(
                    child: Text(
                      'No categories available. Please close and reopen app.',
                      style: TextStyle(
                        fontFamily: regular,
                        color: Colors.teal[800],
                        fontSize: shortestval * 0.05,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
              } else {
                return Center(
                  child: Text(
                    'Error. Please relogin.',
                    style: TextStyle(
                      fontFamily: regular,
                      color: Colors.red[700],
                      fontSize: shortestval * 0.05,
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
      body: Container(
        width: widthval,
        height: heightval,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.teal[700]!, Colors.teal[100]!],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: HeaderWidget(
                  email: widget.email,
                  usertype: widget.usertype,
                  jwttoken: widget.jwttoken,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: shortestval * 0.05,
                  vertical: shortestval * 0.03,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(shortestval * 0.06),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {});
                    },
                    controller: Search_Box_Cont,
                    obscureText: false,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.teal[300]!,
                          width: shortestval * 0.005,
                        ),
                        borderRadius: BorderRadius.circular(shortestval * 0.06),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.teal[700]!,
                          width: shortestval * 0.008,
                        ),
                        borderRadius: BorderRadius.circular(shortestval * 0.06),
                      ),
                      hintText: "Search by ISBN, title, or author",
                      hintStyle: TextStyle(
                        fontFamily: regular,
                        color: Colors.teal[600],
                        fontSize: shortestval * 0.045,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.teal[700],
                        size: shortestval * 0.07,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: shortestval * 0.04,
                        horizontal: shortestval * 0.05,
                      ),
                    ),
                    style: TextStyle(
                      fontFamily: regular,
                      fontSize: shortestval * 0.05,
                      color: Colors.teal[900],
                    ),
                  ),
                ),
              ),
              SizedBox(height: heightval * 0.02),

              FutureBuilder<void> (
                future:
                    Filter_Sort_Value == ""
                        ? GetBookInfo()
                        : GetBookReviewInfos(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(color: Colors.teal[700]),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Error fetching user data. Please reopen app.",
                        style: TextStyle(
                          fontFamily: regular,
                          color: Colors.red[700],
                          fontSize: shortestval * 0.05,
                        ),
                      ),
                    );
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (Search_Box_Cont.text.toString().isNotEmptyAndNotNull &&
                        BookInfoList.length >= 1 &&
                        Filter_Sort_Value == "") {
                      try {
                        print("Filtered user list add item condition called.");
                        for (var book_info in BookInfoList) {
                          if (book_info.bookId
                                      .toString()
                                      .toLowerCase()
                                      .trim() ==
                                  Search_Box_Cont.text
                                      .toString()
                                      .toLowerCase()
                                      .trim() ||
                              book_info.title.toString().toLowerCase().trim() ==
                                  Search_Box_Cont.text
                                      .toString()
                                      .toLowerCase()
                                      .trim() ||
                              book_info.author
                                      .toString()
                                      .toLowerCase()
                                      .trim() ==
                                  Search_Box_Cont.text
                                      .toString()
                                      .toLowerCase()
                                      .trim()) {
                            print(
                              "Search by ISBN, author, or title of book match.",
                            );
                            FilteredBookListIdOrTittleOrAuthor.clear();
                            FilteredBookListIdOrTittleOrAuthor.add(book_info);
                          }
                        }
                        if (FilteredBookListIdOrTittleOrAuthor.length <= 0) {
                          FilteredBookListIdOrTittleOrAuthor.clear();
                          Toastget().Toastmsg(
                            "Entered ID, author, or title didn't match any books.",
                          );
                          print(
                            "Entered ID, author, or title didn't match any books.",
                          );
                        }
                      } catch (Obj) {
                        FilteredBookListIdOrTittleOrAuthor.clear();
                        Toastget().Toastmsg(
                          "Entered ID or title didn't match any books.",
                        );
                        print(
                          "Exception caught while filtering book info list",
                        );
                        print(Obj.toString());
                      }
                      return FilteredBookListIdOrTittleOrAuthor.isEmpty
                          ? Center(
                            child: Text(
                              "No book data available.",
                              style: TextStyle(
                                fontFamily: regular,
                                color: Colors.teal[800],
                                fontSize: shortestval * 0.05,
                              ),
                            ),
                          )
                          : Builder(
                            builder:
                                (context) => ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: shortestval * 0.05,
                                  ),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    final book =
                                        FilteredBookListIdOrTittleOrAuthor[index];
                                    return Card(
                                      elevation: 6,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.white,
                                              Colors.teal[50]!,
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 8,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [

                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.all(
                                                  shortestval * 0.03,
                                                ),
                                                child: Text(
                                                  "Book ISBN: ${book.bookId}",
                                                  style: TextStyle(
                                                    fontFamily: semibold,
                                                    fontSize:
                                                        shortestval * 0.055,
                                                    color: Colors.teal[900],
                                                  ),
                                                ),
                                              ),
                                            ),

                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.all(
                                                  shortestval * 0.03,
                                                ),
                                                child: Text(
                                                  "Book Name: ${book.bookName}",
                                                  style: TextStyle(
                                                    fontFamily: semibold,
                                                    fontSize:
                                                    shortestval * 0.055,
                                                    color: Colors.teal[900],
                                                  ),
                                                ),
                                              ),
                                            ),

                                            Padding(
                                              padding: EdgeInsets.only(
                                                right: shortestval * 0.03,
                                              ),
                                              child: Icon(
                                                Icons.book_online_outlined,
                                                color: Colors.teal[600],
                                                size: shortestval * 0.07,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ).onTap(() {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return BookDetails(
                                              jwttoken: widget.jwttoken,
                                              usertype: widget.usertype,
                                              email: widget.email,
                                              BookId: book.bookId.toString(),
                                              BookName:
                                                  book.bookName.toString(),
                                              Price: book.price.toString(),
                                              Format: book.format.toString(),
                                              Title: book.title.toString(),
                                              Author: book.author.toString(),
                                              Publisher:
                                                  book.publisher.toString(),
                                              PublicationDate:
                                                  book.publicationDate
                                                      .toString(),
                                              Language:
                                                  book.language.toString(),
                                              Category:
                                                  book.category.toString(),
                                              ListedAt:
                                                  book.listedAt.toString(),
                                              AvailableQuantity:
                                                  book.availableQuantity
                                                      .toString(),
                                              DiscountPercent:
                                                  book.discountPercent
                                                      .toString(),
                                              DiscountStart:
                                                  book.discountStart.toString(),
                                              DiscountEnd:
                                                  book.discountEnd.toString(),
                                              Photo: book.photo.toString(),
                                            );
                                          },
                                        ),
                                      );
                                    });
                                  },
                                  itemCount:
                                      FilteredBookListIdOrTittleOrAuthor.length,
                                ),
                          );
                    } else if (BookInfoList.length >= 1 &&
                        Search_Box_Cont.text.isEmptyOrNull &&
                        Filter_Sort_Value.isNotEmptyAndNotNull &&
                        Filter_Sort_Value == "Date aescending") {
                      try {
                        print("Filtered book list add item condition called.");
                        final sort_result = sortBooksByPublicationDateAsc(
                          BookInfoList,
                        );
                        if (FilteredBookListDateAesc.length <= 0) {
                          FilteredBookListDateAesc.clear();
                          Toastget().Toastmsg(
                            "Not available book information.",
                          );
                          print("Not available book information.");
                        }
                      } catch (Obj) {
                        FilteredBookListDateAesc.clear();
                        Toastget().Toastmsg("Not available book information.");
                        print("Not available book information.");
                        print(Obj.toString());
                      }
                      return FilteredBookListDateAesc.isEmpty
                          ? Center(
                            child: Text(
                              "No book data available.",
                              style: TextStyle(
                                fontFamily: regular,
                                color: Colors.teal[800],
                                fontSize: shortestval * 0.05,
                              ),
                            ),
                          )
                          : Builder(
                            builder:
                                (context) => ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: shortestval * 0.05,
                                  ),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    final book =
                                        FilteredBookListDateAesc[index];
                                    return Card(
                                      elevation: 6,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.white,
                                              Colors.teal[50]!,
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 8,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [


                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.all(
                                                  shortestval * 0.03,
                                                ),
                                                child: Text(
                                                  "Book ISBN: ${book.bookId}",
                                                  style: TextStyle(
                                                    fontFamily: semibold,
                                                    fontSize:
                                                    shortestval * 0.055,
                                                    color: Colors.teal[900],
                                                  ),
                                                ),
                                              ),
                                            ),

                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.all(
                                                  shortestval * 0.03,
                                                ),
                                                child: Text(
                                                  "Book Name: ${book.bookName}",
                                                  style: TextStyle(
                                                    fontFamily: semibold,
                                                    fontSize:
                                                    shortestval * 0.055,
                                                    color: Colors.teal[900],
                                                  ),
                                                ),
                                              ),
                                            ),


                                            Padding(
                                              padding: EdgeInsets.only(
                                                right: shortestval * 0.03,
                                              ),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "${book.publicationDate}",
                                                    style: TextStyle(
                                                      fontFamily: regular,
                                                      fontSize:
                                                          shortestval * 0.045,
                                                      color: Colors.teal[600],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: shortestval * 0.02,
                                                  ),
                                                  Icon(
                                                    Icons.book_outlined,
                                                    color: Colors.teal[600],
                                                    size: shortestval * 0.07,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ).onTap(() {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return BookDetails(
                                              jwttoken: widget.jwttoken,
                                              usertype: widget.usertype,
                                              email: widget.email,
                                              BookId: book.bookId.toString(),
                                              BookName:
                                                  book.bookName.toString(),
                                              Price: book.price.toString(),
                                              Format: book.format.toString(),
                                              Title: book.title.toString(),
                                              Author: book.author.toString(),
                                              Publisher:
                                                  book.publisher.toString(),
                                              PublicationDate:
                                                  book.publicationDate
                                                      .toString(),
                                              Language:
                                                  book.language.toString(),
                                              Category:
                                                  book.category.toString(),
                                              ListedAt:
                                                  book.listedAt.toString(),
                                              AvailableQuantity:
                                                  book.availableQuantity
                                                      .toString(),
                                              DiscountPercent:
                                                  book.discountPercent
                                                      .toString(),
                                              DiscountStart:
                                                  book.discountStart.toString(),
                                              DiscountEnd:
                                                  book.discountEnd.toString(),
                                              Photo: book.photo.toString(),
                                            );
                                          },
                                        ),
                                      );
                                    });
                                  },
                                  itemCount: FilteredBookListDateAesc.length,
                                ),
                          );
                    } else if (BookInfoList.length >= 1 &&
                        Search_Box_Cont.text.isEmptyOrNull &&
                        Filter_Sort_Value.isNotEmptyAndNotNull &&
                        Filter_Sort_Value == "Date descending") {
                      try {
                        print("Filtered book list add item condition called.");
                        final sort_result = sortBooksByPublicationDateDesc(
                          BookInfoList,
                        );
                        if (FilteredBookListDateDesc.length <= 0) {
                          FilteredBookListDateDesc.clear();
                          Toastget().Toastmsg(
                            "Not available book information.",
                          );
                          print("Not available book information.");
                        }
                      } catch (Obj) {
                        FilteredBookListDateDesc.clear();
                        Toastget().Toastmsg("Not available book information.");
                        print("Not available book information.");
                        print(Obj.toString());
                      }
                      return FilteredBookListDateDesc.isEmpty
                          ? Center(
                            child: Text(
                              "No book data available.",
                              style: TextStyle(
                                fontFamily: regular,
                                color: Colors.teal[800],
                                fontSize: shortestval * 0.05,
                              ),
                            ),
                          )
                          : Builder(
                            builder:
                                (context) => ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: shortestval * 0.05,
                                  ),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    final book =
                                        FilteredBookListDateDesc[index];
                                    return Card(
                                      elevation: 6,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.white,
                                              Colors.teal[50]!,
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 8,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [


                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.all(
                                                  shortestval * 0.03,
                                                ),
                                                child: Text(
                                                  "Book ISBN: ${book.bookId}",
                                                  style: TextStyle(
                                                    fontFamily: semibold,
                                                    fontSize:
                                                    shortestval * 0.055,
                                                    color: Colors.teal[900],
                                                  ),
                                                ),
                                              ),
                                            ),

                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.all(
                                                  shortestval * 0.03,
                                                ),
                                                child: Text(
                                                  "Book Name: ${book.bookName}",
                                                  style: TextStyle(
                                                    fontFamily: semibold,
                                                    fontSize:
                                                    shortestval * 0.055,
                                                    color: Colors.teal[900],
                                                  ),
                                                ),
                                              ),
                                            ),


                                            Padding(
                                              padding: EdgeInsets.only(
                                                right: shortestval * 0.03,
                                              ),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "${book.publicationDate}",
                                                    style: TextStyle(
                                                      fontFamily: regular,
                                                      fontSize:
                                                          shortestval * 0.045,
                                                      color: Colors.teal[600],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: shortestval * 0.02,
                                                  ),
                                                  Icon(
                                                    Icons.book_outlined,
                                                    color: Colors.teal[600],
                                                    size: shortestval * 0.07,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ).onTap(() {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return BookDetails(
                                              jwttoken: widget.jwttoken,
                                              usertype: widget.usertype,
                                              email: widget.email,
                                              BookId: book.bookId.toString(),
                                              BookName:
                                                  book.bookName.toString(),
                                              Price: book.price.toString(),
                                              Format: book.format.toString(),
                                              Title: book.title.toString(),
                                              Author: book.author.toString(),
                                              Publisher:
                                                  book.publisher.toString(),
                                              PublicationDate:
                                                  book.publicationDate
                                                      .toString(),
                                              Language:
                                                  book.language.toString(),
                                              Category:
                                                  book.category.toString(),
                                              ListedAt:
                                                  book.listedAt.toString(),
                                              AvailableQuantity:
                                                  book.availableQuantity
                                                      .toString(),
                                              DiscountPercent:
                                                  book.discountPercent
                                                      .toString(),
                                              DiscountStart:
                                                  book.discountStart.toString(),
                                              DiscountEnd:
                                                  book.discountEnd.toString(),
                                              Photo: book.photo.toString(),
                                            );
                                          },
                                        ),
                                      );
                                    });
                                  },
                                  itemCount: FilteredBookListDateDesc.length,
                                ),
                          );
                    } else if (BookInfoList.length >= 1 &&
                        Search_Box_Cont.text.isEmptyOrNull &&
                        Filter_Sort_Value.isNotEmptyAndNotNull &&
                        Filter_Sort_Value == "Price descending") {
                      try {
                        print("Filtered book list add item condition called.");
                        final sort_result = sortBooksByPriceDesc(BookInfoList);
                        if (FilteredBookListPriceDesc.length <= 0) {
                          FilteredBookListPriceDesc.clear();
                          Toastget().Toastmsg(
                            "Not available book information.",
                          );
                          print("Not available book information.");
                        }
                      } catch (Obj) {
                        FilteredBookListPriceDesc.clear();
                        Toastget().Toastmsg("Not available book information.");
                        print("Not available book information.");
                        print(Obj.toString());
                      }
                      return FilteredBookListPriceDesc.isEmpty
                          ? Center(
                            child: Text(
                              "No book data available.",
                              style: TextStyle(
                                fontFamily: regular,
                                color: Colors.teal[800],
                                fontSize: shortestval * 0.05,
                              ),
                            ),
                          )
                          : Builder(
                            builder:
                                (context) => ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: shortestval * 0.05,
                                  ),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    final book =
                                        FilteredBookListPriceDesc[index];
                                    return Card(
                                      elevation: 6,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.white,
                                              Colors.teal[50]!,
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 8,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [


                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.all(
                                                  shortestval * 0.03,
                                                ),
                                                child: Text(
                                                  "Book ISBN: ${book.bookId}",
                                                  style: TextStyle(
                                                    fontFamily: semibold,
                                                    fontSize:
                                                    shortestval * 0.055,
                                                    color: Colors.teal[900],
                                                  ),
                                                ),
                                              ),
                                            ),

                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.all(
                                                  shortestval * 0.03,
                                                ),
                                                child: Text(
                                                  "Book Name: ${book.bookName}",
                                                  style: TextStyle(
                                                    fontFamily: semibold,
                                                    fontSize:
                                                    shortestval * 0.055,
                                                    color: Colors.teal[900],
                                                  ),
                                                ),
                                              ),
                                            ),


                                            Padding(
                                              padding: EdgeInsets.only(
                                                right: shortestval * 0.03,
                                              ),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "${book.price}",
                                                    style: TextStyle(
                                                      fontFamily: regular,
                                                      fontSize:
                                                          shortestval * 0.045,
                                                      color: Colors.teal[600],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: shortestval * 0.02,
                                                  ),
                                                  Icon(
                                                    Icons.book_outlined,
                                                    color: Colors.teal[600],
                                                    size: shortestval * 0.07,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ).onTap(() {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return BookDetails(
                                              jwttoken: widget.jwttoken,
                                              usertype: widget.usertype,
                                              email: widget.email,
                                              BookId: book.bookId.toString(),
                                              BookName:
                                                  book.bookName.toString(),
                                              Price: book.price.toString(),
                                              Format: book.format.toString(),
                                              Title: book.title.toString(),
                                              Author: book.author.toString(),
                                              Publisher:
                                                  book.publisher.toString(),
                                              PublicationDate:
                                                  book.publicationDate
                                                      .toString(),
                                              Language:
                                                  book.language.toString(),
                                              Category:
                                                  book.category.toString(),
                                              ListedAt:
                                                  book.listedAt.toString(),
                                              AvailableQuantity:
                                                  book.availableQuantity
                                                      .toString(),
                                              DiscountPercent:
                                                  book.discountPercent
                                                      .toString(),
                                              DiscountStart:
                                                  book.discountStart.toString(),
                                              DiscountEnd:
                                                  book.discountEnd.toString(),
                                              Photo: book.photo.toString(),
                                            );
                                          },
                                        ),
                                      );
                                    });
                                  },
                                  itemCount: FilteredBookListPriceDesc.length,
                                ),
                          );
                    } else if (BookInfoList.length >= 1 &&
                        Search_Box_Cont.text.isEmptyOrNull &&
                        Filter_Sort_Value.isNotEmptyAndNotNull &&
                        Filter_Sort_Value == "Price aescending") {
                      try {
                        print("Filtered book list add item condition called.");
                        final sort_result = sortBooksByPriceAsc(BookInfoList);
                        if (FilteredBookListPriceAesc.length <= 0) {
                          FilteredBookListPriceAesc.clear();
                          Toastget().Toastmsg(
                            "Not available book information.",
                          );
                          print("Not available book information.");
                        }
                      } catch (Obj) {
                        FilteredBookListPriceAesc.clear();
                        Toastget().Toastmsg("Not available book information.");
                        print("Not available book information.");
                        print(Obj.toString());
                      }
                      return FilteredBookListPriceAesc.isEmpty
                          ? Center(
                            child: Text(
                              "No book data available.",
                              style: TextStyle(
                                fontFamily: regular,
                                color: Colors.teal[800],
                                fontSize: shortestval * 0.05,
                              ),
                            ),
                          )
                          : Builder(
                            builder:
                                (context) => ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: shortestval * 0.05,
                                  ),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    final book =
                                        FilteredBookListPriceAesc[index];
                                    return Card(
                                      elevation: 6,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.white,
                                              Colors.teal[50]!,
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 8,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [


                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.all(
                                                  shortestval * 0.03,
                                                ),
                                                child: Text(
                                                  "Book ISBN: ${book.bookId}",
                                                  style: TextStyle(
                                                    fontFamily: semibold,
                                                    fontSize:
                                                    shortestval * 0.055,
                                                    color: Colors.teal[900],
                                                  ),
                                                ),
                                              ),
                                            ),

                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.all(
                                                  shortestval * 0.03,
                                                ),
                                                child: Text(
                                                  "Book Name: ${book.bookName}",
                                                  style: TextStyle(
                                                    fontFamily: semibold,
                                                    fontSize:
                                                    shortestval * 0.055,
                                                    color: Colors.teal[900],
                                                  ),
                                                ),
                                              ),
                                            ),


                                            Padding(
                                              padding: EdgeInsets.only(
                                                right: shortestval * 0.03,
                                              ),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "${book.price}",
                                                    style: TextStyle(
                                                      fontFamily: regular,
                                                      fontSize:
                                                          shortestval * 0.045,
                                                      color: Colors.teal[600],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: shortestval * 0.02,
                                                  ),
                                                  Icon(
                                                    Icons.book_outlined,
                                                    color: Colors.teal[600],
                                                    size: shortestval * 0.07,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ).onTap(() {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return BookDetails(
                                              jwttoken: widget.jwttoken,
                                              usertype: widget.usertype,
                                              email: widget.email,
                                              BookId: book.bookId.toString(),
                                              BookName:
                                                  book.bookName.toString(),
                                              Price: book.price.toString(),
                                              Format: book.format.toString(),
                                              Title: book.title.toString(),
                                              Author: book.author.toString(),
                                              Publisher:
                                                  book.publisher.toString(),
                                              PublicationDate:
                                                  book.publicationDate
                                                      .toString(),
                                              Language:
                                                  book.language.toString(),
                                              Category:
                                                  book.category.toString(),
                                              ListedAt:
                                                  book.listedAt.toString(),
                                              AvailableQuantity:
                                                  book.availableQuantity
                                                      .toString(),
                                              DiscountPercent:
                                                  book.discountPercent
                                                      .toString(),
                                              DiscountStart:
                                                  book.discountStart.toString(),
                                              DiscountEnd:
                                                  book.discountEnd.toString(),
                                              Photo: book.photo.toString(),
                                            );
                                          },
                                        ),
                                      );
                                    });
                                  },
                                  itemCount: FilteredBookListPriceAesc.length,
                                ),
                          );
                    } else if (BookReviewInfoList.length >= 1 &&
                        Search_Box_Cont.text.isEmptyOrNull &&
                        Filter_Sort_Value.isNotEmptyAndNotNull &&
                        Filter_Sort_Value == "Ratings aescending") {
                      try {
                        print("Filtered user list add item condition called.");
                        final Sort_Result = sortBooksByRatingAsc(
                          BookReviewInfoList,
                        );
                        if (FilteredBookListRatingsAesc.length <= 0) {
                          FilteredBookListRatingsAesc.clear();
                          Toastget().Toastmsg("No book data available.");
                          print("No book data available.");
                        }
                      } catch (Obj) {
                        FilteredBookListRatingsAesc.clear();
                        Toastget().Toastmsg("No book data available.");
                        print(
                          "Exception caught while filtering book info list",
                        );
                        print(Obj.toString());
                      }
                      return FilteredBookListRatingsAesc.isEmpty
                          ? Center(
                            child: Text(
                              "No book data available.",
                              style: TextStyle(
                                fontFamily: regular,
                                color: Colors.teal[800],
                                fontSize: shortestval * 0.05,
                              ),
                            ),
                          )
                          : Builder(
                            builder:
                                (context) => ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: shortestval * 0.05,
                                  ),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    final book =
                                        FilteredBookListRatingsAesc[index];
                                    return Card(
                                      elevation: 6,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.white,
                                              Colors.teal[50]!,
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 8,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [



                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.all(
                                                  shortestval * 0.03,
                                                ),
                                                child: Text(
                                                  "Book ISBN: ${book.bookId}",
                                                  style: TextStyle(
                                                    fontFamily: semibold,
                                                    fontSize:
                                                    shortestval * 0.055,
                                                    color: Colors.teal[900],
                                                  ),
                                                ),
                                              ),
                                            ),

                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.all(
                                                  shortestval * 0.03,
                                                ),
                                                child: Text(
                                                  "Book Name: ${book.bookName}",
                                                  style: TextStyle(
                                                    fontFamily: semibold,
                                                    fontSize:
                                                    shortestval * 0.055,
                                                    color: Colors.teal[900],
                                                  ),
                                                ),
                                              ),
                                            ),


                                            Padding(
                                              padding: EdgeInsets.only(
                                                right: shortestval * 0.03,
                                              ),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "Rating: ${book.rating}",
                                                    style: TextStyle(
                                                      fontFamily: regular,
                                                      fontSize:
                                                          shortestval * 0.045,
                                                      color: Colors.teal[600],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: shortestval * 0.02,
                                                  ),
                                                  Icon(
                                                    Icons.book_online_outlined,
                                                    color: Colors.teal[600],
                                                    size: shortestval * 0.07,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ).onTap(() {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return BookDetails(
                                              jwttoken: widget.jwttoken,
                                              usertype: widget.usertype,
                                              email: widget.email,
                                              BookId: book.bookId.toString(),
                                              BookName:
                                                  book.bookName.toString(),
                                              Price: book.price.toString(),
                                              Format: book.format.toString(),
                                              Title: book.title.toString(),
                                              Author: book.author.toString(),
                                              Publisher:
                                                  book.publisher.toString(),
                                              PublicationDate:
                                                  book.publicationDate
                                                      .toString(),
                                              Language:
                                                  book.language.toString(),
                                              Category:
                                                  book.category.toString(),
                                              ListedAt:
                                                  book.listedAt.toString(),
                                              AvailableQuantity:
                                                  book.availableQuantity
                                                      .toString(),
                                              DiscountPercent:
                                                  book.discountPercent
                                                      .toString(),
                                              DiscountStart:
                                                  book.discountStart.toString(),
                                              DiscountEnd:
                                                  book.discountEnd.toString(),
                                              Photo: book.photo.toString(),
                                            );
                                          },
                                        ),
                                      );
                                    });
                                  },
                                  itemCount: FilteredBookListRatingsAesc.length,
                                ),
                          );
                    } else if (BookReviewInfoList.length >= 1 &&
                        Search_Box_Cont.text.isEmptyOrNull &&
                        Filter_Sort_Value.isNotEmptyAndNotNull &&
                        Filter_Sort_Value == "Ratings descending") {
                      try {
                        print("Filtered user list add item condition called.");
                        final Sort_Result = sortBooksByRatingDesc(
                          BookReviewInfoList,
                        );
                        print("Filter rating result");
                        print(Sort_Result);
                        if (FilteredBookListRatingsDesc.length <= 0) {
                          FilteredBookListRatingsDesc.clear();
                          Toastget().Toastmsg("No book data available.");
                          print("No book data available.");
                        }
                      } catch (Obj) {
                        FilteredBookListRatingsDesc.clear();
                        Toastget().Toastmsg("No book data available.");
                        print(
                          "Exception caught while filtering book info list",
                        );
                        print(Obj.toString());
                      }
                      return FilteredBookListRatingsDesc.isEmpty
                          ? Center(
                            child: Text(
                              "No book data available.",
                              style: TextStyle(
                                fontFamily: regular,
                                color: Colors.teal[800],
                                fontSize: shortestval * 0.05,
                              ),
                            ),
                          )
                          : Builder(
                            builder:
                                (context) => ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: shortestval * 0.05,
                                  ),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    final book =
                                        FilteredBookListRatingsDesc[index];
                                    return Card(
                                      elevation: 6,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.white,
                                              Colors.teal[50]!,
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 8,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [


                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.all(
                                                  shortestval * 0.03,
                                                ),
                                                child: Text(
                                                  "Book ISBN: ${book.bookId}",
                                                  style: TextStyle(
                                                    fontFamily: semibold,
                                                    fontSize:
                                                    shortestval * 0.055,
                                                    color: Colors.teal[900],
                                                  ),
                                                ),
                                              ),
                                            ),

                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.all(
                                                  shortestval * 0.03,
                                                ),
                                                child: Text(
                                                  "Book Name: ${book.bookName}",
                                                  style: TextStyle(
                                                    fontFamily: semibold,
                                                    fontSize:
                                                    shortestval * 0.055,
                                                    color: Colors.teal[900],
                                                  ),
                                                ),
                                              ),
                                            ),


                                            Padding(
                                              padding: EdgeInsets.only(
                                                right: shortestval * 0.03,
                                              ),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "Rating: ${book.rating}",
                                                    style: TextStyle(
                                                      fontFamily: regular,
                                                      fontSize:
                                                          shortestval * 0.045,
                                                      color: Colors.teal[600],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: shortestval * 0.02,
                                                  ),
                                                  Icon(
                                                    Icons.book_online_outlined,
                                                    color: Colors.teal[600],
                                                    size: shortestval * 0.07,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ).onTap(() {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return BookDetails(
                                              jwttoken: widget.jwttoken,
                                              usertype: widget.usertype,
                                              email: widget.email,
                                              BookId: book.bookId.toString(),
                                              BookName:
                                                  book.bookName.toString(),
                                              Price: book.price.toString(),
                                              Format: book.format.toString(),
                                              Title: book.title.toString(),
                                              Author: book.author.toString(),
                                              Publisher:
                                                  book.publisher.toString(),
                                              PublicationDate:
                                                  book.publicationDate
                                                      .toString(),
                                              Language:
                                                  book.language.toString(),
                                              Category:
                                                  book.category.toString(),
                                              ListedAt:
                                                  book.listedAt.toString(),
                                              AvailableQuantity:
                                                  book.availableQuantity
                                                      .toString(),
                                              DiscountPercent:
                                                  book.discountPercent
                                                      .toString(),
                                              DiscountStart:
                                                  book.discountStart.toString(),
                                              DiscountEnd:
                                                  book.discountEnd.toString(),
                                              Photo: book.photo.toString(),
                                            );
                                          },
                                        ),
                                      );
                                    });
                                  },
                                  itemCount: FilteredBookListRatingsDesc.length,
                                ),
                          );
                    } else if (BookInfoList.length >= 1 &&
                        Search_Box_Cont.text.isEmptyOrNull &&
                        Filter_Sort_Value.isEmptyOrNull) {
                      return Builder(
                        builder:
                            (context) => Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: shortestval * 0.03,
                                  ),
                                  child: Text(
                                    "All Books",
                                    style: TextStyle(
                                      fontFamily: bold,
                                      fontSize: shortestval * 0.07,
                                      color: Colors.teal[900],
                                      shadows: [
                                        Shadow(
                                          color: Colors.black26,
                                          offset: Offset(0, 2),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: shortestval * 0.05,
                                  ),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    final book = BookInfoList[index];
                                    return Card(
                                      elevation: 6,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.white,
                                              Colors.teal[50]!,
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 8,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.all(
                                                  shortestval * 0.03,
                                                ),
                                                child: Text(
                                                  "Book ISBN: ${book.bookId}",
                                                  style: TextStyle(
                                                    fontFamily: semibold,
                                                    fontSize:
                                                        shortestval * 0.055,
                                                    color: Colors.teal[900],
                                                  ),
                                                ),
                                              ),
                                            ),

                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.all(
                                                  shortestval * 0.03,
                                                ),
                                                child: Text(
                                                  "Book: ${book.bookName}",
                                                  style: TextStyle(
                                                    fontFamily: semibold,
                                                    fontSize:
                                                        shortestval * 0.055,
                                                    color: Colors.teal[900],
                                                  ),
                                                ),
                                              ),
                                            ),

                                            Padding(
                                              padding: EdgeInsets.only(
                                                right: shortestval * 0.03,
                                              ),
                                              child: Icon(
                                                Icons.book_online_outlined,
                                                color: Colors.teal[600],
                                                size: shortestval * 0.07,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ).onTap(() {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return BookDetails(
                                              jwttoken: widget.jwttoken,
                                              usertype: widget.usertype,
                                              email: widget.email,
                                              BookId: book.bookId.toString(),
                                              BookName:
                                                  book.bookName.toString(),
                                              Price: book.price.toString(),
                                              Format: book.format.toString(),
                                              Title: book.title.toString(),
                                              Author: book.author.toString(),
                                              Publisher:
                                                  book.publisher.toString(),
                                              PublicationDate:
                                                  book.publicationDate
                                                      .toString(),
                                              Language:
                                                  book.language.toString(),
                                              Category:
                                                  book.category.toString(),
                                              ListedAt:
                                                  book.listedAt.toString(),
                                              AvailableQuantity:
                                                  book.availableQuantity
                                                      .toString(),
                                              DiscountPercent:
                                                  book.discountPercent
                                                      .toString(),
                                              DiscountStart:
                                                  book.discountStart.toString(),
                                              DiscountEnd:
                                                  book.discountEnd.toString(),
                                              Photo: book.photo.toString(),
                                            );
                                          },
                                        ),
                                      );
                                    });
                                  },
                                  itemCount: BookInfoList.length,
                                ),
                              ],
                            ),
                      );
                    } else {
                      return BookInfoList.isEmpty
                          ? Center(
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: shortestval * 0.03,
                                  ),
                                  child: Text(
                                    "All Books",
                                    style: TextStyle(
                                      fontFamily: bold,
                                      fontSize: shortestval * 0.07,
                                      color: Colors.teal[900],
                                      shadows: [
                                        Shadow(
                                          color: Colors.black26,
                                          offset: Offset(0, 2),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Text(
                                  "No book data available.",
                                  style: TextStyle(
                                    fontFamily: regular,
                                    color: Colors.teal[800],
                                    fontSize: shortestval * 0.05,
                                  ),
                                ),
                              ],
                            ),
                          )
                          : Builder(
                            builder:
                                (context) => Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: shortestval * 0.03,
                                      ),
                                      child: Text(
                                        "All Books",
                                        style: TextStyle(
                                          fontFamily: bold,
                                          fontSize: shortestval * 0.07,
                                          color: Colors.teal[900],
                                          shadows: [
                                            Shadow(
                                              color: Colors.black26,
                                              offset: Offset(0, 2),
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: shortestval * 0.05,
                                      ),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        final book = BookInfoList[index];
                                        return Card(
                                          elevation: 6,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.white,
                                                  Colors.teal[50]!,
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black26,
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                // ClipOval(
                                                //   child: Image.memory(
                                                //     base64Decode(book.photo!),
                                                //     fit: BoxFit.cover,
                                                //     errorBuilder: (context, error, stackTrace) =>
                                                //     const Icon(
                                                //       Icons.broken_image,
                                                //       size: 100,
                                                //       color: Colors.grey,
                                                //     ),
                                                //   ),
                                                // ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                      shortestval * 0.03,
                                                    ),
                                                    child: Text(
                                                      "Book ISBN: ${book.bookId}",
                                                      style: TextStyle(
                                                        fontFamily: semibold,
                                                        fontSize:
                                                            shortestval * 0.055,
                                                        color: Colors.teal[900],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                      shortestval * 0.03,
                                                    ),
                                                    child: Text(
                                                      "Book: ${book.bookName}",
                                                      style: TextStyle(
                                                        fontFamily: semibold,
                                                        fontSize:
                                                            shortestval * 0.055,
                                                        color: Colors.teal[900],
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                Padding(
                                                  padding: EdgeInsets.only(
                                                    right: shortestval * 0.03,
                                                  ),
                                                  child: Icon(
                                                    Icons.book_online_outlined,
                                                    color: Colors.teal[600],
                                                    size: shortestval * 0.07,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ).onTap(() {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return BookDetails(
                                                  jwttoken: widget.jwttoken,
                                                  usertype: widget.usertype,
                                                  email: widget.email,
                                                  BookId:
                                                      book.bookId.toString(),
                                                  BookName:
                                                      book.bookName.toString(),
                                                  Price: book.price.toString(),
                                                  Format:
                                                      book.format.toString(),
                                                  Title: book.title.toString(),
                                                  Author:
                                                      book.author.toString(),
                                                  Publisher:
                                                      book.publisher.toString(),
                                                  PublicationDate:
                                                      book.publicationDate
                                                          .toString(),
                                                  Language:
                                                      book.language.toString(),
                                                  Category:
                                                      book.category.toString(),
                                                  ListedAt:
                                                      book.listedAt.toString(),
                                                  AvailableQuantity:
                                                      book.availableQuantity
                                                          .toString(),
                                                  DiscountPercent:
                                                      book.discountPercent
                                                          .toString(),
                                                  DiscountStart:
                                                      book.discountStart
                                                          .toString(),
                                                  DiscountEnd:
                                                      book.discountEnd
                                                          .toString(),
                                                  Photo: book.photo.toString(),
                                                );
                                              },
                                            ),
                                          );
                                        });
                                      },
                                      itemCount: BookInfoList.length,
                                    ),
                                  ],
                                ),
                          );
                    }
                  } else {
                    return Center(
                      child: Text(
                        "Please reopen app.",
                        style: TextStyle(
                          fontFamily: regular,
                          color: Colors.red[700],
                          fontSize: shortestval * 0.05,
                        ),
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: heightval * 0.02),
              SizedBox(width: double.infinity, child: FooterWidget()),
              SizedBox(height: heightval * 0.02),
            ],
          ),
        ),
      ),
    );
  }

  // Sorting methods section
  int sortBooksByPublicationDateAsc(List<BooKInfos> bookList) {
    try {
      List<BooKInfos> sortedList = List.from(bookList);
      sortedList.sort((a, b) {
        DateTime dateA =
            DateTime.tryParse(a.publicationDate ?? '') ?? DateTime(1900);
        DateTime dateB =
            DateTime.tryParse(b.publicationDate ?? '') ?? DateTime(1900);
        return dateA.compareTo(dateB);
      });
      FilteredBookListDateAesc.clear();
      FilteredBookListDateAesc.addAll(sortedList);
      return 1;
    } catch (e) {
      print('Error sorting by publication date ASC: $e');
      return 0;
    }
  }

  int sortBooksByPublicationDateDesc(List<BooKInfos> bookList) {
    try {
      List<BooKInfos> sortedList = List.from(bookList);
      sortedList.sort((a, b) {
        DateTime dateA =
            DateTime.tryParse(a.publicationDate ?? '') ?? DateTime(1900);
        DateTime dateB =
            DateTime.tryParse(b.publicationDate ?? '') ?? DateTime(1900);
        return dateB.compareTo(dateA);
      });
      FilteredBookListDateDesc.clear();
      FilteredBookListDateDesc.addAll(sortedList);
      return 1;
    } catch (e) {
      print('Error sorting by publication date DESC: $e');
      return 0;
    }
  }

  int sortBooksByPriceAsc(List<BooKInfos> bookList) {
    try {
      List<BooKInfos> sortedList = List.from(bookList);
      sortedList.sort((a, b) {
        double priceA = a.price ?? 0.0;
        double priceB = b.price ?? 0.0;
        return priceA.compareTo(priceB);
      });
      FilteredBookListPriceAesc.clear();
      FilteredBookListPriceAesc.addAll(sortedList);
      return 1;
    } catch (e) {
      print('Error sorting by price ASC: $e');
      return 0;
    }
  }

  int sortBooksByPriceDesc(List<BooKInfos> bookList) {
    try {
      List<BooKInfos> sortedList = List.from(bookList);
      sortedList.sort((a, b) {
        double priceA = a.price ?? 0.0;
        double priceB = b.price ?? 0.0;
        return priceB.compareTo(priceA);
      });
      FilteredBookListPriceDesc.clear();
      FilteredBookListPriceDesc.addAll(sortedList);
      return 1;
    } catch (e) {
      print('Error sorting by price DESC: $e');
      return 0;
    }
  }

  int sortBooksByRatingAsc(List<BooksWithReviewModel> bookList) {
    try {
      List<BooksWithReviewModel> sortedList = List.from(bookList);
      sortedList.sort((a, b) {
        int ratingA = a.rating ?? 0;
        int ratingB = b.rating ?? 0;
        return ratingA.compareTo(ratingB);
      });
      FilteredBookListRatingsAesc.clear();
      FilteredBookListRatingsAesc.addAll(sortedList);
      return 1;
    } catch (e) {
      print('Error sorting by rating ASC: $e');
      return 0;
    }
  }

  int sortBooksByRatingDesc(List<BooksWithReviewModel> bookList) {
    try {
      List<BooksWithReviewModel> sortedList = List.from(bookList);
      sortedList.sort((a, b) {
        int ratingA = a.rating ?? 0;
        int ratingB = b.rating ?? 0;
        return ratingB.compareTo(ratingA);
      });
      FilteredBookListRatingsDesc.clear();
      FilteredBookListRatingsDesc.addAll(sortedList);
      return 1;
    } catch (e) {
      print('Error sorting by rating DESC: $e');
      return 0;
    }
  }
}
