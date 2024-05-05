import 'dart:convert';
import 'dart:developer';

import 'package:my_task/models/task_model.dart';
import 'package:http/http.dart';

class TaskService {
  Future<List<TaskModel>> getTasks() async {
    final Response result = await get(
      Uri.parse(
          "https://ct2npjmj-3000.asse.devtunnels.ms/todos-list?keyOrder=DESC"),
    );
    Map<String, dynamic> jsonResult = jsonDecode(result.body);

    log("result.body => ${result.body}");

    List<TaskModel> tasks = [];

    for (var element in jsonResult['data'] as List) {
      TaskModel taskModel = TaskModel.fromJson(element);

      tasks.add(taskModel);
    }

    return tasks;
  }

  Future<bool> updateStatusTask(
      {required String id, required bool value}) async {
    Map<String, dynamic> data = {"status": value};
    final Response result = await patch(
      Uri.parse("https://ct2npjmj-3000.asse.devtunnels.ms/todos-list/$id"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(data),
    );

    if (result.statusCode != 200) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> addTask(
      {required String title, required String description}) async {
    Map<String, dynamic> data = {
      "todo": title,
      "description": description,
    };
    final Response result = await post(
      Uri.parse("https://ct2npjmj-3000.asse.devtunnels.ms/todos-list/create"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(data),
    );

    if (result.statusCode != 201) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> deleteTask({required String id}) async {
    final Response result = await delete(
      Uri.parse("https://ct2npjmj-3000.asse.devtunnels.ms/todos-list/$id"),
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (result.statusCode != 200) {
      return false;
    } else {
      return true;
    }
  }
}
