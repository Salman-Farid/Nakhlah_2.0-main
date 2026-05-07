# Errors

Command failures and integration errors.

---

## [ERR-20260502-001] GetX Rx mutation during Flutter build

**Logged**: 2026-05-02T10:25:00+06:00
**Priority**: high

A `HomeView.initState()` call synchronously invoked GetX controller `load()` methods that immediately set `loading.value = true`. Because the view is mounted inside a shell `Obx`, this triggered `setState() or markNeedsBuild() called during build`.

**Fix**: defer initial controller loads from views using `WidgetsBinding.instance.addPostFrameCallback`, then check `mounted` before mutating Rx state. Applied to Home, Lessons, Exercise, Progress, Gamification, and Profile views.

## [ERR-20260502-002] Exercise finish blocked and MP3 rendered as image

**Logged**: 2026-05-02T10:29:00+06:00
**Priority**: high

Exercise media included audio files such as `.mp3`, but the exercise screen rendered all question media through `CachedNetworkImage`, causing `Invalid image data` codec exceptions. The Finish button also awaited progress-save before navigating back, so if `make-learner-progress` failed or stalled the button appeared not to work.

**Fix**: add media-type/extension detection in `ExerciseView`; only image files use `CachedNetworkImage`, audio files render as audio attachment tiles. Finish now starts progress-save best-effort and navigates immediately with `Get.back(result: true)`.

## [ERR-20260502-NAKHLAH-ASSETS] Flutter asset subfolder not declared

**Logged**: 2026-05-02T14:45:00+06:00
**Context**: Nakhlah Flutter welcome/auth redesign
**Error**: Device build threw `Unable to load asset: assets/nakhlah_design/...` because the new `assets/nakhlah_design/` subfolder was not explicitly listed in `pubspec.yaml`.
**Fix**: Added `- assets/nakhlah_design/` under `flutter.assets` and ran `flutter pub get`.
**Lesson**: When adding a new nested Flutter asset folder, register that exact folder in `pubspec.yaml`; do not rely on a broad parent `assets/` entry.

## [ERR-20260502-DART-FORMAT-YAML] dart format used on pubspec.yaml

**Logged**: 2026-05-02T14:45:00+06:00
**Context**: Nakhlah Flutter validation
**Error**: `dart format pubspec.yaml ...` failed because YAML is not Dart source.
**Fix**: Run `dart format` only on `.dart` files; validate YAML via `flutter pub get`.

## [ERR-20260502-PIL-MISSING] image_enlarge_python

**Logged**: 2026-05-02T10:04:00Z
**Priority**: low
**Status**: resolved
**Area**: tooling

### Summary
Attempted to use `uv run python` with Pillow/PIL to enlarge a screenshot, but PIL was not installed in the current environment.

### Details
For quick local screenshot enlargement/cropping on macOS, prefer built-in tools like `sips` or `qlmanage` unless Pillow is already installed. Avoid installing packages for a one-off visual inspection.

### Suggested Action
Use macOS-native image tools or browser/canvas snapshots for image inspection before reaching for PIL.

---
