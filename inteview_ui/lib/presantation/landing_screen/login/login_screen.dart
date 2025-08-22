import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../theme/theme.dart';
import '../../../utils/validations.dart';
import 'login_bloc/auth_bloc.dart';
import 'login_bloc/auth_event.dart';
import 'login_bloc/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _usernameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  final ValueNotifier<bool> _isLogin = ValueNotifier(true);
  final ValueNotifier<bool> _isPasswordVisible = ValueNotifier(false);
  final ValueNotifier<String> _selectedExperienceLevel = ValueNotifier('easy');

  late AnimationController _animationController;
  late AnimationController _floatingController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // Main animation controller for entrance effects
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Floating animation for subtle movement
    _floatingController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeInOutCubic),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.2, 0.9, curve: Curves.easeOutCubic),
          ),
        );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOutBack),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.stop();
    _animationController.dispose();
    _floatingController.stop();
    _floatingController.dispose();

    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _isLogin.dispose();
    _isPasswordVisible.dispose();
    _selectedExperienceLevel.dispose();
    super.dispose();
  }

  // Helper method to get responsive values
  double _getResponsiveValue(BuildContext context, {
    required double mobile,
    required double tablet,
    required double desktop,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 600) return mobile;
    if (screenWidth < 1024) return tablet;
    return desktop;
  }

  // Helper method to check if screen is small
  bool _isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  // Helper method to check if screen height is small
  bool _isShortScreen(BuildContext context) {
    return MediaQuery.of(context).size.height < 700;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = _isSmallScreen(context);
    final isShortScreen = _isShortScreen(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (!mounted) return;
        if (state is AuthAuthenticated) {
          Navigator.pushReplacementNamed(context, '/dashboard');
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              backgroundColor: AppTheme.errorColor,
              duration: const Duration(seconds: 4),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 16 : 24,
                vertical: 16,
              ),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            _buildAnimatedBackground(),

            // Main content with responsive layout
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Center(
                    child: SingleChildScrollView(
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: EdgeInsets.symmetric(
                        horizontal: _getResponsiveValue(context,
                          mobile: 16,
                          tablet: 32,
                          desktop: 120,
                        ),
                        vertical: isShortScreen ? 16 : 32,
                      ),
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: ScaleTransition(
                            scale: _scaleAnimation,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: isSmallScreen ? double.infinity : 700,
                                minHeight: isShortScreen ? 0 : constraints.maxHeight * 0.6,
                              ),
                              child: _buildGlassCard(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryColor.withOpacity(0.8),
            AppTheme.secondaryColor.withOpacity(0.9),
            AppTheme.accentColor.withOpacity(0.7),
            AppTheme.primaryColor.withOpacity(0.6),
          ],
          stops: const [0.0, 0.3, 0.7, 1.0],
        ),
      ),
    );
  }

  Widget _buildGlassCard() {
    final isSmallScreen = _isSmallScreen(context);
    final isShortScreen = _isShortScreen(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isSmallScreen ? 20 : 32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 30,
            spreadRadius: -5,
            offset: const Offset(0, 20),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: -10,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(isSmallScreen ? 20 : 32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: EdgeInsets.all(isSmallScreen ? 20 : 32),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(isSmallScreen ? 20 : 32),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.25),
                  Colors.white.withOpacity(0.10),
                  Colors.white.withOpacity(0.05),
                ],
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Form(
              key: _formKey,
              child: ValueListenableBuilder<bool>(
                valueListenable: _isLogin,
                builder: (context, isLogin, _) {
                  return Column(
                    spacing: isSmallScreen ? 8 : 12,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeader(isLogin),

                      if (!isLogin)
                        _buildGlassFormField(
                          controller: _usernameController,
                          focusNode: _usernameFocus,
                          label: 'Username',
                          icon: Icons.person_outline_rounded,
                          validator: ValidatorUtil.validateUsername,
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).requestFocus(_emailFocus),
                        ),
                      _buildGlassFormField(
                        controller: _emailController,
                        focusNode: _emailFocus,
                        label: 'Email Address',
                        icon: Icons.email_outlined,
                        validator: ValidatorUtil.validateEmail,
                        keyboardType: TextInputType.emailAddress,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(_passwordFocus),
                      ),
                      if (!isLogin) _buildGlassDropdown(),

                      _buildPasswordField(),
                      if (isLogin) _buildForgotPassword(),

                      SizedBox(height: isSmallScreen ? 8 : 12),
                      _buildSubmitButton(isLogin),
                      SizedBox(height: isSmallScreen ? 4 : 6),
                      _buildToggleLoginRegister(),
                      if (!isShortScreen) _buildFooter(),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isLogin) {
    final isSmallScreen = _isSmallScreen(context);
    final isShortScreen = _isShortScreen(context);

    return Column(
      children: [
        // Hero logo with responsive size
        Container(
          width: isSmallScreen ? 70 : 100,
          height: isSmallScreen ? 70 : 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.3),
                Colors.white.withOpacity(0.1),
              ],
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(isSmallScreen ? 35 : 50),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryColor.withOpacity(0.7),
                      AppTheme.secondaryColor.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Icon(
                  isLogin ? Icons.login_rounded : Icons.person_add_rounded,
                  size: isSmallScreen ? 30 : 45,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height:  10),
        Text(
          isLogin ? 'Welcome Back!' : 'Join the Journey',
          style: TextStyle(
            fontSize: isSmallScreen ? 24 : 28,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: 0.5,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        SizedBox(height: isShortScreen ? 4 : 8),

       Text(
            isLogin
                ? 'Sign in to ace your interview prep'
                : 'Create an account to start your interview adventure',
            style: TextStyle(
              fontSize: isSmallScreen ? 14 : 16,
              color: Colors.white.withOpacity(0.9),
              height: 1.4,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),

        SizedBox(height: isShortScreen ? 12 : 16),
      ],
    );
  }

  Widget _buildGlassFormField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
    bool obscureText = false,
    TextInputAction textInputAction = TextInputAction.next,
    void Function(String)? onFieldSubmitted,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final isSmallScreen = _isSmallScreen(context);

    return Container(
      margin: EdgeInsets.symmetric(vertical: isSmallScreen ? 4 : 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.surfaceContainer.withValues(alpha: 0.15),
            Theme.of(context).colorScheme.surfaceContainer.withValues(alpha: 0.35),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.25),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            obscureText: obscureText,
            validator: validator,
            textInputAction: textInputAction,
            onFieldSubmitted: onFieldSubmitted,
            keyboardType: keyboardType,
            style: TextStyle(
              fontSize: isSmallScreen ? 13 : 14,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(
                fontSize: isSmallScreen ? 12 : 13,
                color: Theme.of(context).colorScheme.surfaceContainer.withValues(alpha: 0.8),
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: Icon(
                icon,
                color: Theme.of(context).colorScheme.surfaceContainer.withValues(alpha: 0.8),
                size: isSmallScreen ? 16 : 18,
              ),
              suffixIcon: suffixIcon,
              filled: true,
              fillColor: Colors.transparent,
              contentPadding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 12 : 14,
                vertical: isSmallScreen ? 10 : 12,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              errorStyle: TextStyle(
                color: Colors.red.shade200,
                fontWeight: FontWeight.w500,
                fontSize: isSmallScreen ? 11 : 12,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    final isSmallScreen = _isSmallScreen(context);

    return ValueListenableBuilder<bool>(
      valueListenable: _isPasswordVisible,
      builder: (context, isVisible, _) {
        return _buildGlassFormField(
          controller: _passwordController,
          focusNode: _passwordFocus,
          label: 'Password',
          icon: Icons.lock_outline_rounded,
          validator: ValidatorUtil.validatePassword,
          obscureText: !isVisible,
          textInputAction: TextInputAction.done,
          suffixIcon: IconButton(
            icon: Icon(
              isVisible ? Icons.visibility_rounded : Icons.visibility_off_rounded,
              color: Theme.of(context).colorScheme.surfaceContainer.withValues(alpha: 0.8),
              size: isSmallScreen ? 20 : 22,
            ),
            onPressed: () => _isPasswordVisible.value = !isVisible,
            splashRadius: 20,
          ),
        );
      },
    );
  }

  Widget _buildGlassDropdown() {
    final isSmallScreen = _isSmallScreen(context);

    return ValueListenableBuilder<String>(
      valueListenable: _selectedExperienceLevel,
      builder: (context, value, _) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: isSmallScreen ? 4 : 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.15),
                Colors.white.withOpacity(0.05),
              ],
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.25),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: DropdownButtonFormField<String>(
                validator: (_) => ValidatorUtil.validateExperience(value),
                value: value,
                decoration: InputDecoration(
                  labelText: 'Experience Level',
                  labelStyle: TextStyle(
                    fontSize: isSmallScreen ? 12 : 13,
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w400,
                  ),
                  prefixIcon: Icon(
                    Icons.work_outline_rounded,
                    color: Colors.white.withOpacity(0.8),
                    size: isSmallScreen ? 16 : 18,
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 12 : 14,
                    vertical: isSmallScreen ? 10 : 12,
                  ),
                  border: InputBorder.none,
                ),
                items: [
                  DropdownMenuItem(
                    value: 'easy',
                    child: Text(
                      'Entry Level',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 13 : 14,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'medium',
                    child: Text(
                      'Mid Level',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 13 : 14,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'hard',
                    child: Text(
                      'Senior Level',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 13 : 14,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                ],
                onChanged: (val) =>
                val != null ? _selectedExperienceLevel.value = val : null,
                dropdownColor: Colors.white.withOpacity(0.95),
                style: TextStyle(
                  fontSize: isSmallScreen ? 13 : 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
                icon: Icon(
                  Icons.arrow_drop_down_rounded,
                  color: Colors.white.withOpacity(0.8),
                  size: isSmallScreen ? 20 : 22,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubmitButton(bool isLogin) {
    final isSmallScreen = _isSmallScreen(context);

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return AnimatedScale(
          scale: state is AuthLoading ? 0.95 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: Container(
            height: isSmallScreen ? 44 : 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.25),
                  Colors.white.withOpacity(0.1),
                ],
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.35),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: ElevatedButton(
                  onPressed: state is AuthLoading ? null : _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 16 : 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: state is AuthLoading
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: isSmallScreen ? 16 : 18,
                        height: isSmallScreen ? 16 : 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Processing...',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 13 : 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isLogin
                            ? Icons.login_rounded
                            : Icons.person_add_rounded,
                        size: isSmallScreen ? 16 : 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isLogin ? 'Sign In' : 'Create Account',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 13 : 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildForgotPassword() {
    final isSmallScreen = _isSmallScreen(context);

    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Forgot Password feature coming soon!'),
              backgroundColor: AppTheme.primaryColor,
            ),
          );
        },

        child: Text(
          'Forgot Password?',
          style: TextStyle(
            fontSize: isSmallScreen ? 13 : 14,
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.underline,
            decorationColor: Colors.white.withOpacity(0.5),
          ),
        ),
      ),
    );
  }

  Widget _buildToggleLoginRegister() {
    final isSmallScreen = _isSmallScreen(context);

    return ValueListenableBuilder<bool>(
      valueListenable: _isLogin,
      builder: (context, isLogin, _) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 8 : 0,
          ),
          child: Row(
            spacing: 6,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isLogin ? "Don't have an account?" : "Already have an account?",
                style: TextStyle(
                  fontSize: isSmallScreen ? 13 : 14,
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),

              InkWell(
                onTap: () {
                  _isLogin.value = !isLogin;
                  _formKey.currentState?.reset();
                  _usernameController.clear();
                  _emailController.clear();
                  _passwordController.clear();
                  FocusScope.of(context).unfocus();
                  _animationController.forward(from: 0.0);
                },
                child: Text(
                  isLogin ? 'Sign Up' : 'Sign In',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 15 : 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white.withOpacity(0.7),
                    decorationThickness: 2,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFooter() {

    return Text(
      'By continuing, you agree to our Terms & Privacy Policy',
      style: TextStyle(
        fontSize: 11 ,
        color: Colors.white.withOpacity(0.7),
        fontWeight: FontWeight.w400,
      ),
      textAlign: TextAlign.center,
    );
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      if (_isLogin.value) {
        context.read<AuthBloc>().add(
          LoginUser(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          ),
        );
      } else {
        context.read<AuthBloc>().add(
          RegisterUser(
            name: _usernameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
            level: _selectedExperienceLevel.value,
          ),
        );
      }
    }
  }
}