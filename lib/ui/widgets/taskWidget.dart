import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/task.dart';
import '../../providers/taskProvider.dart';
import '../../ui/screens/detailsTaskView.dart';

class TaskWidget extends StatefulWidget {
  final Task task;
  const TaskWidget({Key? key, required this.task}) : super(key: key);

  @override

  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell( // rectangle that responds to touch
      onTap: () {
        _navigateToDetailsTaskView(context);
      },
      child: Card(
        color: const Color(0xFFFFF3E0),
        margin: const EdgeInsets.all(12.0),
        child: Opacity(
          opacity: widget.task.isCompleted ? 0.5 : 1.0,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0), // Adjust this value as needed
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.task.name,
                          style: const TextStyle(
                            fontFamily: 'Sanchez',
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Date: ${widget.task.date}',
                          style: const TextStyle(fontFamily: 'Sanchez'),
                        ),
                        Text(
                          'Location: ${widget.task.location}',
                          style: const TextStyle(fontFamily: 'Sanchez'),
                        ),
                        Text(
                          'Description: ${widget.task.description}',
                          style: const TextStyle(fontFamily: 'Sanchez'),
                        ),
                        Text(
                          'Priority: ${widget.task.priority}',
                          style: const TextStyle(fontFamily: 'Sanchez'),
                        ),
                      ],
                    ),
                  ),
                ),
                Checkbox(
                  value: widget.task.isCompleted,
                  onChanged: (value) {
                    setState(() {
                      widget.task.isCompleted = value!;
                    });
                    final taskRepository = Provider.of<TaskProvider>(context, listen: false);
                    taskRepository.updateFlag(widget.task.id!, value!);
                  },
                ),
              ],
            ),
          ),
        ),
      ),



    );
  }

  void _navigateToDetailsTaskView(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailsTaskView(task: widget.task)),
    );
  }
}
