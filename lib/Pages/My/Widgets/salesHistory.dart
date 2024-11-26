import 'package:flutter/material.dart';
import 'package:flutter_nomad_market/utils/json_utils.dart';

class SalesHistoryPage extends StatefulWidget {
  @override
  _SalesHistoryPageState createState() => _SalesHistoryPageState();
}

class _SalesHistoryPageState extends State<SalesHistoryPage> {
  List<dynamic> sellingItems = [];
  List<dynamic> soldItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadItems();
  }

  Future<void> loadItems() async {
    final currentUserId = await getCurrentUserId();
    if (currentUserId != null) {
      final selling = await loadSellingItems(currentUserId);
      final sold = await loadSoldItems(currentUserId);
      setState(() {
        sellingItems = selling;
        soldItems = sold;
        isLoading = false;
      });
    }
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
              Tab(text: '판매중 ${sellingItems.length}'),
              Tab(text: '거래완료 ${soldItems.length}'),
            ],
          ),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  // 판매중 탭
                  ListView.builder(
                    itemCount: sellingItems.length,
                    itemBuilder: (context, index) =>
                        buildSalesItem(context, index, true),
                  ),
                  // 거래완료 탭
                  ListView.builder(
                    itemCount: soldItems.length,
                    itemBuilder: (context, index) =>
                        buildSalesItem(context, index, false),
                  ),
                ],
              ),
      ),
    );
  }

  Widget buildSalesItem(BuildContext context, int index, bool isSelling) {
    final item = isSelling ? sellingItems[index] : soldItems[index];
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
            Text('${item['likes'] ?? 0}'),
          ],
        ),
      ),
    );
  }
}
