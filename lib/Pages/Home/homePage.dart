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
import 'package:flutter_nomad_market/Pages/Writing/writingPage.dart';

class HomePage extends StatefulWidget {
  HomePage({required this.getSelectedCity, required this.getSelectedCurrency});
  final String getSelectedCity; //로그인 페이지에서 선택된 국가를 받아오기 위한 변수
  final String getSelectedCurrency; //로그인 페이지에서 선택된 통화를 받아오기 위한 변수

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //---------------dropdownBox의 목록들-----------------
  //상품 카테고리
  final List<String> productCategory = [
    '전체',
    '전자기기 및 가전',
    '패션 및 액세서리',
    '명품 및 럭셔리',
    '공예 및 수공예품',
    '문화 및 엔터테인먼트',
    '홈 및 리빙',
    '뷰티 및 퍼스널 케어',
    '식품 및 음료',
    '키즈 및 베이비',
    '스포츠 및 아웃도어',
    '반려동물 용품',
    '건강 및 웰빙',
    '자동차 및 오토바이 액세서리',
    '서비스',
    '기타',
    '구매요청'
  ];
  String selectedProductCategory = '전체';

  //삽니다 또는 팝니다
  final List<String> salesOrpurchaseCategory = ['전체', '삽니다', '팝니다'];
  String selectedSalesOrPurchaseCategory = '전체';

  //판매 상태 카테고리
  final List<String> waitingCategory = ['모든 상품', '판매중'];
  String selectedWaitingCategory = '모든 상품';

  //정렬 카테고리
  final List<String> sortCategory = ['최신순', '좋아요순', '댓글순'];
  String selectedSortCategory = '최신순';

  //------------productInfo json을 사용하기 위한 부분-----------------------------
  //productInfo.json을 사용하기 위한 변수
  final Future<List<dynamic>> productInfo =
      loadJsonData('assets/json/productInfo.json', 'productInfo');

  // -----------도시 정보와 통화 정보를 받아오기 위한 부분------------------
  //CitySelection에서 city에 대한 정보를 가져오기 위한 setting
  List<Map<String, dynamic>> cities = [];
  String selectedCity = '';

  //CurrencySetting에서 currency에 대한 정보를 가져오기 위한 setting
  String selectedCurrency = '';

  //통화 기호를 가지고 오기 위한 정규 표현식
  RegExp regExp = RegExp(r'\((.*?)\)'); //괄호 안의 문자열을 찾는 정규 표현식
  String currencySymbol = '';

  @override
  void initState() {
    super.initState();
    _initialization();
    _loadSelection();
  }

  //도시 정보를 받아오는 부분
  void _initialization() {
    cities = CitySelection.getCities();
  }

  //선택된 정보들을 받아와서 각각의 변수에 저장
  Future<void> _loadSelection() async {
    setState(() {
      selectedCity = widget.getSelectedCity; //선택된 도시
      selectedCurrency = widget.getSelectedCurrency; //선택된 통화
    });
    _getCurrency();
  }

  //선택된 통화의 통화 기호를 추출하기 위한 정규 표현식
  void _getCurrency() {
    super.initState();
    //priceCurrency에서 정규 표현식과 매칭되는 부분을 matchString 변수에 저장
    Match? matchString = regExp.firstMatch(selectedCurrency);

    if (matchString != null) {
      //정규 표현식에서 찾은 매치의 첫번째 값을 추출
      currencySymbol = matchString.group(1)!;
    } else {
      //일치하는 문자열이 없는 경우 빈 값
      currencySymbol = '';
    }
  }

  //---------------------검색 기능 추가 부분-----------------------------
  List<dynamic> searchedProducts = [];
  List<dynamic> searchResults = [];

  void _showSearchDialog() {
    String searchQuery = ""; // 다이얼로그 내 검색어 저장

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('상품검색'),
          content: TextField(
            onChanged: (value) {
              searchQuery = value; // 검색어 저장
            },
            decoration: InputDecoration(
              hintText: '검색할 키워드 입력',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Search'),
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
                _searchProducts(searchQuery); // 검색 실행
              },
            ),
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
            ),
          ],
        );
      },
    );
  }

  void _searchProducts(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults = []; //검색상태 초기화
      });
      return;
    }

    // productInfo에서 데이터를 기다림
    final List<dynamic> products = await productInfo;

    setState(() {
      searchResults = products.where((product) {
        final title = product['title']?.toString().toLowerCase() ?? '';
        final description =
            product['description']?.toString().toLowerCase() ?? '';
        final category =
            product['productCategory']?.toString().toLowerCase() ?? '';
        final images = (product['images'] as List<dynamic>)
            .map((image) => image.toString().toLowerCase())
            .join(' ');

        final searchWords = query.toLowerCase().split(' ');

        return searchWords.any((word) =>
            title.contains(word) ||
            description.contains(word) ||
            category.contains(word) ||
            images.contains(word));
      }).toList();
    });
  }

  //---------------------글쓰기 버튼 추가 부분----------------------------
  bool _isMenuOpen = false;

  void _showWritingOptions() {
    setState(() {
      _isMenuOpen = true;
    });
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
          800,
          MediaQuery.of(context).size.height - 280,
          4000,
          MediaQuery.of(context).size.height - 100),
      items: [
        PopupMenuItem(
          child: Row(
            children: [
              Icon(Icons.request_page),
              SizedBox(width: 8),
              Text('물품 의뢰하기'),
            ],
          ),
          onTap: () {
            setState(() {
              _isMenuOpen = false;
            });
            Future.delayed(
              const Duration(seconds: 0),
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WritingPage(isRequesting: true),
                ),
              ),
            );
          },
        ),
        PopupMenuItem(
          child: Row(
            children: [
              Icon(Icons.sell),
              SizedBox(width: 8),
              Text('내 물건 판매'),
            ],
          ),
          onTap: () {
            setState(() {
              _isMenuOpen = false;
            });
            Future.delayed(
              const Duration(seconds: 0),
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WritingPage(isRequesting: false),
                ),
              ),
            );
          },
        ),
      ],
    ).then((value) {
      setState(() {
        _isMenuOpen = false;
      });
    });
  }

  //UI 설정 부분
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
                searchedProducts.clear();
              });
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('selectedCity', newCity);
            },
            itemBuilder: (BuildContext context) {
              return CitySelection.getCities().map((Map<String, dynamic> city) {
                return PopupMenuItem<String>(
                  value: city['name'],
                  child: Row(
                    children: [
                      Flag.fromString(
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
              onPressed: _showSearchDialog,
              icon: const Icon(Icons.search, size: 30),
            ),
          )
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: productInfo,
        builder: (context, snapshot) {
          //상품 리스트를 가져올 때 로딩화면
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            //dropdownBox 선택 값에 따른 필터링 부분
            List<dynamic> filteredProducts = snapshot.data!.where((product) {
              //도시 카테고리
              bool cityMatch = product['selectedCity'] == selectedCity;

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
              return cityMatch && categoryMatch && statusMatch && waitingMatch;
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
                      Text(
                          '${searchResults.isNotEmpty ? searchResults.length : filteredProducts.length}개의 상품이 있습니다.'),
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
                    itemCount: searchResults.isNotEmpty
                        ? searchResults.length
                        : filteredProducts.length,
                    itemBuilder: (context, index) {
                      //product_info json
                      //검색을 했다면 검색한 결과의 상품 리스트 표시, 없다면 모든 상품 리스트 또는 필터링된 상품 리스트 표시
                      final itemInfo = searchResults.isNotEmpty
                          ? searchResults[index]
                          : filteredProducts[index];

                      return ProductList(
                        nextPage: DescriptionPage(
                          userID: itemInfo["userId"],
                          productImage: itemInfo["images"],
                          productTitle: itemInfo["title"],
                          productCategory: itemInfo["productCategory"],
                          productStatus: itemInfo["productStatus"],
                          productPrice: itemInfo["priceWon"],
                          productDescription:
                              itemInfo["description"] ?? "설명 없음",
                          priceStatus: itemInfo['priceStatus'],
                          priceCurrency: currencySymbol,
                        ),
                        productThumbnail: itemInfo["thumbnailImage"] ?? "",
                        productTitle: itemInfo["title"] ?? "제목 없음",
                        productStatus: itemInfo["waitingStatus"] ?? "대기 상태 없음",
                        productPrice: itemInfo["priceWon"] ?? "가격 없음",
                        priceCurrency: currencySymbol,
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
      floatingActionButton: Container(
        height: 50,
        child: FloatingActionButton.extended(
          onPressed: _showWritingOptions,
          icon: Icon(_isMenuOpen ? Icons.close : Icons.add),
          label: Text('글쓰기'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: CommonBottomWidget(),
    );
  }
}
