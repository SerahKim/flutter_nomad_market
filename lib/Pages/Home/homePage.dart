import 'package:flutter/material.dart';
import 'package:flutter_nomad_market/Pages/Home/Widgets/dropdownButton.dart';
import 'package:flutter_nomad_market/Pages/Home/Widgets/productList.dart';
import 'package:flutter_nomad_market/Pages/Login/Widgets/LocaleSetting.dart';
import 'package:flutter_nomad_market/Pages/Widgets/commonWidgets.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //상품 정렬
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

  int productLength = 0;

  void updateProductLength(int length) {
    if (productLength != length) {
      setState(() {
        productLength = length;
      });
    }
  }

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
      body: Column(
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  DropdownButtonWidget(
                    selectedValue: selectedProductCategory,
                    items: productCategory,
                    onChanged: (value) {
                      setState(() {
                        selectedProductCategory = value!;
                      });
                    },
                  ),
                  SizedBox(width: 20),
                  DropdownButtonWidget(
                    selectedValue: selectedSalesOrPurchaseCategory,
                    items: salesOrpurchaseCategory,
                    onChanged: (value) {
                      setState(() {
                        selectedSalesOrPurchaseCategory = value!;
                      });
                    },
                  ),
                  SizedBox(width: 20),
                  DropdownButtonWidget(
                    selectedValue: selectedWaitingCategory,
                    items: waitingCategory,
                    onChanged: (value) {
                      setState(() {
                        selectedWaitingCategory = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text('$productLength개의 상품이 있습니다.'),
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
            child: ProductList(dataLength: updateProductLength),
          ),
          Spacer(),
          CommonBottomWidget(),
        ],
      ),
    );
  }
}
