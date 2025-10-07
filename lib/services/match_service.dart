import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:roostr/models/match_model.dart';

class MatchService {
  static const String _matchesKey = 'matches';

  Future<List<MatchModel>> getAllMatches() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_matchesKey);
    
    if (data == null) return [];
    
    final List<dynamic> jsonList = json.decode(data);
    return jsonList.map((json) => MatchModel.fromJson(json)).toList();
  }

  Future<void> addMatch(String userId, String roommateId) async {
    final prefs = await SharedPreferences.getInstance();
    final matches = await getAllMatches();
    
    final newMatch = MatchModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      roommateId: roommateId,
      matchedAt: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    matches.add(newMatch);
    final jsonList = matches.map((m) => m.toJson()).toList();
    await prefs.setString(_matchesKey, json.encode(jsonList));
  }

  Future<List<MatchModel>> getUserMatches(String userId) async {
    final allMatches = await getAllMatches();
    return allMatches.where((m) => m.userId == userId).toList();
  }
}
