import 'dart:convert';
import 'package:booknest/Models/BookInfosModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../constant/constant.dart';
import '../../../constant/styles.dart';
import '../../common widget/common_method.dart';
import '../../common widget/toast.dart';
import '../Home/user_not_login_home_screen.dart';

// AdminBookDetails widget to display book details for admin users
class AdminBookDetails extends StatefulWidget {
  final String email; // User's email for authentication
  final String usertype; // User type (e.g., admin)
  final String jwttoken; // JWT token for API authentication

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
  // List to store book information fetched from the server
  List<BooKInfos> BookInfoList = [];
  // Store the Future for fetching book info to prevent repeated API calls
  late Future<void> _bookInfoFuture;

  @override
  void initState() {
    super.initState();
    // Initialize the Future for fetching book info
    _bookInfoFuture = GetBookInfo();
    // Check JWT token validity on widget initialization
    checkJWTExpiationAdmin();
  }

  // Function to validate JWT token and handle session expiration
  Future<void> checkJWTExpiationAdmin() async {
    try {
      print("Checking JWT token in AdminBookDetails screen.");
      int result = await checkJwtToken_initistate_admin(
          widget.email, widget.usertype, widget.jwttoken);
      if (result == 0) {
        // Clear user data and redirect to login screen if token is expired
        await clearUserData();
        if (mounted) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => UserNotLoginHomeScreen()));
          Toastget().Toastmsg("Session ended. Please re-login.");
        }
      }
    } catch (obj) {
      // Handle errors during JWT verification
      print("Exception caught while verifying JWT: ${obj.toString()}");
      await clearUserData();
      if (mounted) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => UserNotLoginHomeScreen()));
        Toastget().Toastmsg("Error occurred. Please re-login.");
      }
    }
  }

  // Function to fetch book information from the server
  Future<void> GetBookInfo() async {
    try {
      const String url = Backend_Server_Url + "api/Admin/get_books_info";
      final headers = {
        'Authorization': 'Bearer ${widget.jwttoken}',
        'Content-Type': 'application/json',
      };
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        // Parse response and update BookInfoList
        List<dynamic> responseData = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            BookInfoList.clear();
            BookInfoList.addAll(responseData
                .map((data) => BooKInfos.fromJson(data))
                .toList());
          });
        }
      } else {
        // Clear list if response fails
        if (mounted) {
          setState(() {
            BookInfoList.clear();
          });
        }
        if (mounted) {
          Toastget().Toastmsg("Failed to load books.");
        }
      }
    } catch (e) {
      // Handle errors during API call
      print("Error fetching book info: $e");
      if (mounted) {
        setState(() {
          BookInfoList.clear();
        });
        Toastget().Toastmsg("Error fetching books: $e");
      }
    }
  }

  // Function to confirm and delete a book
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
        final url =
        Uri.parse(Backend_Server_Url + "api/Admin/delete_book/$bookId");
        final response = await http.delete(
          url,
          headers: {
            'Authorization': 'Bearer ${widget.jwttoken}',
          },
        );

        if (response.statusCode == 200) {
          // Remove deleted book from the list and update UI
          if (mounted) {
            setState(() {
              BookInfoList.removeWhere((book) => book.bookId == bookId);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Book deleted successfully.")),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Failed to delete book.")),
            );
          }
        }
      } catch (e) {
        // Handle deletion errors
        print("Delete Error: $e");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Error occurred while deleting.")),
          );
        }
      }
    }
  }

  // Function to refresh the book list
  Future<void> _refreshBooks() async {
    if (mounted) {
      setState(() {
        _bookInfoFuture = GetBookInfo();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          "Book Management",
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
      body: RefreshIndicator(
        onRefresh: _refreshBooks,
        child: FutureBuilder<void>(
          future: _bookInfoFuture, // Use cached Future
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
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: BookInfoList.length,
                itemBuilder: (context, index) {
                  final book = BookInfoList[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Book cover image
                          if (book.photo != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.memory(
                                base64Decode(book.photo!),
                                height: 120,
                                width: 90,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) =>
                                const Icon(Icons.broken_image,
                                    size: 90, color: Colors.grey),
                              ),
                            )
                          else
                            const Icon(Icons.book,
                                size: 90, color: Colors.grey),
                          const SizedBox(width: 12),
                          // Book details
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                // Book name
                                Text(
                                  book.bookName ?? "Unknown Book",
                                  style: TextStyle(
                                    fontFamily: bold,
                                    fontSize: 18,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                // Title
                                _infoRow("Title", book.title),
                                // Author
                                _infoRow("Author", book.author),
                                // Price
                                _infoRow("Price",
                                    book.price?.toStringAsFixed(2)),
                                // Available Quantity
                                _infoRow("Quantity",
                                    book.availableQuantity?.toString()),
                                // Format
                                _infoRow("Format", book.format),
                                // Publisher
                                _infoRow("Publisher", book.publisher),
                                // Publication Date
                                _infoRow(
                                    "Publication Date",
                                    book.publicationDate?.split('T')[0] ??
                                        null),
                                // Language
                                _infoRow("Language", book.language),
                                // Category
                                _infoRow("Category", book.category),
                                // Listed At
                                _infoRow("Listed At",
                                    book.listedAt?.split('T')[0] ?? null),
                                // Discount
                                if (book.discountPercent != null &&
                                    book.discountPercent! > 0)
                                  _infoRow("Discount",
                                      "${book.discountPercent}%"),
                                // Discount Period
                                if (book.discountStart != null &&
                                    book.discountEnd != null)
                                  _infoRow(
                                      "Discount Period",
                                      "${book.discountStart?.split('T')[0]} to ${book.discountEnd?.split('T')[0]}"),
                              ],
                            ),
                          ),
                          // Delete button
                          IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.red, size: 28),
                            onPressed: () => _confirmDelete(book.bookId!),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text("Please reopen the app."));
            }
          },
        ),
      ),
    );
  }

  // Helper widget to display a labeled piece of information
  Widget _infoRow(String label, String? value) {
    return value != null && value.isNotEmpty
        ? Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: semibold,
                fontSize: 14,
                color: Colors.black54),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                  fontFamily: regular,
                  fontSize: 14,
                  color: Colors.black87),
            ),
          ),
        ],
      ),
    )
        : const SizedBox.shrink();
  }

  @override
  void dispose() {
    // Clean up any resources if needed
    super.dispose();
  }
}



