class ToDo{
  String? id;
  String? todoText;
  bool isDone;

  ToDo({
    required this.id,
    required this.todoText,
    this.isDone = false
  });

  Map toJson() => {
      'id': id,
      'text': todoText,
      'done': isDone,
    };

  ToDo.fromJson(dynamic json):
      id = json["id"],
      todoText = json["text"],
      isDone = json["done"];
}