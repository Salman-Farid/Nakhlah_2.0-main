# Learnings

Corrections, insights, and knowledge gaps captured during development.

**Categories**: correction | insight | knowledge_gap | best_practice

---

## [LRN-20260502-001] correction

**Logged**: 2026-05-02T10:34:00+06:00
**Priority**: medium

User pointed out leaderboard should not show demo data. The generated leaderboard used hardcoded rankings because the Postman collection contains no leaderboard/ranking endpoint.

**Action**: removed demo leaderboard rows. Screen now shows a real-data-only empty state until a backend leaderboard endpoint is provided.

## [LRN-20260502-002] correction

**Logged**: 2026-05-02T10:35:00+06:00
**Priority**: medium

User asked to compare the GitHub reference for leaderboard. The web app's `LeaderBoardPage.jsx` and dashboard `LeaderboardCard.jsx` both use local hardcoded arrays (`leaderboardData`, `topLeaders`) instead of fetching a leaderboard API.

**Action**: Flutter leaderboard now mirrors the web layout structure (header, weekly/monthly/all-time filters, podium/list components) but keeps entries empty until a real backend endpoint is supplied. No sample web names or scores are shown.

## [LRN-20260502-003] best_practice

**Logged**: 2026-05-02T10:44:00+06:00
**Priority**: medium

For game-like Flutter UI motion, create reusable animation primitives (`PageEnter`, `GameListView`, `StaggeredList`, `PressableScale`) and apply them at screen structure boundaries. Include reduced-motion handling via `MediaQuery.disableAnimations/accessibilityNavigation`. Avoid wrapping `Spacer`/`Expanded` directly in animation widgets inside `Column`, because ParentDataWidget constraints can break.
