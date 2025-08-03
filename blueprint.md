# Gradium: Enhanced Cross-Platform Student Academic App - Blueprint

## Project Overview

Gradium is a cross-platform mobile and web application designed for students to track, manage, and analyze their academic performance. It focuses on providing robust grade and GPA tracking, a gamified leaderboard system, achievements, social features for connecting with friends and sharing schedules, and a comprehensive planner for task management. A core principle of Gradium is strong data privacy, particularly the local caching of sensitive academic data. The app will be built using Flutter for cross-platform compatibility and Supabase as the backend.

## Feature Outline

### Authentication & Security

*   **Supabase Auth:** Implement user authentication using Google and Apple sign-in providers.
*   **Profile Sync:** Securely synchronize user profiles with privacy settings for controlling data sharing.
*   **Credential Storage:** Store school grade website credentials encrypted either in Supabase Vault (server-side) or locally using Flutter Secure Storage (client-side), prioritizing client-side storage for sensitive data.


### Core Features

#### Grade & GPA Tracking

*   **Live Sync with School Portals:**
    *   Automatic synchronization upon app login.
    *   Display cached grades and show an "Unable to load grades" message if sync fails.
    *   Integrate with the Frisco ISD HAC API (`https://friscoisdhacapi.vercel.app`).
    *   Utilize API endpoints: `/api/info`, `/api/gpa`, `/api/schedule`, `/api/currentclasses`, `/api/pastclasses`, `/api/transcript`.
    *   Parse API data and map to app models.
    *   **GPA Calculation Logic:** "CNS" and "CWS" assignments do not count towards GPA. "INS" assignments count as 0.
*   **Manual Entry:** Allow users to manually input and manage grades and assignments.
*   **GPA Calculators:** Provide both weighted and unweighted GPA calculation tools.
*   **What-If Simulator:** Enable users to input hypothetical scores or add hypothetical assignments to see the real-time impact on class grades and GPA with animated feedback.

#### Gamified Leaderboards

*   **Ranking Metrics:** Rank users by GPA, grade improvement percentage, homework completion streaks, and app engagement streaks.
*   **Data Source:** Leaderboard data (GPA, grade improvement %) will be derived **exclusively from API-retrieved data**.
*   **Academic Period Summaries:** Provide summaries at the end of quarters, 9 weeks, semesters, and school years, highlighting trends and achievements.
*   **Filters:** Allow filtering by grade-level, school-wide, and district-wide.
*   **Privacy:** Opt-in leaderboards, name visibility toggles (full, nickname, anonymized), GPA visibility toggles (exact, range, hidden). Masked entries still show correct placement.

#### Achievements & Rewards

*   **Badges:** Unlock achievements like “Top 5%,” “Homework Hero,” “Comeback Kid.”
*   **Rewards:** Redeem earned badges for app themes, icons, or leaderboard flair.

#### Social Media & Friends

*   **Adding Friends:** Add friends via username search, QR codes, or mutual class suggestions.
*   **Friend Requests:** Accept/reject requests with customizable trust levels.
*   **Academic Updates:** Post academic updates with support for emoji reactions and comments.

#### Schedule Sharing & Comparison

*   **Sharing:** Allow users to opt-in to share their schedules per class or time block.
*   **Comparison:** Compare schedules with friends, highlighting overlapping classes and free time.
*   **Suggestions:** Suggest optimal times for studying or meeting based on shared schedules.

#### Planner & Tasks

*   **Task Management:** Assign tasks to specific classes with due dates and notification capabilities.
*   **Streak Tracking:** Track homework completion streaks with animated progress bars.

## Technical Architecture & Tools

*   **Frontend:** Flutter for cross-platform development (iOS, Android, Web).
*   **Backend:** Supabase (Supabase is set up and initialized in the project).
    *   **Database:** Supabase Postgres DB with Row-Level Security (RLS) for enforcing data privacy, especially for social features.
    *   **Functions:** Supabase Edge Functions for efficient leaderboard calculations and analytics processing.
    *   **Authentication:** Supabase Auth for user sign-in (Supabase Auth is planned for implementation).
*   **API Integration:** Integration with the Frisco ISD HAC API for retrieving academic data. Handle URL-encoding of credentials as required by the API.
    *   Base URL: `https://friscoisdhacapi.vercel.app`
    *   Endpoints: `/api/info`, `/api/gpa`, `/api/schedule`, `/api/currentclasses`, `/api/pastclasses`, `/api/transcript`.
*   **Secure Storage:** Flutter Secure Storage for local encryption of sensitive credentials like school portal logins.
*   **State Management:** Utilize Riverpod or Bloc for managing application state effectively.
*   **Animations:** Implement Flutter animations, including Hero transitions, AnimatedContainers, and potentially Rive or Lottie for complex cross-platform animations.
*   **Analytics & Error Tracking:** Integrate an analytics and error tracking solution (potentially Supabase's built-in capabilities or a third-party service).
*   **UI/UX:** Support for light/dark modes, multiple color themes, and accessibility options.

## Privacy & Security

*   **User Control:** Provide users with full control over profile visibility, schedule sharing, and grade visibility settings.
*   **No External Monitoring:** Explicitly exclude features for parent mode or any external monitoring of student data.
*   **Sensitive Data Handling:** **Academic data (individual grades, detailed assignments, transcripts) will be cached on the user's device only and never synced to any database.** This data is exclusively for personal tracking and the what-if simulator.
*   **Synced Data:** Only specific, non-sensitive statistics like the user's GPA (if opted into leaderboards) will be synced to Supabase and stored as an **encrypted value**.

### Offline Functionality

*   **Cached Data:** When offline, the app will seamlessly use cached data to display grades, schedules, and tasks.
*   **Local Changes:** Manual grade entries and hypothetical what-if simulator changes made while offline will **never be synced** to any database. These changes are temporary and exist only within the local device's cache or session.

## Animation & Motion Design

*   **Core Principles:**
    *   Use 200–400ms easing animations with ease-in-out curves.
    *   Motion should enhance understanding and not distract.
    *   Incorporate subtle microinteractions for feedback.
    *   Ensure consistent animation behavior across all platforms.
    *   Utilize GPU-accelerated transitions for performance.
*   **Animation Ideas by Feature:**
    *   **Login/Home:** Fade-in with logo zoom, inputs float, button morphing to a spinner.
    *   **Grades Dashboard:** Card flips, height transitions for bars, slide/pulse on grade changes.
    *   **GPA Calculator:** Real-time slider animations, smooth GPA counter, elastic chart bars.
    *   **Leaderboard:** Slide-in rankings, flicker for anonymized users, glow/bounce on placement changes, smooth privacy toggle transitions.
    *   **Social Feed:** Posts slide from the top, emoji scaling on reactions, comment box expansion.
    *   **Friends:** Friend request card fold/unfold animations.
    *   **Schedule Comparison:** Pulse/glow on shared classes, split-screen transition, animated free time suggestions.
    *   **Achievements:** Badge spin/sparkle/pop, streak bars filling with a glow, theme background fade/blurs.
*   **Microinteraction Examples:**
    *   Button Tap: Shrink slightly and bounce back.
    *   New Assignment Added: Slide in with a checkmark pop.
    *   Swipe Dismiss: Fade out with a friction bounce.
    *   Face ID Login: Smiley wink animation.
*   **Accessibility in Motion:**
    *   Respect the user's `prefers-reduced-motion` settings.
    *   Avoid disorienting camera shakes or spins.
    *   Ensure all animations are non-blocking and can be interrupted by user actions.