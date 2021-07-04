import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqlfile_app/helpeabase_helpers.dart';
import 'package:sqlfile_app/helpers/database_helpers.dart';

import 'package:sqlfile_app/models/task_model.dart';

class TaskScreen extends StatefulWidget {
  final Task? task;
  final Function? updateTaskList;

  TaskScreen({
    this.task,
    this.updateTaskList,
  });
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _title = '';
  DateTime? _date = DateTime.now();

  TextEditingController dateController = TextEditingController();
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');

  handleDatePicker() async {
    DateTime? date = await showDatePicker(
      context: context,
      lastDate: DateTime(2050),
      initialDate: _date!,
      firstDate: DateTime(2000),
    );
    if (date != null && date != _date) {
      setState(() {
        _date = date;
      });
      dateController.text = _dateFormatter.format(date);
    }
  }

  _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print('$_title, $_date');

      Task task = Task(title: _title, date: _date);
      if (widget.task == null) {
        task.status = 0;
        DatabaseHelper.instance.insertTask(task);
      } else {
        task.status = widget.task!.status;
        DatabaseHelper.instance.updateTask(task);
      }
      widget.updateTaskList!();
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _title = widget.task!.title;

      _date = widget.task!.date;
    }
    dateController.text = _dateFormatter.format(_date!);
  }

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back_ios),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Add Task',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Form(
                  key: _formKey,
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TextFormField(
                        style: TextStyle(fontSize: 20, color: Colors.red),
                        decoration: InputDecoration(
                          labelText: 'Title',
                          labelStyle: TextStyle(fontSize: 18),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        validator: (input) {
                          if (input!.trim().isEmpty)
                            return ("Please enter a title");
                        },
                        onSaved: (input) {
                          _title = input;
                        },
                        initialValue: _title,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TextFormField(
                        readOnly: true,
                        onTap: handleDatePicker,
                        controller: dateController,
                        style: TextStyle(fontSize: 20, color: Colors.red),
                        decoration: InputDecoration(
                          labelText: 'Date',
                          labelStyle: TextStyle(fontSize: 18),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 80,
                  width: double.infinity,
                  child: Center(
                    child: TextButton(
                      onPressed: _submit,
                      child: Text(
                        'Add',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(30)),
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}
