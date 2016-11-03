import 'dart:async';
import 'dart:convert';

/// [GCloudStorageUploadTask] import.
import 'package:beaver_gcloud_task/beaver_gcloud_task.dart';
import 'package:beaver_store/beaver_store.dart' as beaver_store;
import 'package:beaver_task/beaver_task.dart' as beaver_task;
import 'package:beaver_task/beaver_task_runner.dart';

import './base.dart';

class TaskInstanceRunner {
  final Context _context;
  final beaver_store.Config _config;
  final ParsedTrigger _parsedTrigger;
  final List<Map<String, Object>> _tasks;
  final CloudInfo _cloudInfo;

  TaskInstanceRunner(this._context, this._config, this._parsedTrigger,
      this._tasks, this._cloudInfo);

  Future<TaskInstanceRunResult> run() async {
    _context.logger.fine('TaskInstanceRunner started.');

    final jsonTask = _createJsonForTask(_tasks, _parsedTrigger);
    _context.logger.fine('Task: ${jsonTask}');

    final config = new beaver_task.Config(_cloudInfo.type,
        {'project_name': _cloudInfo.projectName, 'zone': _cloudInfo.region});
    final result = await runBeaver(jsonTask, config);

    return new TaskInstanceRunResult(TaskInstanceStatus.success, result);
  }
}

List<String> _getArgs(List<String> args, ParsedTrigger parsedTrigger) {
  final ret = new List<String>();
  args.forEach((arg) {
    if (parsedTrigger.isTriggerData(arg)) {
      ret.add(parsedTrigger.getTriggerData(arg));
    } else {
      ret.add(arg);
    }
  });
  return ret;
}

String _createJsonForTask(
    List<Map<String, Object>> taskInstances, ParsedTrigger parsedTrigger) {
  assert(taskInstances.isNotEmpty);

  final taskList = [];
  taskInstances.forEach((taskInstance) {
    taskList.add({
      'name': taskInstance['name'],
      'args': _getArgs(taskInstance['args'] as List<String>, parsedTrigger)
    });
  });

  if (taskList.length == 1) {
    return JSON.encode(taskList[0]);
  }

  // FIXME: Need to be able to use par, too.
  final map = {}..addAll({'name': 'seq', 'args': taskList});
  return JSON.encode(map);
}
