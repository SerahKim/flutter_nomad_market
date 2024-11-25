import 'package:flutter/material.dart';
import 'package:flutter_nomad_market/utils/json_utils.dart';

class ChattingPage extends StatefulWidget {
  final String chatId;
  final String postId;
  final String sellerId;
  final String buyerId;
  final String productTitle;
  final String productImage;
  final String price;

  ChattingPage({
    required this.chatId,
    required this.postId,
    required this.sellerId,
    required this.buyerId,
    required this.productTitle,
    required this.productImage,
    required this.price,
  });

  @override
  _ChattingPageState createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  final TextEditingController _messageController = TextEditingController();
  List<dynamic> messages = [];

  @override
  void initState() {
    super.initState();
    _loadChatMessages();
  }

  // 채팅 메시지 로드
  Future<void> _loadChatMessages() async {
    final chatData =
        await loadJsonData('assets/json/chattingInfo.json', 'chattingInfo');
    final currentChat =
        chatData.firstWhere((chat) => chat['chatId'] == widget.chatId);
    setState(() {
      messages = currentChat['messages'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('푸르지오 (평점)', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          // 상품 정보 섹션
          _buildProductInfo(),
          // 경고 메시지
          _buildWarningMessage(),
          // 채팅 메시지 목록
          Expanded(
            child: _buildMessageList(),
          ),
          // 메시지 입력 섹션
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildProductInfo() {
    return Container(
      padding: EdgeInsets.all(12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              widget.productImage,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.productTitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.price,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningMessage() {
    return Container(
      padding: EdgeInsets.all(16),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            color: Colors.purple,
            size: 48,
          ),
          SizedBox(height: 8),
          Text(
            '만약 상대방이 외부 메신저로 유도하는 경우,\n피해가 있을 수 있으니 주의하세요!',
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isMe = message['senderId'] == widget.buyerId;

        return _buildMessageBubble(message, isMe);
      },
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? Colors.purple : Colors.grey[800],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message['content'],
              style: TextStyle(color: Colors.white),
            ),
            Text(
              _formatTimestamp(message['timestamp']),
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(8),
      color: Colors.grey[900],
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: '메시지 보내기',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                filled: true,
                fillColor: Colors.grey[800],
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.sentiment_satisfied_alt, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.send, color: Colors.purple),
            onPressed: () {
              // 메시지 전송 로직 구현
            },
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(String timestamp) {
    final dateTime = DateTime.parse(timestamp);
    return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
