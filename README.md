# Gradium - Enhanced Cross-Platform Student Academic App

Gradium is a comprehensive Flutter application designed to help students track their academic progress, calculate GPAs, and participate in gamified leaderboards while maintaining privacy and data security.

## Features

### 🎓 Academic Tracking
- **Live Grade Sync**: Automatically syncs with Frisco ISD HAC (Home Access Center) API
- **GPA Calculator**: Both weighted and unweighted GPA calculations
- **Assignment Management**: Track assignments, due dates, and grades
- **Class Overview**: Detailed view of all classes with grades and schedules

### 🏆 Gamified Leaderboards
- **Privacy-First**: Opt-in leaderboard participation with full privacy controls
- **Multiple Visibility Options**: Full name, nickname, or anonymized display
- **GPA Visibility Controls**: Exact GPA, range, or hidden
- **Real-time Rankings**: Live leaderboard updates

### 🔒 Privacy & Security
- **Local Data Storage**: Sensitive academic data cached locally only
- **Secure Credentials**: School portal credentials encrypted and stored securely
- **No Parent Monitoring**: Student-focused design with full privacy control
- **Offline Functionality**: Works seamlessly without internet connection

### 📱 Modern UI/UX
- **Smooth Animations**: 200-400ms easing animations with consistent motion design
- **Dark/Light Themes**: Full theme support with Material 3 design
- **Responsive Design**: Optimized for all screen sizes
- **Accessibility**: Full accessibility support with reduced motion options

## Technical Architecture

### Backend
- **Supabase**: PostgreSQL database with Row-Level Security (RLS)
- **Authentication**: Google and Apple sign-in integration
- **Edge Functions**: Serverless functions for leaderboard calculations
- **Real-time**: Live updates for leaderboard and social features

### Frontend
- **Flutter**: Cross-platform development
- **Riverpod**: State management with providers
- **Go Router**: Navigation and routing
- **Material 3**: Modern design system

### Data Flow
1. **Authentication**: Google/Apple sign-in via Supabase Auth
2. **Credential Storage**: HAC credentials stored securely using Flutter Secure Storage
3. **Grade Sync**: Periodic sync with Frisco ISD HAC API
4. **Local Caching**: Academic data cached locally for offline access
5. **Privacy Controls**: User controls what data is shared on leaderboards

## Setup Instructions

### Prerequisites
- Flutter SDK (3.8.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Supabase account

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/gradium.git
   cd gradium
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up Supabase**
   - Create a new Supabase project
   - Enable Google and Apple authentication
   - Set up the database tables (profiles, leaderboard_scores)
   - Configure Row-Level Security policies

4. **Environment Configuration**
   Create a `.env` file in the root directory:
   ```
   SUPABASE_URL=your_supabase_url_here
   SUPABASE_ANON_KEY=your_supabase_anon_key_here
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

### Database Schema

The app uses the following Supabase tables:

#### profiles
- `id` (uuid, primary key)
- `username` (text)
- `avatar_url` (text)
- `opt_in_leaderboard` (boolean)
- `name_visibility` (text: 'full', 'nickname', 'anonymized')
- `gpa_visibility` (text: 'exact', 'range', 'hidden')
- `updated_at` (timestamp)

#### leaderboard_scores
- `user_id` (uuid, primary key)
- `encrypted_gpa` (text)
- `last_updated` (timestamp)

## API Integration

### Frisco ISD HAC API
The app integrates with the Frisco ISD HAC API for grade synchronization:

- **Base URL**: `https://friscoisdhacapi.vercel.app`
- **Endpoints**:
  - `/api/info` - Student information
  - `/api/gpa` - GPA and rank data
  - `/api/schedule` - Class schedule
  - `/api/currentclasses` - Current classes and assignments
  - `/api/pastclasses` - Past classes by quarter
  - `/api/transcript` - Academic transcript

### Data Processing
- **Grade Mapping**: Handles special grade types (CNS, CWS, INS)
- **GPA Calculation**: Implements both weighted and unweighted GPA algorithms
- **Error Handling**: Graceful fallback to cached data when sync fails

## Privacy & Security Features

### Data Privacy
- **Local Storage**: Academic data cached locally only
- **Selective Sync**: Only non-sensitive stats synced to Supabase
- **Encryption**: School credentials encrypted using Flutter Secure Storage
- **Privacy Controls**: Granular control over data visibility

### Security Measures
- **Row-Level Security**: Database-level access control
- **Secure Authentication**: OAuth integration with Google and Apple
- **Input Validation**: All user inputs validated and sanitized
- **Error Handling**: Secure error messages without data leakage

## Development

### Project Structure
```
lib/
├── main.dart                 # App entry point
├── router.dart              # Navigation configuration
├── models/                  # Data models
│   ├── assignment.dart
│   ├── class.dart
│   ├── grade.dart
│   ├── leaderboard_entry.dart
│   ├── school_credential.dart
│   └── user_profile.dart
├── providers/               # Riverpod providers
│   └── app_providers.dart
├── screens/                 # UI screens
│   ├── auth_screen.dart
│   ├── dashboard_screen.dart
│   ├── classes_screen.dart
│   ├── assignments_screen.dart
│   ├── leaderboard_screen.dart
│   ├── profile_screen.dart
│   └── main_app_shell.dart
└── services/               # Business logic
    ├── academic_service.dart
    ├── data_service.dart
    ├── gpa_service.dart
    └── hac_api_service.dart
```

### State Management
The app uses Riverpod for state management with the following providers:
- `academicServiceProvider` - Academic data operations
- `authStateProvider` - Authentication state
- `userProfileProvider` - User profile data
- `classesProvider` - Class data
- `assignmentsProvider` - Assignment data
- `gpaProvider` - GPA calculations
- `leaderboardProvider` - Leaderboard data

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support, email support@gradium.app or create an issue in the GitHub repository.

## Roadmap

- [ ] What-if GPA simulator
- [ ] Achievement system
- [ ] Social features (friends, study groups)
- [ ] Push notifications
- [ ] Export functionality
- [ ] Multi-district support
- [ ] Parent portal (optional)
- [ ] Advanced analytics
- [ ] Study planning tools
