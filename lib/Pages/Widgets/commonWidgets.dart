//홈, 채팅, 마이페이지
import 'package:flutter/material.dart';
import 'package:flutter_nomad_market/Pages/Home/homePage.dart';

class CommonBottomWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              child: Column(
                children: [
                  Icon(
                    Icons.home_outlined,
                    size: 40,
                  ),
                  Text(
                    '홈',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () {},
              child: Column(
                children: [
                  Icon(
                    Icons.chat_bubble_outline_outlined,
                    size: 40,
                  ),
                  Text(
                    '채팅',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () {},
              child: Column(
                children: [
                  Icon(
                    Icons.manage_accounts,
                    size: 40,
                  ),
                  Text(
                    '마이페이지',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
