import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flag/flag.dart';
import 'package:flutter_nomad_market/Pages/Home/homePage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 공통 위젯 모음 클래스
class CommonWidgets {
  // 확인 버튼 위젯
  static Widget confirmButton({
    required BuildContext context,
    required VoidCallback? onPressed,
    String text = '확인',
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        //'확인 버튼'에 대한 에니메이션 효과
        SlideTransition(
          //애니메이션의 시작 값과 끝 값 정의
          position: Tween<Offset>(
            begin: const Offset(0, 1), //애니메이션 시작 위치 : 화면 아래
            end: Offset.zero, // 애니메이션 끝 위치 : 화면 원래 자리
          ).animate(CurvedAnimation(
            parent: ModalRoute.of(context)!.animation!,
            curve: Curves.easeOut,
          )),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  text,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 45), // 버튼 아래 여백 추가
      ],
    );
  }
}

// 제네릭 설정 페이지 (다국어, 국가, 통화 선택에 사용)
class GenericSettingPage extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> items;
  final Widget Function(String) nextPageBuilder;
  final String? initialSelection;

  const GenericSettingPage({
    Key? key,
    required this.title,
    required this.items,
    required this.nextPageBuilder,
    this.initialSelection,
  }) : super(key: key);

  @override
  _GenericSettingPageState createState() => _GenericSettingPageState();
}

class _GenericSettingPageState extends State<GenericSettingPage> {
  late String selectedItem;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    selectedItem = widget.initialSelection ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
          // 상단 고정 영역
          Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 필요한 다른 상단 요소를 여기에 추가할 수 있습니다.
              ],
            ),
          ),
          // 검색 결과 리스트
          Expanded(
            child: ListView.separated(
              controller: _scrollController,
              itemCount: widget.items.length,
              separatorBuilder: (context, index) => Divider(height: 1),
              itemBuilder: (context, index) {
                final item = widget.items[index];
                if (_searchController.text.isEmpty ||
                    item['name']
                        .toLowerCase()
                        .contains(_searchController.text.toLowerCase())) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedItem = item['name'];
                      });
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 18, horizontal: 32),
                      child: Row(
                        children: [
                          // 국기 이미지
                          SizedBox(
                            width: 50,
                            height: 50,
                            child: Flag.fromString(
                              item['flag'],
                              height: 50,
                              width: 50,
                              borderRadius: 20,
                              fit: BoxFit.cover,
                            ),
                          ),
                          // 간격 조절
                          SizedBox(width: 21),
                          // 텍스트
                          Expanded(
                            child: Text(
                              item['name'],
                              style: TextStyle(
                                fontSize: 18,
                                color: selectedItem == item['name']
                                    ? Colors.purple
                                    : Colors.black,
                              ),
                            ),
                          ),
                          // 체크 아이콘
                          if (selectedItem == item['name'])
                            Icon(Icons.check, color: Colors.purple),
                        ],
                      ),
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
          // 확인 버튼
          if (selectedItem.isNotEmpty)
            CommonWidgets.confirmButton(
              context: context,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => widget.nextPageBuilder(selectedItem),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// 언어 설정 페이지
class LanguageSetting extends StatelessWidget {
  final String selectedLanguage;
  const LanguageSetting({Key? key, this.selectedLanguage = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> languages = [
      {'name': 'English', 'flag': 'US'},
      {'name': '中文', 'flag': 'CN'},
      {'name': 'Español', 'flag': 'ES'},
      {'name': 'العربية', 'flag': 'AE'},
      {'name': 'Français', 'flag': 'FR'},
      {'name': 'Deutsch', 'flag': 'DE'},
      {'name': '日本語', 'flag': 'JP'},
      {'name': '한국어', 'flag': 'KR'},
      {'name': 'Português', 'flag': 'PT'},
      {'name': 'Русский', 'flag': 'RU'},
      {'name': 'Italiano', 'flag': 'IT'},
    ];

    return GenericSettingPage(
      title: '언어 선택',
      items: languages,
      initialSelection: selectedLanguage,
      nextPageBuilder: (selectedLanguage) =>
          CitySelection(), //선택된 언어를 CitySelection 위젯으로 넘겨줌
    );
  }
}

// 도시 설정 페이지
class CitySelection extends StatelessWidget {
  final String selectedCity;
  const CitySelection({Key? key, this.selectedCity = ''}) : super(key: key);

  static List<Map<String, dynamic>> getCities() {
    return [
      {'name': '런던, 영국', 'flag': 'GB'},
      {'name': '두바이, 아랍에미리트', 'flag': 'AE'},
      {'name': '이스탄불, 터키', 'flag': 'TR'},
      {'name': '파리, 프랑스', 'flag': 'FR'},
      {'name': '암스테르담, 네덜란드', 'flag': 'NL'},
      {'name': '프랑크푸르트, 독일', 'flag': 'DE'},
      {'name': '뉴욕, 미국', 'flag': 'US'},
      {'name': '방콕, 태국', 'flag': 'TH'},
      {'name': '싱가포르, 싱가포르', 'flag': 'SG'},
      {'name': '도쿄, 일본', 'flag': 'JP'},
      {'name': '서울, 대한민국', 'flag': 'KR'},
      {'name': '홍콩, 중국 특별행정구', 'flag': 'HK'},
      {'name': '시카고, 미국', 'flag': 'US'},
      {'name': '로스앤젤레스, 미국', 'flag': 'US'},
      {'name': '마드리드, 스페인', 'flag': 'ES'},
      {'name': '바르셀로나, 스페인', 'flag': 'ES'},
      {'name': '로마, 이탈리아', 'flag': 'IT'},
      {'name': '뮌헨, 독일', 'flag': 'DE'},
      {'name': '상하이, 중국', 'flag': 'CN'},
      {'name': '베이징, 중국', 'flag': 'CN'},
      {'name': '쿠알라룸푸르, 말레이시아', 'flag': 'MY'},
      {'name': '델리, 인도', 'flag': 'IN'},
      {'name': '모스크바, 러시아', 'flag': 'RU'},
      {'name': '멕시코시티, 멕시코', 'flag': 'MX'},
      {'name': '토론토, 캐나다', 'flag': 'CA'},
      {'name': '마이애미, 미국', 'flag': 'US'},
      {'name': '샌프란시스코, 미국', 'flag': 'US'},
      {'name': '취리히, 스위스', 'flag': 'CH'},
      {'name': '밀라노, 이탈리아', 'flag': 'IT'},
      {'name': '비엔나, 오스트리아', 'flag': 'AT'},
    ];
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> cities = getCities();

    return GenericSettingPage(
      title: '도시 선택',
      items: cities,
      initialSelection: selectedCity,
      nextPageBuilder: (selectedCity) =>
          CurrencySetting(selectedCity: selectedCity),
    );
  }
}

// 통화 설정 페이지
class CurrencySetting extends StatelessWidget {
  final String selectedCity;

  CurrencySetting({required this.selectedCity});

  Future<void> _saveSelectedCurrency(String currency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedCurrency', currency);
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> currencies = [
      {'name': 'KRW (₩)', 'flag': 'KR'},
      {'name': 'USD (\$)', 'flag': 'US'},
      {'name': 'EUR (€)', 'flag': 'EU'},
      {'name': 'JPY (¥)', 'flag': 'JP'},
      {'name': 'GBP (£)', 'flag': 'GB'},
      {'name': 'CNY (¥)', 'flag': 'CN'},
      {'name': 'AUD (\$)', 'flag': 'AU'},
      {'name': 'CAD (\$)', 'flag': 'CA'},
    ];

    return GenericSettingPage(
      title: '선호 통화 선택',
      items: currencies,
      nextPageBuilder: (selectedCurrency) {
        _saveSelectedCurrency(
            selectedCurrency.split(' ')[0]); // Save only 'KRW' or 'USD'
        return NicknameSetting(selectedCity: selectedCity);
      },
    );
  }
}

// 닉네임 설정 페이지
class NicknameSetting extends StatefulWidget {
  NicknameSetting({required this.selectedCity});
  String selectedCity;
  @override
  _NicknameSettingState createState() => _NicknameSettingState();
}

class _NicknameSettingState extends State<NicknameSetting> {
  final TextEditingController _nicknameController = TextEditingController();
  String _profileImagePath = 'assets/images/profile_images/defaultprofile.jpg';
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _profileImagePath = prefs.getString('profile_image') ??
          'assets/images/profile_images/defaultprofile.jpg';
    });
  }

  Future<void> _updateProfileImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image', image.path);
      setState(() {
        _profileImagePath = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('닉네임 설정', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
          SizedBox(height: 80),
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: _profileImagePath ==
                          'assets/images/profile_images/defaultprofile.jpg'
                      ? AssetImage(_profileImagePath)
                      : FileImage(File(_profileImagePath)) as ImageProvider,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.gallery);

                      if (image != null) {
                        setState(() {
                          _profileImagePath = image.path;
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 40),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _nicknameController,
              decoration: InputDecoration(
                hintText: '닉네임을 입력하세요',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Spacer(),
          CommonWidgets.confirmButton(
            context: context,
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('nickname', _nicknameController.text);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => HomePage(
                          getSelectedCity: widget.selectedCity,
                        )),
              );
            },
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
