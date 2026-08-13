import 'package:flutter_test/flutter_test.dart';
import 'package:nikki_albums/utils/unit.dart';

void main() {
  group('formatBytes', () {
    test('returns "0 B" for 0 or negative bytes', () {
      expect(formatBytes(0), '0 B');
      expect(formatBytes(-100), '0 B');
    });

    test('formats correctly with different units', () {
      expect(formatBytes(500), '500.00 B');
      expect(formatBytes(1024), '1.00 KB');
      expect(formatBytes(1024 * 1024), '1.00 MB');
      expect(formatBytes((1.5 * 1024 * 1024 * 1024).toInt()), '1.50 GB');
    });

    test('respects decimals parameter', () {
      expect(formatBytes(1024 + 512, decimals: 1), '1.5 KB');
      expect(formatBytes(1024, decimals: 0), '1 KB');
    });
  });
}
