import 'package:flutter/material.dart';
import 'package:flutter_nomad_market/Pages/Chatting/chattingListPage.dart';
import 'package:flutter_nomad_market/Pages/Home/homePage.dart';
import 'package:flutter_nomad_market/Pages/My/myPage.dart';

class CommonBottomWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          height: 80,
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavButton(context, Icons.home, '홈', () {
                Navigator.pushReplacement(
                  //Navigator.push를 Navigator.pushReplacement로 변경 현재 페이지를 새로운 HomePage로 교체하는 방법으로 페이지 이동 오류 해결하고 스택에 불필요한 페이지가 쌓이는 것을 방지
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(
                      getSelectedCity: '',
                    ),
                  ),
                );
              }),
              _buildNavButton(context, Icons.chat, '채팅', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChattingListPage()),
                );
              }),
              _buildNavButton(context, Icons.person, '마이페이지', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyPage()),
                );
              }),
            ],
          ),
        ),
        SizedBox(height: 15),
      ],
    );
  }

  Widget _buildNavButton(BuildContext context, IconData icon, String label,
      VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: Colors.purple,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 30),
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
