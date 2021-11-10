import 'dart:io';

import 'package:process_run/shell.dart';

import 'package:app_build/outputs/prints.dart';
import 'package:app_build/utils/app_data.dart';
import 'package:app_build/utils/enum.dart';
import 'package:app_build/utils/spinner.dart';

class AppBuild {
  /// Cleans the previous build files before building the new ones.
  static Future<void> cleanAndGetPubspec() async {
    /// Shell object.
    Shell shell = Shell(
      commandVerbose: false,
      commentVerbose: false,
      runInShell: true,
      verbose: false,
    );

    try {
      await startSpinner();

      /// Change the directory to the project root.
      /// Run the clean command.
      await shell.run('cd ${appData.path}').then((_) async {
        List<ProcessResult> a = await shell.run('pwd');
        print(a.outText);
        await shell.run('flutter clean');
        stopSpinner();
        printSuccessln('Cleaned the previous build files.');
        printInfo('Pub getting...');
        await startSpinner();

        /// Run the pub get command.
        await shell.run('flutter pub get');
        stopSpinner();
        printSuccessln('Got all pub dependencies.');
      }).catchError((Object? e) {
        stopSpinner();
        printErrorln('Error: ${e.toString()}');
      });
    } catch (e) {
      printError(e.toString());
    }
  }

  /// Builds the app and returns the build directory
  /// Takes an argument [platform] to build for.
  static Future<void> build(String? platform) async {
    /// Shell object.
    Shell shell = Shell(
      commandVerbose: false,
      commentVerbose: false,
      runInShell: true,
      verbose: false,
    );
    List<ProcessResult>? wtf;

    await startSpinner();
    try {
      /// List of arguments to be passed to the build command.
      List<String> args = <String>['build'];

      /// If platform is not null, add it to the arguments.
      if (appData.platform != null) args.add(appData.platform!.toLowerCase());

      /// If build mode is not null, add it to the arguments.
      if (appData.buildMode != null) args.add('--${appData.buildMode!.toString().split('.')[1]}');

      /// If release mode is not null, add `--dart-define` to the arguments.
      /// And also add `release-type` key and it's value to the arguments.
      if (appData.releaseType != null) {
        args.add('--dart-define');
        args.add('release-type=${appData.releaseType.toString().split('.')[1]}');
      }

      /// If version is not null, add `--dart-define` to the arguments.
      /// And also add `current-version` key and it's value to the arguments.
      if (appData.version != null) {
        args.add('--dart-define');
        args.add('current-version=${appData.version}');
      }

      /// Run the build command.
      wtf = await shell.run('flutter ${args.join(' ')}');
      stopSpinner();
    } catch (e) {
      stopSpinner();
      printError(wtf!.outText);
      printError(e.toString());
    }
  }

  /// Builds the MSXI file. All parameters are pre defined.
  static Future<void> buildMSIX() async {
    await startSpinner();
    try {
      if (appData.buildMode == BuildType.release) {
        /// Shell object.
        Shell shell = Shell(
          commandVerbose: false,
          commentVerbose: false,
          runInShell: true,
          verbose: false,
        );
        List<String> args = <String>['pub', 'run', 'msix:create', 'CN=FLUTTERMATIC,', 'O=Fluttermatic'];
        await shell.run('flutter ${args.join(' ')}');
      } else {
        printError('Debug and Profile modes are not supported for MSIX');
      }
      stopSpinner();
    } catch (e) {
      stopSpinner();
      printError(e.toString());
    }
  }
}
