class BookStatus {
  BookStatus._();

  static const Map<int, String> overStatus = {
    1: "连载中",
    2: "完结",
    3: "弃坑",
    4: "有生之年",
  };

  static const Map<int, String> readStatus = {
    1: "未读",
    2: "已读",
    3: "在读",
  };

  static const Map<int, String> loveStatus = {
    1: "未收藏",
    2: "已收藏",
  };

  static String getOverStatus(int? key) => overStatus[key] ?? "未知";
  static String getReadStatus(int? key) => readStatus[key] ?? "未知";
  static String getLoveStatus(int? key) => loveStatus[key] ?? "未知";
}