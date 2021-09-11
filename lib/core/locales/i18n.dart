import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class I18n {
  I18n(this.locale);

  final String _baseUri = 'assets/locales/';
  final Locale locale;

  static I18n of(BuildContext context) => Localizations.of<I18n>(context, I18n);

  static const LocalizationsDelegate<I18n> delegate =
      _AppLocalizationsDelegate();

  Map<String, String> _resources;

  // Load file json vào bộ nhớ
  Future<bool> load() async {
    // Đọc file json dưới dạng chuỗi
    final jsonString =
        await rootBundle.loadString('$_baseUri${locale.languageCode}.json');
    // Giải mã file json sang Map
    final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
    // Sau đó dùng hàm map() để đưa Map<String, dynamic> về Map<String, String>
    // và gán cho biến _resources
    _resources = jsonMap.map((String key, dynamic value) =>
        MapEntry<String, String>(key, value.toString()));
    return true;
  }

  // Đoạn này đơn giản chỉ là lấy giá trị đang
  // được lưu tại cái key được truyền vào
  String translate(String key) => _resources[key];
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<I18n> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => <String>['en', 'vi'].contains(
      locale.languageCode); // Add all language ứng dụng của bạn hỗ trợ tại đây

  @override
  Future<I18n> load(Locale locale) async {
    // Gọi hàm load json được định nghĩa trong class bên trên
    final I18n localizations = I18n(locale);
    // Đợi load xong mới return về giá trị
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(LocalizationsDelegate<I18n> old) => false;
}
