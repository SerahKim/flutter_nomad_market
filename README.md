![Nomad Market 로고](assets/images/logo_images/nomadmarketlogo4_3.png)
<img src="assets/images/logo_images/nomadmarketlogo4_3.png" width="300", height="200">

# Flutter Nomad Market

Flutter로 개발된 글로벌 중고거래 플랫폼 앱입니다. 사용자가 쉽게 상품을 등록하고, 채팅을 통해 거래를 진행할 수 있도록 설계되었습니다. 로컬 및 글로벌 사용자를 위한 다국어 지원과 위치 기반 서비스를 제공합니다.

## 프로그램 실행 방법

1. git 프로젝트 클론

   ```
   git clone https://github.com/SerahKim/flutter_nomad_market.git
   ```

2. main.dart에서 run 실행
   ```
   code ./lib/main.dart
   ```

---

## 주요 기능

- **사용자 인증:** 닉네임 설정
- **다국어 지원:** LocaleSetting을 통해 언어 변경 가능
- **중고 상품 관리:** 상품 등록 및 조회
- **실시간 채팅:** 구매자와 판매자 간 채팅 가능
- **사용자 프로필:** 프로필 정보 및 위치 관리

---

## 앱 구조 및 파일 구조

- **loginPage.dart:** 시작 페이지

  - localeSetting.dart: 언어, 국가, 통화, 닉네임 설정 페이지

- **homePage.dart:** 메인 화면

  - productList.dart: 상품 조회 페이지
  - dropdownButton.dart: 상품 필터링 페이지
  - writingPage.dart: 상품 등록 페이지

- **descriptionPage.dart:** 상품 상세 페이지

- **chattingInfo.json:** 채팅 정보 관리

  - chattingListPage.dart: 채팅 리스트 페이지
  - chattingPage.dart: 채팅 상세 기록 페이지

- **myPage.dart:** 마이페이지
  - profilePage.dart: 프로필 수정 페이지
  - purchaseHistory.dart: 구매 내역(구현 예정)
  - salesHistory.dart: 판매 내역(구현 예정)
  - wishlist.dart : 관심목록(구현 예정)

---

## json 파일

- **userInfo.json:** 사용자 정보 데이터

  - 닉네임, 이미지, 선호 언어 및 지역, 포스팅 내역, 채팅 내역, 관심 목록

- **productInfo.json:** 상품 정보 데이터

  - 상품 제목, 가격, 등록된 위치, 이미지

- **chattingInfo.json:** 채팅 내역 데이터

---

## 사용된 주요 언어

- 프로그래밍 언어: Dart
- 프레임워크: Flutter
- 데이터 관리: JSON 파일 기반
- 디자인: Marterial Design

---

## 기여자

- 김시은 : https://github.com/SerahKim
- 장우수 : https://github.com/oosuhada
- 이승준 : https://github.com/wd247
