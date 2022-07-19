// ignore_for_file: avoid_print

import 'package:flutter_project_base/flutter_project_base.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('DIO client test', () async {
    try {
      final httpClient = DioHttpClient(baseUrl: 'https://google.com');
      final response = await httpClient.get(Uri.parse('/'));
      print(response);
      expect(1, 1);
    } on Emergency catch (e) {
      fail(e.message);
    }
  });
}
