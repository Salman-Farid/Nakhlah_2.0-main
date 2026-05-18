import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../common/loading_state.dart';
import '../../common/responsive.dart';
import '../../services/cms_service.dart';

class LegalView extends StatefulWidget {
  const LegalView({super.key});

  @override
  State<LegalView> createState() => _LegalViewState();
}

class _LegalViewState extends State<LegalView> {
  bool _loading = true;
  String _terms = '';
  String _privacy = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    try {
      final service = Get.find<CmsService>();
      final legal = await service.legal();
      if (mounted) {
        setState(() {
          _terms = legal;
          _privacy = legal;
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
          'Legal Documents',
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Terms & Conditions',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _terms.isNotEmpty
                              ? _terms
                              : 'Terms content is not available.',
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.6,
                            color: AppColors.muted,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Privacy Policy',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _privacy.isNotEmpty
                              ? _privacy
                              : 'Privacy policy content is not available.',
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.6,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
