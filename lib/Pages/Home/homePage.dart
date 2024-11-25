import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nomad_market/Pages/Description/descriptionPage.dart';
import 'package:flutter_nomad_market/Pages/Home/Widgets/dropdownButton.dart';
import 'package:flutter_nomad_market/Pages/Home/Widgets/productList.dart';
import 'package:flutter_nomad_market/Pages/Login/Widgets/LocaleSetting.dart';
import 'package:flutter_nomad_market/Pages/Widgets/commonWidgets.dart';

class HomePage extends StatefulWidget {
  static Future<List<dynamic>> loadJson() async {
    final String response =
        await rootBundle.loadString("assets/json/productInfo.json");
    final data = await json.decode(response);
    return data['productInfo'];
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //상품 정렬
  final List<String> productCategory = [
    '전체',
    '전자기기 및 가전',
    '패션 및 액세서리',
    '홈 및 리빙',
    '뷰티 및 퍼스널 케어',
    '식품 및 음료',
    '키즈 및 베이비',
    '스포츠 및 아웃도어',
    '문화 및 엔터테인먼트',
    '반려동물 용품',
    '건강 및 웰빙',
    '자동차 및 오토바이 액세서리',
    '공예 및 수공예품',
    '명품 및 럭셔리',
    '서비스',
    '기타',
    '구매요청'
  ];
  String? selectedProductCategory = '전체';

  //거래 상태 정렬
  final List<String> salesOrpurchaseCategory = ['전체', '삽니다', '팝니다'];
  String? selectedSalesOrPurchaseCategory = '전체';

  //판매 상태 정렬
  final List<String> waitingCategory = ['모든 상품', '거래 미완료'];
  String? selectedWaitingCategory = '모든 상품';

  //기본 정렬
  final List<String> sortCategory = ['최신순', '좋아요순', '댓글순'];
  String? selectedSortCategory = '최신순';

  final Future<List<dynamic>> productInfo = HomePage.loadJson();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: 200,
        leading: Padding(
          padding: const EdgeInsets.only(left: 30),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LocationSetting(selectedCountry: ''),
                ),
              );
            },
            child: Row(
              children: [
                Text(
                  '한국',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                size: 30,
              ),
            ),
          )
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: productInfo,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            //dropdownBox 선택 값에 따른 필터링 부분
            List<dynamic> filteredProducts = snapshot.data!.where((product) {
              //상품 카테고리
              bool categoryMatch = selectedProductCategory == '전체' ||
                  product['productCategory'] == selectedProductCategory;

              //전체, 삽니다, 팝니다
              bool statusMatch = selectedSalesOrPurchaseCategory == '전체' ||
                  product['productStatus'] == selectedSalesOrPurchaseCategory;

              //전체, 거래 미완료, 거래완료(거래 완료는 선택지에 없음)
              bool waitingMatch = selectedWaitingCategory == '모든 상품' ||
                  product['waitingStatus'] == selectedWaitingCategory;

              //categoryMatch, statusMatch, waitingMatch이 true인 product만 filteredProducts 리스트에 포함시킴.
              return categoryMatch && statusMatch && waitingMatch;
            }).toList();

            return Column(
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: DropdownButtonWidget(
                            selectedValue: selectedProductCategory,
                            items: productCategory,
                            onChanged: (value) {
                              setState(() {
                                selectedProductCategory = value!;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: DropdownButtonWidget(
                            selectedValue: selectedSalesOrPurchaseCategory,
                            items: salesOrpurchaseCategory,
                            onChanged: (value) {
                              setState(() {
                                selectedSalesOrPurchaseCategory = value!;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: DropdownButtonWidget(
                            selectedValue: selectedWaitingCategory,
                            items: waitingCategory,
                            onChanged: (value) {
                              setState(() {
                                selectedWaitingCategory = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Text('${snapshot.data!.length}개의 상품이 있습니다.'),
                      Spacer(),
                      Container(
                        width: 150,
                        child: DropdownButtonWidget(
                          selectedValue: selectedSortCategory,
                          items: sortCategory,
                          onChanged: (value) {
                            setState(() {
                              selectedSortCategory = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    //위에서 필터링 된 것들만 보여줌.
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final item = filteredProducts[index];
                      return ProductList(
                        nextPage: DescriptionPage(
                            productImage: item["image"],
                            productTitle: item["title"],
                            productCategory: item["productCategory"],
                            productStatus: item["status"],
                            prductPrice: item["price"],
                            productDescription: item["decription"],
                            priceStatus: item['priceStatus']),
                        productThumbnail: item["image"][0],
                        productTitle: item["title"],
                        productStatus: item["status"],
                        productPrice: item["price"],
                      );
                    },
                  ),
                ),
                CommonBottomWidget(),
              ],
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
