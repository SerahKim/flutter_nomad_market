// salesHistory.dart
import 'package:flutter/material.dart';
import 'package:flutter_nomad_market/utils/json_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SalesHistoryPage extends StatefulWidget {
  @override
  _SalesHistoryPageState createState() => _SalesHistoryPageState();
}

class _SalesHistoryPageState extends State<SalesHistoryPage> {
  late Future<List<dynamic>> sellingItemsFuture;
  late Future<List<dynamic>> soldItemsFuture;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId') ?? 'user000001';
    sellingItemsFuture = getPostsForUser(userId, 'selling');
    soldItemsFuture = getPostsForUser(userId, 'sold');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('나의 판매내역'),
          bottom: TabBar(
            tabs: [
              Tab(text: '판매중'),
              Tab(text: '거래완료'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // 판매중 탭
            FutureBuilder<List<dynamic>>(
              future: sellingItemsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No items available'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) =>
                        buildSalesItem(context, snapshot.data![index]),
                  );
                }
              },
            ),
            // 거래완료 탭
            FutureBuilder<List<dynamic>>(
              future: soldItemsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No items available'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) =>
                        buildSalesItem(context, snapshot.data![index]),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSalesItem(BuildContext context, dynamic item) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            item['imageUrl'],
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(item['title']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${item['price']}원'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite_border),
            Text('${item['likes']}'),
          ],
        ),
      ),
    );
  }
}
