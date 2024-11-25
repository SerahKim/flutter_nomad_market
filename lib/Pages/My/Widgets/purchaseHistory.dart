import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_nomad_market/utils/json_utils.dart';

class PurchaseHistoryPage extends StatefulWidget {
  @override
  _PurchaseHistoryPageState createState() => _PurchaseHistoryPageState();
}

class _PurchaseHistoryPageState extends State<PurchaseHistoryPage> {
  late Future<List<dynamic>> purchasedItemsFuture;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId') ?? 'user000001';
    purchasedItemsFuture = getPostsForUser(userId, 'purchased');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('나의 구매내역'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: purchasedItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('구매 내역이 없습니다.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) =>
                  buildPurchaseItem(context, snapshot.data![index]),
            );
          }
        },
      ),
    );
  }

  Widget buildPurchaseItem(BuildContext context, dynamic item) {
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
            Text('거래완료'),
            Text(
              '${item['price']}원',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
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
