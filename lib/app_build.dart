import 'package:interact/interact.dart';

String build() {
  List<String> languages = <String>['Rust', 'Dart', 'TypeScript'];
  int selection = Select(
    prompt: 'Your favorite programming language',
    options: languages,
  ).interact();

  return languages[selection];
}
