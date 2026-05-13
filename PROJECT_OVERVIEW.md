# Nakhlah 2.0 — Project Overview

Nakhlah 2.0 is a cross-platform mobile application built with **Flutter** for learning Arabic through structured lessons, interactive exercises, and gamified progress tracking.

## Tech Stack

| Layer | Technology |
|-------|------------|
| Framework | Flutter 3.x (Dart ^3.10.4) |
| State Management | GetX |
| Local Storage | get_storage |
| HTTP Client | `http` package |
| Backend API | `https://nakhlah-api.nakhlah.net` |
| Auth | JWT + Google Sign-In |

## Architecture

The codebase follows an **MVC-inspired** pattern organized into clear layers:

```
lib/
├── main.dart                 # App entry point (GetMaterialApp)
├── bindings/                 # Dependency injection setup
├── constants/                # API endpoints, colors, strings, theme
├── models/                   # Data models & serialization
├── services/                 # API & business logic services
├── controllers/              # GetX controllers (state + UI logic)
├── views/                    # Screens organized by feature
├── routes/                   # Named routes & custom transitions
└── common/                   # Reusable widgets & utilities
```

### Key Layers

- **Models** — Immutable data classes (`UserModel`, `LessonModel`, `QuestionModel`, `JourneyLevel`, etc.) with JSON factories. Defined in `lib/models/models.dart`.
- **Services** — Thin wrappers around the backend API. `ApiService` handles HTTP verbs, auth headers, and error decoding. Feature services (`AuthService`, `ContentService`, `ProfileService`, etc.) build on top.
- **Controllers** — GetX controllers expose reactive state (`Rx`, `.obs`) and bind UI events to service calls. `InitialBinding` registers all controllers and services at startup.
- **Views** — Stateless Flutter widgets that observe controllers via `Obx`.

## Core Features

### Authentication
- Email/password login & sign-up
- Google social sign-in
- Forgot password flow
- JWT token persistence via `StorageService`
- Auto-routing: splash → onboarding (first launch) → login → app shell

### Learning Journey
- Hierarchical curriculum: **Levels → Units → Tasks → Lessons**
- Lessons fetched from `/globals/questionnaires/...` endpoints
- Exam mode with dedicated question sets
- Progress tracking per lesson (`makeLearnerProgress`)

### Exercises & Questions
- Multiple-choice and media-based questions
- `QuestionModel` + `AnswerModel` with media support
- Wrong-answer tracking endpoint

### Gamification
- In-app currencies: **Palm**, **Date**, **Injaz**
- Daily quests & streak tracking
- Badges & achievements tied to level/unit completion
- Gift boxes at task milestones
- Premium subscription & payment flows

### User Profile
- Editable profile with picture upload (multipart)
- Onboarding form: age, country, purpose, goal time, language strength
- Learning progress snapshot (`ProgressModel`)

### App Shell (Bottom Navigation)
1. **Home** — Dashboard & journey overview
2. **Progress** — Personal learning stats
3. **Leaderboard** — Community rankings
4. **Gamification** — Quests, streaks, currency
5. **Profile** — Settings, account, logout

## Notable Design Decisions

- **GetX everywhere** — routing, state, and dependency injection all handled by GetX for consistency and low boilerplate.
- **Single models barrel file** — All data classes live in `models/models.dart` (single-line format) for terse imports.
- **Reactive loading pattern** — Every controller uses a `loading.obs` flag with try/catch/finally wrapped in a private `_run` helper.
- **Custom page transition** — `GamePageTransition` applied globally via `AppPages`.
- **Theme** — Material 3 with a palm-green seed color; light mode default.

## API Surface

Base URL: `https://nakhlah-api.nakhlah.net/api`

Key endpoints (see `lib/constants/api_endpoints.dart` for full list):
- `POST /users/login` / `/users/sign-in` — Auth
- `GET /globals/questionnaires/journey-structure` — Full curriculum tree
- `GET /globals/questionnaires/lessons/:id` — Lesson questions
- `POST /globals/questionnaires/make-learner-progress/:id` — Mark lesson complete
- `GET /user-profile/me` — Current user profile
- `PATCH /user-profile/update-me` — Update profile + picture

## Entry Point

```dart
// lib/main.dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const NakhlahApp());
}
```

The app launches into `SplashView`, then `AppController.decideStart()` routes the user based on onboarding and login state.

## Assets

Static assets live under `assets/` and include:
- Web-optimized images (`nakhlah_web/`)
- Design reference assets (`nakhlah_design/`)
- App icons and branding materials

## Multi-Platform Support

Configured for Android, iOS, Web, macOS, Windows, and Linux (`android/`, `ios/`, `web/`, `macos/`, `windows/`, `linux/`).
