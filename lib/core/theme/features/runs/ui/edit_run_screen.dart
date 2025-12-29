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
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _notes;
  late final TextEditingController _distance;
  late final TextEditingController _duration;

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.run.title);
    _notes = TextEditingController(text: widget.run.notes);
    _distance = TextEditingController(text: widget.run.distance.toString());
    _duration = TextEditingController(text: widget.run.duration.toString());
  }

  @override
  void dispose() {
    _title.dispose();
    _notes.dispose();
    _distance.dispose();
    _duration.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_loading) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final distanceValue = double.tryParse(_distance.text.trim()) ?? 0.0;
    final durationValue = int.tryParse(_duration.text.trim()) ?? 0;

    setState(() => _loading = true);

    try {
      await context.read<RunProvider>().updateRun(
            runId: widget.run.id,
            title: _title.text.trim(),
            notes: _notes.text.trim(),
            distance: distanceValue,
            duration: durationValue,
          );

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Run')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _title,
                decoration: const InputDecoration(
                  labelText: 'Run Name',
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Run name required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _distance,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Distance (km)',
                  prefixIcon: const Icon(Icons.route),
                  suffixIcon: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        child: const Icon(Icons.arrow_drop_up),
                        onTap: () {
                          final current =
                              double.tryParse(_distance.text) ?? 0.0;
                          _distance.text = (current + 0.5).toStringAsFixed(1);
                        },
                      ),
                      InkWell(
                        child: const Icon(Icons.arrow_drop_down),
                        onTap: () {
                          final current =
                              double.tryParse(_distance.text) ?? 0.0;
                          if (current > 0.5) {
                            _distance.text = (current - 0.5).toStringAsFixed(1);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                validator: (v) {
                  final x = double.tryParse((v ?? '').trim());
                  if (x == null || x <= 0) {
                    return 'Enter valid distance';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 12),
              TextFormField(
                controller: _duration,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Time (minutes)',
                  prefixIcon: Icon(Icons.timer),
                ),
                validator: (v) {
                  final x = int.tryParse((v ?? '').trim());
                  if (x == null || x <= 0) return 'Enter valid duration';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notes,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  prefixIcon: Icon(Icons.notes),
                ),
              ),
              const SizedBox(height: 18),
              FilledButton(
                onPressed: _loading ? null : _save,
                child: Text(_loading ? 'Saving...' : 'Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
