import 'dart:io';
import 'package:interact/interact.dart';
import 'package:pub_semver/pub_semver.dart';
import '../utils/app_data.dart';
import '../outputs/prints.dart';

Future<void> versionCollection() async {
  String sMajor = versionInput(
    question: 'Enter the major number in version (*.*.*+*) : ',
    defaultValue: '0',
    valueType: 'major',
  ).interact();
  int major = int.parse(sMajor);
  String sMinor = versionInput(
    question: 'Enter the minor number in version ($major.*.*+*) : ',
    defaultValue: '0',
    valueType: 'minor',
  ).interact();
  int minor = int.parse(sMinor);
  String sPatch = versionInput(
    question: 'Enter the patch number in version ($major.$minor.*+*) : ',
    defaultValue: '0',
    valueType: 'patch',
  ).interact();
  int patch = int.parse(sPatch);
  String sBugPatch = versionInput(
    question: 'Enter the patch number in version ($major.$minor.$patch+*) : ',
    defaultValue: '0',
    valueType: 'patch',
  ).interact();
  int? bugPatch = int.parse(sBugPatch);
  if (bugPatch == 0) {
    bugPatch = null;
  }
  printInfo('Version you entered is : $major.$minor.$patch${bugPatch == null ? '' : '+$bugPatch'}');
  if (major + minor + patch == 0) {
    printErrorln(Exception('❌ Version cannot be all zeros. Try 1.0.0 if it is initial version.').toString());
    await versionCollection();
  } else {
    appData.version = Version(major, minor, patch, build: bugPatch?.toString());
    if (appData.version!.compareTo(await checkPubspecVersion()) < 0) {
      printWarningln(
          'Version is not up to date. Current version : ${appData.version}. Update the version with respect to your project pubspec.yaml');
      exit(1);
    } else if (appData.version!.compareTo(await checkPubspecVersion()) > 0) {
      printSuccessln('💚 Version is valid.');
      return;
    }
  }
}

/// Function that returns an integer from the user input.
/// This function is used for version management.
///
/// **EG:**
/// ```dart
/// String version = versionInput(
///   question: 'Enter the version you want to release : ',
///   defaultValue: '1.0.0',
///   valueType: 'version',
/// ).interact();
/// print('Version : $version');
/// ```
///
/// **OUTPUT:**
///
///Input
/// ```bash
/// ? Enter the version you want to release :  (0) › 0.0.0
/// ```
///
/// Output
/// ```bash
/// ✔ Enter the version you want to release :  · 0.0.0
/// ```
Input versionInput({
  String? question,
  String? defaultValue,
  String? initialText,
  String? valueType,
}) {
  return Input(
    prompt: question!,
    defaultValue: defaultValue,
    initialText: initialText ?? '',
    validator: (String x) {
      if (int.tryParse(x) is int) {
        return true;
      } else {
        throw ValidationError('Not a valid $valueType');
      }
    },
  );
}

Future<Version> checkPubspecVersion() async {
  String? pubVersion;
  int? pubMajor;
  int? pubMinor;
  int? pubPatch;
  try {
    String? pubspecContent = await File('./pubspec.yaml').readAsString();
    for (String ver in pubspecContent.split('\n')) {
      if (ver.startsWith('version: ') == true) {
        pubVersion = ver.split(': ')[1].trim();
      }
    }
    if (pubVersion != null) {
      pubMajor = int.parse(pubVersion.split('.')[0].trim());
      pubMinor = int.parse(pubVersion.split('.')[1].trim());
      pubPatch = int.parse(pubVersion.split('.')[2].trim());
    }
    return Version(pubMajor!, pubMinor!, pubPatch!);
  } catch (e) {
    printErrorln(e.toString());
    return Version(0, 0, 0);
  }
}
