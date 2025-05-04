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
import '../../common widget/common_method.dart';
import '../../common widget/toast.dart';
import 'member_login_page.dart';

class BookScreen extends StatefulWidget {
  final String email;
  final String usertype;
  final String jwttoken;
  const BookScreen({super.key,required this.jwttoken,required this.usertype,required this.email});


  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen>  {


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
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => UserNotLoginHomeScreen()));
      Toastget().Toastmsg("Error. Relogin please.");
    }
  }


  String? Filter_Sort_Value="";
  final Search_Box_Cont=TextEditingController();
  List<BooKInfos> BookInfoList = [];
  List<BooKInfos> FilteredBookListIdOrTittleOrAuthor = [];
  List<BooKInfos> FilteredBookListDateAesc = [];
  List<BooKInfos> FilteredBookListDateDesc= [];
  List<BooKInfos> FilteredBookListPriceDesc = [];
  List<BooKInfos> FilteredBookListPriceAesc = [];

  List<BooksWithReviewModel> BookReviewInfoList=[];
  List<BooksWithReviewModel> FilteredBookListRatingsAesc = [];
  List<BooksWithReviewModel> FilteredBookListRatingsDesc = [];


  Future<void> GetBookReviewInfos() async {
    try {
      print("Get books with review info method called");
      const String url = Backend_Server_Url + "api/Member/getbookswithreviews";
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
        BookReviewInfoList.clear();
        BookReviewInfoList.addAll(responseData.map((data) => BooksWithReviewModel.fromJson(data)).toList());
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
      print("Exception caught while fetching book  review data in http method");
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
      if (response.statusCode == 200) {
        List<dynamic> responseData = await jsonDecode(response.body);
        print("response body");
        print(responseData);
        BookInfoList.clear();
        BookInfoList.addAll(responseData.map((data) => BooKInfos.fromJson(data)).toList());
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



  @override
  Widget build(BuildContext context)
  {
    var shortestval = MediaQuery.of(context).size.shortestSide;
    var widthval = MediaQuery.of(context).size.width;
    var heightval = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
        automaticallyImplyLeading: true,
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
    shadowColor: Colors.black45,
          actions: [
                Row (
                  children: [
                    Text(
                      "Sort/Filters",
                      style: TextStyle(fontFamily: semibold, color: Colors.white, fontSize: shortestval * 0.04),
                    ),
                    PopupMenuButton<String>
                      (
                      onSelected: (value) async
                      {
                        if (value == 'Date aescending')
                        {
                          setState(() {
                            Filter_Sort_Value="Date aescending";
                          });
                        }
                        else if(value == 'Date descending')
                        {
                          setState(() {
                            Filter_Sort_Value="Date descending";
                          });
                        }
                        else if(value == 'Price descending')
                        {
                          setState(() {
                            Filter_Sort_Value="Price descending";
                          });
                        }
                        else if(value == 'Price aescending')
                        {
                          setState(() {
                            Filter_Sort_Value="Price aescending";
                          });
                        }
                        else if(value == 'Ratings aescending')
                        {
                          setState(() {
                            Filter_Sort_Value="Ratings aescending";
                          });
                        }
                        else if(value == 'Ratings descending')
                        {
                          setState(() {
                            Filter_Sort_Value="Ratings descending";
                          });
                        }
                        else{
                          setState(() {
                            Filter_Sort_Value="";
                          });
                        }
                      },
                      itemBuilder: (context) =>
                      [
                        PopupMenuItem(value: '', child: Text('No filter/sort',style: TextStyle(fontFamily:semibold,color: Colors.black,fontSize: shortestval*0.06),)),
                        PopupMenuItem(value: 'Date aescending', child: Text('Date aescending',style: TextStyle(fontFamily:semibold,color: Colors.black,fontSize: shortestval*0.06),)),
                        PopupMenuItem(value: 'Date descending', child: Text('Date descending',style: TextStyle(fontFamily:semibold,color: Colors.black,fontSize: shortestval*0.06),)),
                        PopupMenuItem(value: 'Price aescending', child: Text('Price aescending',style: TextStyle(fontFamily:semibold,color: Colors.black,fontSize: shortestval*0.06),)),
                        PopupMenuItem(value: 'Price descending', child: Text('Price descending',style: TextStyle(fontFamily:semibold,color: Colors.black,fontSize: shortestval*0.06),)),
                        PopupMenuItem(value: 'Ratings aescending', child: Text('Ratings aescending',style: TextStyle(fontFamily:semibold,color: Colors.black,fontSize: shortestval*0.06),)),
                        PopupMenuItem(value: 'Ratings descending', child: Text('Ratings descending',style: TextStyle(fontFamily:semibold,color: Colors.black,fontSize: shortestval*0.06),)),
                      ],
                    ),
                  ],
                ),




          ],
        ),
      body: Container(
        child:
    SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: BouncingScrollPhysics(),
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

              TextFormField
                (
                  onChanged: (value)
                  {
                    setState(()
                    {
                    });
                  },
                  controller: Search_Box_Cont,
                  obscureText: false,
                  decoration:InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.black,
                          width: shortestval*0.01
                      ),
                      borderRadius: BorderRadius.circular(shortestval*0.04),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.black,
                          width: shortestval*0.01
                      ),
                      borderRadius: BorderRadius.circular(shortestval*0.04),
                    ),
                    hintText: "Search by ISBN,tittle or author.",
                    prefixIcon: Icon(Icons.search),
                  )
              ),
              SizedBox(
                height: heightval*0.01,
              ),

              FutureBuilder<void>
                (
                  future: Filter_Sort_Value==""?GetBookInfo():GetBookReviewInfos(),
                  builder: (context, snapshot)
                  {
                    if (snapshot.connectionState == ConnectionState.waiting)
                    {
                      // Show a loading indicator while the future is executing
                      return Center(child: CircularProgressIndicator());
                    }
                    else if (snapshot.hasError)
                    {
                      // Handle any error from the future
                      return Center(
                        child: Text(
                          "Error fetching user data. Please reopen app.",
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      );
                    }

                    else if (snapshot.connectionState == ConnectionState.done)
                    {

                      if(Search_Box_Cont.text.toString().isNotEmptyAndNotNull && BookInfoList.length>=1 && Filter_Sort_Value=="")
                      {

                        try {
                          print("Filtere user list add item condition called.");
                          // Iterate through your CampaignInfoList and check if postId matches the text input.
                          for (var book_info in BookInfoList) {
                            if (
                            book_info.bookId.toString().toLowerCase().trim() ==
                                Search_Box_Cont.text.toString()
                                    .toLowerCase()
                                    .trim() ||
                                book_info.title.toString()
                                    .toLowerCase()
                                    .trim() == Search_Box_Cont.text.toString()
                                    .toLowerCase()
                                    .trim() ||
                                book_info.author.toString()
                                    .toLowerCase()
                                    .trim() == Search_Box_Cont.text.toString()
                                    .toLowerCase()
                                    .trim()

                            ) {
                              // If the postId matches, add it to the FilteredCampaigns list.
                              print(
                                  "Search id,author or tittle of book match and add in filter bookid/tittle info list add start.");
                              FilteredBookListIdOrTittleOrAuthor.clear();
                              FilteredBookListIdOrTittleOrAuthor.add(book_info);
                            }
                          }

                          if (FilteredBookListIdOrTittleOrAuthor.length <= 0) {
                            FilteredBookListIdOrTittleOrAuthor.clear();
                            Toastget().Toastmsg(
                                "Enter id,author or tittle of book didn't match with available user book information.");
                            print(
                                "Enter id,author or tittle of book didn't match with available user book information.");
                          }
                        } catch (Obj) {
                          FilteredBookListIdOrTittleOrAuthor.clear();
                          Toastget().Toastmsg(
                              "Enter id or tittle of book didn't match with available user book information.");
                          print(
                              "Exception caught while filtering book info list");
                          print(Obj.toString());
                        }
                        return FilteredBookListIdOrTittleOrAuthor.isEmpty
                            ? const Center(child: Text(
                            "No book data available."))
                            :
                        Builder(builder: (context) => ListView.builder (
                                   shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    final book = FilteredBookListIdOrTittleOrAuthor[index];
                                    return
                                      Card(
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .center,
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceAround,
                                          children:
                                          [
                                            Text("Book name:${book.bookName}",
                                              style: TextStyle(
                                                  fontFamily: semibold,
                                                  fontSize: shortestval *
                                                      0.05),),
                                            Icon(Icons.book_online_outlined),
                                          ],
                                        ).onTap(() {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return BookDetails(
                                                      jwttoken: widget.jwttoken,
                                                      usertype: widget.usertype
                                                      ,
                                                      email: widget.email
                                                      ,
                                                      BookId: book.bookId
                                                          .toString()
                                                      ,
                                                      BookName: book.bookName
                                                          .toString()
                                                      ,
                                                      Price: book.price
                                                          .toString()
                                                      ,
                                                      Format: book.format
                                                          .toString()
                                                      ,
                                                      Title: book.title
                                                          .toString()
                                                      ,
                                                      Author: book.author
                                                          .toString()
                                                      ,
                                                      Publisher: book.publisher
                                                          .toString()
                                                      ,
                                                      PublicationDate: book
                                                          .publicationDate
                                                          .toString()
                                                      ,
                                                      Language: book.language
                                                          .toString()
                                                      ,
                                                      Category: book.category
                                                          .toString()
                                                      ,
                                                      ListedAt: book.listedAt
                                                          .toString()
                                                      ,
                                                      AvailableQuantity: book
                                                          .availableQuantity
                                                          .toString()
                                                      ,
                                                      DiscountPercent: book
                                                          .discountPercent
                                                          .toString()
                                                      ,
                                                      DiscountStart: book
                                                          .discountStart
                                                          .toString()
                                                      ,
                                                      DiscountEnd: book
                                                          .discountEnd
                                                          .toString()
                                                      ,
                                                      Photo: book.photo
                                                          .toString()
                                                  );
                                                },
                                              )
                                          );
                                        }),
                                      );
                                  },
                                  itemCount: FilteredBookListIdOrTittleOrAuthor.length
                              ),
                        );

                      }//condition for filter

                      else if(BookInfoList.length>=1 && Search_Box_Cont.text.isEmptyOrNull && Filter_Sort_Value.isNotEmptyAndNotNull && Filter_Sort_Value=="Date aescending")
                      {

                        try {
                          print("Filtere book list add item condition called.");
                          // Iterate through your CampaignInfoList and check if postId matches the text input.
                          final sort_result=sortBooksByPublicationDateAsc(BookInfoList);
                          if (FilteredBookListDateAesc.length <= 0)
                          {
                            FilteredBookListDateAesc.clear();
                            Toastget().Toastmsg(
                                "Not available  book information.");
                            print(
                                "Not available  book information.");
                          }
                        } catch (Obj) {
                          FilteredBookListDateAesc.clear();
                          Toastget().Toastmsg(
                              "Not available  book information.");
                          print(
                              "Not available  book information.");
                          print(Obj.toString());
                        }
                        return FilteredBookListDateAesc.isEmpty
                            ? const Center(child: Text(
                            "No book data available."))
                            :
                        Builder(builder: (context) => ListView.builder (
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final book = FilteredBookListDateAesc[index];
                              return
                                Card(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceAround,
                                    children:
                                    [
                                      Text("Book name:${book.bookName}",
                                        style: TextStyle(
                                            fontFamily: semibold,
                                            fontSize: shortestval *
                                                0.05),),
                                      Icon(Icons.book_outlined),
                                      Text("${book.publicationDate}")
                                    ],
                                  ).onTap(() {
                                    Navigator.push(context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return BookDetails(
                                                jwttoken: widget.jwttoken,
                                                usertype: widget.usertype
                                                ,
                                                email: widget.email
                                                ,
                                                BookId: book.bookId
                                                    .toString()
                                                ,
                                                BookName: book.bookName
                                                    .toString()
                                                ,
                                                Price: book.price
                                                    .toString()
                                                ,
                                                Format: book.format
                                                    .toString()
                                                ,
                                                Title: book.title
                                                    .toString()
                                                ,
                                                Author: book.author
                                                    .toString()
                                                ,
                                                Publisher: book.publisher
                                                    .toString()
                                                ,
                                                PublicationDate: book
                                                    .publicationDate
                                                    .toString()
                                                ,
                                                Language: book.language
                                                    .toString()
                                                ,
                                                Category: book.category
                                                    .toString()
                                                ,
                                                ListedAt: book.listedAt
                                                    .toString()
                                                ,
                                                AvailableQuantity: book
                                                    .availableQuantity
                                                    .toString()
                                                ,
                                                DiscountPercent: book
                                                    .discountPercent
                                                    .toString()
                                                ,
                                                DiscountStart: book
                                                    .discountStart
                                                    .toString()
                                                ,
                                                DiscountEnd: book
                                                    .discountEnd
                                                    .toString()
                                                ,
                                                Photo: book.photo
                                                    .toString()
                                            );
                                          },
                                        )
                                    );
                                  }),
                                );
                            },
                            itemCount: FilteredBookListDateAesc.length
                        ),
                        );
                      }
                      else if(BookInfoList.length>=1 && Search_Box_Cont.text.isEmptyOrNull && Filter_Sort_Value.isNotEmptyAndNotNull && Filter_Sort_Value=="Date descending")
                      {

                        try {
                          print("Filtere book list add item condition called.");
                          // Iterate through your CampaignInfoList and check if postId matches the text input.
                          final sort_result=sortBooksByPublicationDateDesc(BookInfoList);
                          if (FilteredBookListDateDesc.length <= 0)
                          {
                            FilteredBookListDateDesc.clear();
                            Toastget().Toastmsg(
                                "Not available  book information.");
                            print(
                                "Not available  book information.");
                          }
                        } catch (Obj) {
                          FilteredBookListDateDesc.clear();
                          Toastget().Toastmsg(
                              "Not available  book information.");
                          print(
                              "Not available  book information.");
                          print(Obj.toString());
                        }
                        return FilteredBookListDateDesc.isEmpty
                            ? const Center(child: Text(
                            "No book data available."))
                            :
                        Builder(builder: (context) => ListView.builder (
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final book = FilteredBookListDateDesc[index];
                              return
                                Card(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceAround,
                                    children:
                                    [
                                      Text("Book name:${book.bookName}",
                                        style: TextStyle(
                                            fontFamily: semibold,
                                            fontSize: shortestval *
                                                0.05),),
                                      Icon(Icons.book_outlined),
                                      Text("${book.publicationDate}")
                                    ],
                                  ).onTap(() {
                                    Navigator.push(context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return BookDetails(
                                                jwttoken: widget.jwttoken,
                                                usertype: widget.usertype
                                                ,
                                                email: widget.email
                                                ,
                                                BookId: book.bookId
                                                    .toString()
                                                ,
                                                BookName: book.bookName
                                                    .toString()
                                                ,
                                                Price: book.price
                                                    .toString()
                                                ,
                                                Format: book.format
                                                    .toString()
                                                ,
                                                Title: book.title
                                                    .toString()
                                                ,
                                                Author: book.author
                                                    .toString()
                                                ,
                                                Publisher: book.publisher
                                                    .toString()
                                                ,
                                                PublicationDate: book
                                                    .publicationDate
                                                    .toString()
                                                ,
                                                Language: book.language
                                                    .toString()
                                                ,
                                                Category: book.category
                                                    .toString()
                                                ,
                                                ListedAt: book.listedAt
                                                    .toString()
                                                ,
                                                AvailableQuantity: book
                                                    .availableQuantity
                                                    .toString()
                                                ,
                                                DiscountPercent: book
                                                    .discountPercent
                                                    .toString()
                                                ,
                                                DiscountStart: book
                                                    .discountStart
                                                    .toString()
                                                ,
                                                DiscountEnd: book
                                                    .discountEnd
                                                    .toString()
                                                ,
                                                Photo: book.photo
                                                    .toString()
                                            );
                                          },
                                        )
                                    );
                                  }),
                                );
                            },
                            itemCount: FilteredBookListDateDesc.length
                        ),
                        );
                      }
                      else if(BookInfoList.length>=1 && Search_Box_Cont.text.isEmptyOrNull && Filter_Sort_Value.isNotEmptyAndNotNull && Filter_Sort_Value=="Price descending")
                      {

                        try {
                          print("Filtere book list add item condition called.");
                          // Iterate through your CampaignInfoList and check if postId matches the text input.
                          final sort_result=sortBooksByPriceDesc(BookInfoList);
                          if (FilteredBookListPriceDesc.length <= 0)
                          {
                            FilteredBookListPriceDesc.clear();
                            Toastget().Toastmsg(
                                "Not available  book information.");
                            print(
                                "Not available  book information.");
                          }
                        } catch (Obj) {
                          FilteredBookListPriceDesc.clear();
                          Toastget().Toastmsg(
                              "Not available  book information.");
                          print(
                              "Not available  book information.");
                          print(Obj.toString());
                        }
                        return FilteredBookListPriceDesc.isEmpty
                            ? const Center(child: Text(
                            "No book data available."))
                            :
                        Builder(builder: (context) => ListView.builder (
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final book = FilteredBookListPriceDesc[index];
                              return
                                Card(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceAround,
                                    children:
                                    [
                                      Text("Book name:${book.bookName}",
                                        style: TextStyle(
                                            fontFamily: semibold,
                                            fontSize: shortestval *
                                                0.05),),
                                      Icon(Icons.book_outlined),
                                      Text("${book.price}")
                                    ],
                                  ).onTap(() {
                                    Navigator.push(context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return BookDetails(
                                                jwttoken: widget.jwttoken,
                                                usertype: widget.usertype
                                                ,
                                                email: widget.email
                                                ,
                                                BookId: book.bookId
                                                    .toString()
                                                ,
                                                BookName: book.bookName
                                                    .toString()
                                                ,
                                                Price: book.price
                                                    .toString()
                                                ,
                                                Format: book.format
                                                    .toString()
                                                ,
                                                Title: book.title
                                                    .toString()
                                                ,
                                                Author: book.author
                                                    .toString()
                                                ,
                                                Publisher: book.publisher
                                                    .toString()
                                                ,
                                                PublicationDate: book
                                                    .publicationDate
                                                    .toString()
                                                ,
                                                Language: book.language
                                                    .toString()
                                                ,
                                                Category: book.category
                                                    .toString()
                                                ,
                                                ListedAt: book.listedAt
                                                    .toString()
                                                ,
                                                AvailableQuantity: book
                                                    .availableQuantity
                                                    .toString()
                                                ,
                                                DiscountPercent: book
                                                    .discountPercent
                                                    .toString()
                                                ,
                                                DiscountStart: book
                                                    .discountStart
                                                    .toString()
                                                ,
                                                DiscountEnd: book
                                                    .discountEnd
                                                    .toString()
                                                ,
                                                Photo: book.photo
                                                    .toString()
                                            );
                                          },
                                        )
                                    );
                                  }),
                                );
                            },
                            itemCount: FilteredBookListPriceDesc.length
                        ),
                        );
                      }
                      else if(BookInfoList.length>=1 && Search_Box_Cont.text.isEmptyOrNull && Filter_Sort_Value.isNotEmptyAndNotNull && Filter_Sort_Value=="Price aescending")
                      {

                        try {
                          print("Filtere book list add item condition called.");
                          // Iterate through your CampaignInfoList and check if postId matches the text input.
                          final sort_result=sortBooksByPriceAsc(BookInfoList);
                          if (FilteredBookListPriceAesc.length <= 0)
                          {
                            FilteredBookListPriceAesc.clear();
                            Toastget().Toastmsg(
                                "Not available  book information.");
                            print(
                                "Not available  book information.");
                          }
                        } catch (Obj) {
                          FilteredBookListPriceAesc.clear();
                          Toastget().Toastmsg(
                              "Not available  book information.");
                          print(
                              "Not available  book information.");
                          print(Obj.toString());
                        }
                        return FilteredBookListPriceAesc.isEmpty
                            ? const Center(child: Text(
                            "No book data available."))
                            :
                        Builder(builder: (context) => ListView.builder (
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final book = FilteredBookListPriceAesc[index];
                              return
                                Card(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceAround,
                                    children:
                                    [
                                      Text("Book name:${book.bookName}",
                                        style: TextStyle(
                                            fontFamily: semibold,
                                            fontSize: shortestval *
                                                0.05),),
                                      Icon(Icons.book_outlined),
                                      Text("${book.price}")
                                    ],
                                  ).onTap(() {
                                    Navigator.push(context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return BookDetails(
                                                jwttoken: widget.jwttoken,
                                                usertype: widget.usertype
                                                ,
                                                email: widget.email
                                                ,
                                                BookId: book.bookId
                                                    .toString()
                                                ,
                                                BookName: book.bookName
                                                    .toString()
                                                ,
                                                Price: book.price
                                                    .toString()
                                                ,
                                                Format: book.format
                                                    .toString()
                                                ,
                                                Title: book.title
                                                    .toString()
                                                ,
                                                Author: book.author
                                                    .toString()
                                                ,
                                                Publisher: book.publisher
                                                    .toString()
                                                ,
                                                PublicationDate: book
                                                    .publicationDate
                                                    .toString()
                                                ,
                                                Language: book.language
                                                    .toString()
                                                ,
                                                Category: book.category
                                                    .toString()
                                                ,
                                                ListedAt: book.listedAt
                                                    .toString()
                                                ,
                                                AvailableQuantity: book
                                                    .availableQuantity
                                                    .toString()
                                                ,
                                                DiscountPercent: book
                                                    .discountPercent
                                                    .toString()
                                                ,
                                                DiscountStart: book
                                                    .discountStart
                                                    .toString()
                                                ,
                                                DiscountEnd: book
                                                    .discountEnd
                                                    .toString()
                                                ,
                                                Photo: book.photo
                                                    .toString()
                                            );
                                          },
                                        )
                                    );
                                  }),
                                );
                            },
                            itemCount: FilteredBookListPriceAesc.length
                        ),
                        );
                      }
                     else if(BookReviewInfoList.length>=1 && Search_Box_Cont.text.isEmptyOrNull && Filter_Sort_Value.isNotEmptyAndNotNull && Filter_Sort_Value=="Ratings aescending")
                      {

                        try {
                          print("Filtere user list add item condition called.");

                          final Sort_Result=sortBooksByRatingAsc(BookReviewInfoList);
                          if (FilteredBookListRatingsAesc.length <= 0) {
                            FilteredBookListRatingsAesc.clear();
                            Toastget().Toastmsg(
                                "No book data available.");
                            print(
                                "No book data available.");
                          }
                        } catch (Obj) {
                          FilteredBookListRatingsAesc.clear();
                          Toastget().Toastmsg(
                              "No book data available.");
                          print(
                              "Exception caught while filtering book info list");
                          print(Obj.toString());
                        }
                        return FilteredBookListRatingsAesc.isEmpty
                            ? const Center(child: Text(
                            "No book data available."))
                            :
                        Builder(builder: (context) => ListView.builder (
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final book = FilteredBookListRatingsAesc[index];
                              return
                                Card(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceAround,
                                    children:
                                    [
                                      Text("Book name:${book.bookName}",
                                        style: TextStyle(
                                            fontFamily: semibold,
                                            fontSize: shortestval *
                                                0.05),),
                                      Icon(Icons.book_online_outlined),
                                      Text("${book.rating}")
                                    ],
                                  ).onTap(() {
                                    Navigator.push(context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return BookDetails(
                                                jwttoken: widget.jwttoken,
                                                usertype: widget.usertype
                                                ,
                                                email: widget.email
                                                ,
                                                BookId: book.bookId
                                                    .toString()
                                                ,
                                                BookName: book.bookName
                                                    .toString()
                                                ,
                                                Price: book.price
                                                    .toString()
                                                ,
                                                Format: book.format
                                                    .toString()
                                                ,
                                                Title: book.title
                                                    .toString()
                                                ,
                                                Author: book.author
                                                    .toString()
                                                ,
                                                Publisher: book.publisher
                                                    .toString()
                                                ,
                                                PublicationDate: book
                                                    .publicationDate
                                                    .toString()
                                                ,
                                                Language: book.language
                                                    .toString()
                                                ,
                                                Category: book.category
                                                    .toString()
                                                ,
                                                ListedAt: book.listedAt
                                                    .toString()
                                                ,
                                                AvailableQuantity: book
                                                    .availableQuantity
                                                    .toString()
                                                ,
                                                DiscountPercent: book
                                                    .discountPercent
                                                    .toString()
                                                ,
                                                DiscountStart: book
                                                    .discountStart
                                                    .toString()
                                                ,
                                                DiscountEnd: book
                                                    .discountEnd
                                                    .toString()
                                                ,
                                                Photo: book.photo
                                                    .toString()
                                            );
                                          },
                                        )
                                    );
                                  }),
                                );
                            },
                            itemCount: FilteredBookListRatingsAesc.length
                        ),
                        );

                      }//condition for filter
                      else if(BookReviewInfoList.length>=1 && Search_Box_Cont.text.isEmptyOrNull && Filter_Sort_Value.isNotEmptyAndNotNull && Filter_Sort_Value=="Ratings descending")
                      {

                        try {
                          print("Filtere user list add item condition called.");

                          final Sort_Result=sortBooksByRatingDesc(BookReviewInfoList);
                          print("Filter rating result");
                          print(Sort_Result);
                          if (FilteredBookListRatingsDesc.length <= 0) {
                            FilteredBookListRatingsDesc.clear();
                            Toastget().Toastmsg(
                                "No book data available.");
                            print(
                                "No book data available.");
                          }
                        } catch (Obj) {
                          FilteredBookListRatingsDesc.clear();
                          Toastget().Toastmsg(
                              "No book data available.");
                          print(
                              "Exception caught while filtering book info list");
                          print(Obj.toString());
                        }

                        return FilteredBookListRatingsDesc.isEmpty
                            ? const Center(child: Text(
                            "No book data available."))
                            :
                        Builder(builder: (context) => ListView.builder (
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final book = FilteredBookListRatingsDesc[index];
                              return
                                Card(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceAround,
                                    children:
                                    [
                                      Text("Book name:${book.bookName}",
                                        style: TextStyle(
                                            fontFamily: semibold,
                                            fontSize: shortestval *
                                                0.05),),
                                      Icon(Icons.book_online_outlined),
                                      Text("${book.rating}")
                                    ],
                                  ).onTap(() {
                                    Navigator.push(context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return BookDetails(
                                                jwttoken: widget.jwttoken,
                                                usertype: widget.usertype
                                                ,
                                                email: widget.email
                                                ,
                                                BookId: book.bookId
                                                    .toString()
                                                ,
                                                BookName: book.bookName
                                                    .toString()
                                                ,
                                                Price: book.price
                                                    .toString()
                                                ,
                                                Format: book.format
                                                    .toString()
                                                ,
                                                Title: book.title
                                                    .toString()
                                                ,
                                                Author: book.author
                                                    .toString()
                                                ,
                                                Publisher: book.publisher
                                                    .toString()
                                                ,
                                                PublicationDate: book
                                                    .publicationDate
                                                    .toString()
                                                ,
                                                Language: book.language
                                                    .toString()
                                                ,
                                                Category: book.category
                                                    .toString()
                                                ,
                                                ListedAt: book.listedAt
                                                    .toString()
                                                ,
                                                AvailableQuantity: book
                                                    .availableQuantity
                                                    .toString()
                                                ,
                                                DiscountPercent: book
                                                    .discountPercent
                                                    .toString()
                                                ,
                                                DiscountStart: book
                                                    .discountStart
                                                    .toString()
                                                ,
                                                DiscountEnd: book
                                                    .discountEnd
                                                    .toString()
                                                ,
                                                Photo: book.photo
                                                    .toString()
                                            );
                                          },
                                        )
                                    );
                                  }),
                                );
                            },
                            itemCount: FilteredBookListRatingsDesc.length
                        ),
                        );
                      }//condition for filtering

                      else if(BookInfoList.length>=1 && Search_Box_Cont.text.isEmptyOrNull && Filter_Sort_Value.isEmptyOrNull)
                      {
                        return
                        Builder(builder: (context) => ListView.builder (
                            shrinkWrap: true,
                            itemBuilder: (context, index)
                            {
                              final book = BookInfoList[index];
                              return
                                Card(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceAround,
                                    children:
                                    [
                                      Text("Book name:${book.bookName}",
                                        style: TextStyle(
                                            fontFamily: semibold,
                                            fontSize: shortestval *
                                                0.05),),
                                      Icon(Icons.book_online_outlined),
                                    ],
                                  ).onTap(() {
                                    Navigator.push(context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return BookDetails(
                                                jwttoken: widget.jwttoken,
                                                usertype: widget.usertype
                                                ,
                                                email: widget.email
                                                ,
                                                BookId: book.bookId
                                                    .toString()
                                                ,
                                                BookName: book.bookName
                                                    .toString()
                                                ,
                                                Price: book.price
                                                    .toString()
                                                ,
                                                Format: book.format
                                                    .toString()
                                                ,
                                                Title: book.title
                                                    .toString()
                                                ,
                                                Author: book.author
                                                    .toString()
                                                ,
                                                Publisher: book.publisher
                                                    .toString()
                                                ,
                                                PublicationDate: book
                                                    .publicationDate
                                                    .toString()
                                                ,
                                                Language: book.language
                                                    .toString()
                                                ,
                                                Category: book.category
                                                    .toString()
                                                ,
                                                ListedAt: book.listedAt
                                                    .toString()
                                                ,
                                                AvailableQuantity: book
                                                    .availableQuantity
                                                    .toString()
                                                ,
                                                DiscountPercent: book
                                                    .discountPercent
                                                    .toString()
                                                ,
                                                DiscountStart: book
                                                    .discountStart
                                                    .toString()
                                                ,
                                                DiscountEnd: book
                                                    .discountEnd
                                                    .toString()
                                                ,
                                                Photo: book.photo
                                                    .toString()
                                            );
                                          },
                                        )
                                    );
                                  }),
                                );
                            },
                            itemCount: BookInfoList.length
                        ),
                        );
                      }

                      else
                      {
                        return BookInfoList.isEmpty
                            ? const Center(child: Text(
                            "No book data available."))
                            :
                        Builder(builder: (context) => ListView.builder (
                            shrinkWrap: true,
                            itemBuilder: (context, index)
                            {
                              final book = BookInfoList[index];
                              return
                                Card(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceAround,
                                    children:
                                    [
                                      Text("Book name:${book.bookName}",
                                        style: TextStyle(
                                            fontFamily: semibold,
                                            fontSize: shortestval *
                                                0.05),),
                                      Icon(Icons.book_online_outlined),
                                    ],
                                  ).onTap(() {
                                    Navigator.push(context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return BookDetails(
                                                jwttoken: widget.jwttoken,
                                                usertype: widget.usertype
                                                ,
                                                email: widget.email
                                                ,
                                                BookId: book.bookId
                                                    .toString()
                                                ,
                                                BookName: book.bookName
                                                    .toString()
                                                ,
                                                Price: book.price
                                                    .toString()
                                                ,
                                                Format: book.format
                                                    .toString()
                                                ,
                                                Title: book.title
                                                    .toString()
                                                ,
                                                Author: book.author
                                                    .toString()
                                                ,
                                                Publisher: book.publisher
                                                    .toString()
                                                ,
                                                PublicationDate: book
                                                    .publicationDate
                                                    .toString()
                                                ,
                                                Language: book.language
                                                    .toString()
                                                ,
                                                Category: book.category
                                                    .toString()
                                                ,
                                                ListedAt: book.listedAt
                                                    .toString()
                                                ,
                                                AvailableQuantity: book
                                                    .availableQuantity
                                                    .toString()
                                                ,
                                                DiscountPercent: book
                                                    .discountPercent
                                                    .toString()
                                                ,
                                                DiscountStart: book
                                                    .discountStart
                                                    .toString()
                                                ,
                                                DiscountEnd: book
                                                    .discountEnd
                                                    .toString()
                                                ,
                                                Photo: book.photo
                                                    .toString()
                                            );
                                          },
                                        )
                                    );
                                  }),
                                );
                            },
                            itemCount: BookInfoList.length
                        ),
                        );
                      }

                    }//conection state waiting
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
    )
      ),
    );
  }

  //add method
  int sortBooksByPublicationDateAsc(List<BooKInfos> bookList) {
    try {
      List<BooKInfos> sortedList = List.from(bookList);
      sortedList.sort((a, b) {
        DateTime dateA = DateTime.tryParse(a.publicationDate ?? '') ?? DateTime(1900);
        DateTime dateB = DateTime.tryParse(b.publicationDate ?? '') ?? DateTime(1900);
        return dateA.compareTo(dateB);
      });

      FilteredBookListDateAesc.clear();
      FilteredBookListDateAesc.addAll(sortedList);
      return 1; // success
    } catch (e) {
      print('Error sorting by publication date ASC: $e');
      return 0; // failure
    }
  }

  int sortBooksByPublicationDateDesc(List<BooKInfos> bookList) {
    try {
      List<BooKInfos> sortedList = List.from(bookList);
      sortedList.sort((a, b) {
        DateTime dateA = DateTime.tryParse(a.publicationDate ?? '') ?? DateTime(1900);
        DateTime dateB = DateTime.tryParse(b.publicationDate ?? '') ?? DateTime(1900);
        return dateB.compareTo(dateA);
      });

      FilteredBookListDateDesc.clear();
      FilteredBookListDateDesc.addAll(sortedList);
      return 1; // success
    } catch (e) {
      print('Error sorting by publication date DESC: $e');
      return 0; // failure
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
      return 1; // success
    } catch (e) {
      print('Error sorting by price ASC: $e');
      return 0; // failure
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
      return 1; // success
    } catch (e) {
      print('Error sorting by price DESC: $e');
      return 0; // failure
    }
  }

  // Sort ratings in ascending order
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
      return 1; // success
    } catch (e) {
      print('Error sorting by rating ASC: $e');
      return 0; // failure
    }
  }

// Sort ratings in descending order
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
      return 1; // success
    } catch (e) {
      print('Error sorting by rating DESC: $e');
      return 0; // failure
    }
  }

}
