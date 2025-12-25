import 'package:flutter/material.dart';
import 'package:gano/core/theme/theme_provider.dart';
import 'package:gano/core/theme/widgets/app_button.dart';
import 'package:gano/core/theme/widgets/section_title.dart';
import 'package:gano/core/theme/widgets/stat_card.dart';
import 'package:provider/provider.dart';

import '../models/run_model.dart';
import '../provider/runs_provider.dart';
import 'add_run_screen.dart';
import 'edit_run_screen.dart';

class RunsScreen extends StatelessWidget {
  const RunsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    final provider = context.read<RunProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Running Tracker'),
        actions: [
          IconButton(
            icon: Icon(theme.isDark ? Icons.dark_mode : Icons.light_mode),
            onPressed: theme.toggleTheme,
          )
        ],
      ),
      body: StreamBuilder<List<Run>>(
        stream: provider.runsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final runs = snapshot.data ?? [];

          final totalDistance =
              runs.fold<double>(0.0, (s, r) => s + r.distance);

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle(title: 'Statistics'),
                Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        title: 'Total Distance',
                        value: '${totalDistance.toStringAsFixed(1)} km',
                        subtitle: 'All runs',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatCard(
                        title: 'Total Runs',
                        value: '${runs.length}',
                        subtitle: 'Count',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                AppButton(
                  text: 'Add Run',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddRunScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                const SectionTitle(title: 'Runs'),
                Expanded(
                  child: runs.isEmpty
                      ? const Center(child: Text('No runs yet'))
                      : ListView.builder(
                          itemCount: runs.length,
                          itemBuilder: (_, i) {
                            final run = runs[i];
                            return Card(
                              child: ListTile(
                                title: Text(run.title),
                                subtitle: Text(
                                  '${run.distance.toStringAsFixed(1)} km • ${run.duration} min',
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          EditRunScreen(run: run),
                                    ),
                                  );
                                },
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    provider.deleteRun(run.id);
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
