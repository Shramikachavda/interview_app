import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../../../data/models/feedback_response.dart';
import '../../../../data/models/interview_models.dart';
import '../../../utils/shared_pref.dart';
import 'interview_bloc/interview_bloc.dart';
import 'interview_bloc/interview_event.dart';
import 'interview_bloc/interview_state.dart';

class InterviewScreen extends StatefulWidget {
  final InterviewModel? initialInterview;

  const InterviewScreen({super.key, this.initialInterview});

  @override
  State<InterviewScreen> createState() => _InterviewScreenState();
}

class _InterviewScreenState extends State<InterviewScreen> {
  late InterviewBloc _interviewBloc;
  InterviewModel? _initialArg;
  final TextEditingController _answerController = TextEditingController();
  int _lastQuestionIndex = -1;
  bool _initialized = false;

  late stt.SpeechToText _speech;
  final ValueNotifier<bool> _isListeningNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isHoveredMic = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final args = ModalRoute.of(context)?.settings.arguments;
      _interviewBloc = BlocProvider.of<InterviewBloc>(context);

      if (args is InterviewModel) {
        _initialArg = args;
        if ((_initialArg?.sessionId ?? '').isNotEmpty) {
          _interviewBloc.add(SetInterviewState(interview: _initialArg!));
          saveInterviewState(_initialArg!);
        } else {
          _interviewBloc.add(StartInterview(initialState: _initialArg!));
          saveInterviewState(_initialArg!);
        }
      } else if (widget.initialInterview != null) {
        _initialArg = widget.initialInterview;
        _interviewBloc.add(SetInterviewState(interview: _initialArg!));
        saveInterviewState(_initialArg!);
      } else {
        _restoreInterviewState();
      }
      _initialized = true;
    }
  }

  Future<void> _restoreInterviewState() async {
    final prefs = await SharedPreferences.getInstance();
    final interviewJson = prefs.getString('interview_state');
    print('Restoring interview state: $interviewJson'); // Debug log
    if (interviewJson != null) {
      try {
        final interviewMap = jsonDecode(interviewJson);
        final restoredInterview = InterviewModel.fromJson(interviewMap);
        _initialArg = restoredInterview;
        _interviewBloc.add(SetInterviewState(interview: restoredInterview));
        print('Restored interview: ${restoredInterview.toJson()}'); // Debug log
      } catch (e) {
        print('Error restoring interview state: $e');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(context, '/dashboard');
        });
      }
    } else {
      print('No saved interview state, redirecting to dashboard');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      });
    }
  }

  Future<void> saveInterviewState(InterviewModel interview) async {
    final prefs = await SharedPreferences.getInstance();
    final interviewJson = jsonEncode(interview.toJson());
    await prefs.setString('interview_state', interviewJson);
    print('Saved interview state: $interviewJson'); // Debug log
  }

  Future<void> clearInterviewState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('interview_state');
    print('Cleared interview state'); // Debug log
  }

  void _submitAnswer() {
    final answer = _answerController.text.trim();
    if (answer.isEmpty) return;
    print('Submitting answer: $answer'); // Debug log
    _interviewBloc.add(SubmitAnswer(answer: answer));
    // Clear the answer immediately to provide instant feedback
    _answerController.clear();
    print('Cleared answer controller'); // Debug log
    // Save state after submission in case the bloc updates the interview
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_interviewBloc.state.interview != null) {
        saveInterviewState(_interviewBloc.state.interview!);
      }
    });
  }

  void _listen() async {
    if (!_isListeningNotifier.value) {
      var status = await Permission.microphone.status;
      if (!status.isGranted) {
        status = await Permission.microphone.request();
        if (!status.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Microphone permission denied',
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
          return;
        }
      }

      bool available = await _speech.initialize(
        onStatus: (val) => val == 'done' || val == 'notListening'
            ? _isListeningNotifier.value = false
            : null,
        onError: (val) => print('Speech error: $val'),
      );
      if (available) {
        _isListeningNotifier.value = true;
        _speech.listen(
          onResult: (val) => _answerController.text = val.recognizedWords,
        );
      }
    } else {
      _isListeningNotifier.value = false;
      _speech.stop();
    }
  }

  @override
  void dispose() {
    _answerController.dispose();
    _speech.stop();
    _isListeningNotifier.dispose();
    _isHoveredMic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        final padding = 24.0;

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(
            child: Column(
              children: [
                _buildCustomAppBar(context),
                Expanded(
                  child: BlocConsumer<InterviewBloc, InterviewBlocState>(
                    listener: (context, state) {
                      if (state.interview != null) {
                        final newInterview = state.interview!;
                        final currentIndex = newInterview.currentQuestionIndex;
                        if (_lastQuestionIndex != currentIndex) {
                          _lastQuestionIndex = currentIndex;
                          _answerController.clear();
                          print(
                              'Question changed to $currentIndex, answer: ${_answerController.text}'); // Debug log
                          saveInterviewState(newInterview);
                        }
                      }
                    },
                    builder: (context, state) {
                      if (state is InterviewLoading) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(
                                  Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Loading Interview...',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      final interview = state.interview ?? _initialArg;
                      if (interview == null) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 64,
                                color: Theme.of(context).colorScheme.error,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Interview not started.',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      if (state is InterviewCompleted ||
                          interview.done == true ||
                          interview.sessionStatus == 'done') {
                        final feedbackData = interview.feedback ??
                            InterviewFeedback(
                              score: 0,
                              feedback: "No feedback",
                              areasForImprovement: [],
                            );

                        WidgetsBinding.instance.addPostFrameCallback((_) async {
                          print('Interview completed, saving feedback and clearing state'); // Debug log
                          await saveFeedbackAndInterview(feedbackData, interview);
                          await clearInterviewState();
                          Navigator.pushReplacementNamed(
                            context,
                            '/feedback',
                            arguments: {
                              'feedback': feedbackData,
                              'interviewState': interview,
                            },
                          );
                        });

                        return const Center(child: CircularProgressIndicator());
                      }

                      return SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: padding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 32),
                            _buildProgressSection(context, interview, isMobile),
                            const SizedBox(height: 32),
                            _buildQuestionCard(context, interview),
                            const SizedBox(height: 32),
                            _buildAnswerSection(context),
                            const SizedBox(height: 32),
                            _buildSubmitButton(context),
                            const SizedBox(height: 24),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCustomAppBar(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
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
                Container(
                  margin: const EdgeInsets.only(left: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 20,
                    ),
                    onPressed: () async {
                      print('Navigating back to dashboard, clearing state'); // Debug log
                      await clearInterviewState();
                      Navigator.pushReplacementNamed(context, '/dashboard');
                    },
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Interview Session',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: isMobile ? 18 : 20,
                      ),
                    ),
                    Text(
                      'Stay Focused & Confident',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimary
                            .withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 24,
                  width: 72,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressSection(
      BuildContext context,
      InterviewModel interview,
      bool isMobile,
      ) {
    final totalQuestions = interview.totalQuestions > 0
        ? interview.totalQuestions
        : '?';
    final currentIndex = interview.currentQuestionIndex + 1;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
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
                        color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: isMobile ? 20.0 : 25.0,
                    backgroundColor: Colors.transparent,
                    child: Text(
                      '$currentIndex',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: isMobile ? 18 : 22,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Question $currentIndex of $totalQuestions',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Take your time to think and answer',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(
                begin: 0,
                end: totalQuestions is int && totalQuestions > 0
                    ? currentIndex / totalQuestions
                    : 0,
              ),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOut,
              builder: (context, value, child) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Progress',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color:
                            Theme.of(context).colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          '${(value * 100).toInt()}%',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: LinearProgressIndicator(
                        value: value,
                        backgroundColor:
                        Theme.of(context).colorScheme.outline.withOpacity(0.2),
                        valueColor: AlwaysStoppedAnimation(
                          Theme.of(context).colorScheme.primary,
                        ),
                        minHeight: 8,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(
      BuildContext context,
      InterviewModel interview,
      ) {
    final currentQuestion =
        interview.currentQuestion ?? 'No question available.';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.help_outline,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Interview Question',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            currentQuestion,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: 16,
              height: 1.5,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.edit_outlined,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Your Answer',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 18,
                ),
              ),
              const Spacer(),
              ValueListenableBuilder<bool>(
                valueListenable: _isHoveredMic,
                builder: (context, isHovered, child) {
                  return MouseRegion(
                    onEnter: (_) => _isHoveredMic.value = true,
                    onExit: (_) => _isHoveredMic.value = false,
                    child: ValueListenableBuilder<bool>(
                      valueListenable: _isListeningNotifier,
                      builder: (context, isListening, child) {
                        return GestureDetector(
                          onTap: _listen,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isListening
                                  ? Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.8)
                                  : Theme.of(context)
                                  .colorScheme
                                  .onPrimary
                                  .withOpacity(isHovered ? 0.15 : 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              isListening ? Icons.mic : Icons.mic_none,
                              color: isListening
                                  ? Colors.white
                                  : Theme.of(context).colorScheme.secondary,
                              size: 20,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _answerController,
            maxLines: 6,
            decoration: InputDecoration(
              hintText: 'Type your answer here or use the microphone...',
              hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant
                    .withOpacity(0.6),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                ),
              ),
              contentPadding: const EdgeInsets.all(16),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
            ),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return InkWell(
      onTap: _submitAnswer,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.send, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Text(
              'Submit Answer',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}