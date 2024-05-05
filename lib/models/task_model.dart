class TaskModel {
  final String id;
  final String todo;
  final String description;
  final bool status;
  TaskModel({required this.id, required this.todo, required this.description, required this.status,});

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      todo: json['todo'],
      description: json['description'],
      status: json['status']
    );
  }
}
