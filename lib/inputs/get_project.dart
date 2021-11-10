import 'dart:io';

import 'package:app_build/utils/app_data.dart';
import 'package:interact/interact.dart';

void getProjectDirectory() {
  String projectDirectory = Input(
    prompt: 'Enter the absolute path of your project directory : ',
    defaultValue: 'your project path',
    validator: (String x) {
      bool isDirExist = checkDirectory(x);
      if (isDirExist) {
        return true;
      } else {
        throw ValidationError('Not a valid path. Try again.');
      }
    },
  ).interact();
  appData.path = projectDirectory;
}

bool checkDirectory(String projectDirectory) {
  List<String>? pathElements;
  List<String> emptyPathElementsList = <String>[];
  if (projectDirectory.contains('/')) {
    pathElements = projectDirectory.split('/');
  } else if (projectDirectory.contains('\\')) {
    pathElements = projectDirectory.split('\\');
  } else {
    pathElements = <String>[projectDirectory];
  }
  for (String fileName in pathElements) {
    if (fileName.isNotEmpty) {
      emptyPathElementsList.add(fileName);
    }
  }
  projectDirectory = emptyPathElementsList.join('/');
  if (Directory(projectDirectory).existsSync()) {
    bool isPubspecExists = checkFile(projectDirectory);
    if (isPubspecExists) {
      return true;
    } else {
      throw ValidationError('Directory $projectDirectory does not exist');
    }
  } else {
    throw ValidationError('Directory $projectDirectory does not exist');
  }
}

bool checkFile(String projectDirectory) {
  if (File(projectDirectory + '/' + 'pubspec.yaml').existsSync()) {
    return true;
  } else {
    throw ValidationError('Looks like $projectDirectory is not a valid directory');
  }
}
