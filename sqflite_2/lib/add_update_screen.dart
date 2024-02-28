import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite_2/db_handler.dart';
import 'package:sqflite_2/home_screen.dart';

import 'model.dart';

class AddUpdateTask extends StatefulWidget {
  int? todoId;
  String? todoTitle;
  String? todoDesc;
  String? todoDT;
  bool? update;

  AddUpdateTask({
    this.todoId,
    this.todoTitle,
    this.todoDesc,
    this.todoDT,
    this.update,
    Key? key,
  }) : super(key: key);

  @override
  State<AddUpdateTask> createState() => _AddUpdateTaskState();
}

class _AddUpdateTaskState extends State<AddUpdateTask> {
  DBHelper? dbHelper;
  late Future<List<TodoModel>> dataList;

  final _fromKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }

  loadData() async {
    dataList = dbHelper!.getDataList();
  }

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(text: widget.todoTitle);
    final descController = TextEditingController(text: widget.todoDesc);
    String appTitle;
    if (widget.update == true) {
      appTitle = "Update Task";
    } else {
      appTitle = "Add Task";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          appTitle,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
          padding: EdgeInsets.only(top: 100),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: _fromKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          keyboardType: TextInputType.multiline,
                          controller: titleController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Note Title",
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter some text";
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          minLines: 5,
                          controller: descController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Write notes here",
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter some text";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Material(
                        color: Colors.green[400],
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          onTap: () {
                            if (_fromKey.currentState!.validate()) {
                              if (widget.update == true) {
                                dbHelper!.update(TodoModel(
                                  id: widget.todoId,
                                  title: titleController.text,
                                  desc: descController.text,
                                  dateandtime: widget.todoDT,
                                ));
                              } else {
                                dbHelper!.insert(TodoModel(
                                    title: titleController.text,
                                    desc: descController.text,
                                    dateandtime: DateFormat('yMd')
                                        .add_jm()
                                        .format(DateTime.now())
                                        .toString()));
                              }
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Home_Screen()));
                              titleController.clear();
                              descController.clear();
                              // to check if its working or not
                              print("Data added");
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            height: 55,
                            width: 120,
                            decoration: BoxDecoration(
                                // boxShadow: [
                                //   BoxShadow(
                                //     color: Colors.black12,
                                //     blurRadius: 5,
                                //     spreadRadius: 1,
                                //   ),
                                // ],
                                ),
                            child: Text(
                              "Submit",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Material(
                        color: Colors.red[400],
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              titleController.clear();
                              descController.clear();
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            height: 55,
                            width: 120,
                            decoration: BoxDecoration(
                                // boxShadow: [
                                //   BoxShadow(
                                //     color: Colors.black12,
                                //     blurRadius: 5,
                                //     spreadRadius: 1,
                                //   ),
                                // ],
                                ),
                            child: Text(
                              "Clear",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
