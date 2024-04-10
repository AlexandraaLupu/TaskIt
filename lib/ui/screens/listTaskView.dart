import 'package:flutter/material.dart';
import '../../providers/taskProvider.dart';
import 'package:provider/provider.dart';

import '../widgets/taskWidget.dart';

class ListTaskView extends StatelessWidget {
  const ListTaskView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TaskProvider provider = Provider.of<TaskProvider>(context);

    return Scaffold(
        appBar: AppBar( // the app bar configuration
          backgroundColor: const Color(0xFFB2DFDB),
          title: const Center(
            child: Text(
              'TaskIt',
              style: TextStyle(fontSize: 40, fontFamily: 'Rozha One'),
            ),
          ),
        ),
        backgroundColor: const Color(0xFFB2DFDB),
        floatingActionButton: FloatingActionButton( // for the add button
          // the default position is at the bottom right
          onPressed: () async {
            await Navigator.pushNamed(context, '/addTaskView');
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add, color: Colors.white),
        ),
        body: ListView.builder( // builds the list tiles
          itemCount: provider.allTasks.length,
          itemBuilder: (context, index) {
            var task = provider.allTasks[index];
            return TaskWidget(
              key: ValueKey(task.id),
              task: task,
            );
          },
        )
    );
  }
}