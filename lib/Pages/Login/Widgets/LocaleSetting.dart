import 'package:flutter/material.dart';

//언어 선택 페이지
class LanguageSetting extends StatelessWidget {
  LanguageSetting({required this.selectedLanguage});
  String selectedLanguage;

  @override
  Widget build(BuildContext context) {
    final List<String> language = [
      'English',
      '中文',
      'Español',
      'العربية',
      'Français',
      'Deutsch',
      '日本語',
      '한국어',
      'Português',
      'Русский',
      'Italiano'
    ];

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              hintText: "검색할 언어를 입력해주세요"),
        ),
      ),
      body: ListView.builder(
        itemCount: language.length,
        itemBuilder: (BuildContext context, int index) {
          return LocaleSettingList(
            localeList: language[index],
            nextPage: LocationSetting(
              selectedCountry: '',
            ),
          );
        },
      ),
    );
  }
}

//국가 선택 페이지
class LocationSetting extends StatelessWidget {
  LocationSetting({required this.selectedCountry});
  String selectedCountry;

  @override
  Widget build(BuildContext context) {
    final List<String> country = [
      '대한민국, 서울',
      '독일, 뮌헨',
      '독일, 프랑크푸르트',
      '러시아, 모스크바',
      '말레이시아, 쿠알라룸푸르',
      '멕시코, 멕시코시티',
      '미국, 로스앤젤레스',
      '미국, 마이애미',
      '미국, 샌프란시스코',
      '미국, 시카고',
      '미국, 뉴욕',
      '스페인, 바르셀로나',
      '스페인, 마드리드',
      '스위스, 취리히',
      '싱가포르, 싱가포르',
      '아랍에미리트, 두바이',
      '오스트리아, 비엔나',
      '영국, 런던',
      '이탈리아, 로마',
      '이탈리아, 밀라노',
      '인도, 델리',
      '일본, 도쿄',
      '중국, 베이징',
      '중국, 상하이',
      '중국 특별행정구, 홍콩',
      '캐나다, 토론토',
      '태국, 방콕',
      '터키, 이스탄불',
      '프랑스, 파리',
      '네덜란드, 암스테르담'
    ];

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              hintText: "검색할 국가를 입력해주세요"),
        ),
      ),
      body: ListView.builder(
        itemCount: country.length,
        itemBuilder: (BuildContext context, int index) {
          return LocaleSettingList(
            localeList: country[index],
            nextPage: NicknameSetting(),
          );
        },
      ),
    );
  }
}

//닉네임 설정 페이지
class NicknameSetting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: TextField(
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  hintText: "원하는 닉네임을 입력해주세요."),
              keyboardType: TextInputType.text,
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            width: double.maxFinite,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  '확인',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//공통 UI
class LocaleSettingList extends StatefulWidget {
  LocaleSettingList({required this.localeList, required this.nextPage});
  final String localeList;
  final Widget nextPage;

  @override
  State<LocaleSettingList> createState() => _LocaleSettingListState();
}

class _LocaleSettingListState extends State<LocaleSettingList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[300]!, //container의 바닥 부분에만 색을 줌.
          ),
        ),
      ),
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => widget.nextPage,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.localeList,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
