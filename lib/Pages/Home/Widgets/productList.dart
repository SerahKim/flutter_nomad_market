import 'package:flutter/material.dart';

class ProductList extends StatelessWidget {
  final Map product;
  final Function(Map) onTap; // 콜백 함수 추가

  const ProductList(
      {Key? key,
      required this.product,
      required this.onTap // 콜백 함수를 필수 파라미터로 추가
      })
      : super(key: key);

  String getMainImage() {
    return product['images'][0]; // 첫 번째 이미지를 메인 이미지로 사용
  }

  @override
  Widget build(BuildContext context) {
    final String imagePath = getMainImage();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GestureDetector(
        onTap: () => onTap(product),
        child: Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  imagePath,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    print('이미지 로딩 실패: $imagePath - $error');
                    return Image.asset(
                      'assets/system_images/defaultprofile.jpg',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['title'] ?? '제목 없음',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2),
                    Text(
                      product['status'] ?? '상태 없음',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '₩${product['price'] ?? '0'}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.favorite_border,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
