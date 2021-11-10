import 'package:pub_semver/pub_semver.dart';

import 'enum.dart';

/// [AppData] global object.
AppData appData = AppData();

/// [AppData] class which holds the app version, app name, app release type, build type,
class AppData {
  String? path;
  Version? version;
  ReleaseType? releaseType;
  BuildType? buildMode;
  String? platform;
  AppData({
    this.path,
    this.version,
    this.releaseType,
    this.buildMode,
    this.platform,
  });
}
