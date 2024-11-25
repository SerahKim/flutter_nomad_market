import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nomad_market/Pages/Description/descriptionPage.dart';
import 'package:flutter_nomad_market/Pages/Home/Widgets/dropdownButton.dart';
import 'package:flutter_nomad_market/Pages/Home/Widgets/productList.dart';
import 'package:flutter_nomad_market/Pages/Login/Widgets/LocaleSetting.dart';
import 'package:flutter_nomad_market/Pages/Widgets/commonWidgets.dart';
import 'package:flutter_nomad_market/utils/json_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> products = [];
  int productCount = 0;
  String selectedCity = '서울, 대한민국';
  late List<Map<String, dynamic>> cities;

  final List<String> productCategory = [
    '전체',
    '전자기기 및 가전',
    '패션 및 액세서리',
    '홈 & 리빙',
    '뷰티 & 퍼스널 케어',
    '식품 & 음료',
    '키즈 & 베이비',
    '스포츠 & 아웃도어',
    '문화 & 엔터테인먼트',
    '반려동물 용품',
    '건강 & 웰빙',
    '자동차 & 오토바이 액세서리',
    '공예 & 수공예품',
    '명품 & 럭셔리',
    '서비스',
    '기타',
    '구매요청'
  ];
  String selectedProductCategory = '전체';

  final List<String> salesOrpurchaseCategory = ['전체', '삽니다', '팝니다'];
  String selectedSalesOrPurchaseCategory = '전체';

  final List<String> waitingCategory = ['모든 상품', '거래 미완료'];
  String selectedWaitingCategory = '모든 상품';

  final List<String> sortCategory = ['최신순', '좋아요순', '댓글순'];
  String selectedSortCategory = '최신순';

  @override
  void initState() {
    super.initState();
    _initializeCities();
    _loadSelectedCity().then((_) => _loadProducts());
  }

  void _initializeCities() {
    final citySelection = CitySelection(selectedCity: selectedCity);
    cities = citySelection.getCities();
  }

  Future<void> _loadSelectedCity() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedCity = prefs.getString('selectedCity') ?? '서울, 대한민국';
    });
  }

  Future<void> _loadProducts() async {
    final postsData = await loadJsonData('assets/data/posts.json');
    setState(() {
      products = postsData['posts']
          .where((product) => product['location'] == selectedCity)
          .map((product) => {
                'title': product['title'] ?? '제목 없음',
                'status': product['status'] ?? '상태 없음',
                'price': product['price']?.toString() ?? '0',
                'images': product['images'] ??
                    ['assets/system_images/defaultprofile.jpg'],
                'city': product['city'],
              })
          .toList();
      productCount = products.length;
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
              await _loadProducts();
            },
            itemBuilder: (BuildContext context) {
              return cities.map((Map<String, dynamic> city) {
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
              onPressed: () {},
              icon: const Icon(Icons.search, size: 30),
            ),
          )
        ],
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonWidget(
                  selectedValue: selectedProductCategory,
                  items: productCategory,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedProductCategory = value;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: DropdownButtonWidget(
                  selectedValue: selectedSalesOrPurchaseCategory,
                  items: salesOrpurchaseCategory,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedSalesOrPurchaseCategory = value;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: DropdownButtonWidget(
                  selectedValue: selectedWaitingCategory,
                  items: waitingCategory,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedWaitingCategory = value;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text('$productCount개의 상품이 있습니다.'),
              const Spacer(),
              SizedBox(
                width: 150,
                child: DropdownButtonWidget(
                  selectedValue: selectedSortCategory,
                  items: sortCategory,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedSortCategory = value;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
            child: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            return ProductList(
              product: products[index],
              onTap: _navigateToDescriptionPage,
            );
          },
        )),
        CommonBottomWidget(),
      ]),
    );
  }

  void _navigateToDescriptionPage(Map product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DescriptionPage(
          productData: {
            'images': [product['images'][0]],
            'sellerImage': product['sellerImage'] ?? '',
            'sellerNickname': product['sellerNickname'] ?? '익명',
            'sellerLocation': product['city'] ?? '위치 정보 없음',
            'title': product['title'] ?? '제목 없음',
            'category': product['category'] ?? '카테고리 없음',
            'status': product['status'] ?? '상태 없음',
            'description': product['description'] ?? '설명 없음',
            'price': product['price']?.toString() ?? '0',
            'negotiable': product['negotiable'] ?? false,
          },
        ),
      ),
    );
  }
}
