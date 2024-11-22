// salesHistory.dart
import 'package:flutter/material.dart';

class SalesHistoryPage extends StatelessWidget {
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
              Tab(text: '판매중 1'),
              Tab(text: '거래완료 5'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // 판매중 탭
            ListView.builder(
              itemCount: sellingItems.length,
              itemBuilder: buildSalesItem,
            ),
            // 거래완료 탭
            ListView.builder(
              itemCount: soldItems.length,
              itemBuilder: buildSalesItem,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSalesItem(BuildContext context, int index) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            sellingItems[index].imageUrl,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(sellingItems[index].title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${sellingItems[index].price}원'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite_border),
            Text('${sellingItems[index].likes}'),
          ],
        ),
      ),
    );
  }
}
