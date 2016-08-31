import 'package:args/command_runner.dart';
import 'package:ini/ini.dart';

import './command/register_command.dart';
import './command/upload_command.dart';

CommandRunner getRunner(Config config) {
  final runner = new CommandRunner('beaver', 'CLI for beaver CI.');
  runner
    ..addCommand(new RegisterCommand(config))
    ..addCommand(new UploadCommand(config));
  return runner;
}