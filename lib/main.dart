import 'package:flutter/material.dart';
import '../providers/taskProvider.dart';
import '../ui/screens/listTaskView.dart';
import '../ui/screens/addTaskView.dart';
import 'package:provider/provider.dart';
import '../data_repository/dbHelper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await DBhelper.dbHelper.initDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider( // manage state with ChangeNotifier
      providers: [
        ChangeNotifierProvider<TaskProvider>(
          create: (context) => TaskProvider(),
        ),
      ],
      child: const InitApp(),
    );
  }
}

class InitApp extends StatelessWidget {
  const InitApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TaskIt',
      //theme: ThemeData(fontFamily: 'Roboto'),
      home: const ListTaskView(),
      routes: {
        '/addTaskView': (context) => const AddTaskView(),
        '/listTaskView': (context) => const ListTaskView(),
      },
    );
  }
}