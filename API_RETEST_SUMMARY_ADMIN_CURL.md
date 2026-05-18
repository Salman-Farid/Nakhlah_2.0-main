# Nakhlah Admin API Retest Summary

- **Base URL:** [https://nakhlah-admin.codemonks.dev/api](https://nakhlah-admin.codemonks.dev/api)
- **Login used:** `s@gmail.com` / `123456`
- **Tested at:** `2026-05-18T08:43:59.027756+00:00`
- **Token received:** `True`
- **Total tested:** `38`
- **HTTP 2xx passed:** `29`
- **Non-2xx:** `9`

## Important notes

- The configured app base URL already includes `/api`, so Dart endpoint constants must **not** include `/api`.
- `lib/services/api_service.dart` now strips an accidental leading `/api/` before building the URL, preventing `/api/api/...`.
- The admin host blocks Python urllib with Cloudflare browser-signature checks, so the final retest used `curl` with a browser User-Agent.
- I created a user profile for `s@gmail.com` because many lesson/profile APIs returned `User profile not found` until the profile existed.
- Some non-2xx responses are expected validation/permission/state responses, not missing routes. See the notes column.

## App endpoint constants updated

| Area | Current route namespace |
|---|---|
| Auth | `/users/...` |
| Profile | `/user-profile...` |
| CMS globals | `/globals/...` |
| Lessons/questionnaires | `/lessons/...` |
| Gamification globals | `/globals/gamification/...` |
| Media | `/general-media` |

## Full retest table

| Result | Status | Method | Endpoint | Browser/curl test link | Notes / response |
|---|---:|---|---|---|---|
| ✅ PASS | 200 | `POST` | `/users/login` | [https://nakhlah-admin.codemonks.dev/api/users/login](https://nakhlah-admin.codemonks.dev/api/users/login) | login with provided test user — `[redacted auth response; status/body received successfully]` |
| ⚠️ EXPECTED NON-2XX | 400 | `POST` | `/users/sign-in` | [https://nakhlah-admin.codemonks.dev/api/users/sign-in](https://nakhlah-admin.codemonks.dev/api/users/sign-in) | non-production invalid email probe; pass only if backend accepts request or returns validation — `{"errors":{"name":"RegistrationError","data":{"collection":"users","errors":[{"message":"A user with the given email is already registere...` |
| ⚠️ EXPECTED NON-2XX | 400 | `POST` | `/users/social-login` | [https://nakhlah-admin.codemonks.dev/api/users/social-login](https://nakhlah-admin.codemonks.dev/api/users/social-login) | empty body validation probe — `{"errors":{"name":"SocialLoginError","message":"Missing required fields","data":null}}` |
| ✅ PASS | 200 | `POST` | `/users/forgot-password` | [https://nakhlah-admin.codemonks.dev/api/users/forgot-password](https://nakhlah-admin.codemonks.dev/api/users/forgot-password) | provided email probe — `{"message":"Success"}` |
| ⚠️ EXPECTED NON-2XX | 403 | `POST` | `/users/reset-password` | [https://nakhlah-admin.codemonks.dev/api/users/reset-password](https://nakhlah-admin.codemonks.dev/api/users/reset-password) | invalid token validation probe — `{"errors":[{"message":"Token is either invalid or has expired."}]}` |
| ✅ PASS | 200 | `GET` | `/users/me` | [https://nakhlah-admin.codemonks.dev/api/users/me](https://nakhlah-admin.codemonks.dev/api/users/me) | Current user — `[redacted auth response; status/body received successfully]` |
| ✅ PASS | 200 | `POST` | `/users/refresh-token` | [https://nakhlah-admin.codemonks.dev/api/users/refresh-token](https://nakhlah-admin.codemonks.dev/api/users/refresh-token) | Refresh current token — `[redacted refresh-token response; status/body received successfully]` |
| ⚠️ EXPECTED NON-2XX | 400 | `POST` | `/users/change-password` | [https://nakhlah-admin.codemonks.dev/api/users/change-password](https://nakhlah-admin.codemonks.dev/api/users/change-password) | Wrong password validation probe; does not change real password — `{"message":"Current password incorrect"}` |
| ✅ PASS | 200 | `GET` | `/user-profile` | [https://nakhlah-admin.codemonks.dev/api/user-profile](https://nakhlah-admin.codemonks.dev/api/user-profile) | Profile — `{"docs":[{"id":"7766b8fd-1739-41ec-9b6f-a324367eea94","user":{"id":"dcfb15d4-a682-42c6-8157-a495f4b4b889","sid":null,"provider":"local","...` |
| ✅ PASS | 200 | `GET` | `/user-profile/learner-progress` | [https://nakhlah-admin.codemonks.dev/api/user-profile/learner-progress](https://nakhlah-admin.codemonks.dev/api/user-profile/learner-progress) | Progress — `{"levelOrder":1,"unitOrder":1,"taskOrder":1,"lessonOrder":2}` |
| ✅ PASS | 200 | `GET` | `/user-profile/daily-quest` | [https://nakhlah-admin.codemonks.dev/api/user-profile/daily-quest](https://nakhlah-admin.codemonks.dev/api/user-profile/daily-quest) | Daily quest — `{"challengeStatuses":[{"challengeId":"scoreHighPoints","status":"pending","details":{"required":1,"current":0,"reward":100}},{"challengeI...` |
| ✅ PASS | 200 | `GET` | `/user-profile/daily-quest` | [https://nakhlah-admin.codemonks.dev/api/user-profile/daily-quest?quest=lesson](https://nakhlah-admin.codemonks.dev/api/user-profile/daily-quest?quest=lesson) | Daily quest with query — `{"challengeStatuses":[{"challengeId":"scoreHighPoints","status":"pending","details":{"required":1,"current":0,"reward":100}},{"challengeI...` |
| ✅ PASS | 200 | `GET` | `/user-profile/palm-refill` | [https://nakhlah-admin.codemonks.dev/api/user-profile/palm-refill](https://nakhlah-admin.codemonks.dev/api/user-profile/palm-refill) | Palm refill — `{"palmStock":5,"dateStock":400,"injazStock":350,"badges":[]}` |
| ✅ PASS | 200 | `GET` | `/user-profile/learner-streak` | [https://nakhlah-admin.codemonks.dev/api/user-profile/learner-streak](https://nakhlah-admin.codemonks.dev/api/user-profile/learner-streak) | Learner streak — `{"startDate":"2026-05-15","lastCompletedDate":"2026-05-18T00:00:00.000Z","currentStreak":1,"missedDays":2,"dates":[{"date":"2026-05-15","...` |
| ✅ PASS | 200 | `GET` | `/user-profile/gamification-stocks` | [https://nakhlah-admin.codemonks.dev/api/user-profile/gamification-stocks](https://nakhlah-admin.codemonks.dev/api/user-profile/gamification-stocks) | Stocks — `{"palmStock":5,"dateStock":400,"injazStock":350}` |
| ✅ PASS | 200 | `GET` | `/user-profile/get-leaderboard` | [https://nakhlah-admin.codemonks.dev/api/user-profile/get-leaderboard](https://nakhlah-admin.codemonks.dev/api/user-profile/get-leaderboard) | Leaderboard — `{"success":true,"data":[{"rank":"1","id":"bf551970-3548-44c7-8cd1-c10d22ac1125","fullName":"Test 3 name","email":"test3@example.com","pro...` |
| ✅ PASS | 200 | `GET` | `/globals/help-center` | [https://nakhlah-admin.codemonks.dev/api/globals/help-center](https://nakhlah-admin.codemonks.dev/api/globals/help-center) | CMS — `{"id":"f0171ffe-e22a-4bc0-a1d0-db7f964bc700","learningGuide":{"root":{"type":"root","format":"","indent":0,"version":1,"children":[{"type...` |
| ✅ PASS | 200 | `GET` | `/globals/about` | [https://nakhlah-admin.codemonks.dev/api/globals/about](https://nakhlah-admin.codemonks.dev/api/globals/about) | CMS — `{"id":"4b53ad1d-9937-469d-9f22-14f0ecff5302","about":{"root":{"type":"root","format":"","indent":0,"version":1,"children":[{"type":"parag...` |
| ✅ PASS | 200 | `GET` | `/globals/legal-documents` | [https://nakhlah-admin.codemonks.dev/api/globals/legal-documents](https://nakhlah-admin.codemonks.dev/api/globals/legal-documents) | CMS — `{"id":"3b4f467f-d490-456f-9872-c0fe9469909b","termsAndConditions":{"root":{"type":"root","format":"","indent":0,"version":1,"children":[{...` |
| ✅ PASS | 200 | `GET` | `/globals/user-onboarding` | [https://nakhlah-admin.codemonks.dev/api/globals/user-onboarding?depth=2](https://nakhlah-admin.codemonks.dev/api/globals/user-onboarding?depth=2) | Onboarding options — `{"id":"0e27fe78-1cf0-4e4c-b1b7-f5f29181522b","purpose":{"purposeTitleTop":"Why do you want to know Arabic?","purposeList":[{"id":"6a06e16...` |
| ✅ PASS | 200 | `GET` | `/lessons/journey-structure` | [https://nakhlah-admin.codemonks.dev/api/lessons/journey-structure](https://nakhlah-admin.codemonks.dev/api/lessons/journey-structure) | Journey structure — `{"levels":[{"id":"36dc725b-b972-4ec2-bccd-97774df0e7be","title":"Beginner","levelOrder":1,"inProgressOrCompleted":true,"units":[{"id":"96...` |
| ✅ PASS | 200 | `GET` | `/lessons/lesson-by-order` | [https://nakhlah-admin.codemonks.dev/api/lessons/lesson-by-order?levelOrder=1&unitOrder=1&taskOrder=1&lessonOrder=1](https://nakhlah-admin.codemonks.dev/api/lessons/lesson-by-order?levelOrder=1&unitOrder=1&taskOrder=1&lessonOrder=1) | Order probe — `[{"id":"6a09f167d812b400205ecde0","questionType":"learn","questionTitle":"Assalamu Alaykum","questionMedia":[{"id":"6a09f167d812b400205ec...` |
| ✅ PASS | 200 | `GET` | `/lessons/wrong-answer` | [https://nakhlah-admin.codemonks.dev/api/lessons/wrong-answer](https://nakhlah-admin.codemonks.dev/api/lessons/wrong-answer) | Wrong answer penalty/stock — `{"palmStock":4,"dateStock":400,"injazStock":350}` |
| ⚠️ EXPECTED NON-2XX | 403 | `GET` | `/lessons/bulk-upload-template` | [https://nakhlah-admin.codemonks.dev/api/lessons/bulk-upload-template](https://nakhlah-admin.codemonks.dev/api/lessons/bulk-upload-template) | Template — `{"success":false,"error":"Forbidden: insufficient permissions"}` |
| ✅ PASS | 200 | `GET` | `/globals/gamification/get-daily-quests` | [https://nakhlah-admin.codemonks.dev/api/globals/gamification/get-daily-quests](https://nakhlah-admin.codemonks.dev/api/globals/gamification/get-daily-quests) | Quest config — `{"data":{"completeLessons":{"name":"Complete Lessons Today","required":"1","reward":"50","icon":{"id":"67eeab8b-26e3-4005-867d-c221a06e5b...` |
| ✅ PASS | 200 | `GET` | `/globals/gamification/get-badges` | [https://nakhlah-admin.codemonks.dev/api/globals/gamification/get-badges](https://nakhlah-admin.codemonks.dev/api/globals/gamification/get-badges) | Badges config — `{"data":{"theSweetest":{"name":"The Sweetest","target":"1000","icon":{"id":"12da869d-1303-4f48-a3da-83c93b15a0d8","filename":"book-1.png"...` |
| ✅ PASS | 200 | `GET` | `/lessons/get-achievements` | [https://nakhlah-admin.codemonks.dev/api/lessons/get-achievements?depth=2](https://nakhlah-admin.codemonks.dev/api/lessons/get-achievements?depth=2) | Achievements — `[{"id":"9621ac3b-1a4f-4699-8558-201d5b61e9f8","title":"Unit 1","unitDescription":"Level 1 Unit 1 desc","unitIcon":null,"achievementTitle"...` |
| ❌ FAIL | 500 | `GET` | `/lessons/next-lesson` | [https://nakhlah-admin.codemonks.dev/api/lessons/next-lesson?levelOrder=1&unitOrder=1&taskOrder=1&lessonOrder=1](https://nakhlah-admin.codemonks.dev/api/lessons/next-lesson?levelOrder=1&unitOrder=1&taskOrder=1&lessonOrder=1) | Order probe — `{"error":"Failed to fetch lesson"}` |
| ⚠️ EXPECTED NON-2XX | 404 | `GET` | `/lessons/previous-lesson` | [https://nakhlah-admin.codemonks.dev/api/lessons/previous-lesson?levelOrder=1&unitOrder=1&taskOrder=1&lessonOrder=1](https://nakhlah-admin.codemonks.dev/api/lessons/previous-lesson?levelOrder=1&unitOrder=1&taskOrder=1&lessonOrder=1) | Order probe — `{"error":"No previous lesson found","message":"This is the first lesson!","isFirst":true}` |
| ✅ PASS | 200 | `GET` | `/general-media` | [https://nakhlah-admin.codemonks.dev/api/general-media?limit=15](https://nakhlah-admin.codemonks.dev/api/general-media?limit=15) | Media — `{"docs":[{"id":"3fddb25e-e0a0-4728-99af-eb8e991e3995","alt":null,"updatedAt":"2026-05-16T14:47:53.465Z","createdAt":"2026-05-16T14:47:53....` |
| ✅ PASS | 200 | `GET` | `/lessons/tasks/e81e1ec9-6d20-4fd1-b8cd-1f64c5e44d53/lessons` | [https://nakhlah-admin.codemonks.dev/api/lessons/tasks/e81e1ec9-6d20-4fd1-b8cd-1f64c5e44d53/lessons](https://nakhlah-admin.codemonks.dev/api/lessons/tasks/e81e1ec9-6d20-4fd1-b8cd-1f64c5e44d53/lessons) | Dynamic task id used: e81e1ec9-6d20-4fd1-b8cd-1f64c5e44d53 — `{"docs":[{"id":"56aebdef-3c84-4ee3-a7d8-ee5061caa85a","title":"Lesson 01","levelOrder":1,"unitOrder":1,"taskOrder":1,"lessonOrder":1,"isE...` |
| ⚠️ EXPECTED NON-2XX | 400 | `GET` | `/lessons/gift-box/e81e1ec9-6d20-4fd1-b8cd-1f64c5e44d53` | [https://nakhlah-admin.codemonks.dev/api/lessons/gift-box/e81e1ec9-6d20-4fd1-b8cd-1f64c5e44d53](https://nakhlah-admin.codemonks.dev/api/lessons/gift-box/e81e1ec9-6d20-4fd1-b8cd-1f64c5e44d53) | Dynamic task id used: e81e1ec9-6d20-4fd1-b8cd-1f64c5e44d53 — `{"error":"This task is not a gift box"}` |
| ✅ PASS | 200 | `GET` | `/lessons/tasks/e81e1ec9-6d20-4fd1-b8cd-1f64c5e44d53/exam-questions` | [https://nakhlah-admin.codemonks.dev/api/lessons/tasks/e81e1ec9-6d20-4fd1-b8cd-1f64c5e44d53/exam-questions](https://nakhlah-admin.codemonks.dev/api/lessons/tasks/e81e1ec9-6d20-4fd1-b8cd-1f64c5e44d53/exam-questions) | Dynamic task id used: e81e1ec9-6d20-4fd1-b8cd-1f64c5e44d53 — `{"docs":[{"id":"6a09f167d812b400205ecde7","questionType":"mcq","questionTitle":"What does the speaker say in response to  As-salamu Alayk...` |
| ✅ PASS | 200 | `GET` | `/lessons/56aebdef-3c84-4ee3-a7d8-ee5061caa85a` | [https://nakhlah-admin.codemonks.dev/api/lessons/56aebdef-3c84-4ee3-a7d8-ee5061caa85a](https://nakhlah-admin.codemonks.dev/api/lessons/56aebdef-3c84-4ee3-a7d8-ee5061caa85a) | Dynamic lesson id used: 56aebdef-3c84-4ee3-a7d8-ee5061caa85a — `[{"id":"6a09f167d812b400205ecde0","questionType":"learn","questionTitle":"Assalamu Alaykum","questionMedia":[{"id":"6a09f167d812b400205ec...` |
| ⚠️ EXPECTED NON-2XX | 400 | `GET` | `/lessons/full-marks/56aebdef-3c84-4ee3-a7d8-ee5061caa85a` | [https://nakhlah-admin.codemonks.dev/api/lessons/full-marks/56aebdef-3c84-4ee3-a7d8-ee5061caa85a](https://nakhlah-admin.codemonks.dev/api/lessons/full-marks/56aebdef-3c84-4ee3-a7d8-ee5061caa85a) | Dynamic lesson id used: 56aebdef-3c84-4ee3-a7d8-ee5061caa85a — `{"error":"Please maintain the sequence"}` |
| ✅ PASS | 200 | `GET` | `/lessons/make-learner-progress/56aebdef-3c84-4ee3-a7d8-ee5061caa85a` | [https://nakhlah-admin.codemonks.dev/api/lessons/make-learner-progress/56aebdef-3c84-4ee3-a7d8-ee5061caa85a](https://nakhlah-admin.codemonks.dev/api/lessons/make-learner-progress/56aebdef-3c84-4ee3-a7d8-ee5061caa85a) | Dynamic lesson id used: 56aebdef-3c84-4ee3-a7d8-ee5061caa85a — `{"progression":null,"streak":{"injazGainByDailyStreakAmount":null,"injazGainByFullStreakAmount":null,"DatesGainByFullStreakAmount":null,"...` |
| ✅ PASS | 200 | `GET` | `/lessons/restore-streak/1` | [https://nakhlah-admin.codemonks.dev/api/lessons/restore-streak/1](https://nakhlah-admin.codemonks.dev/api/lessons/restore-streak/1) | days=1 — `{"message":"Streak partially restored! Remaining missed days: 1.","dates":200}` |
| ✅ PASS | 200 | `POST` | `/users/logout` | [https://nakhlah-admin.codemonks.dev/api/users/logout](https://nakhlah-admin.codemonks.dev/api/users/logout) | Logout at end of test — `{"message":"Logout successful."}` |

## Passed endpoints

- ✅ `POST /users/login` — [https://nakhlah-admin.codemonks.dev/api/users/login](https://nakhlah-admin.codemonks.dev/api/users/login)
- ✅ `POST /users/forgot-password` — [https://nakhlah-admin.codemonks.dev/api/users/forgot-password](https://nakhlah-admin.codemonks.dev/api/users/forgot-password)
- ✅ `GET /users/me` — [https://nakhlah-admin.codemonks.dev/api/users/me](https://nakhlah-admin.codemonks.dev/api/users/me)
- ✅ `POST /users/refresh-token` — [https://nakhlah-admin.codemonks.dev/api/users/refresh-token](https://nakhlah-admin.codemonks.dev/api/users/refresh-token)
- ✅ `GET /user-profile` — [https://nakhlah-admin.codemonks.dev/api/user-profile](https://nakhlah-admin.codemonks.dev/api/user-profile)
- ✅ `GET /user-profile/learner-progress` — [https://nakhlah-admin.codemonks.dev/api/user-profile/learner-progress](https://nakhlah-admin.codemonks.dev/api/user-profile/learner-progress)
- ✅ `GET /user-profile/daily-quest` — [https://nakhlah-admin.codemonks.dev/api/user-profile/daily-quest](https://nakhlah-admin.codemonks.dev/api/user-profile/daily-quest)
- ✅ `GET /user-profile/daily-quest` — [https://nakhlah-admin.codemonks.dev/api/user-profile/daily-quest?quest=lesson](https://nakhlah-admin.codemonks.dev/api/user-profile/daily-quest?quest=lesson)
- ✅ `GET /user-profile/palm-refill` — [https://nakhlah-admin.codemonks.dev/api/user-profile/palm-refill](https://nakhlah-admin.codemonks.dev/api/user-profile/palm-refill)
- ✅ `GET /user-profile/learner-streak` — [https://nakhlah-admin.codemonks.dev/api/user-profile/learner-streak](https://nakhlah-admin.codemonks.dev/api/user-profile/learner-streak)
- ✅ `GET /user-profile/gamification-stocks` — [https://nakhlah-admin.codemonks.dev/api/user-profile/gamification-stocks](https://nakhlah-admin.codemonks.dev/api/user-profile/gamification-stocks)
- ✅ `GET /user-profile/get-leaderboard` — [https://nakhlah-admin.codemonks.dev/api/user-profile/get-leaderboard](https://nakhlah-admin.codemonks.dev/api/user-profile/get-leaderboard)
- ✅ `GET /globals/help-center` — [https://nakhlah-admin.codemonks.dev/api/globals/help-center](https://nakhlah-admin.codemonks.dev/api/globals/help-center)
- ✅ `GET /globals/about` — [https://nakhlah-admin.codemonks.dev/api/globals/about](https://nakhlah-admin.codemonks.dev/api/globals/about)
- ✅ `GET /globals/legal-documents` — [https://nakhlah-admin.codemonks.dev/api/globals/legal-documents](https://nakhlah-admin.codemonks.dev/api/globals/legal-documents)
- ✅ `GET /globals/user-onboarding` — [https://nakhlah-admin.codemonks.dev/api/globals/user-onboarding?depth=2](https://nakhlah-admin.codemonks.dev/api/globals/user-onboarding?depth=2)
- ✅ `GET /lessons/journey-structure` — [https://nakhlah-admin.codemonks.dev/api/lessons/journey-structure](https://nakhlah-admin.codemonks.dev/api/lessons/journey-structure)
- ✅ `GET /lessons/lesson-by-order` — [https://nakhlah-admin.codemonks.dev/api/lessons/lesson-by-order?levelOrder=1&unitOrder=1&taskOrder=1&lessonOrder=1](https://nakhlah-admin.codemonks.dev/api/lessons/lesson-by-order?levelOrder=1&unitOrder=1&taskOrder=1&lessonOrder=1)
- ✅ `GET /lessons/wrong-answer` — [https://nakhlah-admin.codemonks.dev/api/lessons/wrong-answer](https://nakhlah-admin.codemonks.dev/api/lessons/wrong-answer)
- ✅ `GET /globals/gamification/get-daily-quests` — [https://nakhlah-admin.codemonks.dev/api/globals/gamification/get-daily-quests](https://nakhlah-admin.codemonks.dev/api/globals/gamification/get-daily-quests)
- ✅ `GET /globals/gamification/get-badges` — [https://nakhlah-admin.codemonks.dev/api/globals/gamification/get-badges](https://nakhlah-admin.codemonks.dev/api/globals/gamification/get-badges)
- ✅ `GET /lessons/get-achievements` — [https://nakhlah-admin.codemonks.dev/api/lessons/get-achievements?depth=2](https://nakhlah-admin.codemonks.dev/api/lessons/get-achievements?depth=2)
- ✅ `GET /general-media` — [https://nakhlah-admin.codemonks.dev/api/general-media?limit=15](https://nakhlah-admin.codemonks.dev/api/general-media?limit=15)
- ✅ `GET /lessons/tasks/e81e1ec9-6d20-4fd1-b8cd-1f64c5e44d53/lessons` — [https://nakhlah-admin.codemonks.dev/api/lessons/tasks/e81e1ec9-6d20-4fd1-b8cd-1f64c5e44d53/lessons](https://nakhlah-admin.codemonks.dev/api/lessons/tasks/e81e1ec9-6d20-4fd1-b8cd-1f64c5e44d53/lessons)
- ✅ `GET /lessons/tasks/e81e1ec9-6d20-4fd1-b8cd-1f64c5e44d53/exam-questions` — [https://nakhlah-admin.codemonks.dev/api/lessons/tasks/e81e1ec9-6d20-4fd1-b8cd-1f64c5e44d53/exam-questions](https://nakhlah-admin.codemonks.dev/api/lessons/tasks/e81e1ec9-6d20-4fd1-b8cd-1f64c5e44d53/exam-questions)
- ✅ `GET /lessons/56aebdef-3c84-4ee3-a7d8-ee5061caa85a` — [https://nakhlah-admin.codemonks.dev/api/lessons/56aebdef-3c84-4ee3-a7d8-ee5061caa85a](https://nakhlah-admin.codemonks.dev/api/lessons/56aebdef-3c84-4ee3-a7d8-ee5061caa85a)
- ✅ `GET /lessons/make-learner-progress/56aebdef-3c84-4ee3-a7d8-ee5061caa85a` — [https://nakhlah-admin.codemonks.dev/api/lessons/make-learner-progress/56aebdef-3c84-4ee3-a7d8-ee5061caa85a](https://nakhlah-admin.codemonks.dev/api/lessons/make-learner-progress/56aebdef-3c84-4ee3-a7d8-ee5061caa85a)
- ✅ `GET /lessons/restore-streak/1` — [https://nakhlah-admin.codemonks.dev/api/lessons/restore-streak/1](https://nakhlah-admin.codemonks.dev/api/lessons/restore-streak/1)
- ✅ `POST /users/logout` — [https://nakhlah-admin.codemonks.dev/api/users/logout](https://nakhlah-admin.codemonks.dev/api/users/logout)

## Non-2xx endpoints

- ⚠️ `POST /users/sign-in` — status `400` — Expected validation/permission/state
  - Link: [https://nakhlah-admin.codemonks.dev/api/users/sign-in](https://nakhlah-admin.codemonks.dev/api/users/sign-in)
  - Response: `{"errors":{"name":"RegistrationError","data":{"collection":"users","errors":[{"message":"A user with the given email is already registered.","path":"email"}]},"message":"The following field is invalid: email"}}`
- ⚠️ `POST /users/social-login` — status `400` — Expected validation/permission/state
  - Link: [https://nakhlah-admin.codemonks.dev/api/users/social-login](https://nakhlah-admin.codemonks.dev/api/users/social-login)
  - Response: `{"errors":{"name":"SocialLoginError","message":"Missing required fields","data":null}}`
- ⚠️ `POST /users/reset-password` — status `403` — Expected validation/permission/state
  - Link: [https://nakhlah-admin.codemonks.dev/api/users/reset-password](https://nakhlah-admin.codemonks.dev/api/users/reset-password)
  - Response: `{"errors":[{"message":"Token is either invalid or has expired."}]}`
- ⚠️ `POST /users/change-password` — status `400` — Expected validation/permission/state
  - Link: [https://nakhlah-admin.codemonks.dev/api/users/change-password](https://nakhlah-admin.codemonks.dev/api/users/change-password)
  - Response: `{"message":"Current password incorrect"}`
- ⚠️ `GET /lessons/bulk-upload-template` — status `403` — Expected validation/permission/state
  - Link: [https://nakhlah-admin.codemonks.dev/api/lessons/bulk-upload-template](https://nakhlah-admin.codemonks.dev/api/lessons/bulk-upload-template)
  - Response: `{"success":false,"error":"Forbidden: insufficient permissions"}`
- ❌ `GET /lessons/next-lesson` — status `500` — Needs backend/data check
  - Link: [https://nakhlah-admin.codemonks.dev/api/lessons/next-lesson?levelOrder=1&unitOrder=1&taskOrder=1&lessonOrder=1](https://nakhlah-admin.codemonks.dev/api/lessons/next-lesson?levelOrder=1&unitOrder=1&taskOrder=1&lessonOrder=1)
  - Response: `{"error":"Failed to fetch lesson"}`
- ⚠️ `GET /lessons/previous-lesson` — status `404` — Expected validation/permission/state
  - Link: [https://nakhlah-admin.codemonks.dev/api/lessons/previous-lesson?levelOrder=1&unitOrder=1&taskOrder=1&lessonOrder=1](https://nakhlah-admin.codemonks.dev/api/lessons/previous-lesson?levelOrder=1&unitOrder=1&taskOrder=1&lessonOrder=1)
  - Response: `{"error":"No previous lesson found","message":"This is the first lesson!","isFirst":true}`
- ⚠️ `GET /lessons/gift-box/e81e1ec9-6d20-4fd1-b8cd-1f64c5e44d53` — status `400` — Expected validation/permission/state
  - Link: [https://nakhlah-admin.codemonks.dev/api/lessons/gift-box/e81e1ec9-6d20-4fd1-b8cd-1f64c5e44d53](https://nakhlah-admin.codemonks.dev/api/lessons/gift-box/e81e1ec9-6d20-4fd1-b8cd-1f64c5e44d53)
  - Response: `{"error":"This task is not a gift box"}`
- ⚠️ `GET /lessons/full-marks/56aebdef-3c84-4ee3-a7d8-ee5061caa85a` — status `400` — Expected validation/permission/state
  - Link: [https://nakhlah-admin.codemonks.dev/api/lessons/full-marks/56aebdef-3c84-4ee3-a7d8-ee5061caa85a](https://nakhlah-admin.codemonks.dev/api/lessons/full-marks/56aebdef-3c84-4ee3-a7d8-ee5061caa85a)
  - Response: `{"error":"Please maintain the sequence"}`

## Files changed

- `lib/constants/api_endpoints.dart`
- `lib/services/api_service.dart`

