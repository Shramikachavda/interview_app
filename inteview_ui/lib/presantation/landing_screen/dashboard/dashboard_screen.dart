import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constant/enums/difficulty_level.dart';
import '../../../core/constant/enums/session_type.dart';
import '../../../data/models/interview_models.dart';
import '../../../data/models/user_model.dart';
import '../interview/interview_bloc/interview_bloc.dart';
import '../interview/interview_bloc/interview_event.dart';
import '../interview/interview_bloc/interview_state.dart';
import '../login/login_bloc/auth_bloc.dart';
import '../login/login_bloc/auth_event.dart';
import '../login/login_bloc/auth_state.dart';

class DashboardScreen extends StatelessWidget {
  final User user;

  const DashboardScreen({super.key, required this.user});

  void _startInterview(BuildContext context, SessionType sessionType) {
    final difficulty = user.level != null
        ? DifficultyLevel.values.firstWhere(
            (lvl) => lvl.name.toLowerCase() == user.level!.toLowerCase(),
            orElse: () => DifficultyLevel.easy,
          )
        : DifficultyLevel.easy;

    final initialState = InterviewModel(
      done: false,
      userId: user.id ?? 0,
      sessionType: sessionType,
      level: difficulty,
    );

    context.read<InterviewBloc>().add(
      StartInterview(initialState: initialState),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Row(
          children: [
            Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.error,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              'Confirm Logout',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to logout? You will need to sign in again to access your dashboard.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Text(
              'Cancel',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(LogoutUser());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Logout',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        final padding = 24.0; // Consistent 24px padding for all views

        return BlocListener<AuthBloc, AuthState>(
          listener: (context, authState) {
            if (authState is AuthUnauthenticated) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            } else if (authState is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.white),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          authState.message ?? 'Logout failed',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: Theme.of(context).colorScheme.error,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }
          },
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            body: SafeArea(
              child: Column(
                children: [
                  _buildCustomAppBar(context),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: padding,
                      ), // 24px padding
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 32),
                          _buildWelcomeSection(context),
                          const SizedBox(height: 32),
                          _buildSectionHeader(context),
                          const SizedBox(height: 20),
                          _buildInterviewCards(context),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCustomAppBar(BuildContext context) {




        return Container(
          padding: EdgeInsets.symmetric(
            vertical: 12,
          ), // Removed padding to span full width
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(16),
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SafeArea(
            bottom: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 24, width: 24),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Interview Coach',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize:   18  ,
                      ),
                    ),
                    Text(
                      'Your Path to Success',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onPrimary.withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'logout':
                        _showLogoutDialog(context);
                        break;
                      case 'change_level':
                        _showFeatureComingSoon(context, 'Change Level');
                        break;
                      case 'privacy policy':


                      break;
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'change_level',
                      child: Row(
                        children: [
                          Icon(
                            Icons.swap_vert,
                            size: 20,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Change Level',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'Setting',
                      onTap: () {
                        Navigator.pushNamed(context, '/settings');
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.settings,
                            size: 20,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Setting',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),

                    const PopupMenuDivider(),
                    PopupMenuItem(
                      value: 'logout',
                      child: Row(
                        children: [
                          Icon(
                            Icons.logout,
                            size: 20,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Logout',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.onPrimary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.more_vert,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 20,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
          ),
        );

  }

  Widget _buildWelcomeSection(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24), // 24px padding
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.surface,
                Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(isMobile ? 20 : 24),
            child: isMobile
                ? Column(
                    children: [
                      _buildUserAvatar(context),
                      const SizedBox(height: 16),
                      _buildUserInfo(context, centered: true),
                    ],
                  )
                : Row(
                    children: [
                      _buildUserAvatar(context),
                      const SizedBox(width: 20),
                      Expanded(child: _buildUserInfo(context, centered: false)),
                      const SizedBox(width: 16),
                      _buildQuickStats(context),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Widget _buildUserAvatar(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        final avatarSize = isMobile ? 40.0 : 50.0;

        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: avatarSize,
            backgroundColor: Colors.transparent,
            child: Text(
              user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: isMobile ? 24 : 28,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUserInfo(BuildContext context, {required bool centered}) {
    return Column(
      crossAxisAlignment: centered
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Hello, ${user.name}! 👋',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          textAlign: centered ? TextAlign.center : TextAlign.start,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Text(
          'Ready to ace your next interview?',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            height: 1.3,
          ),
          textAlign: centered ? TextAlign.center : TextAlign.start,
        ),
        const SizedBox(height: 12),
        _buildLevelBadge(context, centered),
      ],
    );
  }

  Widget _buildLevelBadge(BuildContext context, bool centered) {
    final levelColor = _getLevelColor(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [levelColor.withOpacity(0.1), levelColor.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: levelColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getLevelIcon(), size: 18, color: levelColor),
          const SizedBox(width: 8),
          Text(
            '${user.level?.toUpperCase() ?? 'EASY'} LEVEL',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: levelColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;

        return Container(
          padding: EdgeInsets.all(isMobile ? 12 : 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.rocket_launch,
                color: Theme.of(context).colorScheme.primary,
                size: isMobile ? 24 : 28,
              ),
              const SizedBox(height: 8),
              Text(
                'Let\'s Go!',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Start Now',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24), // 24px padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose Your Interview Type',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select the type of interview you want to practice',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterviewCards(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        final availableWidth =
            constraints.maxWidth - 48; // 24px padding on each side

        return BlocConsumer<InterviewBloc, InterviewBlocState>(
          listener: (context, state) {
            if (state is InterviewLoaded || state is InterviewCompleted) {
              final interview = state.interview;
              if (interview != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pushReplacementNamed(
                    context,
                    '/interview',
                    arguments: interview,
                  );
                });
              }
            } else if (state is InterviewError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.white),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          state.message ?? 'Failed to start interview',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: Theme.of(context).colorScheme.error,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            final isHrLoading =
                state is InterviewLoading &&
                state.interview?.sessionType == SessionType.hr;
            final isTechLoading =
                state is InterviewLoading &&
                state.interview?.sessionType == SessionType.technical;

            final cards = [
              ModernInterviewCard(
                icon: Icons.people_alt_outlined,
                title: 'HR Interview',
                subtitle: 'Behavioral Questions',
                description:
                    'Prepare for behavioral and situational questions that assess your soft skills and cultural fit.',
                color: Theme.of(context).colorScheme.primary,
                features: [
                  'Communication Skills',
                  'Leadership',
                  'Problem Solving',
                ],
                onTap: isHrLoading
                    ? null
                    : () => _startInterview(context, SessionType.hr),
                isLoading: isHrLoading,
              ),
              ModernInterviewCard(
                icon: Icons.code_outlined,
                title: 'Technical Interview',
                subtitle: 'Coding Challenges',
                description:
                    'Practice coding problems, algorithms, and technical concepts to boost your technical skills.',
                color: Theme.of(context).colorScheme.secondary,
                features: ['Algorithms', 'Data Structures', 'System Design'],
                onTap: isTechLoading
                    ? null
                    : () => _startInterview(context, SessionType.technical),
                isLoading: isTechLoading,
              ),
            ];

            if (isMobile) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: cards
                    .map(
                      (card) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: SizedBox(
                          width:
                              (availableWidth - 16) /
                              2, // Adjusted for two cards
                          child: card,
                        ),
                      ),
                    )
                    .toList(),
              );
            } else {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: cards
                    .map(
                      (card) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: card,
                        ),
                      ),
                    )
                    .toList(),
              );
            }
          },
        );
      },
    );
  }

  Color _getLevelColor(BuildContext context) {
    switch (user.level?.toLowerCase()) {
      case 'hard':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'easy':
      default:
        return Colors.green;
    }
  }

  IconData _getLevelIcon() {
    switch (user.level?.toLowerCase()) {
      case 'hard':
        return Icons.star;
      case 'medium':
        return Icons.star_half;
      case 'easy':
      default:
        return Icons.star_outline;
    }
  }

  void _showFeatureComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.construction, color: Colors.white),
            const SizedBox(width: 8),
            Text('$feature feature coming soon!'),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

class ModernInterviewCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String description;
  final Color color;
  final List<String> features;
  final VoidCallback? onTap;
  final bool isLoading;

  const ModernInterviewCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.color,
    required this.features,
    this.onTap,
    this.isLoading = false,
  });

  @override
  State<ModernInterviewCard> createState() => _ModernInterviewCardState();
}

class _ModernInterviewCardState extends State<ModernInterviewCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final disabled = widget.onTap == null;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;

        return MouseRegion(
          onEnter: (_) {
            if (!disabled && !widget.isLoading) {
              _controller.forward();
              setState(() => _isHovered = true);
            }
          },
          onExit: (_) {
            _controller.reverse();
            setState(() => _isHovered = false);
          },
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: GestureDetector(
                  onTap: widget.isLoading ? null : widget.onTap,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: isMobile
                          ? (constraints.maxWidth - 48) / 2
                          : double.infinity,
                      maxHeight: double.infinity,
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.all(24), // 24px padding

                      decoration: BoxDecoration(
                        gradient: _isHovered
                            ? LinearGradient(
                                colors: [
                                  widget.color.withValues(alpha: 0.1),
                                  Theme.of(context).colorScheme.surface,
                                ],
                                begin: Alignment.bottomRight,
                                end: Alignment.topLeft,
                              )
                            : null,

                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _isHovered
                              ? widget.color.withOpacity(0.5)
                              : Theme.of(
                                  context,
                                ).colorScheme.outline.withOpacity(0.1),
                          width: _isHovered ? 2 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _isHovered
                                ? widget.color.withOpacity(0.2)
                                : Theme.of(
                                    context,
                                  ).colorScheme.shadow.withOpacity(0.08),
                            blurRadius: _isHovered ? 20 : 10,
                            offset: const Offset(0, 4),
                            spreadRadius: _isHovered ? 2 : 0,
                          ),
                        ],
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: widget.color.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  widget.icon,
                                  color: widget.color,
                                  size: 24,
                                ),
                              ),
                              if (widget.isLoading) const SizedBox(width: 12),
                              if (widget.isLoading)
                                SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation(
                                      widget.color,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            widget.title,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: _isHovered
                                      ? widget
                                            .color // highlight text on hover
                                      : Theme.of(context).colorScheme.onSurface,
                                  fontSize: 18,
                                ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),

                          Text(
                            widget.subtitle,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: widget.color,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12),
                          Flexible(
                            child: Text(
                              widget.description,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: _isHovered
                                        ? widget.color.withOpacity(
                                            0.9,
                                          ) // hover effect
                                        : Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                    height: 1.3,
                                    fontSize: 14,
                                  ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            alignment: WrapAlignment.center,
                            children: widget.features
                                .map(
                                  (feature) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: widget.color.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      feature,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: widget.color,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                          ),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
