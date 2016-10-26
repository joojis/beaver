import 'dart:async';
import 'dart:convert';
import 'dart:io';

import './http.dart';

class DescribeCommand extends HttpCommand {
  @override
  String get description => 'Describe project.';

  @override
  String get name => 'describe';

  DescribeCommand() : super() {}

  @override
  String get api => '/api/describe';

  String projectName;

  @override
  Future<Null> run() async {
    if (argResults.rest.length == 1) {
      projectName = argResults.rest[0];
    } else {
      print('project_name is required.');
      exitWithHelpMessage();
    }

    final url = getServerUrl();
    print(url.toString() + ' will be requested.');

    final data = {'project_name': projectName};

    final httpClient = new HttpClient();
    final request = await httpClient.openUrl('POST', url);
    request.headers.add('Content-Type', 'application/json');
    request.write(JSON.encode(data));
    final response = await request.close();
    final responseBody = await response.transform(UTF8.decoder).join();
    httpClient.close();

    print(responseBody);
  }
}
