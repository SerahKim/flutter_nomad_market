import 'package:flutter/material.dart';

class Loginpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Stack(
              alignment: Alignment.center, // Stack 내부 위젯들을 가운데 정렬
              children: [
                Image.asset(
                  "assets/images/nomadmarketlogo4_3.png",
                ),
                Positioned(
                  bottom: 80,
                  child: Text(
                    'Shop Globally, Travel Locally',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.purple, // 보라색으로 텍스트 설정
                      fontWeight: FontWeight.w500, // 텍스트를 조금 더 굵게
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),
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
                    '시작하기',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 80,
            ),
          ],
        ),
      ),
    );
  }
}
