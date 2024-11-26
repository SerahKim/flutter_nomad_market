import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// JSON 파일에서 데이터를 로드하는 함수
Future<List<dynamic>> loadJsonData(String path, name) async {
  final String response = await rootBundle.loadString(path);
  final data = json.decode(response);
  return data[name];
}

// 사용자 정보를 로드하는 함수
Future<Map<String, dynamic>> loadUserData() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/userInfo.json');
  if (await file.exists()) {
    String contents = await file.readAsString();
    return json.decode(contents);
  }
  return {"userInfo": []};
}

// 사용자 정보를 저장하는 함수
Future<void> saveUserData(Map<String, dynamic> userData) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/userInfo.json');
  await file.writeAsString(json.encode(userData));
}

// 새로운 사용자 ID를 생성하는 함수
String generateUserId(List<dynamic> users) {
  int maxId = users.isEmpty
      ? 0
      : users
          .map((user) => int.parse(user['userId'].substring(4)))
          .reduce((a, b) => a > b ? a : b);
  return 'user${(maxId + 1).toString().padLeft(6, '0')}';
}

// 특정 사용자의 게시물을 가져오는 함수
Future<List<dynamic>> getPostsForUser(String userId, String postType) async {
  final usersData = await loadJsonData('assets/data/userInfo.json', "userInfo");
  final postsData =
      await loadJsonData('assets/data/productInfo.json', "productInfo");

  final user = usersData.firstWhere((user) => user['userId'] == userId);
  final postIds = user['posts'][postType];

  return postIds
      .map((postId) => postsData.firstWhere((post) => post['postId'] == postId))
      .toList();
}

// 새로운 사용자를 추가하는 함수
Future<void> addNewUser(String nickname, String profileImagePath) async {
  final userData = await loadUserData();
  final users = userData['users'] as List<dynamic>;

  final newUserId = generateUserId(users);
  users.add({
    "userId": newUserId,
    "nickname": nickname,
    "profileImage": profileImagePath,
    "city": {
      "homeCity": "서울, 대한민국",
      "selectedCity": "서울, 대한민국",
      "language": "한국어"
    },
    "posts": {"selling": [], "sold": [], "purchased": []},
    "wishlist": [],
    "chatRooms": [],
    "rating": 0.0,
    "joinDate": DateTime.now().toIso8601String(),
    "lastActive": DateTime.now().toIso8601String()
  });

  await saveUserData(userData);
}

// 닉네임으로 userId를 조회하는 함수
Future<String?> getUserIdByNickname(String nickname) async {
  final userData = await loadUserData();
  final user = userData['users']
      .firstWhere((user) => user['nickname'] == nickname, orElse: () => null);
  return user?['userId'];
}

// 현재 로그인된 사용자의 ID를 가져오는 함수
Future<String?> getCurrentUserId() async {
  final prefs = await SharedPreferences.getInstance();
  final nickname = prefs.getString('nickname');
  if (nickname != null) {
    return getUserIdByNickname(nickname);
  }
  return null;
}

// 게시물 데이터를 저장하는 함수
Future<void> savePostData(postData) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/productInfo.json');
  await file.writeAsString(json.encode(postData));
}

// 특정 게시물을 ID로 가져오는 함수
Future<Map<String, dynamic>?> getPostById(String postId) async {
  final postsData =
      await loadJsonData('assets/data/productInfo.json', "productInfo");
  var post = postsData.firstWhere((post) => post['postId'] == postId,
      orElse: () => null);

  if (post != null && post['images'] != null) {
    post['images'] = (post['images'] as List).map((imagePath) {
      return normalizeImagePath(imagePath);
    }).toList();
  }

  return post;
}

// 새로운 게시물을 추가하는 함수
Future<void> addNewPost(String userId, Map<String, dynamic> postData) async {
  // 이미지 경로 정규화
  if (postData['images'] != null) {
    postData['images'] = (postData['images'] as List).map((imagePath) {
      return normalizeImagePath(imagePath.toString());
    }).toList();
  }

  final userData = await loadUserData();
  final users = userData['users'] as List<dynamic>;
  final userIndex = users.indexWhere((user) => user['userId'] == userId);

  if (userIndex != -1) {
    // 기존의 selling 목록에 새 postId 추가
    users[userIndex]['posts']['selling'].add(postData['postId']);
    await saveUserData(userData);

    // productInfo.json에 새 게시물 추가
    final postsData =
        await loadJsonData('assets/data/productInfo.json', "productInfo");
    postsData.add(postData);
    await savePostData(postsData);
  }
}

// 판매 중인 아이템 로드
Future<List<dynamic>> loadSellingItems(String userId) async {
  final userData = await loadUserData();
  final user = userData['users'].firstWhere((user) => user['userId'] == userId);
  return getPostsForUser(userId, 'selling');
}

// 판매 완료된 아이템 로드
Future<List<dynamic>> loadSoldItems(String userId) async {
  final userData = await loadUserData();
  final user = userData['users'].firstWhere((user) => user['userId'] == userId);
  return getPostsForUser(userId, 'sold');
}

// 구매한 아이템 로드
Future<List<dynamic>> loadPurchasedItems(String userId) async {
  final userData = await loadUserData();
  final user = userData['users'].firstWhere((user) => user['userId'] == userId);
  return getPostsForUser(userId, 'purchased');
}

// 위시리스트 아이템 로드
Future<List<dynamic>> loadWishlistItems(String userId) async {
  final userData = await loadUserData();
  final user = userData['users'].firstWhere((user) => user['userId'] == userId);
  final wishlistIds = user['wishlist'] ?? [];

  final postsData =
      await loadJsonData('assets/data/productInfo.json', "productInfo");
  return wishlistIds
      .map((postId) => postsData.firstWhere((post) => post['postId'] == postId))
      .toList();
}

// 위시리스트에서 아이템 제거
Future<void> removeFromWishlist(String userId, String postId) async {
  final userData = await loadUserData();
  final users = userData['users'] as List;
  final userIndex = users.indexWhere((user) => user['userId'] == userId);

  if (userIndex != -1) {
    List wishlist = users[userIndex]['wishlist'] as List;
    wishlist.remove(postId);
    await saveUserData(userData);
  }
}

// 이미지 경로 정규화를 위한 헬퍼 함수 추가
String normalizeImagePath(String path) {
  // 기존 경로에서 파일명만 추출
  String fileName = path.split('/').last;
  // 새로운 경로로 조합
  return 'assets/data/posts_images/$fileName';
}

// 채팅 정보를 로드하는 함수 추가
Future<Map<String, dynamic>> loadChattingInfo() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/chattingInfo.json');

  if (await file.exists()) {
    String contents = await file.readAsString();
    return json.decode(contents);
  }

  return {"chatting": []};
}

// 사용자 채팅 정보를 업데이트하는 함수 추가
Future<void> updateChattingInfo(
    String userId, Map<String, dynamic> chatUpdate) async {
  final chattingInfo = await loadChattingInfo();
  final chattingUsers = chattingInfo['chatting'] as List<dynamic>;
  final chatIndex =
      chattingUsers.indexWhere((chatUser) => chatUser['userId'] == userId);

  if (chatIndex != -1) {
    chattingUsers[chatIndex] = {...chattingUsers[chatIndex], ...chatUpdate};
    // Save updated chat info back to the JSON file.
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/chattingInfo.json');
    await file.writeAsString(json.encode(chattingInfo));
  }
}
