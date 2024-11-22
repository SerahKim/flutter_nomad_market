import 'package:flutter/material.dart';
import 'package:flutter_nomad_market/Pages/Login/Widgets/LocaleSetting.dart';
import 'package:flutter_nomad_market/Pages/My/Widgets/profilePage.dart';
import 'package:flutter_nomad_market/Pages/My/Widgets/purchaseHistory.dart';
import 'package:flutter_nomad_market/Pages/My/Widgets/salesHistory.dart';

class MyPage extends StatelessWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('마이페이지'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15),
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
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => WishlistPage()));
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
                      title: Text('관심 있는 국가 변경'),
                      contentPadding: EdgeInsets.zero,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    LocationSetting(selectedCountry: '')));
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
            BottomNavigationWidget(),
          ],
        ),
      ),
    );
  }
}

class BottomNavigationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavButton(Icons.home, '홈', () {}),
          _buildNavButton(Icons.chat_bubble_outline, '채팅', () {}),
          _buildNavButton(Icons.person_outline, '마이페이지', () {}),
        ],
      ),
    );
  }

  Widget _buildNavButton(IconData icon, String label, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: Colors.purple,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          Text(label),
        ],
      ),
    );
  }
}
