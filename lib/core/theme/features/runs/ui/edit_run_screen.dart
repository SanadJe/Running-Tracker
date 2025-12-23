import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/run_model.dart';
import '../provider/runs_provider.dart';

class EditRunScreen extends StatefulWidget {
  final Run run;

  const EditRunScreen({super.key, required this.run});

  @override
  State<EditRunScreen> createState() => _EditRunScreenState();
}

class _EditRunScreenState extends State<EditRunScreen> {
  late TextEditingController titleController;
  late TextEditingController notesController;
  late TextEditingController distanceController;
  late TextEditingController durationController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.run.title);
    notesController = TextEditingController(text: widget.run.notes);
    distanceController =
        TextEditingController(text: widget.run.distance.toString());
    durationController =
        TextEditingController(text: widget.run.duration.toString());
  }

  @override
  void dispose() {
    titleController.dispose();
    notesController.dispose();
    distanceController.dispose();
    durationController.dispose();
    super.dispose();
  }

  void _saveChanges() async {
    final updatedRun = widget.run.copyWith(
      title: titleController.text,
      notes: notesController.text,
      distance: double.tryParse(distanceController.text) ?? 0,
      duration: int.tryParse(durationController.text) ?? 0,
       updatedAt: DateTime.now(), createdAt: widget.run.createdAt,
    );

    await context.read<RunProvider>().updateRun(updatedRun);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Run')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: distanceController,
              decoration: const InputDecoration(labelText: 'Distance (km)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: durationController,
              decoration: const InputDecoration(labelText: 'Duration (min)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: notesController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _saveChanges,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
