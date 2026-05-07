import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/app_motion.dart';
import '../../controllers/app_controller.dart';
import '../gamification/gamification_view.dart';
import '../home/home_view.dart';
import '../leaderboard/leaderboard_view.dart';
import '../profile/profile_view.dart';
import '../progress/progress_view.dart';

class AppShellView extends StatelessWidget {
  const AppShellView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AppController>();
    final pages = [
      const HomeView(),
      const ProgressView(),
      const LeaderboardView(),
      const GamificationView(),
      const ProfileView(),
    ];

    return Obx(
      () => Scaffold(
        body: AnimatedSwitcher(
          duration: AppMotion.normal,
          switchInCurve: AppMotion.out,
          switchOutCurve: AppMotion.inOut,
          transitionBuilder: (child, animation) {
            final slide = Tween<Offset>(
              begin: const Offset(.04, 0),
              end: Offset.zero,
            ).animate(animation);
            final scale = Tween<double>(begin: .985, end: 1).animate(animation);
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: slide,
                child: ScaleTransition(scale: scale, child: child),
              ),
            );
          },
          child: KeyedSubtree(
            key: ValueKey(c.tabIndex.value),
            child: pages[c.tabIndex.value],
          ),
        ),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            navigationBarTheme: NavigationBarThemeData(
              indicatorColor: const Color(0xFFF4ECFF),
              iconTheme: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return const IconThemeData(color: Color(0xFF7C3AED));
                }
                return const IconThemeData(color: Color(0xFF8B7E74));
              }),
              labelTextStyle: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return const TextStyle(
                    color: Color(0xFF7C3AED),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  );
                }
                return const TextStyle(
                  color: Color(0xFF8B7E74),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                );
              }),
            ),
          ),
          child: NavigationBar(
            selectedIndex: c.tabIndex.value,
            onDestinationSelected: c.setTab,
            animationDuration: AppMotion.normal,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            shadowColor: Colors.transparent,
            elevation: 0,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.menu_book_outlined),
                selectedIcon: Icon(Icons.menu_book),
                label: 'Challenges',
              ),
              NavigationDestination(
                icon: Icon(Icons.emoji_events_outlined),
                selectedIcon: Icon(Icons.emoji_events),
                label: 'Leaderboard',
              ),
              NavigationDestination(
                icon: Icon(Icons.workspace_premium_outlined),
                selectedIcon: Icon(Icons.workspace_premium),
                label: 'Store',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
