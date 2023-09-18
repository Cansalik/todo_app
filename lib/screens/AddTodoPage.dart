import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:to_do_app/services/Todo_Services.dart';
import 'package:to_do_app/utils/Snackbar.dart';

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({Key? key, this.todo}) : super(key: key);

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {

  TextEditingController tfTitle = TextEditingController();
  TextEditingController tfDescription = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    final todo = widget.todo;
    if(todo != null)
    {
      isEdit = true;
      final title = todo["title"];
      final description = todo["description"];
      tfTitle.text = title;
      tfDescription.text = description;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Ajanda Düzenle" : "Yapılacak Ekle"),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: tfTitle,
            decoration: InputDecoration(hintText: 'Başlık'),
          ),
          SizedBox(height: 20,),
          TextField(
            controller: tfDescription,
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
            decoration: InputDecoration(hintText: 'Konu'),
          ),
          SizedBox(height: 20,),
          ElevatedButton(
            onPressed: isEdit ? updateData : submitData,
            child: Text(isEdit ? "Güncelle" : "Ekle"),

          ),
        ],
      ),
    );
  }

  void updateData() async {
    // Get data from from
    final todo = widget.todo;
    if (todo == null)
    {
      print("Hata");
      return;
    }
    final id = todo["_id"];

    // Submit update data to server
    final isSuccess = await Todo_Services.updateTodo(id, body);

    // Show Success or Fail message
    if(isSuccess)
    {
      showSuccessMessage(context, message: "Güncellendi");
    }
    else
    {
      showSuccessMessage(context, message: "Hata!");
    }
  }

  void submitData() async {
    // Submit data to server
    final isSuccess = await Todo_Services.addTodo(body);

    // Show Success or Fail message
    if(isSuccess)
    {
      showSuccessMessage(context, message: "Kaydedildi");
    }
    else
    {
      showSuccessMessage(context, message: "Hata!");
    }
  }

  Map get body {
    // Get data from

    final title = tfTitle.text;
    final description = tfDescription.text;
    return {
      "title": title,
      "description": description,
      "is_completed": false
    };
  }


}
