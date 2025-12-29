import 'package:flutter/material.dart';
import 'package:gano/core/theme/features/auth/provider/auth_provider.dart';
import 'package:gano/core/theme/features/runs/models/run_model.dart';
import 'package:gano/core/theme/features/runs/provider/runs_provider.dart';
import 'package:gano/core/theme/features/runs/ui/add_run_screen.dart';
import 'package:gano/core/theme/features/runs/ui/edit_run_screen.dart';
import 'package:gano/core/theme/theme_provider.dart';
import 'package:provider/provider.dart';



class RunsScreen extends StatefulWidget {
  const RunsScreen({super.key});

  @override
  State<RunsScreen> createState() => _RunsScreenState();
}

class _RunsScreenState extends State<RunsScreen> {
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Running Tracker'),
        actions: [
          IconButton(
            icon: Icon(theme.isDark ? Icons.dark_mode : Icons.light_mode),
            onPressed: theme.toggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthProvider>().logout(),
          ),
        ],
      ),
      body: StreamBuilder<List<Run>>(
        stream: context.read<RunProvider>().runsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Something went wrong\n${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final runs = snapshot.data ?? [];

          final filtered = _query.trim().isEmpty
              ? runs
              : runs.where((r) {
                  final q = _query.toLowerCase();
                  return r.title.toLowerCase().contains(q) ||
                      r.notes.toLowerCase().contains(q);
                }).toList();

          final totalDistance = runs.fold<double>(0, (sum, r) => sum + r.distance);
          final totalRuns = runs.length;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search bar أعلى الصفحة (بدون تقطيع)
                TextField(
                  controller: _searchController,
                  focusNode: _searchFocus,
                  decoration: InputDecoration(
                    labelText: 'Search runs',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _query.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                _query = '';
                                _searchController.clear();
                              });
                              _searchFocus.requestFocus();
                            },
                          ),
                  ),
                  onChanged: (v) => setState(() => _query = v),
                ),
                const SizedBox(height: 14),

                // Stats
                Row(
                  children: [
                    Expanded(
                      child: _StatBox(
                        title: 'Total Distance',
                        value: '${totalDistance.toStringAsFixed(1)} km',
                        icon: Icons.route,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatBox(
                        title: 'Total Runs',
                        value: '$totalRuns',
                        icon: Icons.directions_run,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Add Run
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Add Run'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AddRunScreen()),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 14),

                Expanded(
                  child: filtered.isEmpty
                      ? const Center(child: Text('No runs found'))
                      : ListView.builder(
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final run = filtered[index];

                            return Card(
                              child: ListTile(
                                leading: const Icon(Icons.directions_run),
                                title: Text(run.title),
                                subtitle: Text(
                                  '${run.distance.toStringAsFixed(1)} km • ${run.duration} min',
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => EditRunScreen(run: run),
                                    ),
                                  );
                                },
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      tooltip: 'Edit',
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => EditRunScreen(run: run),
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      tooltip: 'Delete',
                                      icon: const Icon(Icons.delete),
                                      color: Colors.red,
                                      onPressed: () async {
                                        try {
                                          await context.read<RunProvider>().deleteRun(run.id);
                                        } catch (e) {
                                          if (!context.mounted) return;
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Failed to delete: $e')),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatBox({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(height: 4),
                  Text(value, style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
