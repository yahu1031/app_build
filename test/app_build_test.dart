import 'package:app_build/inputs/version.dart';
import 'package:test/test.dart';

void main() {
  test('Version input function', () async {
    String majorString = versionInput(
      question: 'Enter the major number in version (*.*.*) : ',
      defaultValue: '0',
      valueType: 'major',
    ).interact();
    int? major = int.tryParse(majorString);
    expect(major, 0);
  });
}
