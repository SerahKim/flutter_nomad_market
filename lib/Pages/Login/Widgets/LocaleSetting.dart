import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flag/flag.dart';
import 'package:flutter_nomad_market/Pages/Home/homePage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_nomad_market/utils/json_utils.dart';

// 공통 위젯 모음 클래스
class CommonWidgets {
  // 공통 확인 버튼 위젯
  static Widget confirmButton({
    required BuildContext context,
    required VoidCallback? onPressed,
    String text = '확인',
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
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
  final String? currentSelection;

  const GenericSettingPage({
    Key? key,
    required this.title,
    required this.items,
    required this.nextPageBuilder,
    this.initialSelection,
    this.currentSelection,
  }) : super(key: key);

  @override
  _GenericSettingPageState createState() => _GenericSettingPageState();
}

class _GenericSettingPageState extends State<GenericSettingPage> {
  late String _selectedItem;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.initialSelection ?? '';
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
                SizedBox(height: 20),
                // 현재 선택된 항목 표시
                if (widget.currentSelection != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Text(
                      '현재 ${widget.title}: ${widget.currentSelection}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                // 검색 필드
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: '${widget.title} 검색',
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      ),
                      onChanged: (value) => setState(() {}),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // 검색 결과 헤더
                Container(
                  width: double.infinity,
                  color: Colors.grey[100],
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    '검색 결과',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ),
                Divider(height: 1, thickness: 1),
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
                        _selectedItem = item['name'];
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
                                color: _selectedItem == item['name']
                                    ? Colors.purple
                                    : Colors.black,
                              ),
                            ),
                          ),
                          // 체크 아이콘
                          if (_selectedItem == item['name'])
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
          if (_selectedItem.isNotEmpty)
            CommonWidgets.confirmButton(
              context: context,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => widget.nextPageBuilder(_selectedItem),
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
      {'name': '한국어', 'flag': 'KR'},
      {'name': 'English', 'flag': 'US'},
      {'name': '中文', 'flag': 'CN'},
      {'name': '日本語', 'flag': 'JP'},
      {'name': 'Español', 'flag': 'ES'},
      {'name': 'العربية', 'flag': 'AE'},
      {'name': 'Français', 'flag': 'FR'},
      {'name': 'Deutsch', 'flag': 'DE'},
      {'name': 'Português', 'flag': 'PT'},
      {'name': 'Русский', 'flag': 'RU'},
      {'name': 'Italiano', 'flag': 'IT'},
    ];

    return GenericSettingPage(
      title: '언어 선택',
      items: languages,
      initialSelection: selectedLanguage,
      nextPageBuilder: (selectedLanguage) => CitySelection(),
    );
  }
}

// 도시 설정 페이지
class CitySelection extends StatelessWidget {
  final String selectedCity;
  const CitySelection({Key? key, this.selectedCity = ''}) : super(key: key);

  // cities 리스트를 클래스 레벨 변수로 이동
  static final List<Map<String, dynamic>> cities = [
    {'name': '서울, 대한민국', 'flag': 'KR'},
    {'name': '도쿄, 일본', 'flag': 'JP'},
    {'name': '뉴욕, 미국', 'flag': 'US'},
    {'name': '로마, 이탈리아', 'flag': 'IT'},
    {'name': '홍콩, 중국 특별행정구', 'flag': 'HK'},
    {'name': '런던, 영국', 'flag': 'GB'},
    {'name': '이스탄불, 터키', 'flag': 'TR'},
    {'name': '파리, 프랑스', 'flag': 'FR'},
    {'name': '두바이, 아랍에미리트', 'flag': 'AE'},
    {'name': '암스테르담, 네덜란드', 'flag': 'NL'},
    {'name': '프랑크푸르트, 독일', 'flag': 'DE'},
    {'name': '방콕, 태국', 'flag': 'TH'},
    {'name': '싱가포르, 싱가포르', 'flag': 'SG'},
    {'name': '시카고, 미국', 'flag': 'US'},
    {'name': '로스앤젤레스, 미국', 'flag': 'US'},
    {'name': '마드리드, 스페인', 'flag': 'ES'},
    {'name': '바르셀로나, 스페인', 'flag': 'ES'},
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

  // cities 리스트를 반환하는 메서드 추가
  List<Map<String, dynamic>> getCities() {
    return cities;
  }

  @override
  Widget build(BuildContext context) {
    return GenericSettingPage(
      title: '도시 선택',
      items: cities,
      initialSelection: selectedCity,
      nextPageBuilder: (selectedCity) => CurrencySetting(),
    );
  }
}

// 통화 설정 페이지
class CurrencySetting extends StatelessWidget {
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
      nextPageBuilder: (selectedCurrency) => NicknameSetting(),
    );
  }
}

// 닉네임 설정 페이지
class NicknameSetting extends StatefulWidget {
  @override
  _NicknameSettingState createState() => _NicknameSettingState();
}

class _NicknameSettingState extends State<NicknameSetting> {
  final TextEditingController _nicknameController = TextEditingController();
  String _profileImagePath = 'assets/system_images/defaultprofile.jpg';
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
          'assets/system_images/defaultprofile.jpg';
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

  // 새로운 _addNewUser 메서드 추가
  Future<void> _addNewUser(String nickname) async {
    await addNewUser(nickname, _profileImagePath);
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
                  radius: 100,
                  backgroundImage: _profileImagePath ==
                          'assets/system_images/defaultprofile.jpg'
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
                      padding: EdgeInsets.all(10),
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
          SizedBox(height: 60),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
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
              await _addNewUser(_nicknameController.text); // 새 사용자 추가
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
