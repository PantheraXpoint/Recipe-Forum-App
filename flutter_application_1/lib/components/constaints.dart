import 'package:flutter/cupertino.dart';

const String BASE_URL = "127.0.0.1:4996";

const Color kPrimaryColor = Color(0x66CA8383);
const Color kSecondaryColor = Color(0xFF6B0000);
const Color kText = Color(0xFFA60000);
const Color kSecondaryText = Color(0xB3B3B3B3);
const Color kUnhighlightedColor = Color(0xFFE0E0E0);
const Color kDarkBackgroundCard = Color(0xFF2D2E2D);

const List<String> types = [
  'Khai vị',
  'Tráng miệng',
  'Món chay',
  'Món chính',
  'Món ăn sáng',
  'Nhanh và dễ',
  'Thức uống',
  'Bánh ngọt',
  'Món ăn cho trẻ',
  'Món nhậu'
];

const Map<String, int> typesToInt = {
  'Khai vị': 1,
  'Tráng miệng': 2,
  'Món chay': 3,
  'Món chính': 4,
  'Món ăn sáng': 5,
  'Nhanh và dễ': 6,
  'Thức uống': 7,
  'Bánh ngọt': 8,
  'Món ăn cho trẻ': 9,
  'Món nhậu': 10
};
