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

class RunsScreen extends StatefulWidget {
  const RunsScreen({super.key});

  @override
  State<RunsScreen> createState() => _RunsScreenState();
}

class _RunsScreenState extends State<RunsScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();

    // أول تحميل
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RunProvider>().fetchFirstPage();
    });

    // Lazy load عند النزول
    _scrollCtrl.addListener(() {
      final provider = context.read<RunProvider>();
      if (_scrollCtrl.position.pixels >= _scrollCtrl.position.maxScrollExtent - 200) {
        provider.loadMore();
      }
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  List<Run> _applySearch(List<Run> runs) {
    final q = _searchCtrl.text.trim().toLowerCase();
    if (q.isEmpty) return runs;
    return runs.where((r) {
      return r.title.toLowerCase().contains(q) || (r.notes).toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    final runsProvider = context.watch<RunProvider>();

    final filteredRuns = _applySearch(runsProvider.runs);
    final totalDistance = runsProvider.totalDistance;
    final totalRuns = runsProvider.totalRuns;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Running Tracker'),
        actions: [
          IconButton(
            icon: Icon(theme.isDark ? Icons.dark_mode : Icons.light_mode),
            onPressed: theme.toggleTheme,
          ),
        ],
      ),
      body: runsProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => runsProvider.fetchFirstPage(),
              child: ListView(
                controller: _scrollCtrl,
                padding: const EdgeInsets.all(16),
                children: [
                  // Search Bar أعلى الصفحة
                  TextField(
                    controller: _searchCtrl,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Search runs...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  const SectionTitle(title: 'Statistics'),
                  const SizedBox(height: 8),

                  // 2 Widgets بجانب بعض: Total Distance + Total Runs
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
                          value: '$totalRuns',
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
                        MaterialPageRoute(builder: (_) => const AddRunScreen()),
                      );
                    },
                  ),

                  const SizedBox(height: 24),
                  const SectionTitle(title: 'Runs'),
                  const SizedBox(height: 8),

                  if (filteredRuns.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Center(child: Text('No runs yet')),
                    ),

                  ...filteredRuns.map((run) {
                    return Card(
                      child: ListTile(
                        title: Text(run.title),
                        subtitle: Text('${run.distance} km • ${run.duration} min'),
                        onTap: () {
                          // فتح Edit Run
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => EditRunScreen(run: run)),
                          );
                        },
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => runsProvider.deleteRun(run.id),
                        ),
                      ),
                    );
                  }),

                  // Loading more indicator
                  if (runsProvider.isLoadingMore)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    ),

                  
                ],
              ),
            ),
    );
  }
}
