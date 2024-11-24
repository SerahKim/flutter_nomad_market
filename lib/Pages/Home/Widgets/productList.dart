import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class ProductList extends StatefulWidget {
  ProductList({
    required this.nextPage,
    required this.productThumbnail,
    required this.productTitle,
    required this.productStatus,
    required this.productPrice,
  });

  final Widget nextPage;
  final String productThumbnail;
  final String productTitle;
  final String productStatus;
  final String productPrice;

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => widget.nextPage,
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey[300]!,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    widget.productThumbnail,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.productTitle,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        widget.productStatus,
                        style: TextStyle(
                            fontSize: 14,
                            color: widget.productStatus == '판매중'
                                ? Colors.green
                                : widget.productStatus == '판매 완료'
                                    ? Colors.red
                                    : Colors.black),
                      ),
                      SizedBox(height: 5),
                      Text(
                        widget.productPrice,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.favorite_border,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
