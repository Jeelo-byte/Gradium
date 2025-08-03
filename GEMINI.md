
Gradium: Enhanced Cross-Platform Student Academic App

Develop a cross-platform student academic app named “Gradium” using Flutter and Supabase backend.

Authentication & Security

    Use Supabase Auth with Google and Apple sign-in.

    Sync user profiles securely with privacy settings for data sharing.

    Store school grade website credentials encrypted in Supabase Vault or locally using Flutter Secure Storage.


Core Features

Grade & GPA Tracking

    Live sync with school portals:

        Synchronization should occur automatically when the user logs into the app.

        If the sync fails (e.g., network error, invalid credentials), a message should pop up stating "Unable to load grades." The app should then display the most recently cached grades instead.

        The app will integrate with external school portals like the 

        Frisco ISD HAC API (Base URL: https://friscoisdhacapi.vercel.app) to retrieve academic data.

Specific API endpoints to be utilized include: 

/api/info, /api/gpa, /api/schedule, /api/currentclasses, /api/pastclasses, and /api/transcript.

    Data Mapping & Score Handling: Data from these APIs will be parsed and mapped to relevant app models. For GPA calculations:

        "CNS" (Currently Not Scored) and "CWS" (Completed With Score) assignments do not count towards GPA.

        "INS" (Incomplete) assignments count as 0 in terms of GPA.

Manual Entry: Allow users to manually enter and manage grades and assignments.

Weighted and unweighted GPA calculators:

    Unweighted GPA: This GPA will be based on a 4.0 scale, where all courses are counted equally. It will be calculated to three decimal places based on semester grades for high school credit courses. The following scale will be used:

    90-100 = 4.0 points 

80-89 = 3.0 points 

70-79 = 2.0 points 

0-69 = 0 points 

Weighted GPA: This GPA will be based on a 5.0 scale, where different courses (advanced, AP, IB, Dual Credit) carry different weights. It will be calculated to three decimal places based on semester grades for high school credit courses.

    What-If simulator: Allow users to input hypothetical scores for assignments and immediately see the impact on their overall class grade and GPA. It should also allow for adding hypothetical assignments, with real-time animation feedback reflecting changes.

Gamified Leaderboards

    Ranking by GPA, grade improvement %, homework completion streaks, app engagement streaks.

    Data Source: All data used for leaderboards (GPA, grade improvement %) will be derived exclusively from API-retrieved data to ensure a fair and even playing field.

    Academic Period Summaries: Whenever a new quarter, 9 weeks, semester, or school year ends, allow for a summary to be shown, highlighting trends and achievements (similar to "Spotify Wrapped").

    Filters: Grade-level, School-wide, District-wide.

    Privacy: opt-in leaderboard, name visibility toggles (full, nickname, anonymized), GPA visibility toggles (exact, range, hidden).

    Masked leaderboard entries still show correct placement.

Privacy & Profile Settings

    Full control over profile visibility, schedule sharing, and grade visibility.

    No parent mode or external monitoring.

    Sensitive Data Handling: Academic data (individual grades, detailed assignments, transcripts) should be cached on the user's device only and never synced to any database. This data is exclusively for the student's personal tracking and what-if simulations.

    Only specific, non-sensitive stats, such as the user's GPA (if the user explicitly allows it for leaderboard participation), should be synced to Supabase and stored as an encrypted value.

Technical Architecture & Tools

    Supabase Postgres DB with Row-Level Security (RLS) to enforce data privacy for social features.

    Supabase Edge Functions for leaderboard calculations and analytics.

    Use Flutter Secure Storage for local encryption of sensitive credentials (e.g., school portal login).

    Flutter animations: Hero transitions, AnimatedContainers, Rive or Lottie for cross-platform consistency.

    State management via Riverpod or Bloc.

    Analytics and error tracking integrated (Supabase or third-party).

    Support light/dark modes, multiple color themes, accessibility options.

Offline Functionality

    When the app is offline, it should seamlessly use cached data for displaying grades, schedules, and tasks.

    Manual entries and hypothetical changes made in the what-if simulator while offline should never be synced to any type of database. These are solely for the student's personal calculations and should not persist beyond the local device's cache or session.

Animation & Motion Design (Core Principles)

    Use 200–400ms easing animations with ease-in-out curves for smoothness.

    Motion must clarify user intent and never distract.

    Subtle microinteractions for rewarding feedback.

    Consistent animation logic on iOS, Android, and web.

    Use GPU-accelerated transitions to avoid lag.

Animation Ideas by Feature

    Login/Home: fade-in + logo zoom, inputs float, morph button to spinner.

    Grades Dashboard: card flip, height transitions for bars, slide/pulse on grade changes.

    GPA Calculator: real-time slider animations, smooth GPA counter, elastic chart bars.

    Leaderboard: slide-in rankings, flicker for anonymized users, glow/bounce on placement changes, smooth privacy toggle transitions.

    Social Feed: posts slide from top, emoji scaling on reactions, comment box expansion.

    Friends: friend request card fold/unfold animations.

    Schedule Comparison: pulse/glow on shared classes, split screen transition, animated free time suggestions.

    Achievements: badge spin/sparkle/pop, streak bars fill with glow, theme background fade/blurs.

Microinteraction Examples

    Tap button: shrink 5%, bounce back.

    New assignment: slide + checkmark pop.

    Swipe dismiss: fade + friction bounce.

    Face ID login: smiley wink animation.

Accessibility in Motion

    Respect prefers-reduced-motion settings.

    Avoid disorienting camera shakes or spins.

    All animations non-blocking and interruptible.