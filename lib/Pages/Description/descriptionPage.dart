import 'package:flutter/material.dart';

class DescriptionPage extends StatelessWidget {
  DescriptionPage(
      {required this.productImage,
      required this.productTitle,
      required this.productCategory,
      required this.productStatus,
      required this.productPrice,
      required this.productDescription,
      required this.priceStatus});

  final List<dynamic> productImage;
  final productTitle;
  final productCategory;
  final productStatus;
  final productPrice;
  final productDescription;
  final priceStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                // 사진
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: PageView.builder(
                    itemCount: productImage.length,
                    itemBuilder: (context, index) {
                      return Image.asset(
                        productImage[index],
                        fit: BoxFit.contain,
                      );
                    },
                  ),
                ),
                Divider(),
                //사용자 정보
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/images/defaultprofile.jpg'),
                  ),
                  title: Text(
                    '아이디',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('거주 지역'),
                ),
                Divider(),
                // 상품 상세설명
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            productTitle,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 8),
                          Text(
                            productStatus,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: productStatus == '판매중'
                                    ? Colors.green
                                    : productStatus == '판매 완료'
                                        ? Colors.red
                                        : Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        productCategory,
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 16),
                      Text(
                        productDescription,
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 40),
            child: Row(
              children: [
                Icon(Icons.favorite_border_outlined),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(productPrice,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.payments,
                              color: priceStatus == "가격 제안 가능"
                                  ? Colors.green
                                  : priceStatus == "가격 제안 불가"
                                      ? Colors.red
                                      : Colors.black,
                              size: 20),
                          SizedBox(width: 8),
                          Text(priceStatus, style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 100),
                Expanded(
                  child: SizedBox(
                    height: 50, // 버튼 높이
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        '채팅하기',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
