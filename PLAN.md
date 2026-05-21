# Nakhlah 2.0 — Flutter App Alignment Plan

## Goal
Clone the website (nakhlah-web-2.0-main) design, screens, API flow, and assets
into the existing Flutter app (root-level lib/) so both are pixel-identical.

## Backend API
Base URL: https://nakhlah-admin.codemonks.dev/api
All endpoints defined in: lib/constants/api_endpoints.dart

## Phases

### Phase 1: Design System + Color Alignment
- Align AppColors with website's Tailwind theme (green/palm theme)
- Update AppTheme to match website typography, spacing, border-radius
- Create shared design tokens matching website's CSS variables
- Files: lib/constants/app_colors.dart, app_theme.dart

### Phase 2: Auth Flow Alignment
- Add OTP Verification screen (4-digit input, timer, resend, mobile dialer)
- Add Social Redirect screen
- Update login/signup to match website design exactly
- Ensure forgot-password -> OTP -> reset-password flow works
- Files: lib/views/auth/*, lib/routes/*

### Phase 3: Onboarding Flow (10 steps)
- Fetch onboarding options from API globals
- Implement all 10 steps: Strength, Goal, Purpose, Country, Source,
  Interests, Profile Info, Age, Account, Completion
- Multi-select for interests, image picker for profile picture
- Files: lib/views/onboarding/*, lib/controllers/profile_controller.dart

### Phase 4: Challenges + Leaderboard Enhancement
- Create Challenges screen with Target/Badges tabs
- Implement Daily Missions with progress tracking
- Implement Badges list with earned/locked sections, search, sort
- Enhance Leaderboard with search, user profile cards
- Files: NEW lib/views/challenges/*, lib/views/leaderboard/*

### Phase 5: Lesson Flow + Exercises
- Implement full lesson engine matching website's question types
- Palm trees lives system, progress bar, timer
- Lesson completion, result handler, streak updates
- Daily mission integration during lessons
- Leaving dialog, loading states
- Files: lib/views/lessons/*, lib/views/exercises/*

### Phase 6: Profile, Store, Missing Screens
- Profile: edit profile, achievements, followers, XP chart
- Store: gems purchase, premium subscription alignment
- New screens: FAQ, Terms, Stats, Tips, Contact Us
- Files: lib/views/profile/*, lib/views/gemification/*, NEW screens
