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
  late TextEditingController title;
  late TextEditingController notes;
  late TextEditingController distance;
  late TextEditingController duration;

  @override
  void initState() {
    super.initState();
    title = TextEditingController(text: widget.run.title);
    notes = TextEditingController(text: widget.run.notes);
    distance =
        TextEditingController(text: widget.run.distance.toString());
    duration =
        TextEditingController(text: widget.run.duration.toString());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<RunProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Run')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: title, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: notes, decoration: const InputDecoration(labelText: 'Notes')),
            TextField(controller: distance, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Distance')),
            TextField(controller: duration, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Duration')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await provider.updateRun(
                  widget.run.copyWith(
                    title: title.text,
                    notes: notes.text,
                    distance: double.tryParse(distance.text) ?? 0,
                    duration: int.tryParse(duration.text) ?? 0,
                  ),
                );
                Navigator.pop(context);
              },
              child: const Text('Save'),
            )
          ],
        ),
      ),
    );
  }
}
