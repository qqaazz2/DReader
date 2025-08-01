import 'dart:convert';

class ServerConfig {
  String baseUrl;
  String qbUrl;
  String embyUrl;

  ServerConfig({
    this.baseUrl = '',
    this.qbUrl = '',
    this.embyUrl = '',
  });

  // 将 ServerConfig 对象转换为 JSON 字符串
  String toJson() {
    return json.encode({
      'baseUrl': baseUrl,
      'qbUrl': qbUrl,
      'embyUrl': embyUrl,
    });
  }

  // 从 JSON 字符串创建 ServerConfig 对象
  factory ServerConfig.fromJson(String jsonString) {
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    return ServerConfig(
      baseUrl: jsonMap['baseUrl'],
      qbUrl: jsonMap['qbUrl'],
      embyUrl: jsonMap['embyUrl'],
    );
  }

  // copyWith 方法
  ServerConfig copyWith({
    String? baseUrl,
    String? qbUrl,
    String? embyUrl,
    String? apiKey,
  }) {
    return ServerConfig(
      baseUrl: baseUrl ?? this.baseUrl,
      qbUrl: qbUrl ?? this.qbUrl,
      embyUrl: embyUrl ?? this.embyUrl,
    );
  }
}