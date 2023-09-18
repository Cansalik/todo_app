import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:to_do_app/screens/AddTodoPage.dart';
import 'package:http/http.dart' as http;
import 'package:to_do_app/services/Todo_Services.dart';
import 'package:to_do_app/utils/Snackbar.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {

  bool isLoading = true;
  List items = [];


  @override
  void initState() {
    fetchTodo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Kişisel Ajandam",style: TextStyle(fontWeight: FontWeight.bold),)),
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(child: RefreshProgressIndicator()),
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
              child: Text("Ajanda Boş",
              style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            child: ListView.builder(
                padding: EdgeInsets.all(12),
                itemCount: items.length,
                itemBuilder: (context, index)
                {
                  final item = items[index] as Map;
                  final id = item["_id"] as String;
                  return Card(
                    child: ListTile(
                     leading: CircleAvatar(child: Text("${index + 1 }")),
                     title: Text(item["title"],style: TextStyle(fontWeight: FontWeight.bold),),
                     subtitle: Text(item["description"]),
                     trailing: PopupMenuButton(
                       onSelected: (value)
                       {
                         if(value == 'edit') {navigateToEditPage(item);}
                         else if (value == 'delete') {deleteById(id);}
                       },
                       itemBuilder: (context){
                         return [
                           PopupMenuItem(
                             value: 'edit',
                             child: Text("Düzenle"),
                           ),
                           PopupMenuItem(
                             value: 'delete',
                             child: Text("Sil"),
                           ),
                         ];
                       },
                     ),
                    ),
                  );
                }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddPage,
        label: Text("Ekle"),
      ),
    );
  }


  Future<void> deleteById(String id) async {

    final isSuccess = await Todo_Services.deleteById(id);
    if(isSuccess) {
      final filtered = items.where((element) => element["_id"] != id).toList();
      setState(() {
        items = filtered;
      });
      showSuccessMessage(context, message: "Silindi");
    }
    else {
      showErrorMessage(context, message: "Silinmedi");
    }
  }

  Future<void> fetchTodo () async {
    final response = await Todo_Services.fetcTodo();
    if(response != null)
    {
      setState(() {
        items = response;
      });
    }
    else
    {
      showErrorMessage(context, message: "Bir şeyler ters gitti!");
    }
    setState(() {
      isLoading = false;
    });
  }

  void navigateToAddPage() async {
    final route = MaterialPageRoute(builder: (context) => AddTodoPage(),);
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  void navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(builder: (context) => AddTodoPage(todo: item),);
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

}