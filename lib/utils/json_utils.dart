import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

Future<List<dynamic>> loadJsonData(String path, name) async {
  loadJsonData(path, name);
  final String response = await rootBundle.loadString(path);
  final data = json.decode(response);
  return data[name];
}

Future<Map<String, dynamic>> loadUserData() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/users.json');
  if (await file.exists()) {
    String contents = await file.readAsString();
    return json.decode(contents);
  }
  return {"users": []};
}

Future<void> saveUserData(Map<String, dynamic> userData) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/users.json');
  await file.writeAsString(json.encode(userData));
}

String generateUserId(List<dynamic> users) {
  int maxId = users.isEmpty
      ? 0
      : users
          .map((user) => int.parse(user['userId'].substring(4)))
          .reduce((a, b) => a > b ? a : b);
  return 'user${(maxId + 1).toString().padLeft(6, '0')}';
}

// Future<List<dynamic>> getPostsForUser(String userId, String postType) async {
//   final usersData = await loadJsonData('assets/data/users.json');
//   final postsData = await loadJsonData('assets/data/posts.json');

//   final user =
//       usersData['users'].firstWhere((user) => user['userId'] == userId);
//   final postIds = user['posts'][postType];

//   return postIds
//       .map((postId) =>
//           postsData['posts'].firstWhere((post) => post['postId'] == postId))
//       .toList();
// }

// Future<void> addNewUser(String nickname, String profileImagePath) async {
//   final userData = await loadUserData();
//   final users = userData['users'] as List<dynamic>;

//   final newUserId = generateUserId(users);
//   users.add({
//     "userId": newUserId,
//     "nickname": nickname,
//     "profileImage": profileImagePath,
//     "preferences": {"country": "서울, 대한민국", "language": "한국어"},
//     "posts": {"selling": [], "sold": [], "purchased": []},
//     "wishlist": [],
//     "chatRooms": [],
//     "rating": 0.0,
//     "joinDate": DateTime.now().toIso8601String(),
//     "lastActive": DateTime.now().toIso8601String()
//   });

//   await saveUserData(userData);
// }

// //게시물 데이터 저장 함수
// Future<void> savePostData(Map<String, dynamic> postData) async {
//   final directory = await getApplicationDocumentsDirectory();
//   final file = File('${directory.path}/posts.json');
//   await file.writeAsString(json.encode(postData));
// }

// //특정 게시물 가져오기 함수
// Future<Map<String, dynamic>?> getPostById(String postId) async {
//   final postsData = await loadJsonData('assets/data/posts.json');
//   var post = postsData['posts']
//       .firstWhere((post) => post['postId'] == postId, orElse: () => null);

//   if (post != null && post['images'] != null) {
//     post['images'] = (post['images'] as List).map((imagePath) {
//       return normalizeImagePath(imagePath);
//     }).toList();
//   }

//   return post;
// }

// //사용자 정보 업데이트 함수
// Future<void> updateUserInfo(
//     String userId, Map<String, dynamic> updatedInfo) async {
//   final userData = await loadUserData();
//   final users = userData['users'] as List<dynamic>;
//   final userIndex = users.indexWhere((user) => user['userId'] == userId);

//   if (userIndex != -1) {
//     users[userIndex] = {...users[userIndex], ...updatedInfo};
//     await saveUserData(userData);
//   }
// }

// //새 게시물 추가 함수
// Future<void> addNewPost(String userId, Map<String, dynamic> postData) async {
//   // 이미지 경로 정규화
//   if (postData['images'] != null) {
//     postData['images'] = (postData['images'] as List).map((imagePath) {
//       return normalizeImagePath(imagePath.toString());
//     }).toList();
//   }

//   final userData = await loadUserData();
//   final users = userData['users'] as List<dynamic>;
//   final userIndex = users.indexWhere((user) => user['userId'] == userId);

//   if (userIndex != -1) {
//     // 기존의 selling 목록에 새 postId 추가
//     users[userIndex]['posts']['selling'].add(postData['postId']);
//     await saveUserData(userData);

//     // posts.json에 새 게시물 추가
//     final postsData = await loadJsonData('assets/data/posts.json');
//     postsData['posts'].add(postData);
//     await savePostData(postsData);
//   }
// }

// // 이미지 경로 정규화를 위한 헬퍼 함수 추가
// String normalizeImagePath(String path) {
//   // 기존 경로에서 파일명만 추출
//   String fileName = path.split('/').last;
//   // 새로운 경로로 조합
//   return 'assets/data/posts_images/$fileName';
// }

// //게시물 상태 변경 함수
// Future<void> changePostStatus(
//     String userId, String postId, String newStatus) async {
//   final userData = await loadUserData();
//   final users = userData['users'] as List<dynamic>;
//   final userIndex = users.indexWhere((user) => user['userId'] == userId);

//   if (userIndex != -1) {
//     final user = users[userIndex];
//     user['posts']['selling'].remove(postId);
//     user['posts'][newStatus].add(postId);
//     await saveUserData(userData);

//     final postsData = await loadJsonData('assets/data/posts.json');
//     final postIndex =
//         postsData['posts'].indexWhere((post) => post['postId'] == postId);
//     if (postIndex != -1) {
//       postsData['posts'][postIndex]['status'] = newStatus;
//       await savePostData(postsData);
//     }
//   }
// }

// // 사용자의 구매 항목 가져오기
// Future<List<dynamic>> getPurchasedItems(String userId) async {
//   return getPostsForUser(userId, 'purchased');
// }

// // 사용자의 판매중인 항목 가져오기
// Future<List<dynamic>> getSellingItems(String userId) async {
//   return getPostsForUser(userId, 'selling');
// }

// // 사용자의 판매 완료 항목 가져오기
// Future<List<dynamic>> getSoldItems(String userId) async {
//   return getPostsForUser(userId, 'sold');
// }

// // 사용자의 구매 항목 추가하기
// Future<void> addPurchasedItem(String userId, String postId) async {
//   await _addItemToUserPosts(userId, postId, 'purchased');
// }

// // 사용자의 판매중인 항목 추가하기
// Future<void> addSellingItem(String userId, String postId) async {
//   await _addItemToUserPosts(userId, postId, 'selling');
// }

// // 사용자의 판매 완료 항목 추가하기
// Future<void> addSoldItem(String userId, String postId) async {
//   await _addItemToUserPosts(userId, postId, 'sold');
// }

// // 사용자의 게시물에 항목을 추가하는 헬퍼 함수
// Future<void> _addItemToUserPosts(
//     String userId, String postId, String postType) async {
//   final userData = await loadUserData();
//   final users = userData['users'] as List<dynamic>;
//   final userIndex = users.indexWhere((user) => user['userId'] == userId);

//   if (userIndex != -1) {
//     users[userIndex]['posts'][postType].add(postId);
//     await saveUserData(userData);
//   }
// }

// // 사용자의 게시물에서 항목 제거하기
// Future<void> removeItemFromUserPosts(
//     String userId, String postId, String postType) async {
//   final userData = await loadUserData();
//   final users = userData['users'] as List<dynamic>;
//   final userIndex = users.indexWhere((user) => user['userId'] == userId);

//   if (userIndex != -1) {
//     users[userIndex]['posts'][postType].remove(postId);
//     await saveUserData(userData);
//   }
// }

// // 항목을 한 게시물 유형에서 다른 유형으로 이동하기 (예: 판매중에서 판매완료로)
// Future<void> moveItemBetweenPostTypes(
//     String userId, String postId, String fromType, String toType) async {
//   await removeItemFromUserPosts(userId, postId, fromType);
//   await _addItemToUserPosts(userId, postId, toType);
// }
