import 'dart:math';

import 'package:flutter_project_base/src/extensions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_project_base/src/basic_types.dart';
import 'package:flutter_project_base/src/helpers.dart';

void main() {
  test('Format file size as integer', () {
    FileSize fileSize = 2350555;
    String formattedFileSize = fileSize.formatSizeInBytesToScaledSize();
    if (fileSize <= 1024) {
      expect(RegExp('^\\d+\\sbytes\$').hasMatch(formattedFileSize), true);
    } else if (fileSize <= pow(1024, 2)) {
      expect(RegExp('^\\d+\\sKb\$').hasMatch(formattedFileSize), true);
    } else if (fileSize <= pow(1024, 3)) {
      expect(RegExp('^\\d+\\sMb\$').hasMatch(formattedFileSize), true);
    }
  });

  test('Format file size as integer float with 2 decimals', () {
    FileSize fileSize = 32350555;
    final decimals = 2;
    final formattedFileSize =
        fileSize.formatSizeInBytesToScaledSize(decimals: decimals);
    if (fileSize <= pow(1024, 2)) {
      expect(
          RegExp('^\\d+\\.\\d{$decimals}\\sKb\$').hasMatch(formattedFileSize),
          true);
    } else if (fileSize <= pow(1024, 3)) {
      expect(
          RegExp('^\\d+\\.\\d{$decimals}\\sMb\$').hasMatch(formattedFileSize),
          true);
    }
  });

  test('Procedure performance meter', () async {
    await meter(() {
      final value = Future.delayed(Duration(seconds: 3), () => 2);
      return value;
    }, 'Future.delayed');
  });
}
