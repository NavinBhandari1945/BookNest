import 'dart:convert';

import 'package:booknest/Views/Pages/Home/user_not_login_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../Models/BookInfosModel.dart';
import '../../../constant/constant.dart';
import '../../../constant/styles.dart';
import '../../common widget/common_method.dart';
import '../../common widget/commonbutton.dart';
import '../../common widget/toast.dart';

class BookScreen extends StatefulWidget {
  final String email;
  final String usertype;
  final String jwttoken;
  const BookScreen({super.key,required this.jwttoken,required this.usertype,required this.email});


  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  final Search_Box_Cont=TextEditingController();
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



  List<BooKInfos> BookInfoList = [];
  List<BooKInfos> FilteredBookList = [];

  Future<void> GetBookInfos() async {
    try {
      print("Get booksinfo method called");
      const String url = Backend_Server_Url + "api/Member/getbooksinfo";
      final headers = {
        'Authorization': 'Bearer ${widget.jwttoken}',
        'Content-Type': 'application/json',
      };
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        List<dynamic> responseData = await jsonDecode(response.body);
        BookInfoList.clear();
        BookInfoList.addAll(responseData.map((data) => BooKInfos.fromJson(data)).toList());
        print("Book list count value");
        print(BookInfoList.length);
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
        child:
    SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: BouncingScrollPhysics(),
      child: Column(
            children: [

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
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                  )
              ),
              SizedBox(
                height: heightval*0.01,
              ),

              FutureBuilder<void>
                (
                  future: GetBookInfos(),
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
                          "Error fetching user data. Please reopen app.",
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      );
                    }
                    else if (snapshot.connectionState == ConnectionState.done)
                    {
                      if(Search_User_Action_cont.text.toString().isNotEmptyAndNotNull && User_Info_List.length>=1)
                      {
                        try {
                          print("Filtere user list add item condition called.");
                          // Iterate through your CampaignInfoList and check if postId matches the text input.
                          for (var user_info in User_Info_List)
                          {
                            if (user_info.username.toString().toLowerCase().trim()==Search_User_Action_cont.text.toString().toLowerCase().trim())
                            {
                              // If the postId matches, add it to the FilteredCampaigns list.
                              print("Search username of cuser match and add in filter user info list.");
                              print("Username= ${user_info.username}");
                              Filter_User_Info_List.clear();
                              Filter_User_Info_List.add(user_info);
                            }

                          }

                          if(Filter_User_Info_List.length<=0)
                          {
                            Filter_User_Info_List.clear();
                            Toastget().Toastmsg("Enter username didn't match with available user username.");
                            print("Enter username didn't match with available user username.");
                          }
                        }catch(Obj)
                        {
                          Filter_User_Info_List.clear();
                          Toastget().Toastmsg("Enter username didn't match with available user username.");
                          print("Exception caught while filtering user info list");
                          print(Obj.toString());
                        }
                      }
                      return User_Info_List.isEmpty
                          ? const Center(child: Text("No user data available."))
                          :
                      Builder(builder: (context)
                      {
                        if(Filter_User_Info_List.length>=1)
                        {
                          return
                            ListView.builder(
                                shrinkWrap: true,
                                itemBuilder: (context, index)
                                {
                                  final user = Filter_User_Info_List[index];
                                  return
                                    Card(
                                      child:Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children:
                                        [
                                          Text("Friend Username:${user.username}",style: TextStyle(fontFamily: semibold,fontSize: shortestval*0.05),),
                                          Icon(Icons.people_rounded),
                                        ],
                                      ).onTap((){
                                        Navigator.push(context,MaterialPageRoute(builder: (context)
                                        {
                                          return User_Friend_Profile_Screen_P(
                                            FriendUsername:user.username!,
                                            Current_User_Usertype:widget.usertype ,
                                            Current_User_Username: widget.username,
                                            Current_User_Jwt_Token: widget.jwttoken,);
                                        },));
                                      }) ,
                                    )
                                        .onTap (()
                                    {
                                      Navigator.push(context,MaterialPageRoute(builder: (context) {
                                        return User_Friend_Profile_Screen_P(Current_User_Jwt_Token: widget.jwttoken,
                                          Current_User_Username: widget.username,
                                          FriendUsername: user.username!,
                                          Current_User_Usertype: widget.usertype,
                                        );
                                      },
                                      )
                                      );

                                    }
                                    );
                                },
                                itemCount: Filter_User_Info_List.length
                            );
                        }
                        else{
                          return
                            ListView.builder(
                                shrinkWrap: true,
                                itemBuilder: (context, index)
                                {
                                  final user = User_Info_List[index];
                                  return Card(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children:
                                      [
                                        Text("Friend Username:${user.username}",style: TextStyle(fontFamily: semibold,fontSize: shortestval*0.05),),
                                        Icon(Icons.people_rounded),
                                      ],
                                    )
                                        .onTap((){
                                      Navigator.push(context,MaterialPageRoute(builder: (context)
                                      {
                                        return User_Friend_Profile_Screen_P(
                                          FriendUsername:user.username!,
                                          Current_User_Usertype:widget.usertype ,
                                          Current_User_Username: widget.username,
                                          Current_User_Jwt_Token: widget.jwttoken,);
                                      },));
                                    }) ,
                                  )
                                      .onTap (()
                                  {
                                    Navigator.push(context,MaterialPageRoute(builder: (context) {
                                      return User_Friend_Profile_Screen_P(Current_User_Jwt_Token: widget.jwttoken,
                                        Current_User_Username: widget.username,
                                        FriendUsername: user.username!,
                                        Current_User_Usertype: widget.usertype,
                                      );
                                    },
                                    )
                                    );
                                  }
                                  );
                                },
                                itemCount: User_Info_List.length
                            );
                        }
                      },
                      );
                    }
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

              Commonbutton("GetBooks", ()async
              {

                final GetBookInfosResult=await GetBookInfos();
                },
             context, Colors.red),
            ],
          ),
    )
      ),
    );
  }
}
