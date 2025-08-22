import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../theme/theme.dart';
import 'login/login_bloc/auth_bloc.dart';
import 'login/login_bloc/auth_event.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLargeScreen = size.width > 600; // Changed to width for better responsiveness
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryColor,
              AppTheme.secondaryColor,
              AppTheme.accentColor,
            ],
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 24,
                horizontal: isLargeScreen ? 120 : 24,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.psychology, size: 60, color: Colors.white),
                        const SizedBox(height: 24),
                        const Text(
                          'Interview Coach',
                          style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'AI-Powered Interview Practice Platform',
                          style: TextStyle(fontSize: 18, color: Colors.white70, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        _buildFeatureCard(
                          icon: Icons.people,
                          title: 'HR Interviews',
                          description: 'Practice behavioral and situational questions with AI feedback',
                        ),
                        const SizedBox(height: 16),
                        _buildFeatureCard(
                          icon: Icons.code,
                          title: 'Technical Interviews',
                          description: 'Solve coding problems and SQL queries with real-time evaluation',
                        ),
                        const SizedBox(height: 16),
                        _buildFeatureCard(
                          icon: Icons.analytics,
                          title: 'AI Feedback',
                          description: 'Get detailed feedback and scoring on your responses',
                        ),
                        const SizedBox(height: 32),
                        _buildActionButtons(context, isLargeScreen),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isLargeScreen) {
    final getStartedButton = ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, '/login');
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text(
        'Get Started',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );

    final learnMoreButton = OutlinedButton(
      onPressed: () => _showDemoDialog(),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.white),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text(
        'Learn More',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );

    if (isLargeScreen) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: getStartedButton),
          const SizedBox(width: 24),
          Expanded(child: learnMoreButton),
        ],
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch, // Makes buttons full width on small screens
        children: [
          getStartedButton,
          const SizedBox(height: 16),
          learnMoreButton,
        ],
      );
    }
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// show dialog
  void _showDemoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Interview Coach Features'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('🎯 Realistic Interview Simulation'),
            const SizedBox(height: 8),
            const Text('🤖 AI-Powered Question Generation'),
            const SizedBox(height: 8),
            const Text('💻 Built-in Code Editor'),
            const SizedBox(height: 8),
            const Text('📊 Detailed Performance Analytics'),
            const SizedBox(height: 8),
            const Text('🎨 Beautiful, Modern UI'),
            const SizedBox(height: 8),
            const Text('📱 Responsive Web Design'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}