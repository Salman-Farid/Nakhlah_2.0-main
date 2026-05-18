import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/responsive.dart';
import '../../constants/app_colors.dart';
import '../../routes/app_routes.dart';
import 'settings_detail_view.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F7F2),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.ink,
            size: 20,
          ),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.ink,
          ),
        ),
        centerTitle: false,
      ),
      body: PageShell(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildSettingItem(
              icon: Icons.person_outline,
              iconBgColor: const Color(0xFFFFF3E0),
              iconColor: const Color(0xFFFF9800),
              title: 'Personal Info',
              onTap: () => Get.to(
                () => const SettingsDetailView(title: 'Personal Info'),
              ),
            ),
            _buildSettingItem(
              icon: Icons.notifications_none_outlined,
              iconBgColor: const Color(0xFFFFEBEE),
              iconColor: const Color(0xFFEF5350),
              title: 'Notification',
              onTap: () =>
                  Get.to(() => const SettingsDetailView(title: 'Notification')),
            ),
            _buildSettingItem(
              icon: Icons.grid_view_outlined,
              iconBgColor: const Color(0xFFEDE7F6),
              iconColor: const Color(0xFF7E57C2),
              title: 'General',
              onTap: () =>
                  Get.to(() => const SettingsDetailView(title: 'General')),
            ),
            _buildSettingItem(
              icon: Icons.visibility_outlined,
              iconBgColor: const Color(0xFFFFFDE7),
              iconColor: const Color(0xFFFFB300),
              title: 'Accessibility',
              onTap: () => Get.to(
                () => const SettingsDetailView(title: 'Accessibility'),
              ),
            ),
            _buildSettingItem(
              icon: Icons.shield_outlined,
              iconBgColor: const Color(0xFFE8F5E9),
              iconColor: const Color(0xFF66BB6A),
              title: 'Security',
              onTap: () =>
                  Get.to(() => const SettingsDetailView(title: 'Security')),
            ),
            _buildSettingItem(
              icon: Icons.people_outline,
              iconBgColor: const Color(0xFFFFF3E0),
              iconColor: const Color(0xFFFF9800),
              title: 'Find Friends',
              onTap: () =>
                  Get.to(() => const SettingsDetailView(title: 'Find Friends')),
            ),
            _buildToggleItem(
              icon: Icons.dark_mode_outlined,
              iconBgColor: const Color(0xFFE3F2FD),
              iconColor: const Color(0xFF42A5F5),
              title: 'Dark Mode',
              value: _darkMode,
              onChanged: (v) => setState(() => _darkMode = v),
            ),
            _buildSettingItem(
              icon: Icons.help_outline,
              iconBgColor: const Color(0xFFE0F7FA),
              iconColor: const Color(0xFF26C6DA),
              title: 'Help Center',
              onTap: () => Get.toNamed(Routes.helpCenter),
            ),
            _buildSettingItem(
              icon: Icons.info_outline,
              iconBgColor: const Color(0xFFEDE7F6),
              iconColor: const Color(0xFF7E57C2),
              title: 'About Nakhlah',
              onTap: () => Get.toNamed(Routes.about),
            ),
            _buildSettingItem(
              icon: Icons.gavel_outlined,
              iconBgColor: const Color(0xFFE8F5E9),
              iconColor: const Color(0xFF66BB6A),
              title: 'Legal Documents',
              onTap: () => Get.toNamed(Routes.legal),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.ink,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey, size: 22),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleItem({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.ink,
                ),
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: AppColors.palm,
              activeTrackColor: AppColors.palm.withValues(alpha: 0.3),
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: Colors.grey.shade300,
            ),
          ],
        ),
      ),
    );
  }
}
