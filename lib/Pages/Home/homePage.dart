import 'dart:convert';

import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nomad_market/Pages/Description/descriptionPage.dart';
import 'package:flutter_nomad_market/Pages/Home/Widgets/dropdownButton.dart';
import 'package:flutter_nomad_market/Pages/Home/Widgets/productList.dart';
import 'package:flutter_nomad_market/Pages/Login/Widgets/LocaleSetting.dart';
import 'package:flutter_nomad_market/Pages/Widgets/commonWidgets.dart';
import 'package:flutter_nomad_market/utils/json_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage({required this.getSelectedCity});
  final String getSelectedCity;
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
  final List<String> waitingCategory = ['모든 상품', '판매중'];
  String? selectedWaitingCategory = '모든 상품';

  //기본 정렬
  final List<String> sortCategory = ['최신순', '좋아요순', '댓글순'];
  String? selectedSortCategory = '최신순';

  //productInfo.json을 사용하기 위한 변수
  final Future<List<dynamic>> productInfo =
      loadJsonData('assets/json/productInfo.json', 'productInfo');

  //LocaleSetting에서 city에 대한 정보를 가져오기 위한 setting
  List<Map<String, dynamic>> cities = [];
  String selectedCity = '';

  @override
  void initState() {
    super.initState();
    _initializeCities();
    _loadSelectedCity();
  }

  void _initializeCities() {
    cities = CitySelection.getCities();
  }

  Future<void> _loadSelectedCity() async {
    setState(() {
      selectedCity = widget.getSelectedCity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: 200,
        leading: Padding(
          padding: const EdgeInsets.only(left: 30),
          child: PopupMenuButton<String>(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedCity,
                    style: TextStyle(fontSize: 20),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(Icons.keyboard_arrow_down, size: 20),
              ],
            ),
            onSelected: (String newCity) async {
              setState(() {
                selectedCity = newCity;
              });
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('selectedCity', newCity);
            },
            itemBuilder: (BuildContext context) {
              return cities.map((Map<String, dynamic> city) {
                return PopupMenuItem<String>(
                  //도시 이름
                  value: city['name'],
                  child: Row(
                    children: [
                      Flag.fromString(
                        //도시 국기
                        city['flag']!,
                        height: 20,
                        width: 20,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 10),
                      Text(city['name']!),
                    ],
                  ),
                );
              }).toList();
            },
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search, size: 30),
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
                            productImage: item["images"],
                            productTitle: item["title"],
                            productCategory: item["productCategory"],
                            productStatus: item["productStatus"],
                            productPrice: item["priceWon"],
                            productDescription: item["decription"],
                            priceStatus: item['priceStatus']),
                        productThumbnail: item["images"][0],
                        productTitle: item["title"],
                        productStatus: item["waitingStatus"],
                        productPrice: item["priceWon"],
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
