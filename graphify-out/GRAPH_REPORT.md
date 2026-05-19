# Graph Report - /Volumes/SSD_512GB/Nakhlah-2.0/Nakhlah_2.0-main/lib  (2026-05-19)

## Corpus Check
- Corpus is ~25,487 words - fits in a single context window. You may not need a graph.

## Summary
- 650 nodes · 792 edges · 34 communities detected
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- [[_COMMUNITY_Home Screen UI|Home Screen UI]]
- [[_COMMUNITY_Common Widgets Library|Common Widgets Library]]
- [[_COMMUNITY_Lessons & Exercises UI|Lessons & Exercises UI]]
- [[_COMMUNITY_Controllers & Routing|Controllers & Routing]]
- [[_COMMUNITY_Auth & Onboarding Flow|Auth & Onboarding Flow]]
- [[_COMMUNITY_App Theme & Shell|App Theme & Shell]]
- [[_COMMUNITY_Profile Screen UI|Profile Screen UI]]
- [[_COMMUNITY_API & Content Services|API & Content Services]]
- [[_COMMUNITY_Data Models|Data Models]]
- [[_COMMUNITY_Onboarding Intro Screen|Onboarding Intro Screen]]
- [[_COMMUNITY_Lessons View Components|Lessons View Components]]
- [[_COMMUNITY_Leaderboard UI|Leaderboard UI]]
- [[_COMMUNITY_App Routes & Pages|App Routes & Pages]]
- [[_COMMUNITY_Progress Screen UI|Progress Screen UI]]
- [[_COMMUNITY_Onboarding Form Pickers|Onboarding Form Pickers]]
- [[_COMMUNITY_Settings Detail UI|Settings Detail UI]]
- [[_COMMUNITY_Animation & Motion|Animation & Motion]]
- [[_COMMUNITY_Gamification Hub UI|Gamification Hub UI]]
- [[_COMMUNITY_Premium Subscription UI|Premium Subscription UI]]
- [[_COMMUNITY_Purchase Dates UI|Purchase Dates UI]]
- [[_COMMUNITY_Settings List UI|Settings List UI]]
- [[_COMMUNITY_API Endpoints|API Endpoints]]
- [[_COMMUNITY_Payment Screen|Payment Screen]]
- [[_COMMUNITY_App Strings|App Strings]]
- [[_COMMUNITY_App Routes Constants|App Routes Constants]]
- [[_COMMUNITY_Media Model|Media Model]]
- [[_COMMUNITY_Profile Model|Profile Model]]
- [[_COMMUNITY_Gamification Model|Gamification Model]]
- [[_COMMUNITY_Journey Model|Journey Model]]
- [[_COMMUNITY_API Exception|API Exception]]
- [[_COMMUNITY_CMS Model|CMS Model]]
- [[_COMMUNITY_Lesson Model|Lesson Model]]
- [[_COMMUNITY_User Model|User Model]]
- [[_COMMUNITY_Question Model|Question Model]]

## God Nodes (most connected - your core abstractions)
1. `package:flutter/material.dart` - 33 edges
2. `package:get/get.dart` - 32 edges
3. `../../constants/app_colors.dart` - 20 edges
4. `../common/app_motion.dart` - 18 edges
5. `../models/models.dart` - 16 edges
6. `../../routes/app_routes.dart` - 14 edges
7. `../../common/responsive.dart` - 10 edges
8. `../../common/loading_state.dart` - 9 edges
9. `../constants/api_endpoints.dart` - 7 edges
10. `../../controllers/profile_controller.dart` - 7 edges

## Surprising Connections (you probably didn't know these)
- None detected - all connections are within the same source files.

## Communities

### Community 0 - "Home Screen UI"
Cohesion: 0.03
Nodes (61): dart:math, AnimatedBuilder, _BubbleTailPainter, build, _buildJourneyView, Column, Container, copyWith (+53 more)

### Community 1 - "Common Widgets Library"
Cohesion: 0.04
Nodes (46): app_button.dart, app_motion.dart, package:flutter/widgets.dart, AppButton, build, PressableScale, AppCard, build (+38 more)

### Community 2 - "Lessons & Exercises UI"
Cohesion: 0.05
Nodes (41): ../../common/app_button.dart, ../../common/loading_state.dart, ../../common/responsive.dart, ../../constants/app_colors.dart, package:cached_network_image/cached_network_image.dart, ../../services/cms_service.dart, AppSnackbar, error (+33 more)

### Community 3 - "Controllers & Routing"
Cohesion: 0.06
Nodes (34): bindings/initial_binding.dart, ../../common/app_snackbar.dart, constants/app_theme.dart, ../../controllers/content_controller.dart, ../../controllers/gamification_controller.dart, ../../controllers/profile_controller.dart, package:get/get.dart, package:get_storage/get_storage.dart (+26 more)

### Community 4 - "Auth & Onboarding Flow"
Cohesion: 0.05
Nodes (37): ../common/app_motion.dart, ../../common/nakhlah_intro_widgets.dart, ../../controllers/app_controller.dart, ../../controllers/auth_controller.dart, package:google_sign_in/google_sign_in.dart, buildTransition, FadeTransition, GamePageTransition (+29 more)

### Community 5 - "App Theme & Shell"
Cohesion: 0.05
Nodes (33): app_colors.dart, ../gamification/gamification_view.dart, ../home/home_view.dart, ../leaderboard/leaderboard_view.dart, package:flutter/material.dart, ../profile/profile_view.dart, ../progress/progress_view.dart, build (+25 more)

### Community 6 - "Profile Screen UI"
Cohesion: 0.06
Nodes (35): package:share_plus/share_plus.dart, ../settings/settings_detail_view.dart, AppButton, _AreaChartPainter, build, _buildAchievementItem, _buildAchievementsSection, _buildActionButtons (+27 more)

### Community 7 - "API & Content Services"
Cohesion: 0.09
Nodes (26): api_service.dart, ../constants/api_endpoints.dart, dart:async, dart:convert, dart:io, ../models/models.dart, package:http/http.dart, storage_service.dart (+18 more)

### Community 8 - "Data Models"
Cohesion: 0.07
Nodes (28): AchievementModel, AnswerModel, ApiException, AuthSession, _bool, extract, FaqModel, GamificationStock (+20 more)

### Community 9 - "Onboarding Intro Screen"
Cohesion: 0.07
Nodes (27): _BigButton, _BubbleTailPainter, build, Column, dispose, Divider, _DropMascot, _DropPainter (+19 more)

### Community 10 - "Lessons View Components"
Cohesion: 0.08
Nodes (23): ../../common/app_card.dart, AppCard, build, Container, EmptyState, Icon, initState, _isLocked (+15 more)

### Community 11 - "Leaderboard UI"
Cohesion: 0.08
Nodes (23): ../../common/empty_state.dart, build, Color, Column, Container, EmptyState, Expanded, Icon (+15 more)

### Community 12 - "App Routes & Pages"
Cohesion: 0.09
Nodes (21): app_routes.dart, game_page_transition.dart, ../views/auth/forgot_password_view.dart, ../views/auth/login_view.dart, ../views/auth/reset_password_view.dart, ../views/auth/signup_view.dart, ../views/exercises/exercise_view.dart, ../views/gamification/payment_view.dart (+13 more)

### Community 13 - "Progress Screen UI"
Cohesion: 0.09
Nodes (21): _BadgeCard, _BadgeData, build, Container, GameListView, GestureDetector, _Header, Icon (+13 more)

### Community 14 - "Onboarding Form Pickers"
Cohesion: 0.09
Nodes (21): _back, build, Column, dispose, Expanded, _GoalPicker, _GoalPickerState, IntroHeroImage (+13 more)

### Community 15 - "Settings Detail UI"
Cohesion: 0.1
Nodes (20): _body, build, Container, dispose, _findFriends, _infoList, _InfoRow, initState (+12 more)

### Community 16 - "Animation & Motion"
Cohesion: 0.11
Nodes (18): AppMotion, build, didUpdateWidget, dispose, FadeTransition, GameColumn, GameListView, initState (+10 more)

### Community 17 - "Gamification Hub UI"
Cohesion: 0.11
Nodes (18): build, _BuyDatesCard, Container, _FeatureCard, GamificationView, _GamificationViewState, _GoPremiumButton, Icon (+10 more)

### Community 18 - "Premium Subscription UI"
Cohesion: 0.13
Nodes (14): Align, _BackHeader, build, Column, Icon, PageEnter, _PlanCard, _PremiumTitle (+6 more)

### Community 19 - "Purchase Dates UI"
Cohesion: 0.13
Nodes (14): Align, _BackHeader, build, Column, _DatePack, _DatePackCard, Icon, PageEnter (+6 more)

### Community 20 - "Settings List UI"
Cohesion: 0.18
Nodes (10): settings_detail_view.dart, build, _buildSettingItem, _buildToggleItem, Icon, Padding, Scaffold, SettingsView (+2 more)

### Community 21 - "API Endpoints"
Cohesion: 0.22
Nodes (8): ApiEndpoints, examQuestions, fullMarks, giftBox, lessonsByTask, makeLearnerProgress, questionsByLesson, restoreStreak

### Community 22 - "Payment Screen"
Cohesion: 0.22
Nodes (8): Align, _BackHeader, build, Icon, PageEnter, PaymentView, Scaffold, SizedBox

### Community 23 - "App Strings"
Cohesion: 1.0
Nodes (1): AppStrings

### Community 24 - "App Routes Constants"
Cohesion: 1.0
Nodes (1): Routes

### Community 25 - "Media Model"
Cohesion: 1.0
Nodes (0): 

### Community 26 - "Profile Model"
Cohesion: 1.0
Nodes (0): 

### Community 27 - "Gamification Model"
Cohesion: 1.0
Nodes (0): 

### Community 28 - "Journey Model"
Cohesion: 1.0
Nodes (0): 

### Community 29 - "API Exception"
Cohesion: 1.0
Nodes (0): 

### Community 30 - "CMS Model"
Cohesion: 1.0
Nodes (0): 

### Community 31 - "Lesson Model"
Cohesion: 1.0
Nodes (0): 

### Community 32 - "User Model"
Cohesion: 1.0
Nodes (0): 

### Community 33 - "Question Model"
Cohesion: 1.0
Nodes (0): 

## Knowledge Gaps
- **558 isolated node(s):** `NakhlahApp`, `build`, `bindings/initial_binding.dart`, `constants/app_theme.dart`, `routes/app_pages.dart` (+553 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **Thin community `App Strings`** (2 nodes): `app_strings.dart`, `AppStrings`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `App Routes Constants`** (2 nodes): `app_routes.dart`, `Routes`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Media Model`** (1 nodes): `media_model.dart`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Profile Model`** (1 nodes): `profile_model.dart`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Gamification Model`** (1 nodes): `gamification_model.dart`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Journey Model`** (1 nodes): `journey_model.dart`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `API Exception`** (1 nodes): `api_exception.dart`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `CMS Model`** (1 nodes): `cms_model.dart`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Lesson Model`** (1 nodes): `lesson_model.dart`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `User Model`** (1 nodes): `user_model.dart`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Question Model`** (1 nodes): `question_model.dart`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `package:flutter/material.dart` connect `App Theme & Shell` to `Home Screen UI`, `Common Widgets Library`, `Lessons & Exercises UI`, `Controllers & Routing`, `Auth & Onboarding Flow`, `Profile Screen UI`, `Onboarding Intro Screen`, `Lessons View Components`, `Leaderboard UI`, `Progress Screen UI`, `Onboarding Form Pickers`, `Settings Detail UI`, `Animation & Motion`, `Gamification Hub UI`, `Premium Subscription UI`, `Purchase Dates UI`, `Settings List UI`, `Payment Screen`?**
  _High betweenness centrality (0.293) - this node is a cross-community bridge._
- **Why does `package:get/get.dart` connect `Controllers & Routing` to `Home Screen UI`, `Common Widgets Library`, `Lessons & Exercises UI`, `Auth & Onboarding Flow`, `App Theme & Shell`, `Profile Screen UI`, `Onboarding Intro Screen`, `Lessons View Components`, `Leaderboard UI`, `App Routes & Pages`, `Progress Screen UI`, `Onboarding Form Pickers`, `Settings Detail UI`, `Gamification Hub UI`, `Premium Subscription UI`, `Purchase Dates UI`, `Settings List UI`, `Payment Screen`?**
  _High betweenness centrality (0.250) - this node is a cross-community bridge._
- **Why does `../models/models.dart` connect `API & Content Services` to `Home Screen UI`, `Lessons & Exercises UI`, `Controllers & Routing`, `Profile Screen UI`, `Lessons View Components`, `Onboarding Form Pickers`?**
  _High betweenness centrality (0.177) - this node is a cross-community bridge._
- **What connects `NakhlahApp`, `build`, `bindings/initial_binding.dart` to the rest of the system?**
  _558 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Home Screen UI` be split into smaller, more focused modules?**
  _Cohesion score 0.03 - nodes in this community are weakly interconnected._
- **Should `Common Widgets Library` be split into smaller, more focused modules?**
  _Cohesion score 0.04 - nodes in this community are weakly interconnected._
- **Should `Lessons & Exercises UI` be split into smaller, more focused modules?**
  _Cohesion score 0.05 - nodes in this community are weakly interconnected._