import 'package:beaver_task/beaver_task_runner.dart';
import 'package:beaver_trigger_handler/beaver_trigger.dart';

class TriggerResult {
  final String projectName;
  final int buildNumber;

  final String status;

  // Trigger
  final String triggerName;
  final Map<String, String> triggerHeaders;
  final Map<String, Object> triggerPayload;

  // ParsedTrigger
  final String parsedTriggerEvent;
  final String parsedTriggerUrl;

  final Map<String, Object> taskInstance;

  // TaskRunResult
  final String taskStatus;
  final String taskConfigCloudType;
  final Map<String, Object> taskConfigCloudSettings;
  final String taskLog;

  TriggerResult._internal(
      this.projectName,
      this.buildNumber,
      this.status,
      this.triggerName,
      this.triggerHeaders,
      this.triggerPayload,
      this.parsedTriggerEvent,
      this.parsedTriggerUrl,
      this.taskInstance,
      this.taskStatus,
      this.taskConfigCloudType,
      this.taskConfigCloudSettings,
      this.taskLog);

  factory TriggerResult.fromTriggerHandler(
      String id,
      int buildNumber,
      String status,
      Trigger trigger,
      ParsedTrigger parsedTrigger,
      Map<String, Object> taskInstance,
      TaskRunResult taskRunResult) {
    return new TriggerResult._internal(
        id,
        buildNumber,
        status,
        trigger.name,
        trigger.headers,
        trigger.payload,
        parsedTrigger?.event,
        parsedTrigger?.url,
        taskInstance,
        taskRunResult != null
            ? taskRunResult.status == TaskStatus.success ? 'success' : 'failure'
            : null,
        taskRunResult?.config?.cloudType,
        taskRunResult?.config?.cloudSettings,
        taskRunResult?.log);
  }

  factory TriggerResult.fromGCloud(
      String projectName,
      int buildNumber,
      String status,
      String triggerType,
      Map<String, String> triggerHeaders,
      Map<String, Object> triggerPayload,
      String parsedTriggerEvent,
      String parsedTriggerUrl,
      Map<String, Object> taskInstance,
      String taskStatus,
      String taskConfigCloudType,
      Map<String, Object> taskConfigCloudSettings,
      String taskLog) {
    return new TriggerResult._internal(
        projectName,
        buildNumber,
        status,
        triggerType,
        triggerHeaders,
        triggerPayload,
        parsedTriggerEvent,
        parsedTriggerUrl,
        taskInstance,
        taskStatus,
        taskConfigCloudType,
        taskConfigCloudSettings,
        taskLog);
  }
}
