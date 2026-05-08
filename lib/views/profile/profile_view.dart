import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../common/app_button.dart';
import '../../common/app_motion.dart';
import '../../common/loading_state.dart';
import '../../common/responsive.dart';
import '../../constants/app_colors.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/gamification_controller.dart';
import '../../controllers/profile_controller.dart';
import '../../models/models.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Get.find<ProfileController>().load();
      Get.find<AuthController>().loadMe();
      Get.find<GamificationController>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = Get.find<ProfileController>();
    final a = Get.find<AuthController>();
    final g = Get.find<GamificationController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: PageShell(
        child: Obx(() {
          if (p.loading.value && p.profile.value == null) {
            return const LoadingState();
          }
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              for (var i = 0; i < 16; i++)
                PageEnter(
                  delay: Duration(milliseconds: 30 * i),
                  duration: const Duration(milliseconds: 280),
                  child: [
                    _buildAppBar(context),
                    const SizedBox(height: 20),
                    _buildProfileHeader(context, p, a),
                    const SizedBox(height: 20),
                    _buildStatsRow(context, p, g),
                    const SizedBox(height: 16),
                    _buildActionButtons(context),
                    const SizedBox(height: 28),
                    _buildStatisticsSection(context, p, g),
                    const SizedBox(height: 20),
                    _buildXpChartSection(context),
                    const SizedBox(height: 28),
                    _buildAchievementsSection(context, g),
                    const SizedBox(height: 24),
                    _buildLogoutButton(context, a),
                    const SizedBox(height: 32),
                  ][i],
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.palm,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.person_outline,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Account',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.ink,
              ),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {
                Share.share('Check out my progress on Nakhlah!');
              },
              icon: const Icon(Icons.send_outlined, color: AppColors.ink),
            ),
            IconButton(
              onPressed: () {
                Get.snackbar(
                  'Settings',
                  'Settings page coming soon!',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              icon: const Icon(Icons.settings_outlined, color: AppColors.ink),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileHeader(BuildContext context, ProfileController p, AuthController a) {
    final imageUrl = p.profile.value?.profilePicture?.absoluteUrl;
    final name = p.profile.value?.fullName ?? a.user.value?.name ?? a.user.value?.email ?? 'Learner';
    final goalTime = p.profile.value?.onboardInfo.goalTime ?? 0;

    return Column(
      children: [
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 52,
                backgroundColor: const Color(0xFFF3E8FF),
                backgroundImage: imageUrl != null ? CachedNetworkImageProvider(imageUrl) : null,
                child: imageUrl == null
                    ? const Icon(Icons.person, size: 52, color: AppColors.palm)
                    : null,
              ),
            ),
            Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.palm,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.edit, color: Colors.white, size: 16),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '$goalTime min daily goal',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(BuildContext context, ProfileController p, GamificationController g) {
    final level = p.progress.value.levelOrder;
    final unit = p.progress.value.unitOrder;
    final totalXp = p.stock.value.palmStock + p.stock.value.dateStock + p.stock.value.injazStock;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          Expanded(child: _buildStatItem('$level', 'Level')),
          Container(width: 1, height: 40, color: Colors.grey.shade200),
          Expanded(child: _buildStatItem('$unit', 'Unit')),
          Container(width: 1, height: 40, color: Colors.grey.shade200),
          Expanded(child: _buildStatItem('$totalXp', 'Total XP')),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              Get.snackbar(
                'Edit Profile',
                'Edit profile coming soon!',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            icon: const Icon(Icons.edit, size: 18),
            label: const Text(
              'Edit Profile',
              overflow: TextOverflow.ellipsis,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.palm,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              textStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              Share.share('Check out my progress on Nakhlah!');
            },
            icon: const Icon(Icons.share, size: 18),
            label: const Text(
              'Share',
              overflow: TextOverflow.ellipsis,
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.palm,
              side: const BorderSide(color: AppColors.palm, width: 1.5),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              textStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticsSection(BuildContext context, ProfileController p, GamificationController g) {
    final stats = [
      _StatData(icon: '🔥', value: '${g.streak.value.currentStreak}', label: 'Day Streak'),
      _StatData(icon: '📅', value: '${p.progress.value.lessonOrder}', label: 'Lessons'),
      _StatData(icon: '💎', value: '${p.stock.value.palmStock}', label: 'Palms'),
      _StatData(icon: '⚡', value: '${p.stock.value.injazStock}', label: 'Injaz'),
      _StatData(icon: '🎯', value: '${p.progress.value.taskOrder}', label: 'Tasks'),
      _StatData(icon: '🏅', value: '${g.achievements.where((a) => a.achieved).length}', label: 'Achievements'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Text(
              'Your Statistics',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.ink,
              ),
            ),
            SizedBox(width: 8),
            Text('📊', style: TextStyle(fontSize: 18)),
          ],
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.2,
          ),
          itemCount: stats.length,
          itemBuilder: (context, index) {
            final stat = stats[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(stat.icon, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text(
                        stat.value,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.ink,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.only(left: 28),
                    child: Text(
                      stat.label,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildXpChartSection(BuildContext context) {
    final weeklyData = [980, 340, 520, 680, 920, 640, 880];
    final totalXp = weeklyData.reduce((a, b) => a + b);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your XP this week',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.ink,
                ),
              ),
              Text(
                '$totalXp XP',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: CustomPaint(
              size: const Size(double.infinity, 180),
              painter: _AreaChartPainter(data: weeklyData),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Expanded(child: Text('Mon', style: TextStyle(fontSize: 12.0, color: Colors.grey), textAlign: TextAlign.center)),
              Expanded(child: Text('Tue', style: TextStyle(fontSize: 12.0, color: Colors.grey), textAlign: TextAlign.center)),
              Expanded(child: Text('Wed', style: TextStyle(fontSize: 12.0, color: Colors.grey), textAlign: TextAlign.center)),
              Expanded(child: Text('Thu', style: TextStyle(fontSize: 12.0, color: Colors.grey), textAlign: TextAlign.center)),
              Expanded(child: Text('Fri', style: TextStyle(fontSize: 12.0, color: Colors.grey), textAlign: TextAlign.center)),
              Expanded(child: Text('Sat', style: TextStyle(fontSize: 12.0, color: Colors.grey), textAlign: TextAlign.center)),
              Expanded(child: Text('Sun', style: TextStyle(fontSize: 12.0, color: Colors.grey), textAlign: TextAlign.center)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsSection(BuildContext context, GamificationController g) {
    final achievements = g.achievements.take(3).toList();
    final achievedCount = g.achievements.where((a) => a.achieved).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Text(
              'Your Achievements',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.ink,
              ),
            ),
            SizedBox(width: 8),
            Text('🏆', style: TextStyle(fontSize: 18)),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade200),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$achievedCount Achievements',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.ink,
                    ),
                  ),
                  const Icon(Icons.arrow_forward, color: AppColors.palm),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              if (achievements.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    'No achievements yet. Keep learning!',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              else
                ...achievements.asMap().entries.map((entry) {
                  final index = entry.key;
                  final achievement = entry.value;
                  return Column(
                    children: [
                      if (index > 0) const Divider(height: 1),
                      _buildAchievementItem(achievement),
                    ],
                  );
                }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementItem(AchievementModel achievement) {
    final target = achievement.unitOrder > 0 ? achievement.unitOrder : 10;
    final progress = target > 0 ? achievement.levelOrder / target : 0.0;
    final progressClamped = progress.clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: _getAchievementColor(achievement.id),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Icon(
                    _getAchievementIcon(achievement.id),
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  decoration: BoxDecoration(
                    color: _getAchievementColor(achievement.id).withOpacity(0.9),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: Text(
                    'LEVEL ${achievement.levelOrder}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  achievement.achievementTitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progressClamped,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: const AlwaysStoppedAnimation(AppColors.palm),
                          minHeight: 8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${achievement.levelOrder} / $target',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.palm,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, AuthController a) {
    return AppButton(
      label: 'Log out',
      icon: Icons.logout,
      onPressed: a.logout,
    );
  }

  Color _getAchievementColor(String id) {
    final colors = [
      const Color(0xFF7C3AED),
      const Color(0xFFEF4444),
      const Color(0xFF10B981),
      const Color(0xFFF59E0B),
      const Color(0xFF3B82F6),
    ];
    return colors[id.hashCode.abs() % colors.length];
  }

  IconData _getAchievementIcon(String id) {
    final icons = [
      Icons.emoji_events,
      Icons.psychology,
      Icons.military_tech,
      Icons.star,
      Icons.local_fire_department,
    ];
    return icons[id.hashCode.abs() % icons.length];
  }
}

class _StatData {
  final String icon;
  final String value;
  final String label;
  const _StatData({required this.icon, required this.value, required this.label});
}

class _AreaChartPainter extends CustomPainter {
  final List<int> data;
  const _AreaChartPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    final maxValue = 1000.0;
    final labelWidth = 32.0;
    final padding = EdgeInsets.only(left: labelWidth, right: 8, top: 10, bottom: 10);
    final chartWidth = size.width - padding.horizontal;
    final chartHeight = size.height - padding.vertical;

    final labelStyle = TextStyle(
      color: Colors.grey.shade400,
      fontSize: 11,
    );

    for (int i = 0; i <= 5; i++) {
      final value = (maxValue / 5 * i).toInt();
      final y = padding.top + chartHeight - (chartHeight / 5 * i);
      
      final painter = TextPainter(
        text: TextSpan(text: '$value', style: labelStyle),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.right,
      )..layout(maxWidth: labelWidth - 4);
      painter.paint(canvas, Offset(labelWidth - painter.width - 4, y - painter.height / 2));

      if (i > 0) {
        final gridPaint = Paint()
          ..color = Colors.grey.shade100
          ..strokeWidth = 1;
        canvas.drawLine(
          Offset(labelWidth, y),
          Offset(size.width - 8, y),
          gridPaint,
        );
      }
    }

    final points = <Offset>[];
    for (int i = 0; i < data.length; i++) {
      final x = padding.left + (chartWidth / (data.length - 1)) * i;
      final y = padding.top + chartHeight - (data[i] / maxValue * chartHeight);
      points.add(Offset(x, y));
    }

    final fillPath = Path();
    fillPath.moveTo(points.first.dx, padding.top + chartHeight);
    for (final point in points) {
      fillPath.lineTo(point.dx, point.dy);
    }
    fillPath.lineTo(points.last.dx, padding.top + chartHeight);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.palm.withOpacity(0.12),
          AppColors.palm.withOpacity(0.01),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(fillPath, fillPaint);

    final linePath = Path();
    linePath.moveTo(points.first.dx, points.first.dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final cp1 = Offset((p0.dx + p1.dx) / 2, p0.dy);
      final cp2 = Offset((p0.dx + p1.dx) / 2, p1.dy);
      linePath.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p1.dx, p1.dy);
    }

    final linePaint = Paint()
      ..color = AppColors.palm
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(linePath, linePaint);

    for (final point in points) {
      final pointPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      final pointBorderPaint = Paint()
        ..color = AppColors.palm
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawCircle(point, 4, pointPaint);
      canvas.drawCircle(point, 4, pointBorderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
