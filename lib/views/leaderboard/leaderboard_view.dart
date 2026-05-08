import 'package:flutter/material.dart';

import '../../common/empty_state.dart';
import '../../common/app_motion.dart';
import '../../common/responsive.dart';
import '../../constants/app_colors.dart';

class LeaderboardView extends StatefulWidget {
  const LeaderboardView({super.key});

  @override
  State<LeaderboardView> createState() => _LeaderboardViewState();
}

class _LeaderboardViewState extends State<LeaderboardView> {
  String timeFilter = 'weekly';

  // Demo data matching the reference image
  final List<LeaderboardEntry> entries = const [
    LeaderboardEntry(rank: 1, name: 'Maryland Winkles', injaz: 948, avatar: 'MW'),
    LeaderboardEntry(rank: 2, name: 'Andrew Ainsley', injaz: 872, avatar: 'AA'),
    LeaderboardEntry(rank: 3, name: 'Charlotte Hanlin', injaz: 769, avatar: 'CH'),
    LeaderboardEntry(rank: 4, name: 'Florencio Dollore', injaz: 723, avatar: 'FD'),
    LeaderboardEntry(rank: 5, name: 'Roselle Ehram', injaz: 640, avatar: 'RE'),
    LeaderboardEntry(rank: 6, name: 'Darron Kulinowzi', injaz: 596, avatar: 'DK'),
    LeaderboardEntry(rank: 7, name: 'Clinton Mcclure', injaz: 537, avatar: 'CM'),
    LeaderboardEntry(rank: 8, name: 'Darcell Ballentine', injaz: 481, avatar: 'DB'),
  ];

  @override
  Widget build(BuildContext context) {
    final topThree = entries.take(3).toList();
    final remaining = entries.skip(3).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      body: SafeArea(
        child: PageShell(
          padding: EdgeInsets.zero,
          child: GameListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            children: [
              // Header
              Row(
                children: [
                  Text(
                    'Leaderboard',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: AppColors.ink,
                        ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.emoji_events_rounded, color: AppColors.date, size: 28),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.search_rounded, color: AppColors.muted),
                  ),
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
                const SizedBox(height: 24),
                ...remaining.map((entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _LeaderboardRow(entry: entry),
                    )),
                const SizedBox(height: 20),
              ],
            ],
          ),
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
            child: GestureDetector(
              onTap: () => onChanged(filter.key),
              child: AnimatedContainer(
                duration: AppMotion.fast,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: selected ? const Color(0xFFE8D5B7) : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: selected ? null : Border.all(color: const Color(0xFFE5E5E5)),
                ),
                child: Center(
                  child: Text(
                    filter.value,
                    style: TextStyle(
                      color: selected ? AppColors.ink : AppColors.muted,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
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
    if (entries.length < 3) return const SizedBox.shrink();

    final first = entries[0];
    final second = entries[1];
    final third = entries[2];

    return Column(
      children: [
        // 1st place avatar
        _PodiumAvatar(
          entry: first,
          size: 84,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF9333EA), Color(0xFF7C3AED)],
          ),
        ),
        const SizedBox(height: 8),
        // Three columns
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 2nd place
            Expanded(
              child: Column(
                children: [
                  _PodiumAvatar(
                    entry: second,
                    size: 64,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFCBD5E1), Color(0xFF9CA3AF)],
                    ),
                  ),
                  const SizedBox(height: 2),
                  _PodiumNameCard(entry: second),
                  const SizedBox(height: 8),
                  _PodiumBlock(place: 2, height: 110, color: const Color(0xFF9CA3AF)),
                ],
              ),
            ),
            // 1st place
            Expanded(
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  _PodiumNameCard(entry: first, large: true),
                  const SizedBox(height: 8),
                  _PodiumBlock(place: 1, height: 150, color: AppColors.palm),
                ],
              ),
            ),
            // 3rd place
            Expanded(
              child: Column(
                children: [
                  _PodiumAvatar(
                    entry: third,
                    size: 64,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFFB923C), Color(0xFFEA580C)],
                    ),
                  ),
                  const SizedBox(height: 21),
                  _PodiumNameCard(entry: third),
                  const SizedBox(height: 8),
                  _PodiumBlock(place: 3, height: 90, color: const Color(0xFFD97706)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PodiumAvatar extends StatelessWidget {
  const _PodiumAvatar({required this.entry, required this.size, required this.gradient});

  final LeaderboardEntry entry;
  final double size;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: gradient,
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Center(
        child: Text(
          entry.avatar,
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.35,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _PodiumNameCard extends StatelessWidget {
  const _PodiumNameCard({required this.entry, this.large = false});

  final LeaderboardEntry entry;
  final bool large;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: large ? 16 : 12, vertical: large ? 12 : 10),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            entry.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: large ? 15 : 13,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${entry.injaz} Injaz',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.palm,
              fontWeight: FontWeight.w800,
              fontSize: large ? 18 : 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _PodiumBlock extends StatelessWidget {
  const _PodiumBlock({required this.place, required this.height, required this.color});

  final int place;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Center(
        child: Text(
          '$place',
          style: const TextStyle(
            fontSize: 40,
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _LeaderboardRow extends StatelessWidget {
  const _LeaderboardRow({required this.entry});

  final LeaderboardEntry entry;

  Color get _avatarColor {
    switch (entry.avatar) {
      case 'FD':
        return const Color(0xFF4ADE80);
      case 'RE':
        return const Color(0xFFA855F7);
      case 'DK':
        return const Color(0xFFFB923C);
      case 'CM':
        return const Color(0xFF2DD4BF);
      case 'DB':
        return const Color(0xFFF472B6);
      default:
        return AppColors.palm;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Rank
          SizedBox(
            width: 28,
            child: Text(
              '${entry.rank}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.muted,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _avatarColor,
            ),
            child: Center(
              child: Text(
                entry.avatar,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Name and score
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${entry.injaz} Injaz',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LeaderboardEntry {
  const LeaderboardEntry({
    required this.rank,
    required this.name,
    required this.injaz,
    required this.avatar,
  });

  final int rank;
  final String name;
  final int injaz;
  final String avatar;
}
