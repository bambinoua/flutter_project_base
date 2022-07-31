// ignore_for_file: avoid_print

import 'package:flutter_project_base/flutter_project_base.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('DIO client GET test', () async {
    try {
      const numberApiBaseUrl = 'http://numbersapi.com';
      final httpClient = JsonHttpClient(baseUrl: numberApiBaseUrl);
      final response = await httpClient.get(Uri.parse('/100/trivia'));
      expect(response.statusCode, 200);
    } on Emergency catch (e) {
      fail(e.message);
    }
  });
}
