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
  HomePage({required this.getSelectedCity});
  final String getSelectedCity;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> products = [];
  bool isLoading = false;
  int currentPage = 0;
  final int itemsPerPage = 20;
  String selectedCity = '';
  List<Map<String, String>> cities = [];
  List<dynamic> searchResults = [];

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

  final List<String> salesOrpurchaseCategory = ['전체', '삽니다', '팝니다'];
  String selectedSalesOrPurchaseCategory = '전체';

  final List<String> waitingCategory = ['모든 상품', '판매중'];
  String selectedWaitingCategory = '모든 상품';

  final List<String> sortCategory = ['최신순', '좋아요순', '댓글순'];
  String selectedSortCategory = '최신순';

  bool _isMenuOpen = false;

  @override
  void initState() {
    super.initState();
    _loadSelectedCity();
    _loadAllProducts();
  }

  void _initializeCities() {
    cities = CitySelection.getCities()
        .map((city) => Map<String, String>.from(city))
        .toList();
  }

  Future<void> _loadSelectedCity() async {
    setState(() {
      selectedCity = widget.getSelectedCity;
    });
    await _loadAllProducts();
  }

  Future<void> _loadAllProducts() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    try {
      final allProducts = await loadJsonData(
        'assets/json/productInfo.json',
        'productInfo',
        selectedCity,
        selectedProductCategory,
        selectedSalesOrPurchaseCategory,
        selectedWaitingCategory,
      );

      setState(() {
        products = allProducts;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading products: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('상품검색'),
          content: TextField(
            onChanged: (value) {
              _searchProducts(value);
            },
            decoration: InputDecoration(
              hintText: '검색할 키워드 입력',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
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
        searchResults = [];
        products = []; // 검색어가 비어있을 때 products도 초기화
      });
      return;
    }

    final allProducts = await loadJsonData(
      'assets/json/productInfo.json',
      'productInfo',
      selectedCity,
      selectedProductCategory,
      selectedSalesOrPurchaseCategory,
      selectedWaitingCategory,
    );

    setState(() {
      // 검색어와 일치하는 제품 필터링
      searchResults = allProducts.where((product) {
        final title = product['title'].toLowerCase();
        final description = product['description'].toLowerCase();
        final category = product['productCategory'].toLowerCase();
        final images =
            (product['images'] as List<dynamic>).join(' ').toLowerCase();
        final searchQuery = query.toLowerCase();

        // 검색어를 단어로 분리
        final searchWords = searchQuery.split(' ');

        // 제품명, 설명, 카테고리, 이미지 파일명에서 검색어의 일부라도 포함되는지 확인
        bool matchesAnyField = searchWords.any((word) =>
            title.contains(word) ||
            description.contains(word) ||
            category.contains(word) ||
            images.contains(word));

        // 특정 카테고리나 제품군에 대한 추가 검색 로직
        if (category == '전자기기 및 가전' && searchQuery.contains('전자기기')) {
          return true;
        }

        if (title.contains('아이폰') && searchQuery.contains('아이폰')) {
          return true;
        }

        if ((title.contains('맥북') || title.contains('아이맥')) &&
            searchQuery.contains('맥')) {
          return true;
        }

        return matchesAnyField;
      }).toList();
      products = searchResults; // 검색 결과를 products에 할당하여 화면에 표시
    });
  }

  Future<List<dynamic>> loadJsonData(
    String path,
    String key,
    String selectedCity,
    String selectedProductCategory,
    String selectedSalesOrPurchaseCategory,
    String selectedWaitingCategory,
  ) async {
    final jsonString = await rootBundle.loadString(path);
    final jsonData = json.decode(jsonString);
    final List allItems = jsonData[key];

    //선택한 필터에 따라 필터링
    return allItems
        .where((item) =>
            item['selectedCity'] == selectedCity &&
            (selectedProductCategory == '전체' ||
                item['productCategory'] == selectedProductCategory) &&
            (selectedSalesOrPurchaseCategory == '전체' ||
                item['productStatus'] == selectedSalesOrPurchaseCategory) &&
            (selectedWaitingCategory == '모든 상품' ||
                item['waitingStatus'] == selectedWaitingCategory))
        .toList();
  }

  String formatPrice(String price, String currency) {
    if (currency == 'KRW') {
      return '₩$price';
    } else {
      return '\$$price';
    }
  }

  Future<String> _getSelectedCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('selectedCurrency') ?? 'USD';
  }

  void _navigateToDescriptionPage(
      Map<String, dynamic> item, String selectedCurrency) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DescriptionPage(
          productImage: item["images"] ?? [],
          productTitle: item["title"] ?? '제목 없음',
          productCategory: item["productCategory"] ?? '카테고리 없음',
          productStatus: item["productStatus"] ?? '상태 없음',
          waitingStatus: item["waitingStatus"] ?? '대기 상태 없음',
          productDescription: item["description"] ?? '설명 없음',
          priceStatus: item['priceStatus'] ?? '가격 정보 없음',
          productPriceKRW: item["priceWon"] ?? '가격없음',
          productPriceUSD: item["priceDollar"] ?? '가격없음',
          selectedCurrency: selectedCurrency,
        ),
      ),
    );
  }

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
                products.clear();
              });
              await _loadAllProducts();
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
              icon: const Icon(Icons.search, size: 30),
              onPressed: _showSearchDialog,
            ),
          ),
        ],
      ),
      body: Column(
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
                          products.clear();
                          currentPage = 0;
                        });
                        _loadAllProducts();
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
                          products.clear();
                          currentPage = 0;
                        });
                        _loadAllProducts();
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
                          products.clear();
                          currentPage = 0;
                        });
                        _loadAllProducts();
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
                Text('${products.length}개의 상품이 있습니다.'),
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
            child: FutureBuilder(
              future: _getSelectedCurrency(),
              builder: (context, currencySnapshot) {
                if (currencySnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (currencySnapshot.hasError) {
                  return Center(child: Text('통화 로딩 중 오류 발생'));
                } else {
                  final selectedCurrency = currencySnapshot.data!;
                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final item = products[index];
                      return ProductList(
                        productThumbnail: item["thumbnailImage"] ??
                            'assets/images/product_images/0.no_image.jpg',
                        productTitle: item["title"] ?? '제목 없음',
                        productStatus: item["productStatus"] ?? '상태 없음',
                        waitingStatus: item["waitingStatus"] ?? '상태 없음',
                        productPriceKRW: item["priceWon"] ?? '가격없음',
                        productPriceUSD: item["priceDollar"] ?? '가격없음',
                        selectedCurrency: selectedCurrency,
                        onTap: () =>
                            _navigateToDescriptionPage(item, selectedCurrency),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
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
