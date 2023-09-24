import 'dart:convert'; 
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/colors.dart';
import '../widgets/todo_items.dart';
import '../model/todo.dart';
import '../helper/filesystem.dart';


class Home extends StatefulWidget{
  const Home ({Key?key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ToDo> todoList = [];
  late SharedPreferences sharedPreferences;
  List<ToDo> _foundItem = [];
  final _todoController = TextEditingController();
  double addSize = 50;

  final FileSystem file = FileSystem();

  @override
  void initState() {
    loadState();
    initSaredPreferences() async {
      sharedPreferences = await SharedPreferences.getInstance();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: tdBG,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15
            ),
            child: Column(
              children: [
                searchBox(),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          top: 50,
                          bottom: 20
                        ),
                        child: const Text(
                          "All Activities",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                      ),

                      for (ToDo todos in _foundItem.reversed)
                        ToDoItem(
                          todo: todos,
                          onToDoChanged: _handleToDoChange,
                          onDeleteItem: _deleteToDoItem,
                        )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                  child: Container(margin: const EdgeInsets.only(
                    bottom: 20,
                    right: 20,
                    left: 20
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                     vertical: 5
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 0.0),
                        blurRadius: 10.0,
                        spreadRadius: 0.0
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _todoController,
                    decoration: const InputDecoration(
                      hintText: "Add a new item",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    bottom: 10,
                    right: 20
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      _addToDoItem(_todoController.text);
                      savedItems();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tdBlue,
                      minimumSize: Size(addSize, addSize),
                      elevation: 50
                    ),
                    child: const Text(
                      '+',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleToDoChange(ToDo todo){
    todo.isDone = !todo.isDone;
    savedItems();
    setState(() {
    });
  }

  void _deleteToDoItem(String id){
    todoList.removeWhere((i) => i.id == id);
    savedItems();
    setState(() {
      todoList = todoList;
    });
  }

  void _addToDoItem(String toDo){
    if(toDo == "") return;
    setState(() {
      todoList.add(ToDo(id: DateTime.now().millisecondsSinceEpoch.toString(),todoText: toDo));
    });
    _todoController.clear();
  }

  void _searchFilter(String searchString){
    List<ToDo> result = [];
    if(searchString.isEmpty){
      result = todoList;
    }else{
      result = todoList
        .where((item) => item.todoText!
          .toLowerCase()
          .contains(searchString.toLowerCase()))
        .toList();
    }
    setState(() {
      _foundItem = result;
    });
  }
  //TODO: Fix jsonEncode save items
  void savedItems(){
    String jsonTodo = jsonEncode(todoList);
    file.write(jsonTodo);
  }

  void loadState() async {
    await file.setup();

    String json = file.read();

    if(json.isEmpty) return;
    if(!(json.startsWith('[') && json.endsWith(']'))) return;

    // JSON -> ToDo
    List<dynamic> decodedJson = jsonDecode(json);
    List<ToDo> todos = [];
    decodedJson.forEach((todoJsonItem) => todos.add(ToDo.fromJson(todoJsonItem)));

    setState(() {
      todoList = todos;
      _foundItem = todoList;
    });
  }

  Widget searchBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0)
      ),
      child: TextField(
        onChanged: (value) => _searchFilter(value),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: tdTB,
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(
            maxHeight: 20,
            minWidth: 25
          ),
          border: InputBorder.none,
          hintText: "Search for activities...",
          hintStyle: TextStyle(color: tdTB),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: tdBG,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.menu,
          color: tdBlack,
          size: 30,
          ),
          SizedBox(
            height: 40,
            width: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.asset('assets/images/img.png')
            ),
          ),
        ],
      ),
    );
  }
}