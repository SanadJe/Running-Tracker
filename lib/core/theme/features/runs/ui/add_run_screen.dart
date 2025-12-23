import 'package:flutter/material.dart';
import 'package:gano/core/theme/features/runs/provider/runs_provider.dart';
import 'package:gano/core/theme/theme_provider.dart';
import 'package:provider/provider.dart';

import '../models/run_model.dart';

class AddRunScreen extends StatefulWidget {
  const AddRunScreen({super.key});

  @override
  State<AddRunScreen> createState() => _AddRunScreenState();
}

class _AddRunScreenState extends State<AddRunScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _distanceController = TextEditingController();
  final _timeController = TextEditingController();
  final _descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Run'),
        actions: [
          IconButton(
            icon: Icon(theme.isDark ? Icons.dark_mode : Icons.light_mode),
            onPressed: theme.toggleTheme,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Run Name'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _distanceController,
                decoration:
                    const InputDecoration(labelText: 'Distance (km)'),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _timeController,
                decoration:
                    const InputDecoration(labelText: 'Time (minutes)'),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descController,
                decoration:
                    const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveRun,
                child: const Text('Save Run'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveRun() {
    if (!_formKey.currentState!.validate()) return;

    context.read<RunProvider>().addRun(
          Run(
            id: '',
            title: _nameController.text,
            notes: _descController.text,
            distance: double.parse(_distanceController.text),
            duration: int.parse(_timeController.text),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );

    Navigator.pop(context);
  }
}
