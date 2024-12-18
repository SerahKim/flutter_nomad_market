import 'package:flutter/material.dart';
import 'package:flutter_nomad_market/Pages/Login/Widgets/LocaleSetting.dart';
import 'package:flutter_nomad_market/Pages/My/Widgets/profilePage.dart';
import 'package:flutter_nomad_market/Pages/My/Widgets/purchaseHistory.dart';
import 'package:flutter_nomad_market/Pages/My/Widgets/salesHistory.dart';
import 'package:flutter_nomad_market/Pages/Widgets/commonWidgets.dart';

class MyPage extends StatelessWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('마이페이지'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.grey[300],
                        child: Icon(Icons.person, size: 30),
                      ),
                      SizedBox(width: 10),
                      Text('나루터', style: TextStyle(fontSize: 18)),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilePage()),
                      );
                    },
                    child: Text('프로필 수정'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.purple,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('나의 거래',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    ListTile(
                      leading: Icon(Icons.favorite_border),
                      title: Text('관심목록'),
                      contentPadding: EdgeInsets.zero,
                      onTap: () {
                        // TODO: 관심목록 페이지로 이동
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.receipt_long),
                      title: Text('판매내역'),
                      contentPadding: EdgeInsets.zero,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SalesHistoryPage()));
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.shopping_bag_outlined),
                      title: Text('구매내역'),
                      contentPadding: EdgeInsets.zero,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PurchaseHistoryPage()));
                      },
                    ),
                    SizedBox(height: 20),
                    Text('환경 설정',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    ListTile(
                      leading: Icon(Icons.public),
                      title: Text('관심 있는 도시 변경'),
                      contentPadding: EdgeInsets.zero,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CitySelection(selectedCity: '')));
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.language),
                      title: Text('언어 변경'),
                      contentPadding: EdgeInsets.zero,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    LanguageSetting(selectedLanguage: '')));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CommonBottomWidget(),
    );
  }
}
