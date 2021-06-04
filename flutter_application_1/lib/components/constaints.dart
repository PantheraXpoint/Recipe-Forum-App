import 'package:flutter/cupertino.dart';

const String BASE_URL = "127.0.0.1:4996";

const Color kPrimaryColor = Color(0x66CA8383);
const Color kSecondaryColor = Color(0xFF6B0000);
const Color kText = Color(0xFFA60000);
const Color kSecondaryText = Color(0xB3B3B3B3);
const Color kUnhighlightedColor = Color(0xFFE0E0E0);
const Color kDarkBackgroundCard = Color(0xFF2D2E2D);

enum recipeDifficulty { BEGINNER, INTERMEDIATE, ADVANCE, MASTER }

String recipeDiffiCultyMap(recipeDifficulty difficulty) {
  switch (difficulty) {
    case recipeDifficulty.BEGINNER:
      return "Căn bản";
    case recipeDifficulty.INTERMEDIATE:
      return "trung cấp";
    case recipeDifficulty.ADVANCE:
      return "Cao cấp";
    case recipeDifficulty.MASTER:
      return "Thượng hạng";
  }
}
