import 'package:flutter/material.dart';

import '../../common/empty_state.dart';import '../../common/app_motion.dart';
import '../../common/responsive.dart';
import '../../constants/app_colors.dart';

class LeaderboardView extends StatefulWidget {
  const LeaderboardView({super.key});

  @override
  State<LeaderboardView> createState() => _LeaderboardViewState();
}

class _LeaderboardViewState extends State<LeaderboardView> {
  String timeFilter = 'weekly';

  // The GitHub web reference currently uses a hardcoded `leaderboardData` array.
  // Keep Flutter real-data-only: this list must be populated by an API service
  // once a real leaderboard endpoint is provided by the backend/Postman collection.
  final List<LeaderboardEntry> entries = const [];

  @override
  Widget build(BuildContext context) {
    final topThree = entries.take(3).toList();
    final remaining = entries.skip(3).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded))],
      ),
      body: PageShell(
        child: GameListView(
          children: [
            Row(
              children: [
                Text('Leaderboard', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
                const SizedBox(width: 10),
                const Icon(Icons.emoji_events_rounded, color: AppColors.date),
              ],
            ),
            const SizedBox(height: 16),
            _TimeFilters(value: timeFilter, onChanged: (v) => setState(() => timeFilter = v)),
            const SizedBox(height: 24),
            if (entries.isEmpty)
              const EmptyState(
                icon: Icons.leaderboard_rounded,
                title: 'No real leaderboard data yet',
                subtitle: 'The GitHub web app shows this page with hardcoded sample users. No leaderboard API endpoint exists in the provided Postman collection, so the Flutter app does not show demo rankings.',
              )
            else ...[
              _Podium(entries: topThree),
              const SizedBox(height: 20),
              ...remaining.map((entry) => _LeaderboardRow(entry: entry)),
            ],
          ],
        ),
      ),
    );
  }
}

class _TimeFilters extends StatelessWidget {
  const _TimeFilters({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const filters = {'weekly': 'Weekly', 'monthly': 'Monthly', 'alltime': 'All Time'};
    return Row(
      children: filters.entries.map((filter) {
        final selected = value == filter.key;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              selected: selected,
              label: Center(child: Text(filter.value)),
              onSelected: (_) => onChanged(filter.key),
              selectedColor: AppColors.palm,
              labelStyle: TextStyle(color: selected ? Colors.white : AppColors.muted, fontWeight: FontWeight.w700),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _Podium extends StatelessWidget {
  const _Podium({required this.entries});

  final List<LeaderboardEntry> entries;

  @override
  Widget build(BuildContext context) {
    LeaderboardEntry? at(int i) => entries.length > i ? entries[i] : null;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _PodiumPlace(entry: at(1), place: 2, height: 86, color: Colors.blueGrey),
        _PodiumPlace(entry: at(0), place: 1, height: 116, color: AppColors.palm, large: true),
        _PodiumPlace(entry: at(2), place: 3, height: 72, color: AppColors.date),
      ],
    );
  }
}

class _PodiumPlace extends StatelessWidget {
  const _PodiumPlace({required this.entry, required this.place, required this.height, required this.color, this.large = false});

  final LeaderboardEntry? entry;
  final int place;
  final double height;
  final Color color;
  final bool large;

  @override
  Widget build(BuildContext context) {
    if (entry == null) return const SizedBox.shrink();
    return Expanded(
      child: Column(
        children: [
          CircleAvatar(radius: large ? 34 : 28, backgroundColor: color, child: Text(entry!.avatar, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900))),
          const SizedBox(height: 8),
          Text(entry!.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800)),
          Text('${entry!.injaz} Injaz', style: const TextStyle(color: AppColors.date, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Container(height: height, decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.vertical(top: Radius.circular(18))), child: Center(child: Text('$place', style: const TextStyle(fontSize: 34, color: Colors.white, fontWeight: FontWeight.w900)))),
        ],
      ),
    );
  }
}

class _LeaderboardRow extends StatelessWidget {
  const _LeaderboardRow({required this.entry});

  final LeaderboardEntry entry;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(backgroundColor: AppColors.palm, foregroundColor: Colors.white, child: Text(entry.avatar)),
        title: Text(entry.name, style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text('${entry.injaz} Injaz'),
        trailing: Text('#${entry.rank}', style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.date)),
      ),
    );
  }
}

class LeaderboardEntry {
  const LeaderboardEntry({required this.rank, required this.name, required this.injaz, required this.avatar});

  final int rank;
  final String name;
  final int injaz;
  final String avatar;
}
