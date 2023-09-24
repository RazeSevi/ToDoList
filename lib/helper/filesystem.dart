import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileSystem {
  
  String filePath = "todos.json";
  bool finishedSetup = false;

  Future<String> setup() async {
    if (finishedSetup) return filePath;
    Directory dir = await getApplicationCacheDirectory();
    ensureExists(dir.path);
    finishedSetup = true;
    return filePath;
  }

  void ensureExists(String dirPath) {
    filePath = "$dirPath/$filePath";
    File file = _localFile;
    if(!file.existsSync()) {
      file.createSync();
    }
  }

  File get _localFile {
    return File(filePath);
  }

  String read() {
    String data = _localFile.readAsStringSync();
    print(data);
    return data;
  }

  void write(String data)  {
    _localFile.writeAsString(data);
    print(_localFile);
  }
}