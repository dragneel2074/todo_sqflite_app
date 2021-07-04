import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqlfile_app/helpers/database_helpers.dart';
import 'package:sqlfile_app/models/task_model.dart';

import 'Add_task_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Task>>? _taskList;

  @override
  void initState() {
    super.initState();
    _updateTaskList();
  }

  _updateTaskList() {
    setState(() {
      _taskList = DatabaseHelper.instance.getTaskList();
    });
  }

  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');

  Widget tiles(Task task) {
    return ListTile(
      title: Text(task.title!,
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              decoration: task.status == 0
                  ? TextDecoration.none
                  : TextDecoration.lineThrough)),
      subtitle: Text(
        _dateFormatter.format(task.date!),
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            decoration: task.status == 0
                ? TextDecoration.none
                : TextDecoration.lineThrough),
      ),
      trailing: Checkbox(
        onChanged: (value) {
          task.status = value! ? 1 : 0;
          DatabaseHelper.instance.updateTask(task);
          _updateTaskList();
        },
        value: true,
        activeColor: Colors.blue,
      ),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return TaskScreen(task: task, updateTaskList: _updateTaskList,);
        }));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TaskScreen(
                    updateTaskList: _updateTaskList,
                  ),
                ),
              );
            },
          ),
          body: FutureBuilder<List<Task>>(
              future: _taskList,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final int completedTaskCount = snapshot.data!
                    .where((Task task) => task.status == 1)
                    .toList()
                    .length;

                return ListView.builder(
                    itemCount: 1 + snapshot.data!.length,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Column(
                            children: [
                              Text(
                                'My Task',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                  '$completedTaskCount of ${snapshot.data!.length} completed',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600))
                            ],
                          ),
                        );
                      }
                      return tiles(snapshot.data![index - 1]);
                    });
              })),
    );
  }
}
