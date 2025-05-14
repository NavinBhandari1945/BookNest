import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Application Modules
import '../../../Models/UserInfoModel.dart';
import '../../../constant/constant.dart';
import '../../../constant/styles.dart';
import '../../common widget/circular_progress_ind_yellow.dart';
import '../../common widget/common_method.dart';
import '../../common widget/header_footer.dart';
import '../../common widget/toast.dart';
import 'bookmark_screen.dart';
import 'change_email.screen.dart';
import 'order_history.dart';
import 'review_page.dart';
import 'user_not_login_home_screen.dart';

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
  List<UserInfosModel> userInfoList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeProfile();
  }

  /// Initialize user profile and authentication status
  Future<void> _initializeProfile() async {
    try {
      int result = await checkJwtToken_initistate_member(
        widget.email,
        widget.usertype,
        widget.jwttoken,
      );

      if (result == 0) {
        await clearUserData();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const UserNotLoginHomeScreen()),
        );
        Toastget().Toastmsg("Session ended. Please re-login.");
      } else {
        await _getUserInfo();
      }
    } catch (e) {
      await clearUserData();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const UserNotLoginHomeScreen()),
      );
      Toastget().Toastmsg("Error occurred. Please re-login.");
    }
    setState(() {
      isLoading = false;
    });
  }

  /// Fetch user details from backend API
  Future<void> _getUserInfo() async {
    try {
      const String url = Backend_Server_Url + "api/Member/get_user_details";
      final body = jsonEncode({"Email": widget.email});

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${widget.jwttoken}',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        userInfoList.clear();
        userInfoList.add(UserInfosModel.fromJson(data));
      } else {
        userInfoList.clear();
      }
    } catch (e) {
      userInfoList.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Profile",
          style: TextStyle(fontFamily: bold, fontSize: 18, color: Colors.white),
        ),
        backgroundColor: Colors.green[800],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[50]!.withOpacity(0.9), Colors.white.withOpacity(0.95)],
          ),
        ),
        child: Column(
          children: [
            HeaderWidget(email: widget.email, usertype: widget.usertype, jwttoken: widget.jwttoken),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSidebar(width),
                  Expanded(child: _buildProfileContent()),
                ],
              ),
            ),
            FooterWidget(),
          ],
        ),
      ),
    );
  }

  /// Build navigation sidebar with profile options
  Widget _buildSidebar(double width) {
    return Container(
      width: 180,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(2, 0))],
        borderRadius: const BorderRadius.only(topRight: Radius.circular(16), bottomRight: Radius.circular(16)),
      ),
      child: Column(
        children: [
          _buildSidebarButton("Change Email", Icons.email, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) =>
                ChangeEmailScreen(jwttoken: widget.jwttoken,
                    usertype: widget.usertype, email: widget.email)));
          }),
          _buildSidebarButton("Bookmarks", Icons.bookmark, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) =>
                BookmarkPage(jwttoken: widget.jwttoken,
                    usertype: widget.usertype, email: widget.email)));
          }),
          _buildSidebarButton("Order History", Icons.history, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) =>
                OrderHistoryPage(jwttoken: widget.jwttoken,
                    usertype: widget.usertype, email: widget.email)));
          }),
          _buildSidebarButton("Give Review", Icons.reviews_outlined, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) =>
                RreviewPage(jwttoken: widget.jwttoken,
                    usertype: widget.usertype, email: widget.email)));
          }),
          _buildSidebarButton("Logout", Icons.logout, () async {
            await clearUserData();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => const UserNotLoginHomeScreen()));
          }),
        ],
      ),
    );
  }

  /// Create sidebar menu items
  Widget _buildSidebarButton(String label, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.green[800]),
      title: Text(label, style: const TextStyle(fontSize: 15, fontFamily: bold)),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      tileColor: Colors.green[50],
      hoverColor: Colors.green[100],
    );
  }

  /// Build main profile content with centered layout
  Widget _buildProfileContent() {
    if (isLoading) return Center(child: Circular_pro_indicator_Yellow(context));
    if (userInfoList.isEmpty) return _buildMessageCard(
        "No user info available. Please refresh or restart the app.",
        Colors.grey[600]!
    );

    final user = userInfoList[0];
    return Center(
      child: Container(
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
        ),
        constraints: BoxConstraints(maxWidth: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // User avatar with increased size
            CircleAvatar(
              radius: 36,
              backgroundColor: Colors.green[800],
              child: Text(
                user.firstName?.substring(0, 1).toUpperCase() ?? "U",
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontFamily: bold,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // User information rows with adjusted sizes
            _buildInfoRow(Icons.person, "Name", "${user.firstName ?? 'N/A'} ${user.lastName ?? ''}"),
            _buildInfoRow(Icons.email, "Email", user.email ?? "N/A"),
            _buildInfoRow(Icons.phone, "Phone", user.phoneNumber ?? "N/A"),
            _buildInfoRow(Icons.badge, "User ID", user.userId?.toString() ?? "N/A"),
          ],
        ),
      ),
    );
  }

  /// Build information rows with centered layout
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.green[700], size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[800],
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageCard(String message, Color color) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            message,
            style: TextStyle(fontSize: 14, color: color, fontFamily: bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
