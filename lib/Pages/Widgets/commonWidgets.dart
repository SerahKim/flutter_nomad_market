import 'package:flutter/material.dart';
import 'package:flutter_nomad_market/Pages/Chatting/chattingListPage.dart';
import 'package:flutter_nomad_market/Pages/Home/homePage.dart';
import 'package:flutter_nomad_market/Pages/My/myPage.dart';

class CommonBottomWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavButton(context, Icons.home_outlined, '홈', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          }),
          _buildNavButton(context, Icons.chat_bubble_outline, '채팅', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChattingListPage()),
            );
          }),
          _buildNavButton(context, Icons.person_outline, '마이페이지', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyPage()),
            );
          }),
        ],
      ),
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
