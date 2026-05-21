import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/empty_state.dart';
import '../../common/app_motion.dart';
import '../../common/loading_state.dart';
import '../../common/responsive.dart';
import '../../constants/app_colors.dart';
import '../../controllers/profile_controller.dart';
import '../../models/models.dart';

class LeaderboardView extends StatefulWidget {
  const LeaderboardView({super.key});

  @override
  State<LeaderboardView> createState() => _LeaderboardViewState();
}

class _LeaderboardViewState extends State<LeaderboardView> {
  final ProfileController controller = Get.find<ProfileController>();
  String timeFilter = 'weekly';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.loadLeaderboard();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<LeaderboardEntryModel> _filteredEntries() {
    final entries = controller.leaderboard.toList();
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      return entries
          .where((e) => e.fullName.toLowerCase().contains(query))
          .toList();
    }
    return entries;
  }

  void _showUserProfile(LeaderboardEntryModel entry) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _UserProfileSheet(entry: entry),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      body: SafeArea(
        child: PageShell(
          padding: EdgeInsets.zero,
          child: GameListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            children: [
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
                  const Icon(
                    Icons.emoji_events_rounded,
                    color: AppColors.date,
                    size: 28,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () =>
                        controller.loadLeaderboard(period: timeFilter),
                    icon: const Icon(
                      Icons.refresh_rounded,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildSearchBar(),
              const SizedBox(height: 12),
              _TimeFilters(
                value: timeFilter,
                onChanged: (v) {
                  setState(() => timeFilter = v);
                  controller.loadLeaderboard(period: v);
                },
              ),
              const SizedBox(height: 24),
              Obx(() {
                final entries = _filteredEntries();
                final topThree = entries.take(3).toList();
                final remaining = entries.skip(3).toList();
                if (controller.loading.value && entries.isEmpty) {
                  return const LoadingState(message: 'Loading leaderboard...');
                }
                if (entries.isEmpty) {
                  return const EmptyState(
                    icon: Icons.leaderboard_rounded,
                    title: 'No leaderboard data yet',
                    subtitle:
                        'Rankings will appear here after learners earn Injaz points.',
                  );
                }
                return Column(
                  children: [
                    _Podium(
                      entries: topThree,
                      onTap: _showUserProfile,
                    ),
                    const SizedBox(height: 24),
                    ...remaining.map(
                      (entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _LeaderboardRow(
                          entry: entry,
                          onTap: () => _showUserProfile(entry),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFE5E5E5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (v) => setState(() => _searchQuery = v),
        decoration: InputDecoration(
          hintText: 'Search learners...',
          hintStyle: TextStyle(color: AppColors.muted, fontSize: 14),
          prefixIcon:
              Icon(Icons.search_rounded, color: AppColors.muted, size: 22),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.close_rounded,
                      color: AppColors.muted, size: 20),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
    const filters = {
      'weekly': 'Weekly',
      'monthly': 'Monthly',
      'alltime': 'All Time',
    };
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
                  border: selected
                      ? null
                      : Border.all(color: const Color(0xFFE5E5E5)),
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
  const _Podium({required this.entries, required this.onTap});

  final List<LeaderboardEntryModel> entries;
  final void Function(LeaderboardEntryModel) onTap;

  @override
  Widget build(BuildContext context) {
    if (entries.length < 3) return const SizedBox.shrink();

    final first = entries[0];
    final second = entries[1];
    final third = entries[2];

    return Column(
      children: [
        GestureDetector(
          onTap: () => onTap(first),
          child: _PodiumAvatar(
            entry: first,
            size: 84,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => onTap(second),
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
                    const SizedBox(height: 23),
                    const _PodiumBlock(
                      place: 2,
                      height: 110,
                      color: Color(0xFF9CA3AF),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  _PodiumNameCard(entry: first, large: true),
                  const SizedBox(height: 8),
                  const _PodiumBlock(
                    place: 1,
                    height: 150,
                    color: AppColors.palm,
                  ),
                ],
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => onTap(third),
                child: Column(
                  children: [
                    _PodiumAvatar(
                      entry: third,
                      size: 64,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFCD7F32), Color(0xFFA0522D)],
                      ),
                    ),
                    const SizedBox(height: 21),
                    _PodiumNameCard(entry: third),
                    const SizedBox(height: 6),
                    const _PodiumBlock(
                      place: 3,
                      height: 90,
                      color: Color(0xFFD97706),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PodiumAvatar extends StatelessWidget {
  const _PodiumAvatar({
    required this.entry,
    required this.size,
    required this.gradient,
  });

  final LeaderboardEntryModel entry;
  final double size;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    final imageUrl = entry.profilePictureUrl;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: gradient,
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: imageUrl != null && imageUrl.isNotEmpty
            ? ClipOval(
                child: Image.network(
                  imageUrl,
                  width: size - 8,
                  height: size - 8,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => _initialsAvatar(entry, size),
                ),
              )
            : _initialsAvatar(entry, size),
      ),
    );
  }

  Widget _initialsAvatar(LeaderboardEntryModel entry, double size) {
    return Text(
      entry.initials,
      style: TextStyle(
        color: Colors.white,
        fontSize: size * 0.35,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _PodiumNameCard extends StatelessWidget {
  const _PodiumNameCard({required this.entry, this.large = false});

  final LeaderboardEntryModel entry;
  final bool large;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: large ? 16 : 12,
        vertical: large ? 12 : 10,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            entry.fullName,
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
            '${entry.injazCount} Injaz',
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
  const _PodiumBlock({
    required this.place,
    required this.height,
    required this.color,
  });

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
  const _LeaderboardRow({required this.entry, required this.onTap});

  final LeaderboardEntryModel entry;
  final VoidCallback onTap;

  Color get _avatarColor {
    final name = entry.fullName;
    if (name.contains('FD')) return const Color(0xFF4ADE80);
    if (name.contains('RE')) return const Color(0xFFA855F7);
    if (name.contains('DK')) return const Color(0xFFFB923C);
    if (name.contains('CM')) return const Color(0xFF2DD4BF);
    if (name.contains('DB')) return const Color(0xFFF472B6);
    return AppColors.palm;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
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
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _avatarColor,
              ),
              child: Center(
                child: Text(
                  entry.initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.fullName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${entry.injazCount} Injaz',
                    style:
                        const TextStyle(fontSize: 13, color: AppColors.muted),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
          ],
        ),
      ),
    );
  }
}

class _UserProfileSheet extends StatelessWidget {
  const _UserProfileSheet({required this.entry});

  final LeaderboardEntryModel entry;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: entry.rank <= 3
                      ? const [Color(0xFFFFD700), Color(0xFFFFA500)]
                      : [AppColors.palm, AppColors.palmDark],
                ),
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  entry.initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 28,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              entry.fullName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _StatChip(
                  icon: Icons.diamond_rounded,
                  label: '${entry.injazCount}',
                  subtitle: 'Injaz',
                  color: AppColors.accent,
                ),
                const SizedBox(width: 16),
                _StatChip(
                  icon: Icons.leaderboard_rounded,
                  label: '#${entry.rank}',
                  subtitle: 'Rank',
                  color: AppColors.palm,
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.palm,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Close',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: color.withValues(alpha: 0.7),
                ),
              ),
            ],
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
