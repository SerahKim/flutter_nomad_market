import 'package:flutter/material.dart';

class WritingPage extends StatefulWidget {
  @override
  _WritingPageState createState() => _WritingPageState();
}

class _WritingPageState extends State<WritingPage> {
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
        title: Text('내 물건 팔기'),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.grey),
                    width: 100,
                    height: 50,
                    child: Center(
                      child: Text('판매하기'),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border(bottom: BorderSide(color: Colors.grey))),
                    width: 100,
                    height: 50,
                    child: Center(
                      child: Text('나눔하기'),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                ],
              ),
              SizedBox(height: 16.0),

              // 가격 입력
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
