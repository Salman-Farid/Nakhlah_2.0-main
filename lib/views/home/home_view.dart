import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/app_motion.dart';
import '../../common/empty_state.dart';
import '../../common/loading_state.dart';
import '../../controllers/content_controller.dart';
import '../../controllers/gamification_controller.dart';
import '../../controllers/profile_controller.dart';
import '../../models/models.dart';
import '../../routes/app_routes.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Get.find<ProfileController>().load();
      Get.find<ContentController>().loadJourney();
      Get.find<GamificationController>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profile = Get.find<ProfileController>();
    final content = Get.find<ContentController>();
    final gamification = Get.find<GamificationController>();

    return Scaffold(
      backgroundColor: WebHomeColors.background,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: WebHomeColors.accent,
          onRefresh: () async {
            await profile.load();
            await gamification.load();
            await content.loadJourney();
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: _StatsHeaderDelegate(
                  minHeight: 72,
                  maxHeight: 72,
                  child: Obx(
                    () => _WebStatsBar(
                      streak: gamification.streak.value.currentStreak,
                      dates: gamification.stock.value.dateStock,
                      palms: gamification.stock.value.palmStock == 0
                          ? 5
                          : gamification.stock.value.palmStock,
                    ),
                  ),
                ),
              ),
              Obx(() {
                if (content.levels.isEmpty) {
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                }
                final flat = _buildJourneyView(
                  content.levels,
                  profile.profile.value?.currentProgress,
                );
                if (flat.nodes.isEmpty) {
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                }
                final current = _currentHeader(flat);
                return SliverPersistentHeader(
                  pinned: true,
                  delegate: _UnitHeaderDelegate(
                    minHeight: 112,
                    maxHeight: 112,
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 520),
                        child: _StickyUnitHeader(
                          section: current.section,
                          currentNode: current.node,
                        ),
                      ),
                    ),
                  ),
                );
              }),
              SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Obx(() {
                      if (content.loading.value && content.levels.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 96),
                          child: LoadingState(
                            message: 'Loading your journey...',
                          ),
                        );
                      }

                      if (content.levels.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(24),
                          child: EmptyState(
                            title: 'No journey found',
                            subtitle: 'Pull down to refresh.',
                          ),
                        );
                      }

                      return _LearnDashboard(
                        levels: content.levels,
                        profile: profile,
                        gamification: gamification,
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LearnDashboard extends StatelessWidget {
  const _LearnDashboard({
    required this.levels,
    required this.profile,
    required this.gamification,
  });

  final List<JourneyLevel> levels;
  final ProfileController profile;
  final GamificationController gamification;

  @override
  Widget build(BuildContext context) {
    final flat = _buildJourneyView(
      levels,
      profile.profile.value?.currentProgress,
    );

    return Column(
      children: [
        _ZigzagPath(sections: flat.sections, nodes: flat.nodes),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
          child: Column(
            children: [
              _DailyQuestsCard(controller: gamification),
              const SizedBox(height: 16),
              _ProfileSectionCard(controller: profile),
            ],
          ),
        ),
      ],
    );
  }
}

class _WebStatsBar extends StatelessWidget {
  const _WebStatsBar({
    required this.streak,
    required this.dates,
    required this.palms,
  });

  final int streak;
  final int dates;
  final int palms;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      color: WebHomeColors.primary,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _HeaderIconValue(icon: _FlameIcon(size: 34), value: streak),
          _HeaderIconValue(icon: _GemIcon(size: 34), value: dates),
          _HeaderIconValue(icon: _HeartIcon(size: 34), value: palms),
        ],
      ),
    );
  }
}

class _HeaderIconValue extends StatelessWidget {
  const _HeaderIconValue({required this.icon, required this.value});

  final Widget icon;
  final int value;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      scale: .94,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 7),
            Text(
              '$value',
              style: const TextStyle(
                color: WebHomeColors.primaryForeground,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ZigzagPath extends StatelessWidget {
  const _ZigzagPath({required this.sections, required this.nodes});

  final List<_PathSection> sections;
  final List<_PathNodeData> nodes;

  @override
  Widget build(BuildContext context) {
    if (nodes.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              for (
                var sectionIndex = 0;
                sectionIndex < sections.length;
                sectionIndex++
              )
                _SectionPath(
                  section: sections[sectionIndex],
                  nodes: nodes
                      .where((n) => n.sectionId == sections[sectionIndex].id)
                      .toList(),
                  allNodes: nodes,
                  sectionIndex: sectionIndex,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StickyUnitHeader extends StatelessWidget {
  const _StickyUnitHeader({required this.section, required this.currentNode});

  final _PathSection section;
  final _PathNodeData currentNode;

  @override
  Widget build(BuildContext context) {
    final colors = WebHomeColors.sectionGradient(section.colorIndex);
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${section.levelName.isNotEmpty ? '${section.levelName}, ' : ''}${section.name}'
                      .toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .8,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  currentNode.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    height: 1.05,
                  ),
                ),
              ],
            ),
          ),
          PressableScale(
            scale: .9,
            child: Material(
              color: Colors.white.withValues(alpha: .18),
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () {
                  Get.toNamed(Routes.lessons, arguments: currentNode.apiId);
                  Get.find<ContentController>().loadLessons(currentNode.apiId);
                },
                child: const SizedBox(
                  width: 44,
                  height: 44,
                  child: Icon(
                    Icons.description_outlined,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionPath extends StatelessWidget {
  const _SectionPath({
    required this.section,
    required this.nodes,
    required this.allNodes,
    required this.sectionIndex,
  });

  final _PathSection section;
  final List<_PathNodeData> nodes;
  final List<_PathNodeData> allNodes;
  final int sectionIndex;

  @override
  Widget build(BuildContext context) {
    if (nodes.isEmpty) return const SizedBox.shrink();
    final firstCurrent = nodes.first.isCurrent;

    return Column(
      children: [
        SizedBox(height: firstCurrent ? 34 : 8),
        _LevelBarrier(section: section, index: sectionIndex),
        SizedBox(height: firstCurrent ? 56 : 16),
        LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  children: [
                    for (var index = 0; index < nodes.length; index++)
                      SizedBox(
                        height: 112,
                        width: double.infinity,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            _LessonNodePosition(
                              node: nodes[index],
                              globalIndex: allNodes.indexWhere(
                                (n) => n.id == nodes[index].id,
                              ),
                              localIndex: index,
                              width: constraints.maxWidth,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                if (sectionIndex == 0 && nodes.length >= 2)
                  _FloatingWaterDrop(
                    left: constraints.maxWidth * .66,
                    top: 1 * 112.0 - 18,
                    delay: Duration.zero,
                  ),
                if (sectionIndex == 1 && nodes.length >= 2)
                  _FloatingWaterDrop(
                    left: constraints.maxWidth * .66,
                    top: 1 * 112.0 - 10,
                    delay: const Duration(milliseconds: 650),
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: 28),
      ],
    );
  }
}

class _FloatingWaterDrop extends StatefulWidget {
  const _FloatingWaterDrop({
    required this.left,
    required this.top,
    required this.delay,
  });

  final double left;
  final double top;
  final Duration delay;

  @override
  State<_FloatingWaterDrop> createState() => _FloatingWaterDropState();
}

class _FloatingWaterDropState extends State<_FloatingWaterDrop>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );
    _offset = Tween<double>(begin: -7, end: 7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
    Future<void>.delayed(widget.delay, () {
      if (mounted) _controller.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.left - 220,
      top: widget.top + 190,
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _offset,
          builder: (context, child) => Transform.translate(
            offset: Offset(0, _offset.value),
            child: child,
          ),
          child: Image.asset(
            'assets/nakhlah_web/water_drop_cartoon.png',
            width: 150,
            height: 145,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

class _LevelBarrier extends StatelessWidget {
  const _LevelBarrier({required this.section, required this.index});

  final _PathSection section;
  final int index;

  @override
  Widget build(BuildContext context) {
    final colors = WebHomeColors.sectionGradient(
      section.colorIndex == 0 ? index + 1 : section.colorIndex,
    );
    return Row(
      children: [
        const Expanded(child: SizedBox(height: 1)),
        Container(
          color: WebHomeColors.background,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: ShaderMask(
            shaderCallback: (rect) =>
                LinearGradient(colors: colors).createShader(rect),
            child: Text(
              section.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        const Expanded(child: SizedBox(height: 1)),
      ],
    );
  }
}

class _LessonNodePosition extends StatelessWidget {
  const _LessonNodePosition({
    required this.node,
    required this.globalIndex,
    required this.localIndex,
    required this.width,
  });

  final _PathNodeData node;
  final int globalIndex;
  final int localIndex;
  final double width;

  @override
  Widget build(BuildContext context) {
    final index = globalIndex < 0 ? localIndex : globalIndex;
    final leftPercent = 50 + math.sin(index * .8) * 25;
    final x = width * leftPercent / 100;

    return Positioned(
      left: x - 70,
      top: 0,
      child: PageEnter(
        delay: Duration(milliseconds: 135 * localIndex),
        child: SizedBox(
          width: 140,
          height: 112,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Positioned(top: 16, left: 25, child: _PathCircle(node: node)),
              if (node.isCurrent)
                const Positioned(
                  top: -46,
                  left: 20,
                  right: 20,
                  child: Center(child: _StartSpeechBubble()),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StartSpeechBubble extends StatelessWidget {
  const _StartSpeechBubble();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BubbleTailPainter(),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: WebHomeColors.accent, width: 4),
          boxShadow: const [
            BoxShadow(
              color: Color(0x26000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: const Text(
          'START!',
          style: TextStyle(
            color: WebHomeColors.accent,
            fontSize: 13,
            fontWeight: FontWeight.w900,
            letterSpacing: .9,
          ),
        ),
      ),
    );
  }
}

class _BubbleTailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final border = Paint()..color = WebHomeColors.accent;
    final fill = Paint()..color = Colors.white;
    final cx = size.width / 2;
    final borderPath = Path()
      ..moveTo(cx - 12, size.height - 13)
      ..quadraticBezierTo(cx, size.height + 5, cx + 12, size.height - 13)
      ..close();
    final fillPath = Path()
      ..moveTo(cx - 6, size.height - 11)
      ..quadraticBezierTo(cx, size.height - 1, cx + 6, size.height - 11)
      ..close();
    canvas.drawPath(borderPath, border);
    canvas.drawPath(fillPath, fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PathCircle extends StatefulWidget {
  const _PathCircle({required this.node});

  final _PathNodeData node;

  @override
  State<_PathCircle> createState() => _PathCircleState();
}

class _PathCircleState extends State<_PathCircle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bounce;
  late final Animation<double> _offset;

  @override
  void initState() {
    super.initState();
    _bounce = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _offset = Tween<double>(
      begin: 0,
      end: -8,
    ).animate(CurvedAnimation(parent: _bounce, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _bounce.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final node = widget.node;
    final isTrophy = node.type == _PathNodeType.trophy;

    final child = GestureDetector(
      onTap: node.isLocked
          ? null
          : () {
              Get.toNamed(Routes.lessons, arguments: node.apiId);
              Get.find<ContentController>().loadLessons(node.apiId);
            },
      child: PressableScale(
        scale: node.isLocked ? 1 : .91,
        child: isTrophy
            ? _TrophyNode(locked: node.isLocked)
            : _RoundNode(node: node),
      ),
    );

    if (!node.isCurrent || AppMotion.reduceMotion(context)) return child;

    return AnimatedBuilder(
      animation: _offset,
      builder: (context, child) =>
          Transform.translate(offset: Offset(0, _offset.value), child: child),
      child: child,
    );
  }
}

class _RoundNode extends StatelessWidget {
  const _RoundNode({required this.node});

  final _PathNodeData node;

  @override
  Widget build(BuildContext context) {
    final Color fill;
    final Color border;
    final double bottomDepth;
    final List<BoxShadow> shadows;

    if (node.isLocked) {
      fill = WebHomeColors.nodeLocked;
      border = WebHomeColors.nodeLockedBorder;
      bottomDepth = 4;
      shadows = const [
        BoxShadow(
          color: Color(0x1A000000),
          blurRadius: 10,
          offset: Offset(0, 6),
        ),
      ];
    } else if (node.isCurrent) {
      fill = WebHomeColors.accent;
      border = WebHomeColors.accent;
      bottomDepth = 4;
      shadows = const [
        BoxShadow(
          color: Color(0x33000000),
          blurRadius: 10,
          offset: Offset(0, 6),
        ),
      ];
    } else {
      fill = WebHomeColors.nodeYellow;
      border = WebHomeColors.nodeYellowBorder;
      bottomDepth = 6;
      shadows = const [
        BoxShadow(
          color: Color(0x26000000),
          blurRadius: 15,
          offset: Offset(0, 8),
        ),
      ];
    }

    return Container(
      width: 90,
      height: 96,
      alignment: Alignment.topCenter,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: bottomDepth,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: border,
                boxShadow: shadows,
              ),
            ),
          ),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(shape: BoxShape.circle, color: fill),
            child: Center(
              child: node.isLocked
                  ? const _LockIcon(size: 48, silver: true)
                  : const _StarIcon(size: 48),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrophyNode extends StatelessWidget {
  const _TrophyNode({required this.locked});

  final bool locked;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 96,
      height: 96,
      child: _TrophyIcon(size: 96, silver: locked),
    );
  }
}

class _DailyQuestsCard extends StatelessWidget {
  const _DailyQuestsCard({required this.controller});

  final GamificationController controller;

  @override
  Widget build(BuildContext context) {
    return _WebCard(
      child: Obx(() {
        final quests = controller.quests.take(3).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daily Quests',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: WebHomeColors.foreground,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Complete tasks to earn rewards',
                        style: TextStyle(
                          fontSize: 12,
                          color: WebHomeColors.mutedForeground,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.more_horiz_rounded,
                  color: WebHomeColors.mutedForeground,
                ),
              ],
            ),
            const SizedBox(height: 14),
            if (quests.isEmpty)
              const _QuestRow(
                icon: _GemIcon(size: 24),
                label: 'Complete a lesson today',
                completed: false,
              )
            else
              ...quests.map(
                (q) => _QuestRow(
                  icon: q.status == 'completed'
                      ? const Icon(
                          Icons.check_circle_rounded,
                          color: WebHomeColors.accent,
                          size: 24,
                        )
                      : const _GemIcon(size: 24),
                  label: q.challengeId.isEmpty
                      ? 'Daily challenge'
                      : q.challengeId,
                  completed: q.status == 'completed',
                ),
              ),
          ],
        );
      }),
    );
  }
}

class _QuestRow extends StatelessWidget {
  const _QuestRow({
    required this.icon,
    required this.label,
    required this.completed,
  });

  final Widget icon;
  final String label;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: WebHomeColors.muted.withValues(alpha: .35),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          SizedBox(width: 28, height: 28, child: Center(child: icon)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: completed
                    ? WebHomeColors.mutedForeground
                    : WebHomeColors.foreground,
                fontWeight: FontWeight.w700,
                decoration: completed
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
          ),
          if (completed)
            const Icon(Icons.check_circle_rounded, color: WebHomeColors.accent),
        ],
      ),
    );
  }
}

class _ProfileSectionCard extends StatelessWidget {
  const _ProfileSectionCard({required this.controller});

  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    return _WebCard(
      child: Obx(() {
        final profile = controller.profile.value;
        final imageUrl = profile?.profilePicture?.absoluteUrl;
        return Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: WebHomeColors.primary,
                  backgroundImage: imageUrl == null
                      ? null
                      : NetworkImage(imageUrl),
                  child: imageUrl == null
                      ? const Icon(
                          Icons.person_rounded,
                          color: WebHomeColors.primaryForeground,
                          size: 30,
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile?.fullName ?? 'Nakhlah Learner',
                        style: const TextStyle(
                          fontSize: 17,
                          color: WebHomeColors.foreground,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${profile?.onboardInfo.goalTime ?? 0} min daily goal',
                        style: const TextStyle(
                          color: WebHomeColors.mutedForeground,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: WebHomeColors.mutedForeground,
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}

class _WebCard extends StatelessWidget {
  const _WebCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: WebHomeColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: WebHomeColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _StatsHeaderDelegate extends SliverPersistentHeaderDelegate {
  _StatsHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => Material(
    color: WebHomeColors.primary,
    elevation: overlapsContent ? 4 : 0,
    child: child,
  );

  @override
  bool shouldRebuild(_StatsHeaderDelegate oldDelegate) =>
      maxHeight != oldDelegate.maxHeight ||
      minHeight != oldDelegate.minHeight ||
      child != oldDelegate.child;
}

class _UnitHeaderDelegate extends SliverPersistentHeaderDelegate {
  _UnitHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Material(
      color: WebHomeColors.background,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      child: child,
    );
  }

  @override
  bool shouldRebuild(_UnitHeaderDelegate oldDelegate) =>
      maxHeight != oldDelegate.maxHeight ||
      minHeight != oldDelegate.minHeight ||
      child != oldDelegate.child;
}

_CurrentHeader _currentHeader(_JourneyFlat flat) {
  final currentSection =
      _firstWhereOrNull<_PathSection>(
        flat.sections,
        (s) => flat.nodes.any((n) => n.sectionId == s.id && n.isCurrent),
      ) ??
      flat.sections.first;
  final sectionNodes = flat.nodes
      .where((n) => n.sectionId == currentSection.id)
      .toList();
  final currentNode =
      _firstWhereOrNull<_PathNodeData>(sectionNodes, (n) => n.isCurrent) ??
      (sectionNodes.isNotEmpty ? sectionNodes.first : flat.nodes.first);
  return _CurrentHeader(section: currentSection, node: currentNode);
}

class _CurrentHeader {
  const _CurrentHeader({required this.section, required this.node});
  final _PathSection section;
  final _PathNodeData node;
}

_JourneyFlat _buildJourneyView(
  List<JourneyLevel> journeyLevels,
  ProgressModel? progress,
) {
  final sections = <_PathSection>[];
  final nodes = <_PathNodeData>[];
  final levels = [...journeyLevels]
    ..sort((a, b) => a.levelOrder.compareTo(b.levelOrder));
  final levelOrder = progress?.levelOrder;
  final unitOrder = progress?.unitOrder;
  final taskOrder = progress?.taskOrder;
  final hasProgress =
      levelOrder != null && unitOrder != null && taskOrder != null;

  for (final level in levels) {
    final units = [...level.units]
      ..sort((a, b) => a.unitOrder.compareTo(b.unitOrder));
    for (final unit in units) {
      final sectionId = '${level.id}-${unit.id}';
      final isEarlierLevel = hasProgress && level.levelOrder < levelOrder;
      final isCurrentLevel = hasProgress && level.levelOrder == levelOrder;
      final isEarlierUnitInCurrentLevel =
          hasProgress && isCurrentLevel && unit.unitOrder < unitOrder;
      final isEarlierUnit = isEarlierLevel || isEarlierUnitInCurrentLevel;
      final isCurrentUnit =
          hasProgress && isCurrentLevel && unit.unitOrder == unitOrder;
      final unitUnlocked =
          !hasProgress ||
          isEarlierUnit ||
          isCurrentUnit ||
          unit.active ||
          level.active;
      final unitLocked = !unitUnlocked;

      sections.add(
        _PathSection(
          id: sectionId,
          name: unit.title,
          unitOrder: unit.unitOrder,
          levelOrder: level.levelOrder,
          levelName: level.title,
          colorIndex: level.levelOrder,
        ),
      );

      final tasks = [...unit.tasks]
        ..sort((a, b) => a.taskOrder.compareTo(b.taskOrder));
      final lastActiveIndex = tasks.lastIndexWhere((task) => task.active);
      for (var index = 0; index < tasks.length; index++) {
        final task = tasks[index];
        final hasTaskProgress = lastActiveIndex >= 0;
        final isEarlierTaskInCurrentUnit =
            hasProgress && isCurrentUnit && task.taskOrder < taskOrder;
        final isCurrentTask =
            hasProgress && isCurrentUnit && task.taskOrder == taskOrder;
        var isCompleted =
            (hasProgress && (isEarlierUnit || isEarlierTaskInCurrentUnit)) ||
            (!hasProgress && hasTaskProgress && index < lastActiveIndex);
        var isCurrent =
            (hasProgress && isCurrentTask) ||
            (!hasProgress && hasTaskProgress && index == lastActiveIndex);

        if (!hasProgress && !hasTaskProgress && !unitLocked && index == 0) {
          isCurrent = true;
        }
        if (task.active && !isCurrent) isCompleted = true;
        var isLocked =
            unitLocked || (!task.active && !isCurrent && !isCompleted);
        if (unitLocked) {
          isCurrent = false;
          isCompleted = false;
          isLocked = true;
        }

        nodes.add(
          _PathNodeData(
            id: '$sectionId-${task.id}',
            apiId: task.id,
            type: task.giftBox ? _PathNodeType.trophy : _PathNodeType.lesson,
            title: task.title,
            sectionId: sectionId,
            isCompleted: isCompleted,
            isCurrent: isCurrent,
            isLocked: isLocked,
          ),
        );
      }
    }
  }

  if (nodes.isNotEmpty && !nodes.any((n) => n.isCurrent || !n.isLocked)) {
    nodes[0] = nodes[0].copyWith(isCurrent: true, isLocked: false);
  }

  return _JourneyFlat(sections: sections, nodes: nodes);
}

class _JourneyFlat {
  _JourneyFlat({required this.sections, required this.nodes});
  final List<_PathSection> sections;
  final List<_PathNodeData> nodes;
}

class _PathSection {
  _PathSection({
    required this.id,
    required this.name,
    required this.unitOrder,
    required this.levelOrder,
    required this.levelName,
    required this.colorIndex,
  });
  final String id;
  final String name;
  final int unitOrder;
  final int levelOrder;
  final String levelName;
  final int colorIndex;
}

enum _PathNodeType { lesson, trophy }

class _PathNodeData {
  _PathNodeData({
    required this.id,
    required this.apiId,
    required this.type,
    required this.title,
    required this.sectionId,
    required this.isCompleted,
    required this.isCurrent,
    required this.isLocked,
  });
  final String id;
  final String apiId;
  final _PathNodeType type;
  final String title;
  final String sectionId;
  final bool isCompleted;
  final bool isCurrent;
  final bool isLocked;

  _PathNodeData copyWith({bool? isCurrent, bool? isLocked}) => _PathNodeData(
    id: id,
    apiId: apiId,
    type: type,
    title: title,
    sectionId: sectionId,
    isCompleted: isCompleted,
    isCurrent: isCurrent ?? this.isCurrent,
    isLocked: isLocked ?? this.isLocked,
  );
}

T? _firstWhereOrNull<T>(Iterable<T> items, bool Function(T item) test) {
  for (final item in items) {
    if (test(item)) return item;
  }
  return null;
}

class WebHomeColors {
  const WebHomeColors._();

  static const primary = Color(0xFFE5D09F);
  static const primaryForeground = Color(0xFF47331F);
  static const accent = Color(0xFF7D49DF);
  static const accentLight = Color(0xFFA47EEB);
  static const background = Colors.white;
  static const foreground = Color(0xFF30261D);
  static const card = Color(0xFFFCFAF6);
  static const muted = Color(0xFFEAE5DB);
  static const mutedForeground = Color(0xFF846F61);
  static const border = Color(0xFFE2D8C9);
  static const nodeYellow = Color(0xFFFFD900);
  static const nodeYellowBorder = Color(0xFFCCAE00);
  static const nodeLocked = Color(0xFFA6ACB7);
  static const nodeLockedBorder = Color(0xFF8E95A1);

  static List<Color> sectionGradient(int level) {
    final colors = <List<Color>>[
      const [Color(0xFF34D399), Color(0xFF16A34A)],
      const [Color(0xFFA78BFA), Color(0xFF7C3AED)],
      const [Color(0xFFFB923C), Color(0xFFEA580C)],
      const [Color(0xFF60A5FA), Color(0xFF2563EB)],
      const [Color(0xFFF87171), Color(0xFFDC2626)],
    ];
    return colors[((level <= 0 ? 1 : level) - 1) % colors.length];
  }
}

class _StarIcon extends StatelessWidget {
  const _StarIcon({required this.size});
  final double size;
  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size.square(size), painter: _StarPainter());
}

class _StarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    final shadow = Paint()..color = const Color(0xFFE8E8E1);
    final c = Offset(size.width / 2, size.height / 2);
    final path = Path();
    for (var i = 0; i < 10; i++) {
      final angle = -math.pi / 2 + i * math.pi / 5;
      final r = i.isEven ? size.width * .46 : size.width * .21;
      final p = Offset(c.dx + math.cos(angle) * r, c.dy + math.sin(angle) * r);
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    path.close();
    canvas.drawPath(
      path.shift(Offset(size.width * .035, size.height * .04)),
      shadow,
    );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LockIcon extends StatelessWidget {
  const _LockIcon({required this.size, this.silver = false});
  final double size;
  final bool silver;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.lock_rounded,
      color: silver ? const Color(0xFFE6E8EA) : const Color(0xFFFFD54F),
      size: size * .76,
      shadows: const [
        Shadow(color: Color(0x66000000), offset: Offset(0, 2), blurRadius: 2),
      ],
    );
  }
}

class _TrophyIcon extends StatelessWidget {
  const _TrophyIcon({required this.size, this.silver = false});
  final double size;
  final bool silver;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.emoji_events_rounded,
      color: silver ? const Color(0xFFC9CED3) : const Color(0xFFFFC417),
      size: size * .9,
      shadows: const [
        Shadow(color: Color(0x66000000), offset: Offset(0, 4), blurRadius: 5),
      ],
    );
  }
}

class _GemIcon extends StatelessWidget {
  const _GemIcon({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.diamond_rounded,
      color: const Color(0xFF1E88E5),
      size: size,
      shadows: const [
        Shadow(color: Color(0x33000000), offset: Offset(0, 2), blurRadius: 2),
      ],
    );
  }
}

class _FlameIcon extends StatelessWidget {
  const _FlameIcon({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.local_fire_department_rounded,
      color: const Color(0xFFFF6D00),
      size: size,
      shadows: const [
        Shadow(color: Color(0x33000000), offset: Offset(0, 2), blurRadius: 2),
      ],
    );
  }
}

class _HeartIcon extends StatelessWidget {
  const _HeartIcon({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.favorite_rounded,
      color: const Color(0xFFFF262E),
      size: size,
      shadows: const [
        Shadow(color: Color(0x33000000), offset: Offset(0, 2), blurRadius: 2),
      ],
    );
  }
}
