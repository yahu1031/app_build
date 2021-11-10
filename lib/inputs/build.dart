import 'package:interact/interact.dart';

import '../utils/app_data.dart';
import '../outputs/prints.dart';
import '../utils/enum.dart';

/// Function that returns a String value from the user input.
/// This function is used for Application Build management.
///
/// **EG:**
/// ```dart
/// int build = userBuildInput(
///   question: 'Type of the flutter build : ',
///   options: <String>['Release', 'Profile', 'Debug'],
/// );
/// ```
///
/// **OUTPUT:**
///
/// ```log
/// # Input
/// ? Type of the flutter build :  ›
/// ❯ Release
///   Profile
///   Debug
///
/// # Output
/// ✔ Type of the flutter build :  · Release
/// ```
int userBuildInput({String? question, List<String>? options}) {
  try {
    int buildSelection = Select(
      prompt: question!,
      options: options!,
    ).interact();
    return buildSelection;
  } catch (e) {
    printErrorln(e.toString());
    return -1;
  }
}

void buildCollection() {
  int build = userBuildInput(
    question: 'Type of the flutter build : ',
    options: <String>['Release', 'Profile', 'Debug'],
  );
  switch (build) {
    case 0:
      appData.buildMode = BuildType.release;
      break;
    case 1:
      appData.buildMode = BuildType.profile;
      break;
    case 2:
      appData.buildMode = BuildType.debug;
      break;
  }
  printInfoln('App build type is : ${appData.buildMode.toString().split('.')[1].toUpperCase()}');
  if (appData.buildMode == BuildType.debug) {
    printWarning('✖️ Looks like you choose it by mistake. Building app in debug mode is useless here.');
    bool buildConfirmation = Confirm(
      prompt: 'Still you want to build it?',
      waitForNewLine: false,
    ).interact();
    if (!buildConfirmation) buildCollection();
  }
  if (appData.buildMode!.index == 0) {
    //TODO: Add release build and write the code here.
  }
}
