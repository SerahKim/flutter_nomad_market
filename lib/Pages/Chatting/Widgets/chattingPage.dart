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
  final bool isDarkMode;
  ChattingPage({
    required this.chatId,
    required this.postId,
    required this.sellerId,
    required this.buyerId,
    required this.productTitle,
    required this.productImage,
    required this.price,
    this.isDarkMode = false,
  });
  @override
  _ChattingPageState createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  final TextEditingController _messageController = TextEditingController();
  List messages = [];
  String productTitle = '';
  String price = '';
  @override
  void initState() {
    super.initState();
    _loadChatMessages();
    _loadProductInfo();
  }

  Future _loadChatMessages() async {
    final chatData =
        await loadJsonData('assets/json/chattingInfo.json', 'chattingInfo');
    final currentChat =
        chatData.firstWhere((chat) => chat['chatId'] == widget.chatId);
    setState(() {
      messages = currentChat['messages'];
    });
  }

  Future<void> _loadProductInfo() async {
    final productData =
        await loadJsonData('assets/json/productInfo.json', 'productInfo');
    final product = productData.firstWhere((p) => p['postId'] == widget.postId,
        orElse: () => null);
    if (product != null) {
      setState(() {
        productTitle = product['title'];
        price = product['priceWon'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final purpleTheme = ThemeData(
      primaryColor: Colors.purple,
      primaryColorLight: Colors.purple[100],
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(color: Colors.white),
        bodyLarge: TextStyle(color: Colors.black),
        bodySmall: TextStyle(color: Colors.grey[600]),
      ),
      iconTheme: IconThemeData(color: Colors.white),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: Colors.purple[50],
      ),
    );
    return Theme(
      data: purpleTheme,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(widget.productTitle),
        ),
        body: Column(
          children: [
            _buildProductInfo(purpleTheme),
            _buildWarningMessage(purpleTheme),
            Expanded(
              child: _buildMessageList(purpleTheme),
            ),
            _buildMessageInput(purpleTheme),
          ],
        ),
      ),
    );
  }

  Widget _buildProductInfo(ThemeData theme) {
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
                    color: theme.textTheme.bodyLarge?.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.price,
                  style: TextStyle(color: theme.textTheme.bodySmall?.color),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningMessage(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(16),
      alignment: Alignment.center,
      child: Text(
        '만약 상대방이 외부 메신저로 유도하는 경우,\n피해가 있을 수 있으니 주의하세요!',
        style: TextStyle(
          color: Colors.grey[500], // Light gray color as requested
          fontSize: 12,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildMessageList(ThemeData theme) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isMe = message['senderId'] == widget.buyerId;
        return _buildMessageBubble(message, isMe, theme);
      },
    );
  }

  Widget _buildMessageBubble(Map message, bool isMe, ThemeData theme) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? Colors.purple : Colors.purple[100],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message['content'],
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black,
              ),
            ),
            Text(
              _formatTimestamp(message['timestamp']),
              style: TextStyle(
                color: isMe ? Colors.white70 : Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(8),
      color: Colors.purple[50],
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.purple),
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: '메시지 보내기',
                hintStyle: TextStyle(color: Colors.grey[600]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.sentiment_satisfied_alt, color: Colors.purple),
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
