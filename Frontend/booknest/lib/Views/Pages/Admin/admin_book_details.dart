import 'dart:convert';
import 'package:booknest/Models/BookInfosModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../constant/constant.dart';
import '../../../constant/styles.dart';
import '../../common widget/common_method.dart';
import '../../common widget/toast.dart';
import '../Home/user_not_login_home_screen.dart';

class AdminBookDetails extends StatefulWidget {
  final String email;
  final String usertype;
  final String jwttoken;

  const AdminBookDetails({
    super.key,
    required this.jwttoken,
    required this.usertype,
    required this.email,
  });

  @override
  State<AdminBookDetails> createState() => _AdminBookDetailsState();
}

class _AdminBookDetailsState extends State<AdminBookDetails> {
  @override
  void initState() {
    super.initState();
    checkJWTExpiationAdmin();
  }

  Future<void> checkJWTExpiationAdmin() async {
    try {
      //check jwt called in admin home screen.
      print("check jwt called in admin home screen.");
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
  List<BooKInfos> BookInfoList = [];

  Future<void> GetBookInfo() async {
    try {
      const String url = Backend_Server_Url + "api/Admin/get_books_info";
      final headers = {
        'Authorization': 'Bearer ${widget.jwttoken}',
        'Content-Type': 'application/json',
      };
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        List<dynamic> responseData = jsonDecode(response.body);
        BookInfoList.clear();
        BookInfoList.addAll(responseData.map((data) => BooKInfos.fromJson(data)).toList());
      } else {
        BookInfoList.clear();
      }
    } catch (e) {
      BookInfoList.clear();
      print("Error fetching book info: $e");
    }
  }

  Future<void> _confirmDelete(int bookId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Book"),
        content: const Text("Are you sure you want to delete this book?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Yes, Delete"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final url = Uri.parse(Backend_Server_Url + "api/Admin/delete_book/$bookId");
        final response = await http.delete(
          url,
          headers: {
            'Authorization': 'Bearer ${widget.jwttoken}',
          },
        );

        if (response.statusCode == 200) {
          setState(() {
            BookInfoList.removeWhere((book) => book.bookId == bookId);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Book deleted successfully.")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to delete book.")),
          );
        }
      } catch (e) {
        print("Delete Error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error occurred while deleting.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var shortestval = MediaQuery.of(context).size.shortestSide;

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
      ),
      body: FutureBuilder<void>(
        future: GetBookInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Error loading books. Please try again later.",
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            return BookInfoList.isEmpty
                ? const Center(child: Text("No books available."))
                : ListView.builder(
              itemCount: BookInfoList.length,
              itemBuilder: (context, index) {
                final book = BookInfoList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (book.photo != null)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.memory(
                                  base64Decode(book.photo!),
                                  height: 100,
                                  width: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    book.bookName ?? "Unknown Book",
                                    style: TextStyle(
                                      fontFamily: semibold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  _infoRow("Author", book.author),
                                  _infoRow("Price", book.price?.toStringAsFixed(2)),
                                  _infoRow("Qty", book.availableQuantity?.toString()),
                                  if (book.discountPercent != null && book.discountPercent! > 0)
                                    _infoRow("Discount", "${book.discountPercent}%"),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _confirmDelete(book.bookId!),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("Please reopen app."));
          }
        },
      ),
    );
  }

  Widget _infoRow(String label, String? value) {
    return value != null
        ? Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: TextStyle(fontWeight: FontWeight.bold, fontFamily: semibold),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontFamily: regular),
            ),
          ),
        ],
      ),
    )
        : const SizedBox.shrink();
  }
}
