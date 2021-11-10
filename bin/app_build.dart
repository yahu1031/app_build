import 'package:app_build/inputs/build.dart';
import 'package:app_build/inputs/get_project.dart';
import 'dart:io';

import 'package:app_build/inputs/release.dart';
import 'package:app_build/inputs/version.dart';
import 'package:app_build/outputs/prints.dart';
import 'package:app_build/utils/app_data.dart';
import 'package:app_build/utils/flutter_build.dart';
import 'package:app_build/utils/spinner.dart';

String dartDefine = '--dart-define';
Future<void> main({List<String>? args}) async {
  try {
    appData.platform = Platform.operatingSystem;
    getProjectDirectory();
    await versionCollection();
    buildCollection();
    releaseCollection();
    await runBuild();
  } on FormatException catch (fe) {
    printErrorln('❌ Format Exception : ${fe.message}');
  } catch (e) {
    printErrorln(e.toString());
  }
}

Future<void> runBuild() async {
  printInfo('🧹 Clearing previous build files');
  await AppBuild.cleanAndGetPubspec();
  printInfo('⚒️  Started building application EXE file with the info...');
  printInfo('🖥️  Platform : ${appData.platform}');
  printInfo('📝  Version : ${appData.version}');
  printInfo('🏗️  Build : ${appData.buildMode.toString().split('.')[1].toUpperCase()}');
  printInfo('🎥  Release : ${appData.releaseType.toString().split('.')[1].toUpperCase()}');
  await AppBuild.build(appData.platform);
  stopSpinner();
  printSuccessln('Finished building EXE file');
  printInfo('⚒️  Started building MSIX file...');
  await AppBuild.buildMSIX();
  stopSpinner();
  printSuccess('🏡  Finished building application.');
}
