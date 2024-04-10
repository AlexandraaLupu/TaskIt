import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/task.dart';
import '../../providers/taskProvider.dart';
import 'package:provider/provider.dart';
import 'editTaskView.dart';

class DetailsTaskView extends StatelessWidget {
  final Task task;

  const DetailsTaskView({Key? key, required this.task}) : super(key: key);

  Widget buildRow(String label, String value) { // build a row with a label and the value
    return Row(
      children: [
        Expanded(
          child: Column( // label
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                    fontFamily: 'Sanchez', fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column( // value
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                    fontFamily: 'Sanchez', fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
        builder: ((context, provider, child) => Scaffold(
              appBar: AppBar(
                backgroundColor: new Color(0xFFB2DFDB),
                title: Text('Task Details'),
                iconTheme: const IconThemeData(color: Colors.black),
                actions: [
                  InkWell( // for edit button
                      onTap: () {
                        provider.nameController.text = task.name;
                        provider.dateController.text = task.date;
                        provider.locationController.text =
                            task.location;
                        provider.descriptionController.text =
                            task.description;
                        provider.priority = task.priority;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) =>
                                    EditTaskView(task: task))));
                      },
                      child: const Icon(Icons.edit, color: Colors.orange)),
                  const SizedBox(width: 20),
                  InkWell( // delete button
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Confirm Deletion"),
                            content: const Text(
                                "Are you sure you want to delete this task?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  provider.delete(task.id!);
                                  Navigator.pop(context);
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Delete",
                                    style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Icon(Icons.delete, color: Colors.red),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
              backgroundColor: const Color(0xFFB2DFDB),
              body: SingleChildScrollView(
                  child: Column(children: [
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.all(30),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(5)),
                  height: 170,
                  width: double.infinity,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildRow("Name: ", task.name),
                        buildRow("Date: ", task.date),
                        buildRow("Location: ", task.location),
                        buildRow("Description: ", task.description),
                        buildRow("Priority: ", task.priority)
                      ]),
                ),
                const SizedBox(height: 20),
              ])),
            )));
  }
}
