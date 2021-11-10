import 'package:interact/interact.dart';
import 'package:app_build/utils/app_data.dart';
import 'package:app_build/outputs/prints.dart';
import 'package:app_build/utils/enum.dart';

/// Function that returns a String value from the user input.
/// This function is used for Application Release management.
///
/// **EG:**
/// ```dart
/// userReleaseInput(
///   question: 'Type of the Application release : ',
///   options: <String>['Alpha', 'Beta', 'Stable'],
/// );
/// ```
///
/// **OUTPUT:**
///
/// ```txt
/// # Input
/// ? Type of the Application release : >
///   Alpha
/// ❯ Beta
///   Stable
///
/// # Output
/// ✔ Type of the Application release :  · Beta
/// ```
int userReleaseInput({String? question, List<String>? options}) {
  try {
    try {
      int releaseSelection = Select(
        prompt: question!,
        options: options!,
      ).interact();
      return releaseSelection;
    } catch (e) {
      printErrorln(e.toString());
      return -1;
    }
  } catch (e) {
    printErrorln(e.toString());
    return -1;
  }
}

void releaseCollection() {
  int release = userReleaseInput(
    question: 'Type of the Application release : ',
    options: <String>['Alpha', 'Beta', 'Stable'],
  );
  switch (release) {
    case 0:
      appData.releaseType = ReleaseType.alpha;
      break;
    case 1:
      appData.releaseType = ReleaseType.beta;
      break;
    case 2:
      appData.releaseType = ReleaseType.stable;
      break;
  }
  printInfoln('App release type is : ${appData.releaseType.toString().split('.')[1].toUpperCase()}');
}

void releaseFix() {}
