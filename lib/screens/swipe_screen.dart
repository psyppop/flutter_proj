import 'package:flutter/material.dart';
import 'package:roostr/models/user_model.dart';
import 'package:roostr/services/roommate_service.dart';
import 'package:roostr/widgets/roommate_card.dart';
import 'package:roostr/widgets/action_buttons.dart';

class SwipeScreen extends StatefulWidget {
  const SwipeScreen({super.key});

  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> with SingleTickerProviderStateMixin {
  final RoommateService _roommateService = RoommateService();
  UserModel? _currentProfile;
  bool _isLoading = true;
  Offset _dragPosition = Offset.zero;
  double _dragAngle = 0;
  bool _isDragging = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _initializeData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    await _roommateService.initializeSampleData();
    await _loadNextProfile();
  }

  Future<void> _loadNextProfile() async {
    setState(() => _isLoading = true);
    final profile = await _roommateService.getNextProfile();
    setState(() {
      _currentProfile = profile;
      _isLoading = false;
      _dragPosition = Offset.zero;
      _dragAngle = 0;
    });
  }

  void _handlePass() async {
    if (_currentProfile == null) return;
    await _animateSwipe(const Offset(-500, 0));
    await _roommateService.passProfile(_currentProfile!.id);
    await _loadNextProfile();
  }

  void _handleLike() async {
    if (_currentProfile == null) return;
    await _animateSwipe(const Offset(500, 0));
    await _roommateService.likeProfile(_currentProfile!.id);
    await _loadNextProfile();
  }

  Future<void> _animateSwipe(Offset target) async {
    final animation = Tween<Offset>(
      begin: _dragPosition,
      end: target,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    animation.addListener(() {
      setState(() {
        _dragPosition = animation.value;
        _dragAngle = _dragPosition.dx / 1000;
      });
    });

    _animationController.forward(from: 0);
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Find Your Roommate',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            Expanded(
              child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _currentProfile == null
                  ? _buildNoMoreProfiles()
                  : Stack(
                      children: [
                        Center(
                          child: Transform.translate(
                            offset: _dragPosition,
                            child: Transform.rotate(
                              angle: _dragAngle,
                              child: GestureDetector(
                                onPanStart: (_) => setState(() => _isDragging = true),
                                onPanUpdate: (details) {
                                  setState(() {
                                    _dragPosition += details.delta;
                                    _dragAngle = _dragPosition.dx / 1000;
                                  });
                                },
                                onPanEnd: (details) {
                                  setState(() => _isDragging = false);
                                  if (_dragPosition.dx > 120) {
                                    _handleLike();
                                  } else if (_dragPosition.dx < -120) {
                                    _handlePass();
                                  } else {
                                    setState(() {
                                      _dragPosition = Offset.zero;
                                      _dragAngle = 0;
                                    });
                                  }
                                },
                                child: RoommateCard(roommate: _currentProfile!),
                              ),
                            ),
                          ),
                        ),
                        if (_isDragging && _dragPosition.dx.abs() > 40)
                          Positioned(
                            top: 100,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                decoration: BoxDecoration(
                                  color: _dragPosition.dx > 0 
                                    ? const Color(0xFF4ECDC4)
                                    : const Color(0xFFE74C3C),
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.2),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  _dragPosition.dx > 0 ? 'LIKE' : 'PASS',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
            ),
            const SizedBox(height: 20),
            if (!_isLoading && _currentProfile != null)
              ActionButtons(
                onPass: _handlePass,
                onLike: _handleLike,
              ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildNoMoreProfiles() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 80,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 24),
          Text(
            'No More Profiles',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              "You've viewed all available roommates. Check back later for new profiles!",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
