import 'package:flutter/material.dart';
import 'dart:convert';
import '../../../Models/BookInfosModel.dart';
import '../../../constant/styles.dart';

// Widget definition section
class CategoryBookPage extends StatefulWidget {
  final String email;
  final String usertype;
  final String jwttoken;
  final List<BooKInfos> BookInfo;

  const CategoryBookPage({
    super.key,
    required this.jwttoken,
    required this.usertype,
    required this.email,
    required this.BookInfo,
  });

  @override
  State<CategoryBookPage> createState() => _CategoryBookPageState();
}

// State management section
class _CategoryBookPageState extends State<CategoryBookPage> {
  // UI building section
  @override
  Widget build(BuildContext context) {
    var shortestval = MediaQuery.of(context).size.shortestSide;
    var widthval = MediaQuery.of(context).size.width;
    var heightval = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          "Book Category",
          style: TextStyle(
            fontFamily: bold,
            fontSize: 20,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: Colors.green[700],
        elevation: 2,
        shadowColor: Colors.black45,
      ),
      body: Container(
        width: widthval,
        height: heightval,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[50]!.withOpacity(0.9), Colors.white],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 600,
              minWidth: 300,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header section
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: widthval * 0.02,
                      vertical: heightval * 0.01,
                    ),
                    child: Text(
                      'Category-wise Books',
                      style: TextStyle(
                        fontSize: widthval * 0.035,
                        fontFamily: bold,
                        color: Colors.green[900],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  widget.BookInfo.isEmpty
                      ? Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: heightval * 0.06),
                      child: Text(
                        "No books available in this category.",
                        style: TextStyle(
                          fontFamily: regular,
                          fontSize: shortestval * 0.028,
                          color: Colors.green[800],
                        ),
                      ),
                    ),
                  )
                      : LayoutBuilder(
                    builder: (context, constraints) {
                      double fontScale = constraints.maxWidth < 360 ? 0.65 : 0.8;
                      double imageWidth = widthval * 0.2;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.BookInfo.length,
                        itemBuilder: (context, index) {
                          final book = widget.BookInfo[index];
                          return Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: EdgeInsets.symmetric(
                              horizontal: widthval * 0.02,
                              vertical: heightval * 0.008,
                            ),
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.all(widthval * 0.02),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Image section
                                  Flexible(
                                    child: FractionallySizedBox(
                                      widthFactor: 0.3,
                                      child: AspectRatio(
                                        aspectRatio: 2 / 3,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(6),
                                          child: book.photo != null
                                              ? Image.memory(
                                            base64Decode(book.photo!),
                                            fit: BoxFit.contain,
                                            errorBuilder: (context, error, stackTrace) => const Icon(
                                              Icons.broken_image,
                                              size: 25,
                                              color: Colors.grey,
                                            ),
                                          )
                                              : const Icon(
                                            Icons.broken_image,
                                            size: 25,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: widthval * 0.02),
                                  // Details section
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        _buildInfoRow('Title', book.title ?? 'N/A', widthval, heightval, fontScale,
                                            isBold: true),
                                        _buildInfoRow('Author', book.author ?? 'N/A', widthval, heightval, fontScale,
                                            isItalic: true),
                                        _buildInfoRow('Price', book.price?.toStringAsFixed(2) ?? 'N/A', widthval,
                                            heightval, fontScale,
                                            color: Colors.green[700]),
                                        _buildInfoRow('Category', book.category ?? 'N/A', widthval, heightval, fontScale),
                                        _buildInfoRow(
                                          'Available Quantity',
                                          book.availableQuantity?.toString() ?? 'N/A',
                                          widthval,
                                          heightval,
                                          fontScale,
                                          color: book.availableQuantity != null && book.availableQuantity! > 0
                                              ? Colors.green[600]
                                              : Colors.red[600],
                                        ),
                                        _buildInfoRow('Book ID', book.bookId?.toString() ?? 'N/A', widthval, heightval,
                                            fontScale),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(height: heightval * 0.015),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method section
  Widget _buildInfoRow(
      String label,
      String value,
      double widthval,
      double heightval,
      double fontScale, {
        bool isBold = false,
        bool isItalic = false,
        Color? color,
      }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: heightval * 0.002),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: widthval * 0.022 * fontScale,
              fontFamily: bold,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: widthval * 0.022 * fontScale,
                color: color ?? Colors.grey[800],
                fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}