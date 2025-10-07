# Roommate Finder App Architecture

## App Overview
A Tinder-like roommate finding app with swipe functionality, featuring a sleek modern UI with beautiful colors, generous spacing, and elegant fonts.

## Core Features (MVP)
1. Swipeable card stack showing potential roommate profiles
2. Like (swipe right) / Pass (swipe left) functionality
3. Profile view with roommate details
4. Matches screen to view liked profiles
5. Profile screen for user settings

## Data Models (lib/models)
1. **user_model.dart** - User/Roommate profile data
   - id, name, age, bio, location, occupation
   - budget, moveInDate, preferences (cleanliness, lifestyle)
   - images (profile photos)
   - created_at, updated_at

2. **match_model.dart** - Match data
   - id, userId, roommateId, matchedAt
   - created_at, updated_at

## Services (lib/services)
1. **roommate_service.dart** - Handle roommate data operations
   - Load profiles from local storage
   - Get next profile for swiping
   - Save like/pass decisions
   - Initialize with sample data

2. **match_service.dart** - Handle match operations
   - Save matches to local storage
   - Retrieve user matches
   - Initialize with sample data

## Screens (lib/screens)
1. **home_screen.dart** - Main screen with navigation
2. **swipe_screen.dart** - Card stack with swipeable profiles
3. **matches_screen.dart** - Grid/list of matched profiles
4. **profile_screen.dart** - User's own profile and settings

## Widgets (lib/widgets)
1. **roommate_card.dart** - Individual profile card with image and info
2. **action_buttons.dart** - Pass/Like buttons below card
3. **match_card.dart** - Card showing matched roommate in matches screen

## UI Design
- Modern gradient backgrounds
- Custom color palette (coral, teal, purple accents)
- Playfair Display for headings, Inter for body
- Generous padding (20-32px)
- Rounded corners (16-24px)
- Smooth animations for swipes
- Custom shadows and glassmorphism effects

## Implementation Steps
1. Update theme.dart with modern color palette
2. Create data models with toJson/fromJson/copyWith
3. Create service classes with sample data in local storage
4. Build swipeable card widget with gesture detection
5. Implement swipe screen with card stack
6. Create matches screen
7. Create profile screen
8. Build home screen with bottom navigation
9. Update main.dart
10. Test and debug with compile_project
