import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../common/loading_state.dart';
import '../../common/responsive.dart';
import '../../services/cms_service.dart';

class AboutView extends StatefulWidget {
  const AboutView({super.key});

  @override
  State<AboutView> createState() => _AboutViewState();
}

class _AboutViewState extends State<AboutView> {
  bool _loading = true;
  String _content = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    try {
      final service = Get.find<CmsService>();
      final about = await service.about();
      if (mounted) {
        setState(() {
          _content = about;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

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
          'About Nakhlah',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.ink,
          ),
        ),
        centerTitle: false,
      ),
      body: PageShell(
        child: _loading
            ? const LoadingState()
            : ListView(
                padding: EdgeInsets.zero,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      _content.isNotEmpty
                          ? _content
                          : 'About content is not available.',
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: AppColors.muted,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
