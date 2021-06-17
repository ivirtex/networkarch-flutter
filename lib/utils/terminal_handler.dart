// Dart imports:
import 'dart:io';

//TODO: do this later

class TerminalHandler {
  dynamic stdout = "awdawd";

  String onInput(String input) {
    Process.run('pwd', []).then((ProcessResult results) {
      stdout = results.stdout;
      print(stdout);
    });
    return stdout;
  }
}
