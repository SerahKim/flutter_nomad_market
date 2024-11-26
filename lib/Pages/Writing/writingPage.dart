import 'package:flutter/material.dart';

class WritingPage extends StatefulWidget {
  final bool isRequesting;

  WritingPage({required this.isRequesting});

  @override
  _WritingPageState createState() => _WritingPageState();
}

class _WritingPageState extends State<WritingPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isFormValid = false;
  bool _isPriceNegotiable = false;
  String _title = '';
  String _price = '';
  String _description = '';
  String _tradeMethod = '';
  bool _isRequestButtonActive = false;
  bool _isSellButtonActive = false;
  bool _isShareButtonActive = false;

  void _updateFormState() {
    setState(() {
      _isFormValid = _title.isNotEmpty &&
          _tradeMethod.isNotEmpty &&
          _price.isNotEmpty &&
          _description.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back),
        ),
        title: Text(widget.isRequesting ? '물품 의뢰하기' : '내 물건 판매'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
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
                TextFormField(
                  decoration: InputDecoration(
                    labelText: '제목',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _title = value;
                      _updateFormState();
                    });
                  },
                ),
                SizedBox(height: 25.0),
                // 거래 방식 선택
                Text('거래 방식', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8.0),
                widget.isRequesting
                    ? ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _tradeMethod = '구매요청';
                            _isRequestButtonActive = true;
                            _updateFormState();
                          });
                        },
                        child: Text(
                          '구매요청',
                          style: TextStyle(
                            color: _isRequestButtonActive
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          minimumSize: Size(100, 50),
                          backgroundColor:
                              _isRequestButtonActive ? Colors.purple : null,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _tradeMethod = '판매하기';
                                _isSellButtonActive = true;
                                _isShareButtonActive = false;
                                _updateFormState();
                              });
                            },
                            child: Text(
                              '판매하기',
                              style: TextStyle(
                                color: _isSellButtonActive
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              minimumSize: Size(100, 50),
                              backgroundColor:
                                  _isSellButtonActive ? Colors.purple : null,
                            ),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _tradeMethod = '나눔하기';
                                _isShareButtonActive = true;
                                _isSellButtonActive = false;
                                _updateFormState();
                              });
                            },
                            child: Text(
                              '나눔하기',
                              style: TextStyle(
                                color: _isShareButtonActive
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              minimumSize: Size(100, 50),
                              backgroundColor:
                                  _isShareButtonActive ? Colors.purple : null,
                            ),
                          ),
                        ],
                      ),
                SizedBox(height: 16.0),
                // 가격 입력
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixText: '₩ ',
                    labelText: '가격을 입력해주세요.',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _price = value;
                      _updateFormState();
                    });
                  },
                ),
                SizedBox(height: 8.0),
                // 가격 제안 받기 체크박스
                Row(
                  children: [
                    Checkbox(
                      value: _isPriceNegotiable,
                      onChanged: (bool? value) {
                        setState(() {
                          _isPriceNegotiable = value ?? false;
                        });
                      },
                    ),
                    Text('가격 제안 받기'),
                  ],
                ),
                SizedBox(height: 25.0),
                // 자세한 설명
                TextFormField(
                  maxLines: 6,
                  decoration: InputDecoration(
                    labelText: '게시물 내용을 작성해주세요. (판매 금지 물품은 게시가 제한될 수 있어요)',
                    hintText: '게시물 내용을 작성해주세요.',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _description = value;
                      _updateFormState();
                    });
                  },
                ),
                SizedBox(height: 10.0),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 16.0),
            child: ElevatedButton(
              onPressed: _isFormValid
                  ? () {
                      // 글 작성 완료 처리
                    }
                  : null,
              child: Text(
                '작성 완료',
                style: TextStyle(
                  color: _isFormValid ? Colors.white : Colors.black54,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                backgroundColor: _isFormValid ? Colors.purple : Colors.grey,
                minimumSize: Size(double.infinity, 0), // 버튼의 너비를 최대로 설정
              ),
            ),
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}
