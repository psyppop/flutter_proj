import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:roostr/models/user_model.dart';

class RoommateService {
  static const String _roommatesKey = 'roommates';
  static const String _passedKey = 'passed_profiles';
  static const String _likedKey = 'liked_profiles';
  static const String _currentUserKey = 'current_user';
  static const String _isLoggedInKey = 'is_logged_in';

  Future<void> initializeSampleData() async {
    final prefs = await SharedPreferences.getInstance();
    final existingData = prefs.getString(_roommatesKey);
    
    if (existingData == null) {
      final sampleRoommates = [
        UserModel(
          id: '1',
          name: 'Sarah Johnson',
          age: 24,
          bio: 'Software engineer who loves cooking and yoga. Looking for a clean, respectful roommate to share a 2BR apartment.',
          location: 'San Francisco, CA',
          occupation: 'Software Engineer',
          budget: 1500,
          moveInDate: 'March 2025',
          cleanliness: 'Very Clean',
          lifestyle: 'Early Bird',
          images: ['assets/images/young_professional_apartment_null_1759858345407.jpg'],
          email: 'sarah.johnson@email.com',
          phone: '+1 (415) 555-0123',
          address: '123 Market St, San Francisco, CA 94102',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        UserModel(
          id: '2',
          name: 'Michael Chen',
          age: 22,
          bio: 'Graduate student studying architecture. Quiet, organized, and enjoys occasional movie nights.',
          location: 'New York, NY',
          occupation: 'Graduate Student',
          budget: 1200,
          moveInDate: 'April 2025',
          cleanliness: 'Clean',
          lifestyle: 'Night Owl',
          images: ['assets/images/college_student_portrait_null_1759858346360.jpg'],
          email: 'mchen@university.edu',
          phone: '+1 (212) 555-0187',
          address: '456 Broadway, New York, NY 10013',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        UserModel(
          id: '3',
          name: 'Emma Rodriguez',
          age: 27,
          bio: 'Marketing professional. Love plants, good music, and hosting small gatherings on weekends.',
          location: 'Austin, TX',
          occupation: 'Marketing Manager',
          budget: 1400,
          moveInDate: 'February 2025',
          cleanliness: 'Very Clean',
          lifestyle: 'Social',
          images: ['assets/images/working_professional_headshot_null_1759858347818.jpg'],
          email: 'emma.r@marketingco.com',
          phone: '+1 (512) 555-0245',
          address: '789 Congress Ave, Austin, TX 78701',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        UserModel(
          id: '4',
          name: 'David Kim',
          age: 25,
          bio: 'Medical student looking for a quiet place to study. Respectful of shared spaces and schedules.',
          location: 'Boston, MA',
          occupation: 'Medical Student',
          budget: 1100,
          moveInDate: 'May 2025',
          cleanliness: 'Clean',
          lifestyle: 'Quiet',
          images: ['assets/images/graduate_student_portrait_null_1759858352621.jpg'],
          email: 'dkim@medschool.edu',
          phone: '+1 (617) 555-0398',
          address: '234 Beacon St, Boston, MA 02116',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        UserModel(
          id: '5',
          name: 'Jessica Taylor',
          age: 26,
          bio: 'Graphic designer who works from home. Looking for someone friendly and easy to get along with.',
          location: 'Seattle, WA',
          occupation: 'Graphic Designer',
          budget: 1300,
          moveInDate: 'March 2025',
          cleanliness: 'Moderate',
          lifestyle: 'Flexible',
          images: ['assets/images/young_adult_professional_null_1759858355831.jpg'],
          email: 'jtaylor.design@email.com',
          phone: '+1 (206) 555-0471',
          address: '567 Pike St, Seattle, WA 98101',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        UserModel(
          id: '6',
          name: 'Alex Martinez',
          age: 23,
          bio: 'Financial analyst who enjoys fitness and outdoor activities. Looking for an active roommate.',
          location: 'Denver, CO',
          occupation: 'Financial Analyst',
          budget: 1250,
          moveInDate: 'April 2025',
          cleanliness: 'Very Clean',
          lifestyle: 'Active',
          images: ['assets/images/millennial_professional_null_1759858356998.jpg'],
          email: 'alex.martinez@finance.com',
          phone: '+1 (303) 555-0652',
          address: '890 16th St, Denver, CO 80202',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      final jsonList = sampleRoommates.map((r) => r.toJson()).toList();
      await prefs.setString(_roommatesKey, json.encode(jsonList));
    }
  }

  Future<List<UserModel>> getAllRoommates() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_roommatesKey);
    
    if (data == null) return [];
    
    final List<dynamic> jsonList = json.decode(data);
    return jsonList.map((json) => UserModel.fromJson(json)).toList();
  }

  Future<UserModel?> getNextProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final passed = prefs.getStringList(_passedKey) ?? [];
    final liked = prefs.getStringList(_likedKey) ?? [];
    
    final allRoommates = await getAllRoommates();
    final viewedIds = {...passed, ...liked};
    
    final unviewedRoommates = allRoommates.where((r) => !viewedIds.contains(r.id)).toList();
    
    return unviewedRoommates.isEmpty ? null : unviewedRoommates.first;
  }

  Future<void> passProfile(String profileId) async {
    final prefs = await SharedPreferences.getInstance();
    final passed = prefs.getStringList(_passedKey) ?? [];
    if (!passed.contains(profileId)) {
      passed.add(profileId);
      await prefs.setStringList(_passedKey, passed);
    }
  }

  Future<void> likeProfile(String profileId) async {
    final prefs = await SharedPreferences.getInstance();
    final liked = prefs.getStringList(_likedKey) ?? [];
    if (!liked.contains(profileId)) {
      liked.add(profileId);
      await prefs.setStringList(_likedKey, liked);
    }
  }

  Future<List<UserModel>> getLikedProfiles() async {
    final prefs = await SharedPreferences.getInstance();
    final liked = prefs.getStringList(_likedKey) ?? [];
    final allRoommates = await getAllRoommates();
    
    return allRoommates.where((r) => liked.contains(r.id)).toList();
  }

  Future<void> saveCurrentUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserKey, json.encode(user.toJson()));
    await prefs.setBool(_isLoggedInKey, true);
  }

  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_currentUserKey);
    if (data == null) return null;
    return UserModel.fromJson(json.decode(data));
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
    await prefs.setBool(_isLoggedInKey, false);
  }
}
