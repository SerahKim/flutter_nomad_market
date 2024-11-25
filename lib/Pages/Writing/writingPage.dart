import 'package:flutter/material.dart';

class WritingPage extends StatelessWidget {
  final bool isRequesting;

  WritingPage({required this.isRequesting});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back),
        ),
        title: Text(isRequesting ? '물품 의뢰하기' : '내 물건 판매'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 이미지 업로드 버튼
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                      SizedBox(height: 8.0),
                      Text('0/10', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              // 제목 입력
              Text('제목', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 16.0),
              TextField(
                decoration: InputDecoration(
                  labelText: '제목',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              // 거래 방식 선택
              Text('거래 방식', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8.0),
              isRequesting
                  ? ElevatedButton(
                      onPressed: () {},
                      child: Text('구매요청'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        minimumSize: Size(100, 50),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: Text('판매하기'),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            minimumSize: Size(100, 50),
                          ),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text('나눔하기'),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            minimumSize: Size(100, 50),
                          ),
                        ),
                      ],
                    ),
              SizedBox(height: 16.0),
              // 가격 입력
              if (!isRequesting) ...[
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixText: '₩ ',
                    labelText: '가격을 입력해주세요.',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 8.0),
                // 가격 제안 받기 체크박스
                Row(
                  children: [
                    Checkbox(
                      value: true,
                      onChanged: (bool? value) {
                        // 가격 제안 받기 상태 변경 처리
                      },
                    ),
                    Text('가격 제안 받기'),
                  ],
                ),
              ],
              SizedBox(height: 16.0),
              // 자세한 설명
              TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: '자세한 설명',
                  hintText: 'Nomark에 올릴 게시글 내용을 작성해 주세요...',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
              SizedBox(height: 24.0),
              // 작성 완료 버튼
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // 글 작성 완료 처리
                  },
                  child: Text('작성 완료'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
