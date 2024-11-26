import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nomad_market/Pages/Chatting/Widgets/chattingPage.dart';
import 'package:flutter_nomad_market/Pages/Chatting/Widgets/chattingPage.dart';
import 'package:flutter_nomad_market/Pages/Widgets/commonWidgets.dart';
import 'package:flutter_nomad_market/utils/json_utils.dart';

class ChattingListPage extends StatefulWidget {
  @override
  _ChattingListPageState createState() => _ChattingListPageState();
}

class _ChattingListPageState extends State<ChattingListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;
  List<dynamic> chatList = []; // 채팅 목록을 저장할 리스트
  String userId = "user000001"; // 기본값 설정
  String nickname = "우수"; // 기본값 설정
  Map<String, String> _thumbnailCache = {}; // 썸네일 이미지를 캐시하기 위한 맵
  String _selectedFilter = '전체';
  List filteredChatList = [];
  Map<String, String> userNicknames = {};
  Future<void> _loadUserNicknames() async {
    final String response =
        await rootBundle.loadString('assets/json/userInfo.json');
    final userData = json.decode(response)['userInfo'];
    for (var user in userData) {
      userNicknames[user['userId']] = user['nickname'];
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _initializeData();
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    }
  }

  // 데이터 초기화를 위한 함수
  Future<void> _initializeData() async {
    try {
      setState(() {
        userId = "user000001"; // 정확한 사용자 ID로 설정
        nickname = "우수"; // 사용자단 발표때는 고정값으로 설정
      });
      await _loadUserNicknames(); // 사용자 닉네임 로드
      await _loadChatData();
      await _preloadThumbnails();
      setState(() {
        filteredChatList = chatList; // 데이터 로딩 완료 후 filteredChatList 초기화
      });
    } catch (e) {
      print('Error initializing data: $e');
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  // 사용자 데이터를 로드하는 함수 (발표때는 사용하지 않음)
  Future<void> _loadUserData() async {
    final String response =
        await rootBundle.loadString('assets/json/userInfo.json');
    final userData = json.decode(response)['userInfo'];
    final currentUser = userData.firstWhere(
      (user) => user['nickname'] == nickname,
      orElse: () => {"userId": "user000001", "nickname": "우수"},
    );
    setState(() {
      userId = currentUser['userId'];
      nickname = currentUser['nickname'];
    });
  }

  Future<void> _loadChatData() async {
    final String response =
        await rootBundle.loadString('assets/json/chattingInfo.json');
    final allChattingInfo = json.decode(response)['chattingInfo'];
    setState(() {
      chatList = allChattingInfo
          .where(
              (chat) => chat['sellerId'] == userId || chat['buyerId'] == userId)
          .toList();
      filteredChatList =
          chatList; // _loadChatData() 함수에서 filteredChatList도 함께 업데이트
    });
  }

  // 썸네일을 미리 로드하는 새로운 함수
  Future<void> _preloadThumbnails() async {
    final String response =
        await rootBundle.loadString('assets/json/productInfo.json');
    final productData = json.decode(response)['productInfo'];
    for (var chat in chatList) {
      final product = productData.firstWhere(
        (product) => product['postId'] == chat['postId'],
        orElse: () => null,
      );
      if (product != null) {
        _thumbnailCache[chat['postId']] = product['thumbnailImage'];
      }
    }
  }

  // 하단 패널을 표시하는 함수
  void showBottomPanel(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true, // 전체 화면 높이 사용
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
            initialChildSize: 0.3, // 초기 높이 (화면의 30%)
            minChildSize: 0.2, // 최소 높이
            maxChildSize: 0.75, // 최대 높이
            builder: (_, controller) {
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
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('채팅'),
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
          if (_currentTabIndex == 0) _buildFilterButtons(),
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

  Widget _buildFilterButtons() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(width: 8),
          _buildFilterButton('전체'),
          SizedBox(width: 8),
          _buildFilterButton('판매'),
          SizedBox(width: 8),
          _buildFilterButton('구매'),
          SizedBox(width: 8),
          _buildFilterButton('안 읽은 채팅방'),
          SizedBox(width: 8),
        ],
      ),
    );
  }

  // 필터 버튼을 구축하는 위젯
  Widget _buildFilterButton(String text) {
    bool isSelected = _selectedFilter == text;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedFilter = text;
        });
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: isSelected ? Colors.white : null,
        backgroundColor: isSelected ? Colors.purple : null,
      ),
      child: Text(text),
    );
  }

  List<dynamic> _getFilteredChatList() {
    switch (_selectedFilter) {
      case '전체':
        return chatList;
      case '판매':
        return chatList
            .where((chat) => chat['sellerId'] == 'user000001')
            .toList();
      case '구매':
        return chatList
            .where((chat) => chat['buyerId'] == 'user000001')
            .toList();
      case '안 읽은 채팅방':
        return []; // 실제 로직으로 대체해야 함
      default:
        return chatList;
    }
  }

  // 메시지 목록을 구축하는 위젯
  Widget _buildMessagesList() {
    final filteredList = _getFilteredChatList();
    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final chat = filteredList[index];
        final lastMessage = chat['messages'].last;
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChattingPage(
                  chatId: chat['chatId'],
                  postId: chat['postId'],
                  sellerId: chat['sellerId'],
                  buyerId: chat['buyerId'],
                  productTitle: chat['productTitle'] ?? '', // 실제 상품명 전달
                  productImage: _thumbnailCache[chat['postId']] ??
                      'assets/default_thumbnail.png',
                  price: chat['price'] ?? '', // 실제 가격 전달
                ),
              ),
            );
          },
          child: Container(
            height: 80,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  child: ClipOval(
                    child: Image.asset(
                      _thumbnailCache[chat['postId']] ??
                          'assets/default_thumbnail.png',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        chat['buyerId'] == userId
                            ? userNicknames[chat['sellerId']] ??
                                chat['sellerId']
                            : userNicknames[chat['buyerId']] ?? chat['buyerId'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(height: 4),
                      Text(
                        lastMessage['content'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_formatTimestamp(lastMessage['timestamp'])),
                  ],
                ),
              ],
            ),
          ),
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

  // 타임스탬프를 포맷팅하는 함수
  String _formatTimestamp(String timestamp) {
    // UTC 시간을 한국 시간으로 변환
    final dateTime = DateTime.parse(timestamp).toLocal();
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    // 오늘 날짜인 경우
    if (now.year == dateTime.year &&
        now.month == dateTime.month &&
        now.day == dateTime.day) {
      if (difference.inHours > 0) {
        return '${difference.inHours}시간 전';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}분 전';
      } else {
        return '방금 전';
      }
    }
    // 어제 날짜인 경우
    else if (difference.inDays == 1) {
      return '어제';
    }
    // 최근 7일 이내인 경우
    else if (difference.inDays > 0 && difference.inDays <= 7) {
      return '${difference.inDays}일 전';
    }
    // 7일 이상 지난 경우 실제 날짜 표시
    else {
      return '${dateTime.year}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.day.toString().padLeft(2, '0')}';
    }
  }
}
