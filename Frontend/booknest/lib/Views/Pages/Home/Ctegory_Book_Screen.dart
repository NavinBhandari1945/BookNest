import 'package:flutter/material.dart';
import 'dart:convert';
import '../../../Models/BookInfosModel.dart';
import '../../../constant/styles.dart';

class CategoryBookPage extends StatefulWidget {
  final String email;
  final String usertype;
  final String jwttoken;
  final List<BooKInfos> BookInfo;
  const CategoryBookPage({super.key, required this.jwttoken, required this.usertype, required this.email, required this.BookInfo});

  @override
  State<CategoryBookPage> createState() => _CategoryBookPageState();
}

class _CategoryBookPageState extends State<CategoryBookPage> {
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
            letterSpacing: 1.0,
          ),
        ),
        backgroundColor: Colors.green[700],
        elevation: 4,
        shadowColor: Colors.black45,
      ),
      body: Container(
        width: widthval,
        height: heightval,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[50]!.withOpacity(0.7), Colors.white],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 800,
              minWidth: 300,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: widthval * 0.03,
                      vertical: heightval * 0.015,
                    ),
                    child: Text(
                      'Category wise Books',
                      style: TextStyle(
                        fontSize: widthval * 0.04,
                        fontFamily: bold,
                        color: Colors.green[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Book List
                  LayoutBuilder(
                    builder: (context, constraints) {
                      double fontScale = constraints.maxWidth < 400 ? 0.9 : 1.0; // Smaller fonts on narrow screens
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.BookInfo.length,
                        itemBuilder: (context, index) {
                          final book = widget.BookInfo[index];
                          return

                            Card (
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: EdgeInsets.symmetric(
                              horizontal: widthval * 0.03,
                              vertical: heightval * 0.01,
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(widthval * 0.025),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Book Image
                                  Center(
                                    child: SizedBox(
                                      width: widthval * 0.3,
                                      child: AspectRatio(
                                        aspectRatio: 2 / 3, // Standard book cover ratio
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: book.photo != null
                                              ? Image.memory(
                                            base64Decode(book.photo!),
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) => const Icon(
                                              Icons.broken_image,
                                              size: 50,
                                              color: Colors.grey,
                                            ),
                                          )
                                              : const Icon(
                                            Icons.broken_image,
                                            size: 50,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: heightval * 0.015),
                                  // Book Details
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildInfoRow('Title', book.title ?? 'N/A', widthval, heightval, fontScale, isBold: true),
                                      _buildInfoRow('Book Name', book.bookName ?? 'N/A', widthval, heightval, fontScale),
                                      _buildInfoRow('Author', book.author ?? 'N/A', widthval, heightval, fontScale, isItalic: true),
                                      _buildInfoRow('Price', book.price?.toStringAsFixed(2) ?? 'N/A', widthval, heightval, fontScale, color: Colors.green[700]),
                                      _buildInfoRow('Format', book.format ?? 'N/A', widthval, heightval, fontScale),
                                      _buildInfoRow('Publisher', book.publisher ?? 'N/A', widthval, heightval, fontScale),
                                      _buildInfoRow('Publication Date', book.publicationDate ?? 'N/A', widthval, heightval, fontScale),
                                      _buildInfoRow('Language', book.language ?? 'N/A', widthval, heightval, fontScale),
                                      _buildInfoRow('Category', book.category ?? 'N/A', widthval, heightval, fontScale),
                                      _buildInfoRow('Listed At', book.listedAt ?? 'N/A', widthval, heightval, fontScale),
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
                                      _buildInfoRow(
                                        'Discount Percent',
                                        book.discountPercent != null ? '${book.discountPercent}%' : 'N/A',
                                        widthval,
                                        heightval,
                                        fontScale,
                                      ),
                                      _buildInfoRow('Discount Start', book.discountStart ?? 'N/A', widthval, heightval, fontScale),
                                      _buildInfoRow('Discount End', book.discountEnd ?? 'N/A', widthval, heightval, fontScale),
                                      _buildInfoRow('Book ID', book.bookId?.toString() ?? 'N/A', widthval, heightval, fontScale),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(height: heightval * 0.03), // Bottom padding
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build info rows
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
      padding: EdgeInsets.symmetric(vertical: heightval * 0.004),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: widthval * 0.03 * fontScale,
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
                fontSize: widthval * 0.03 * fontScale,
                color: color ?? Colors.grey[800],
                fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}









