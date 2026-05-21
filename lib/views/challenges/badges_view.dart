import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/empty_state.dart';
import '../../common/loading_state.dart';
import '../../constants/app_colors.dart';
import '../../controllers/gamification_controller.dart';
import '../../models/models.dart';

class BadgesView extends StatefulWidget {
  const BadgesView({super.key});

  @override
  State<BadgesView> createState() => _BadgesViewState();
}

class _BadgesViewState extends State<BadgesView> {
  final GamificationController _gamification = Get.find<GamificationController>();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _sortBy = 'injaz_high';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _gamification.load();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_gamification.loading.value && _gamification.badgeConfig.isEmpty) {
        return const LoadingState(message: 'Loading badges...');
      }

      final badgeConfig = _gamification.badgeConfig;
      final achievements = _gamification.achievements;
      final injazStock = _gamification.stock.value.injazStock;

      if (badgeConfig.isEmpty) {
        return const EmptyState(
          icon: Icons.military_tech_outlined,
          title: 'No badges available',
          subtitle: 'Badges will appear here once available.',
        );
      }

      final allBadges = _parseBadges(badgeConfig, achievements);
      final filteredBadges = _filterAndSort(allBadges);
      final earnedBadges =
          filteredBadges.where((b) => b.earned).toList();
      final lockedBadges =
          filteredBadges.where((b) => !b.earned).toList();

      return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        children: [
          _buildSearchBar(),
          const SizedBox(height: 12),
          _buildSortDropdown(),
          const SizedBox(height: 20),
          if (filteredBadges.isEmpty)
            _buildEmptySearch()
          else ...[
            if (earnedBadges.isNotEmpty) ...[
              _buildSectionTitle(
                'Earned',
                Icons.check_circle_rounded,
                AppColors.correctGreen,
                earnedBadges.length,
              ),
              const SizedBox(height: 12),
              ...earnedBadges.map((b) => _buildBadgeCard(b)),
              const SizedBox(height: 24),
            ],
            if (lockedBadges.isNotEmpty) ...[
              _buildSectionTitle(
                'Locked',
                Icons.lock_rounded,
                AppColors.muted,
                lockedBadges.length,
              ),
              const SizedBox(height: 12),
              ...lockedBadges.map((b) => _buildBadgeCard(b)),
              const SizedBox(height: 24),
            ],
          ],
          _buildInjazFooter(injazStock),
          const SizedBox(height: 24),
        ],
      );
    });
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.border),
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
          hintText: 'Search badges...',
          hintStyle: TextStyle(color: AppColors.muted, fontSize: 14),
          prefixIcon: Icon(Icons.search_rounded, color: AppColors.muted, size: 22),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.close_rounded, color: AppColors.muted, size: 20),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildSortDropdown() {
    return Row(
      children: [
        Icon(Icons.sort_rounded, size: 18, color: AppColors.muted),
        const SizedBox(width: 8),
        Text(
          'Sort by:',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.muted,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _sortBy,
              isDense: true,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
              items: const [
                DropdownMenuItem(
                  value: 'injaz_high',
                  child: Text('Injaz High → Low'),
                ),
                DropdownMenuItem(
                  value: 'injaz_low',
                  child: Text('Injaz Low → High'),
                ),
                DropdownMenuItem(
                  value: 'title_az',
                  child: Text('Title A → Z'),
                ),
              ],
              onChanged: (v) {
                if (v != null) setState(() => _sortBy = v);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, Color color, int count) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '$count',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBadgeCard(_BadgeData badge) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: badge.earned
              ? AppColors.correctGreen.withValues(alpha: 0.3)
              : AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: badge.earned
                  ? AppColors.correctGreen.withValues(alpha: 0.1)
                  : AppColors.muted.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              badge.earned
                  ? Icons.military_tech_rounded
                  : Icons.lock_rounded,
              color: badge.earned ? AppColors.correctGreen : AppColors.muted,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  badge.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.diamond_rounded,
                      size: 14,
                      color: AppColors.gold,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${badge.injazTarget} Injaz',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.gold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (badge.earned)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.correctGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Earned',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.correctGreen,
                ),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.muted.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Target',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.muted,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptySearch() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 48,
            color: AppColors.muted.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 12),
          const Text(
            'No badges found for your search',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInjazFooter(int injazStock) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.diamond_rounded, size: 20, color: AppColors.accent),
          const SizedBox(width: 8),
          Text(
            'Your current Activity Injaz: $injazStock',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.accent,
            ),
          ),
        ],
      ),
    );
  }

  List<_BadgeData> _parseBadges(
    Map<String, dynamic> config,
    List<AchievementModel> achievements,
  ) {
    final earnedTitles = achievements
        .where((a) => a.achieved)
        .map((a) => a.achievementTitle.toLowerCase())
        .toSet();

    final badges = <_BadgeData>[];
    config.forEach((key, value) {
      if (value is Map) {
        final title = (value['title'] ?? value['name'] ?? key).toString();
        final injaz = _parseInt(value['injaz'] ?? value['injazTarget'] ?? value['target']);
        final earned = earnedTitles.contains(title.toLowerCase()) ||
            value['earned'] == true;
        badges.add(_BadgeData(
          id: key,
          title: title,
          injazTarget: injaz,
          earned: earned,
        ));
      }
    });
    return badges;
  }

  int _parseInt(dynamic v) {
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }

  List<_BadgeData> _filterAndSort(List<_BadgeData> badges) {
    var result = badges;

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      result =
          result.where((b) => b.title.toLowerCase().contains(query)).toList();
    }

    switch (_sortBy) {
      case 'injaz_high':
        result.sort((a, b) => b.injazTarget.compareTo(a.injazTarget));
        break;
      case 'injaz_low':
        result.sort((a, b) => a.injazTarget.compareTo(b.injazTarget));
        break;
      case 'title_az':
        result.sort(
            (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
    }

    return result;
  }
}

class _BadgeData {
  const _BadgeData({
    required this.id,
    required this.title,
    required this.injazTarget,
    required this.earned,
  });

  final String id;
  final String title;
  final int injazTarget;
  final bool earned;
}
