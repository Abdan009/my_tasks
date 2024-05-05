import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:my_task/models/task_model.dart';
import 'package:my_task/services/task_service.dart';
import 'package:my_task/ui/add_task_ui.dart';

class MyTasksUi extends StatefulWidget {
  const MyTasksUi({super.key});

  @override
  State<MyTasksUi> createState() => _MyTasksUiState();
}

class _MyTasksUiState extends State<MyTasksUi> {
  List<TaskModel> tasks = [];
  @override
  void initState() {
    getTasks();
    super.initState();
  }

  Future<void> getTasks() async {
    tasks = await TaskService().getTasks();
    setState(() {});
  }

  Future<void> updateStatusTask(
      {required String id, required bool value}) async {
    EasyLoading.show(status: "Loading...");
    bool result = await TaskService().updateStatusTask(id: id, value: value);
    if (result) {
      await getTasks();
      EasyLoading.dismiss();
    }
  }

  Future<void> deleteTask({required String id}) async {
    EasyLoading.show(status: "Loading...");
    bool result = await TaskService().deleteTask(
      id: id,
    );
    if (result) {
      await getTasks();
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Tasks",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () async {
          await Navigator.push(
              context, MaterialPageRoute(builder: (_) => AddTaskUi()));
          getTasks();
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 20,
          ),
          Column(
            children: List.generate(tasks.length, (index) {
              TaskModel task = tasks[index];
              return Container(
                width: MediaQuery.of(context).size.width,
                margin:
                    EdgeInsets.symmetric(horizontal: 15).copyWith(bottom: 15),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    Checkbox(
                      value: task.status,
                      onChanged: (value) {
                        if (value != null) {
                          updateStatusTask(id: task.id, value: value);
                        }
                      },
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.todo,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          Text(task.description,
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.normal))
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        deleteTask(id: task.id);
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
          SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
