import 'dart:convert';
import 'package:booknest/Views/Pages/Home/review_page.dart';
import 'package:booknest/Views/Pages/Home/user_not_login_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../Models/BookmarkUserModel.dart';
import '../../../Models/UserInfoModel.dart';
import '../../../Models/UserOrderBookModel.dart';
import '../../../constant/constant.dart';
import '../../../constant/styles.dart';
import '../../common widget/circular_progress_ind_yellow.dart';
import '../../common widget/common_method.dart';
import '../../common widget/header_footer.dart';
import '../../common widget/toast.dart';
import 'bookmark_screen.dart';
import 'order_history.dart';

class ProfilePage extends StatefulWidget {
  final String email;
  final String usertype;
  final String jwttoken;
  const ProfilePage({
    super.key,
    required this.jwttoken,
    required this.usertype,
    required this.email,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    checkJWTExpiationmember();
  }

  Future<void> checkJWTExpiationmember() async {
    try {
      print("check jwt called in book screen.");
      int result = await checkJwtToken_initistate_member(
          widget.email, widget.usertype, widget.jwttoken);
      if (result == 0) {
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

  List<UserInfosModel> UserInfoList = [];

  Future<void> getUserInfo() async {
    try {
      print("profile user info method called");
      const String url = Backend_Server_Url + "api/Member/get_user_details";
      Map<String, dynamic> BodyDict = {"Email": widget.email};
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${widget.jwttoken}'
        },
        body: json.encode(BodyDict),
      );
      print("status code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print("profile user info get success.");
        Map<String, dynamic> responseData = await jsonDecode(response.body);
        UserInfoList.clear();
        UserInfoList.add(UserInfosModel.fromJson(responseData));
        return;
      } else {
        UserInfoList.clear();
        print("Data insert in userinfo list failed.");
        return;
      }
    } catch (obj) {
      UserInfoList.clear();
      print("Exception caught while fetching user data for profile screen");
      print(obj.toString());
      return;
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
          "Profile",
          style: TextStyle(
            fontFamily: bold,
            fontSize: 20,
            color: Colors.white,
            letterSpacing: 1.0,
          ),
        ),
        backgroundColor: Colors.green[700],
        elevation: 4,
        shadowColor: Colors.black45,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body:

      Container(
        width: widthval,
        height: heightval,
        child:
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Column(
            children: [

              // Header (Full Width)
              SizedBox(
                width: double.infinity,
                child: HeaderWidget(
                  email: widget.email,
                  usertype: widget.usertype,
                  jwttoken: widget.jwttoken,
                ),
              ),


              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.green[50]!.withOpacity(0.7), Colors.white],
                  ),
                ),
                child:
                Center (
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 800,
                      minWidth: 300,
                    ),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(widthval * 0.03),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: heightval * 0.015),
                            child: Text(
                              'My Profile',
                              style: TextStyle(
                                fontSize: widthval * 0.04,
                                fontFamily: bold,
                                color: Colors.green[800],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // User Info Section
                          FutureBuilder(
                            future: getUserInfo(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(
                                  child: Container(
                                    padding: EdgeInsets.all(widthval * 0.03),
                                    child: Circular_pro_indicator_Yellow(context),
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Card(
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(widthval * 0.03),
                                      child: Text(
                                        'Error: ${snapshot.error}',
                                        style: TextStyle(
                                          fontSize: widthval * 0.035,
                                          color: Colors.red[600],
                                          fontFamily: bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                );
                              } else if (snapshot.connectionState == ConnectionState.done) {
                                if (UserInfoList.isNotEmpty) {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      final userInfo = UserInfoList[index];
                                      return Card(
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        margin: EdgeInsets.symmetric(vertical: heightval * 0.01),
                                        child: Padding(
                                          padding: EdgeInsets.all(widthval * 0.03),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              // Profile Avatar
                                              Center(
                                                child: CircleAvatar(
                                                  radius: widthval * 0.08,
                                                  backgroundColor: Colors.green[700],
                                                  child: Text(
                                                    userInfo.firstName?.substring(0, 1).toUpperCase() ?? 'U',
                                                    style: TextStyle(
                                                      fontSize: widthval * 0.05,
                                                      color: Colors.white,
                                                      fontFamily: bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: heightval * 0.015),
                                              // User Details
                                              _buildInfoRow(
                                                Icons.person,
                                                'Name',
                                                '${userInfo.firstName ?? "N/A"} ${userInfo.lastName ?? ""}',
                                                widthval,
                                              ),
                                              Divider(color: Colors.grey[300], height: heightval * 0.015),
                                              _buildInfoRow(
                                                Icons.email,
                                                'Email',
                                                userInfo.email ?? 'N/A',
                                                widthval,
                                              ),
                                              Divider(color: Colors.grey[300], height: heightval * 0.015),
                                              _buildInfoRow(
                                                Icons.phone,
                                                'Phone',
                                                userInfo.phoneNumber ?? 'N/A',
                                                widthval,
                                              ),
                                              Divider(color: Colors.grey[300], height: heightval * 0.015),
                                              _buildInfoRow(
                                                Icons.badge,
                                                'User ID',
                                                userInfo.userId?.toString() ?? 'N/A',
                                                widthval,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    itemCount: UserInfoList.length,
                                  );
                                } else {
                                  return Center(
                                    child: Card(
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(widthval * 0.03),
                                        child: Text(
                                          'No user info. Please close and reopen app.',
                                          style: TextStyle(
                                            fontSize: widthval * 0.035,
                                            color: Colors.grey[600],
                                            fontFamily: bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              } else {
                                return Center(
                                  child: Card(
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(widthval * 0.03),
                                      child: Text(
                                        'Error. Relogin.',
                                        style: TextStyle(
                                          fontSize: widthval * 0.035,
                                          color: Colors.red[600],
                                          fontFamily: bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                          SizedBox(height: heightval * 0.03),
                          // Action Buttons
                          _buildStyledButton(
                            context,
                            'Bookmarks',
                            Icons.bookmark,
                                () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookmarkPage(
                                    jwttoken: widget.jwttoken,
                                    usertype: widget.usertype,
                                    email: widget.email,
                                  ),
                                ),
                              );
                            },
                            widthval,
                            heightval,
                          ),
                          SizedBox(height: heightval * 0.015),
                          _buildStyledButton (
                            context,
                            'Order History',
                            Icons.history,
                                () {
                              Navigator.push (
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrderHistoryPage(
                                    jwttoken: widget.jwttoken,
                                    usertype: widget.usertype,
                                    email: widget.email,
                                  ),
                                ),
                              );
                            },
                            widthval,
                            heightval,
                          ),
                          _buildStyledButton (
                            context,
                            'Give Review',
                            Icons.reviews_outlined,
                                () {
                              Navigator.push (
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RreviewPage(
                                    jwttoken: widget.jwttoken,
                                    usertype: widget.usertype,
                                    email: widget.email,
                                  ),
                                ),
                              );
                            },
                            widthval,
                            heightval,
                          ),

                          _buildStyledButton (
                            context,
                            'Logout',
                            Icons.logout,
                                ()async {
                                  final Clear_User_Data=await clearUserData();
                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                    return UserNotLoginHomeScreen();

                                  },));
                            },
                            widthval,
                            heightval,
                          ),

                        ],
                      ),
                    ),
                  ),
                ),


              ),

              // Footer (Full Width)
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

  // Helper method to build info rows with icons
  Widget _buildInfoRow(IconData icon, String label, String value, double widthval) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: widthval * 0.01),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.green[700], size: widthval * 0.05),
          SizedBox(width: widthval * 0.02),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: widthval * 0.035,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontFamily: bold,
                  ),
                ),
                SizedBox(height: widthval * 0.005),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: widthval * 0.03,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build styled buttons
  Widget _buildStyledButton(
      BuildContext context,
      String label,
      IconData icon,
      VoidCallback onPressed,
      double widthval,
      double heightval,
      ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green[700]!, Colors.green[500]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 3,
                offset: Offset(0, 1),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(
            horizontal: widthval * 0.03,
            vertical: heightval * 0.015,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: widthval * 0.05),
              SizedBox(width: widthval * 0.02),
              Text(
                label,
                style: TextStyle(
                  fontSize: widthval * 0.035,
                  color: Colors.white,
                  fontFamily: bold,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}













// import 'dart:convert';
//
// import 'package:booknest/Views/Pages/Home/user_not_login_home_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// import '../../../Models/BookmarkUserModel.dart';
// import '../../../Models/UserInfoModel.dart';
// import '../../../Models/UserOrderBookModel.dart';
// import '../../../constant/constant.dart';
// import '../../../constant/styles.dart';
// import '../../common widget/circular_progress_ind_yellow.dart';
// import '../../common widget/common_method.dart';
// import '../../common widget/toast.dart';
// import 'bookmark_screen.dart';
// import 'order_history.dart';
//
// class ProfilePage extends StatefulWidget {
//   final String email;
//   final String usertype;
//   final String jwttoken;
//   const ProfilePage({
//     super.key,
//     required this.jwttoken,
//     required this.usertype,
//     required this.email,
//   });
//
//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
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
//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserNotLoginHomeScreen()));
//       Toastget().Toastmsg("Error. Relogin please.");
//     }
//   }
//
//   List<UserInfosModel> UserInfoList = [];
//
//   Future<void> getUserInfo() async {
//     try {
//       print("profile user info method called");
//       const String url = Backend_Server_Url + "api/Member/get_user_details";
//       Map<String, dynamic> BodyDict = {"Email": widget.email};
//       final response = await http.post(
//         Uri.parse(url),
//         headers: {
//           "Content-Type": "application/json",
//           'Authorization': 'Bearer ${widget.jwttoken}'
//         },
//         body: json.encode(BodyDict),
//       );
//       print("status code");
//       print(response.statusCode);
//       if (response.statusCode == 200) {
//         print("profile user info get success.");
//         Map<String, dynamic> responseData = await jsonDecode(response.body);
//         UserInfoList.clear();
//         UserInfoList.add(UserInfosModel.fromJson(responseData));
//         return;
//       } else {
//         UserInfoList.clear();
//         print("Data insert in userinfo list failed.");
//         return;
//       }
//     } catch (obj) {
//       UserInfoList.clear();
//       print("Exception caught while fetching user data for profile screen");
//       print(obj.toString());
//       return;
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     var shortestval = MediaQuery.of(context).size.shortestSide;
//     var widthval = MediaQuery.of(context).size.width;
//     var heightval = MediaQuery.of(context).size.height;
//     return Scaffold(
//        appBar:  AppBar(
//           automaticallyImplyLeading: false,
//           title: const Text(
//             "Cart Details",
//             style: TextStyle(
//               fontFamily: bold,
//               fontSize: 24,
//               color: Colors.white,
//               letterSpacing: 1.2,
//             ),
//           ),
//           backgroundColor: Colors.green[700],
//           elevation: 4,
//           shadowColor: Colors.black45,
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back, color: Colors.white),
//             onPressed: () => Navigator.pop(context),
//           ),
//         ),
//
//         body:Container(child: Column(
//           children:
//           [
//
//
//             FutureBuilder (
//               future: getUserInfo(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting)
//                 {
//                   return Circular_pro_indicator_Yellow(context); // While waiting for response
//                 }
//                 else if (snapshot.hasError)
//                 {
//                   return Text('Error: ${snapshot.error}'); // If there's an error
//                 }
//                 else if (snapshot.connectionState == ConnectionState.done)
//                 {
//                   if (UserInfoList.isNotEmpty || UserInfoList.length>=1)
//                   {
//                     return ListView.builder(
//                         itemBuilder: (context, index) {
//                           final user_info=UserInfoList[index];
//                           return
//                             Container (
//                               child:
//                               Column (
//                                 children:
//                                 [
//                                   Text("${user_info.email}"),
//                                   Text("${user_info.firstName}"),
//                                   Text("${user_info..lastName}"),
//                                   Text("${user_info.phoneNumber}"),
//                                   Text("${user_info.userId}"),
//                                   ]
//
//                             ),
//                           );
//
//
//                         },
//                         itemCount: UserInfoList.length
//                     );
//
//                   }
//                   else
//                   {
//                     return Center(child: Text('No user info.Please close and reopen app.')); // If no user data
//                   }
//                 }//conection done
//                 else
//                 {
//                   return Center(child: Text('Error.Relogin.')); // Default loading state
//                 }
//               },
//
//             ),
//
//
//             ElevatedButton(onPressed: (){
//               // final result=await GetBookMarkInfos();
//
//               Navigator.push(context, MaterialPageRoute(builder: (context)
//               {
//                 return BookmarkPage(jwttoken: widget.jwttoken, usertype:widget.usertype, email:widget.email,);
//               },
//               )
//               );
//
//             }, child: Text("Bookmark")),
//
//
//             ElevatedButton(onPressed: (){
//               // final result=await GetOrderInfos();
//               Navigator.push(context, MaterialPageRoute(builder: (context)
//               {
//                 return OrderHistoryPage(jwttoken: widget.jwttoken, usertype:widget.usertype, email:widget.email,);
//               },
//               )
//               );
//             }, child: Text("OrderHistory")),
//
//           ],
//         ),),
//
//     );
//   }
// }
