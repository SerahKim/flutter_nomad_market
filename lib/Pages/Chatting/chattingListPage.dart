import 'package:flutter/material.dart';
import 'package:flutter_nomad_market/Pages/Chatting/Widgets/chattinPage.dart';
import 'package:flutter_nomad_market/Pages/Widgets/commonWidgets.dart';
import 'package:flutter_nomad_market/utils/json_utils.dart';

class ChattingListPage extends StatefulWidget {
  @override
  _ChattingListPageState createState() => _ChattingListPageState();
}

class _ChattingListPageState extends State<ChattingListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> chatList = []; // 채팅 목록을 저장할 리스트
  String userId = "user000001"; // 기본값 설정
  String nickname = "우수"; // 기본값 설정

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadUserData(); // 사용자 데이터 로드
    _loadChatData(); // 채팅 데이터 로드
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // 사용자 데이터를 로드하는 함수
  Future<void> _loadUserData() async {
    final userData =
        await loadJsonData('assets/json/userInfo.json', 'userInfo');
    final currentUser = userData.firstWhere(
      (user) => user['nickname'] == nickname,
      orElse: () => {"userId": "user000001", "nickname": "우수"},
    );
    setState(() {
      userId = currentUser['userId'];
      nickname = currentUser['nickname'];
    });
  }

  // 채팅 데이터를 JSON 파일에서 로드하는 함수
  Future<void> _loadChatData() async {
    final allChatData =
        await loadJsonData('assets/json/chattingInfo.json', 'chattingInfo');
    final userData =
        await loadJsonData('assets/json/userInfo.json', 'userInfo');
    final currentUser = userData.firstWhere(
      (user) => user['userId'] == userId,
      orElse: () => {"chatRooms": []},
    );
    final userChatRooms = currentUser['chatRooms'] as List<dynamic>;

    setState(() {
      chatList = allChatData
          .where((chat) => userChatRooms.contains(chat['chatId']))
          .toList();
    });
  }

  // 하단 패널을 표시하는 함수
  void showBottomPanel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.all_inbox),
                title: Text('전체'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: Icon(Icons.sell),
                title: Text('판매'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: Icon(Icons.shopping_bag),
                title: Text('구매'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: Icon(Icons.mark_email_unread),
                title: Text('안 읽은 채팅방'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: '메시지'),
            Tab(text: '알림'),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildFilterButtons(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMessagesList(),
                _buildNotificationsList(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CommonBottomWidget(),
    );
  }

  // 필터 버튼을 구축하는 위젯
  Widget _buildFilterButtons() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => showBottomPanel(context),
            child: Text('전체'),
          ),
          SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {},
            child: Text('판매'),
          ),
          SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {},
            child: Text('구매'),
          ),
          SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {},
            child: Text('안 읽은 채팅방'),
          ),
          SizedBox(width: 8),
        ],
      ),
    );
  }

  // 메시지 목록을 구축하는 위젯
  Widget _buildMessagesList() {
    return ListView.builder(
      itemCount: chatList.length,
      itemBuilder: (context, index) {
        final chat = chatList[index];
        final lastMessage = chat['messages'].last;
        return FutureBuilder(
          future: _getProductThumbnail(chat['postId']),
          builder: (context, snapshot) {
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: snapshot.data != null
                    ? AssetImage(snapshot.data as String)
                    : NetworkImage('https://placeholder.com/150')
                        as ImageProvider,
              ),
              title: Text(chat['buyerId'] == userId
                  ? chat['sellerId']
                  : chat['buyerId']),
              subtitle: Text(lastMessage['content']),
              trailing: Text(_formatTimestamp(lastMessage['timestamp'])),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChattingPage(
                      chatId: chat['chatId'],
                      postId: chat['postId'],
                      sellerId: chat['sellerId'],
                      buyerId: chat['buyerId'],
                      productTitle: '상품명', // productInfo에서 가져오기
                      productImage: '상품이미지경로', // productInfo에서 가져오기
                      price: '가격', // productInfo에서 가져오기
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  // 알림 목록을 구축하는 위젯 (현재는 더미 데이터)
  Widget _buildNotificationsList() {
    return Center(
      child: Text('알림 목록'),
    );
  }

  // 상품 썸네일 이미지를 가져오는 함수
  Future<String?> _getProductThumbnail(String postId) async {
    final productData =
        await loadJsonData('assets/json/productInfo.json', 'productInfo');
    final product = productData.firstWhere(
      (product) => product['postId'] == postId,
      orElse: () => null,
    );
    return product != null ? product['thumbnailImage'] : null;
  }

  // 타임스탬프를 포맷팅하는 함수
  String _formatTimestamp(String timestamp) {
    final dateTime = DateTime.parse(timestamp);
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}일 전';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}시간 전';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}분 전';
    } else {
      return '방금 전';
    }
  }
}
