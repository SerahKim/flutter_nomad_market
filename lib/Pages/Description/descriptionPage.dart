import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nomad_market/utils/json_utils.dart';

class DescriptionPage extends StatefulWidget {
  DescriptionPage({
    //productInfo json의 데이터를 받아오는 생성자
    required this.userID,
    required this.productImage,
    required this.productTitle,
    required this.productCategory,
    required this.productStatus,
    required this.productPrice,
    required this.productDescription,
    required this.priceStatus,
    required this.priceCurrency,
  });

  //productInfo
  final userID;
  final List<dynamic> productImage;
  final productTitle;
  final productCategory;
  final productStatus;
  final productPrice;
  final productDescription;
  final priceStatus;
  final priceCurrency;

  @override
  State<DescriptionPage> createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage> {
  //------------사진의 인디케이터를 표시하기 위한 변수--------------
  final PageController _pageController = PageController();
  int _currentPage = 0;

  //------------userInfo json을 사용하기 위한 부분-----------------------------
  Future<List<dynamic>> userInfo =
      loadJsonData("assets/json/userInfo.json", "userInfo");

  //UI 설정 부분
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, //Appbar와 body를 합치는 부분
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: IconButton(
              icon: Icon(Icons.share, color: Colors.white),
              onPressed: () {
                // 공유 기능 구현
              },
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: userInfo,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('데이터를 불러오는 중 오류가 발생했습니다.'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final users = snapshot.data!;
            print(users);

            final user = users.firstWhere(
              (user) => user['userId'] == widget.userID,
              orElse: () => null,
            );

            if (user == null) {
              return Center(child: Text('사용자 정보가 없습니다.'));
            }

            final userName = user['nickname'] ?? '사용자';
            final userProfile =
                user['profileImage'] ?? 'assets/images/defaultprofile.jpg';
            final userLocation = user['preferences']['homeCity'] ?? '위치 정보 없음';

            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero, // 상단 패딩 제거
                    children: [
                      Stack(
                        children: [
                          //----------사진 영역--------------
                          AspectRatio(
                            aspectRatio: 1,
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: widget.productImage.length,
                              onPageChanged: (index) {
                                setState(() {
                                  _currentPage = index;
                                });
                              },
                              itemBuilder: (context, index) {
                                return Image.asset(
                                  widget.productImage[index],
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                          // 사진의 좌우 화살표
                          Positioned.fill(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    if ((_pageController.page?.toInt() ?? 0) >
                                        0) {
                                      _pageController.previousPage(
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                      );
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    if ((_pageController.page?.toInt() ?? 0) <
                                        widget.productImage.length - 1) {
                                      _pageController.nextPage(
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          // 사진의 하단 인디케이터
                          Positioned(
                            bottom: 16,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                widget.productImage.length,
                                (index) => Container(
                                  margin: EdgeInsets.symmetric(horizontal: 4),
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _currentPage == index
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      //--------------사용자 정보 표시-------------
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage(userProfile),
                        ),
                        title: Text(
                          userName,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(userLocation),
                      ),
                      //---------------상품 상세설명--------------
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.productTitle,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            // 상품 상태 표시
                            Text(
                              widget.productStatus,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: widget.productStatus == '팝니다'
                                      ? Colors.green
                                      : widget.productStatus == '삽니다'
                                          ? Colors.red
                                          : Colors.black),
                            ),
                            SizedBox(height: 8),
                            // 상품 카테고리 표시
                            Text(
                              widget.productCategory,
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(height: 16),
                            // 상품 설명 표시
                            Text(
                              widget.productDescription,
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
                //------------페이지 하단 부분---------------
                Padding(
                  padding:
                      EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 40),
                  child: Row(
                    children: [
                      Icon(Icons.favorite_border_outlined),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(widget.priceCurrency,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                Text(widget.productPrice,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.payments,
                                    color: widget.priceStatus == "가격제안 가능"
                                        ? Colors.green
                                        : widget.priceStatus == "가격제안 불가"
                                            ? Colors.red
                                            : Colors.black,
                                    size: 20),
                                SizedBox(width: 8),
                                Text(widget.priceStatus,
                                    style: TextStyle(fontSize: 14)), // 가격 상태 표시
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 100),
                      Expanded(
                        child: SizedBox(
                          height: 50, // 버튼 높이 설정
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple, // 버튼 배경색 설정
                              foregroundColor: Colors.white, // 버튼 글자색 설정
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10)), // 버튼 모서리 둥글게 설정
                            ),
                            child: Text('채팅하기',
                                style: TextStyle(fontSize: 16)), // 버튼 텍스트 설정
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          } else {
            return Center(child: Text('사용자 정보를 찾을 수 없습니다.'));
          }
        },
      ),
    );
  }
}
