import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/taskProvider.dart';
import '../../models/task.dart';

class EditTaskView extends StatefulWidget {
  final Task task;

  const EditTaskView({Key? key, required this.task}) : super(key: key);

  @override
  State<EditTaskView> createState() => _EditTaskViewState();
}

class _EditTaskViewState extends State<EditTaskView> {
  String _selectedPriority = 'Low'; // Default priority
  DateTime? _selectedDate;

  String? _nameError;
  String? _dateError;
  String? _locationError;
  String? _descriptionError;

  bool _checkFields(TaskProvider provider) {
    bool error = false;
    if (provider.nameController.text.isEmpty) {
      setState(() {
        _nameError = 'Name cannot be empty';
      });
      error = true;
    }
    if (provider.dateController.text.isEmpty) {
      setState(() {
        _dateError = 'Date cannot be empty';
      });
      error = true;
    }
    if (provider.locationController.text.isEmpty) {
      setState(() {
        _locationError = 'Location cannot be empty';
      });
      error = true;
    }
    if (provider.descriptionController.text.isEmpty) {
      setState(() {
        _descriptionError = 'Description cannot be empty';
      });
      error = true;
    }
    return error;
  }

  void _showValidationSnackBar(
      BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: color,
    ));
  }

  Future<void> _selectDate(BuildContext context, TaskProvider provider, DateTime taskDate) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: taskDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    )) ??
        DateTime.now();

    if (picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        provider.dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);
      });
      setState(() {
        _dateError = null;
      });
    }
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    VoidCallback? onTap,
    String? error,
    VoidCallback? onChanged,
  }) {
    return Column(
      children: [
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(
              fontFamily: 'Sanchez', fontWeight: FontWeight.normal),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(
                fontFamily: 'Sanchez', fontWeight: FontWeight.normal),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            errorText: error,
          ),
          onTap: onTap,
          onChanged: (value) {
            onChanged?.call();
          },
        ),
      ],
    );
  }

  void _updateRecord(BuildContext context, TaskProvider provider) {
    try {
      if (!_checkFields(provider)) {
        widget.task.name = provider.nameController.text;
        widget.task.date = provider.dateController.text;
        widget.task.location = provider.locationController.text;
        widget.task.description = provider.descriptionController.text;
        widget.task.priority = provider.priority;
        provider.update(widget.task);
        provider.nameController.clear();
        provider.dateController.clear();
        provider.locationController.clear();
        provider.descriptionController.clear();
        provider.priority = "Low";
        provider.isCompleted = false;
        Navigator.of(context).pop();
      }
    } catch (e) {
      _showValidationSnackBar(context, 'Error updating task', Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope( // Manages system back gestures.
      canPop: true,
      onPopInvoked: (_) async {
        final provider = Provider.of<TaskProvider>(context, listen: false);
        provider.nameController.clear();
        provider.dateController.clear();
        provider.locationController.clear();
        provider.descriptionController.clear();
        provider.isCompleted = false;
        provider.priority = "Low";
      },
      child: Scaffold(
        appBar: AppBar(
          title:
          const Text('Edit Task', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
              color: Colors.black),
        ),
        body: Consumer<TaskProvider>(
          builder: (context, provider, child) => SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(
                    label: 'Name',
                    controller: provider.nameController,
                    error: _nameError,
                    onChanged: () => setState(() {
                      _nameError = null;
                    }),
                  ),
                  _buildTextField(
                    label: 'Date',
                    controller: provider.dateController,
                    error: _dateError,
                    onTap: () {
                      _selectDate(context, provider, DateTime.parse(provider.dateController.text));
                    },
                    onChanged: () => setState(() {
                      _dateError = null;
                    }),
                  ),
                  _buildTextField(
                    label: 'Location',
                    controller: provider.locationController,
                    error: _locationError,
                    onChanged: () => setState(() {
                      _locationError = null;
                    }),
                  ),
                  _buildTextField(
                    label: 'Description',
                    controller: provider.descriptionController,
                    keyboardType: TextInputType.number,
                    error: _descriptionError,
                    onChanged: () => setState(() {
                      _descriptionError = null;
                    }),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: provider.priority,
                    onChanged: (String? newValue) {
                      setState(() {
                        provider.priority = newValue!;
                      });
                    },
                    items: <String>['Low', 'Medium', 'High'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: const TextStyle(
                            fontFamily: 'Sanchez', fontWeight: FontWeight.normal),
                        ),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      labelText: 'Priority',
                      labelStyle: TextStyle(
                        fontFamily: 'Sanchez', fontWeight: FontWeight.normal)
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _updateRecord(context, provider);
                    },
                    child: const Center(child: Text('Save Changes')),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}