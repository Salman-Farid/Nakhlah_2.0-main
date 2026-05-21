import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/app_colors.dart';
import '../../common/responsive.dart';

class ContactView extends StatelessWidget {
  const ContactView({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
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
          'Contact Us',
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
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.palm.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.support_agent,
                      color: AppColors.palm,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'We\'re Here to Help',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Have a question or need assistance? Reach out to us through any of the channels below.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildContactCard(
              icon: Icons.email_outlined,
              iconBg: const Color(0xFFFFF3E0),
              iconColor: const Color(0xFFFF9800),
              title: 'Email',
              subtitle: 'support@nakhlah.com',
              onTap: () => _launchUrl('mailto:support@nakhlah.com'),
            ),
            const SizedBox(height: 12),
            _buildContactCard(
              icon: Icons.language,
              iconBg: const Color(0xFFE3F2FD),
              iconColor: const Color(0xFF42A5F5),
              title: 'Website',
              subtitle: 'www.nakhlah.com',
              onTap: () => _launchUrl('https://www.nakhlah.com'),
            ),
            const SizedBox(height: 12),
            _buildContactCard(
              icon: Icons.chat_outlined,
              iconBg: const Color(0xFFE8F5E9),
              iconColor: const Color(0xFF66BB6A),
              title: 'WhatsApp',
              subtitle: 'Chat with us',
              onTap: () => _launchUrl('https://wa.me/966500000000'),
            ),
            const SizedBox(height: 12),
            _buildContactCard(
              icon: Icons.camera_alt_outlined,
              iconBg: const Color(0xFFFCE4EC),
              iconColor: const Color(0xFFEC4899),
              title: 'Instagram',
              subtitle: '@nakhlah_app',
              onTap: () => _launchUrl('https://instagram.com/nakhlah_app'),
            ),
            const SizedBox(height: 12),
            _buildContactCard(
              icon: Icons.play_circle_outline,
              iconBg: const Color(0xFFFEE2E2),
              iconColor: const Color(0xFFEF4444),
              title: 'YouTube',
              subtitle: 'Nakhlah Channel',
              onTap: () => _launchUrl('https://youtube.com/@nakhlah'),
            ),
            const SizedBox(height: 12),
            _buildContactCard(
              icon: Icons.alternate_email,
              iconBg: const Color(0xFFEDE7F6),
              iconColor: const Color(0xFF7C3AED),
              title: 'Twitter / X',
              subtitle: '@nakhlah_app',
              onTap: () => _launchUrl('https://twitter.com/nakhlah_app'),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.open_in_new, color: Colors.grey.shade400, size: 18),
          ],
        ),
      ),
    );
  }
}
