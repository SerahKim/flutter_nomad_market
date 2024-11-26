import 'package:flutter/material.dart';

class ProductList extends StatefulWidget {
  ProductList(
      {required this.nextPage,
      required this.productThumbnail,
      required this.productTitle,
      required this.productStatus,
      required this.productPrice,
      required this.priceCurrency});

  final Widget nextPage;
  final String productThumbnail;
  final String productTitle;
  final String productStatus;
  final String productPrice;
  final String priceCurrency;

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
class ProductList extends StatelessWidget {
  final String productThumbnail;
  final String productTitle;
  final String productStatus;
  final String waitingStatus;
  final String productPriceKRW;
  final String productPriceUSD;
  final String selectedCurrency;
  final VoidCallback onTap;

  const ProductList({
    required this.productThumbnail,
    required this.productTitle,
    required this.productStatus,
    required this.waitingStatus,
    required this.productPriceKRW,
    required this.productPriceUSD,
    required this.selectedCurrency,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: GestureDetector(
        onTap: onTap, // Use onTap here
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
                    productThumbnail,
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
                        productTitle,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        productStatus,
                        style: TextStyle(
                          fontSize: 14,
                          color: productStatus == '판매중'
                              ? Colors.green
                              : productStatus == '판매 완료'
                                  ? Colors.red
                                  : Colors.black,
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            widget.priceCurrency,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.productPrice,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      Text(
                        selectedCurrency == 'KRW'
                            ? '₩$productPriceKRW'
                            : '\$$productPriceUSD',
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
