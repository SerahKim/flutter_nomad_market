import 'package:flutter/material.dart';
import 'package:flutter_nomad_market/Pages/Widgets/commonWidgets.dart';

class ChattingListPage extends StatefulWidget {
  @override
  _ChattingListPageState createState() => _ChattingListPageState();
}

class _ChattingListPageState extends State<ChattingListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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

  Widget _buildMessagesList() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            // 채팅방으로 이동하는 로직
          },
          child: Container(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage('https://placeholder.com/150'),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '사용자 아이디',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '2분 전',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '대한민국',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '마지막 메시지 내용입니다...',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNotificationsList() {
    return Center(
      child: Text('알림 목록'),
    );
  }
}
