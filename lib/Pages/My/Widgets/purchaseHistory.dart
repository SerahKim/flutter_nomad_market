// purchaseHistory.dart
import 'package:flutter/material.dart';

class PurchaseHistoryPage extends StatelessWidget {
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
      body: ListView.builder(
        itemCount: purchaseItems.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  purchaseItems[index].imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(purchaseItems[index].title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('거래완료'),
                  Text(
                    '${purchaseItems[index].price}원',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.favorite_border),
                  Text('${purchaseItems[index].likes}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
